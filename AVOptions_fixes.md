
######################################################################################
# AVOptions API for VideoIO
# avoptions.jl
# Maximiliano Suster
# Oct 2014
######################################################################################

-------------------------------------------------------------------------------------
1. Background
-------------------------------------------------------------------------------------
AVOptions provides a generic system to get/set options for Devices, formats and Codecs.
It relies on AVOptions, AVDictionary and AVDeviceCapabilitiesQuery APIs.

References:
ffmpeg library links
    https://www.ffmpeg.org/doxygen/2.4/files.html
AVOptions API links
    https://www.ffmpeg.org/doxygen/2.4/group__avoptions.html
    https://www.ffmpeg.org/doxygen/trunk/structAVDeviceCapabilitiesQuery.html
    https://www.ffmpeg.org/doxygen/trunk/avdevice_8h_source.html#l00399
AVOptions source files
    opt.c
    opt.h
    avdevice.h
AVDictionary API source files
    dict.h
    dict.c
AVDeviceCapabilitiesQuery API source files
    avdevice.h

see equivalent Julia types and functions in VideoIO/AVUtil/v52 (opt.jl and dict.jl)

-------------------------------------------------------------------------------------
2. How to access generic and private options using ffmpeg AVOptions API
-------------------------------------------------------------------------------------

*The API consists of 3 modules:
    Evaluate option strings  -> eval "string" option, return 0/-1
    Option setting functions -> set value for a key string, if not string, then parsed
    Option getting functions -> get value for a key string, if not string, then parsed

*Options are stored in 3 structure types:
    AVOption
    AVOptionRange
    AVOptionRanges

* key, value pairs can be optionally passed to AVOption functions using AVDictionary
     AVDictionary
     AVDictionaryEntry

*To access the options, the object(structure) must have Ptr{AVClass} as the first element.
 To access options in the input file/stream, i.e., avin::AVInput (see VideoIO/avio.jl)
       -> avin.apFormatContext[1] = Ptr{AVFormatContext}
       Note:
       AVFormatContext has av_class::Ptr{AVClass} as first field
       AVClass in turn has a field "option" of Ptr{AVOption} type
       1. AVFormatContext
            av_class:: Ptr{AVClass}
              AVClass
                 option::Ptr{AVOption}
       2. AVCodecContext
           av_class:: Ptr{AVClass}
              AVClass
                 option::Ptr{AVOption}
       3.  AVDeviceCapabilitiesQuery
            av_class:: Ptr{AVClass}
               AVClass
                 option::Ptr{AVOption}

* Type definitions in VideoIO (VideoIO/AVUtil/v52)
  immutable AVClass
    class_name::Ptr{Uint8}
    item_name::Ptr{Void}
    option::Ptr{AVOption}      # <- AVOption is stored here
    version::Cint
    log_level_offset_offset::Cint
    parent_log_context_offset::Cint
    child_next::Ptr{Void}
    child_class_next::Ptr{Void}
    category::AVClassCategory
    get_category::Ptr{Void}
    query_ranges::Ptr{Void}
  end

  immutable AVOption
    name::Ptr{Uint8}
    help::Ptr{Uint8}
    offset::Cint
    _type::AVOptionType
    default_val::Void
    min::Cdouble
    max::Cdouble
    flags::Cint
    unit::Ptr{Uint8}
  end

  immutable AVOptionRange
    str::Ptr{Uint8}
    value_min::Cdouble
    value_max::Cdouble
    component_min::Cdouble
    component_max::Cdouble
    is_range::Cint
  end

  immutable AVOptionRanges
    range::Ptr{Ptr{AVOptionRange}}
    nb_ranges::Cint
    nb_components::Cint
  end

  immutable AVDictionaryEntry     # AVDictionary (dict.jl)
    key::Ptr{Uint8}               # char *key
    value::Ptr{Uint8}             # char *value
  end

  typealias AVDictionary Void     # AVDictionary (opaque pointer)

  immutable AVDeviceCapabilitiesQuery
     # device capabilities (supported codecs, pixel formats, sample formats,
     resolutions, channel counts, etc). More...

    av_class::Ptr{AVClass}
    device_context::Ptr{AVFormatContext}
    codec::AVCodecID
    sample_format::AVSampleFormat
    pixel_format::AVPixelFormat
    sample_rate::Cint
    channels::Cint
    channel_layout::Int64
    window_width::Cint
    window_height::Cint
    frame_width::Cint
    frame_height::Cint
    fps::AVRational
  end

* Selected AVOptions functions to be implemented in avoptions.jl

  av_opt_find
      Look for an option in an object.
  av_opt_set
      Set the value given a key for a field
      av_opt_set_int
      av_opt_set_double
      av_opt_set_q
      av_opt_set_bin
      av_opt_set_image_size
      av_opt_set_pixel_fmt
      av_opt_set_sample_fmt
      av_opt_set_video_rate
      av_opt_set_channel_layout
  av_opt_set_defaults
      Set the values of all AVOption fields to their default values.
  av_opt_get
      get option type and convert to string
      av_opt_get_int
      av_opt_get_double
      av_opt_get_q
      av_opt_get_image_size
      av_opt_get_pixel_fmt
      av_opt_get_sample_fmt
      av_opt_get_video_rate
      av_opt_get_channel_layout
  av_opt_set_dict
       Set all the options from a given dictionary on an object using AVDictionary
  av_opt_query_ranges
       Get a list of allowed ranges for the given option.
  av_opt_copy
       copy options
  av_opt_child_next
  av_opt_child_class_next
  av_opt_get_key_value
      Extract a key-value pair from the beginning of a string.
  av_opt_free
      Free all allocated objects in obj.
  av_opt_freep_ranges
      Free an AVOptionRanges struct and set it to NULL.
  av_set_options_string
      Parse the key/value pairs list in opts.
  av_opt_set_from_string
     Parse the key-value pairs list in opts.
  av_opt_next
      Iterate over all AVOptions belonging to obj.

-------------------------------------------------------------------------------------
3.  Wrapped AVOptions functions => avoptions.jl
-------------------------------------------------------------------------------------

We assume that an input file/stream has been instantiated in avio.jl as
    avin::AVInput

To access AVOptions, we have to call an obj or its pointer (i.e., AVFormatContext,
AVCodecContext or AVDeviceCapabilitiesQuery) that has Ptr{AVClass} as the first field:
     obj = avin.apFormatContext[1]               # Ptr{AVFormatContext} type
     obj = unsafe_load(avin.apFormatContext[1])  # AVFormatContext type

# Check if an option exists

--- opt.jl ---
    Change Ptr{Uint8} -> Ptr{Void})
   function av_opt_find(obj,name,unit,opt_flags::Integer,search_flags::Integer)
     ccall((:av_opt_find,libavutil),Ptr{AVOption},
     (Ptr{Void},Ptr{Void},Ptr{Void},Cint,Cint),obj,name,unit,opt_flags,search_flags)
   end

-- avoptions.jl ---
   function av_is_option(avin::AVInput, option_name::String)
      obj = avin.apFormatContext[1]
      option_name                 # String -> Ptr{Void}
      unit = C_NULL               # AV_OPT_TYPE_DURATION or C_NULL
      opt_flags = 0               # AV_OPT_FLAG
      search_flags::Integer = 0   # AV_OPT_SEARCH_CHILDREN

      avoption = av_opt_find(obj,option_name, unit, opt_flags,search_flags)

      (avoption == C_NULL) ? error("$No") : println("yes")

      av_opt_free(obj)  #deallocate obj
   end

How to use it:
   # av_is_option(avin,"probesize")
   # av_is_option(avin,"pb")
   # av_is_option(avin,"iformat")
   # av_is_option(avin,"oformat")
   # av_is_option(avin,"duration")
   # av_is_option(avin, "max_delay")


# Set options with (key,value) pairs
   --- opt.jl ---
    # Change Ptr{Uint8} -> Ptr{Void})
  function av_opt_set(obj,name,val,search_flags::Integer)
     ccall((:av_opt_set,libavutil),Cint,
     (Ptr{Void},Ptr{Void},Ptr{Void},Cint),obj,name,val,search_flags)
  end

  -- avoptions.jl---
  function av_set_option(avin::AVInput, key::String, val::String)
    pFormatContext = avin.apFormatContext[1]
    obj = unsafe_load(pFormatContext)       #Ptr{AVClass}) is 1st-element
    search_flags::Integer = 0               # AV_OPT_SEARCH_CHILDREN (to search in children)

    if (av_opt_set(obj,key,val,search_flags) !=0)
      # returns Cint = 0 if value was set
      av_opt_free(obj)  #deallocate obj
      error("Can't set $name to $(int(val))")
    else
      av_opt_free(obj)  #deallocate obj
    end
  end

How to use it:
  # av_set_option(avin, "probesize", "1000000")
  # av_set_option(avin, "iformat", "mpeg")


# Set all options to default values
 --- opt.jl ---
   function av_opt_set_defaults(s)
     ccall((:av_opt_set_defaults,libavutil),Void,(Ptr{Void},),s)
   end

 -- avoptions.jl---
   function av_set_default_options(avin::AVInput)
      pFormatContext = avin.apFormatContext[1]
      obj = unsafe_load(pFormatContext)
       av_opt_set_defaults(obj)
         #calls av_opt_set_defaults2 with mask = 0, flags = 0
       av_opt_free(obj)
   end

How to use it:
   # av_set_default_options(avin)


# Get the current value of an option
--- opt.jl ---
    # Change Ptr{Uint8} -> Ptr{Void})
   function av_opt_get(obj,name,search_flags::Integer,out_val)
     ccall((:av_opt_get,libavutil),Cint,
     (Ptr{Void},Ptr{Void},Cint,Ptr{Ptr{Unint8}}),obj,name,search_flags,out_val)
   end

-- avoptions.jl---
   function av_get_option(avin::AVInput, key::String)

     pFormatContext = avin.apFormatContext[1]
     obj = unsafe_load(pFormatContext)       # Ptr{AVClass}) is 1st-element
     search_flags::Integer = 0               # AV_OPT_SEARCH_CHILDREN (to search in children)
     val = Array(Uint8, 128)                 # create an array(128) of uint8s to hold val

     if (av_opt_get(obj,key,search_flags, val)<0)
       error("Cannot get value for $key")
     else
       fval = bytestring(convert(Ptr{Uint8}, val))
       println("$key = fval")
     end

     av_free(val)
     av_opt_free(obj)  #deallocate obj
   end

Usage:


# Set options with AVDictionary API

--- opt.jl ---

function av_opt_set_dict(obj,options)
    ccall((:av_opt_set_dict,libavutil),Cint,(Ptr{Void},Ptr{Ptr{AVDictionary}}),obj,options)
end


# Set options with AVDeviceCapabilitiesQuery API
     Get a list of allowed ranges for the given option.
  function av_query_capabilities ()

      flags:     AV_OPT_MULTI_COMPONENT_RANGE


      av_opt_query_ranges
  end


flags:
AV_OPT_MULTI_COMPONENT_RANGE     # check multiple options
AV_OPT_SEARCH_CHILDREN           # check for options in structures inside AVIN



















----------------------------------------------------------------------------------------------
Source files:  avformat.h
 ## Libavformat (lavf) library
  - demuxing - i.e. splitting a media file into component streams
  - muxin, i.e., writing supplied data in a specified container format.
  - @ref lavf_io, "I/O module" which supports a number of protocols for accessing the data
    (e.g. file, tcp, http and others).

 ## How to use:
   1. call av_register_all() to register all compiled muxers, demuxers and protocols.
   2. call avformat_network_init().

 ## Data structures and fields:
  1. AVInputFormat and AVOutputFormat structs to hold all the data
  2. av_iformat_next() / av_oformat_next() used to iterate over all registered input/output
  3. AVFormatContext structure used for both muxing and demuxing exports all information
  about the file being read or written.
     - avformat_alloc_context()  -> AVFormatContext
     - avformat_open_input()  -> AVFormatContex
     - AVFormatContext contains several fields:
         * AVFormatContext.iformat "input"   (autodected or set)
         * AVFormatContext.oformat "output"  (always set)
         * AVFormatContext.streams "array"   AVStreams (index)
         * AVFormatContext.pb "I/O context"  (autoopened or set unless AVFMT_NOFILE format)
         * lavf_options passes options to (de)muxers

  4. Generic (format-independent) options in AVFormatContext using AVOption
         * av_opt_next() / av_opt_find()  (or its
         * AVClass from avformat_get_class())

  5. Private (format-specific) options in AVFormatContext
          * AVFormatContex.priv_data if AVFormatContex.priv_data != non-NULL.
          * AVFormatContext.pb "I/O context" if AVClass != non-NULL

 ## How to use AVFormatContext:

 * Demuxers
   input(media file) -> split into @em packets
           * AVPacket "packet"
           * avformat_open_input() -> av_read_frame() (reads single packet)
           * avformat_close_input(), which does the cleanup.
           * lavf_decoding_open -> Opening a media file (URL or filename)
              -> avformat_open_input()
           e.g.,
             const char    *url = "in.mp3";
             AVFormatContext *s = NULL;
             int ret = avformat_open_input(&s, url, NULL, NULL);
             if (ret < 0)
             abort();

 * Some formats do not have a header, in that case
   -> use avformat_find_stream_info() to decode a few frames to find missing information.

 * In some cases, need to preallocate AVFormatContext
   -> use avformat_alloc_context() -> avformat_open_input().
    One such case is when you want to use custom functions

 * To read data without I/O layer
   -> use AVIOContext with avio_alloc_context(), pass callbacks to it.
   -> set pb field of new AVFormatContext to newly created AVIOContext.

  * File format is generally not known until avformat_open_input() has returned
    -> pass options to avformat_open_input()
    -> use AVDictionary:
    e.g., passing "video size" and "pixel format"
         AVDictionary *options = NULL;
         av_dict_set(&options, "video_size", "640x480", 0);
         av_dict_set(&options, "pixel_format", "rgb24", 0);
         if (avformat_open_input(&s, url, NULL, &options) < 0)
         abort();
         av_dict_free(&options);

    -> need to check that the options are recognized
        AVDictionaryEntry *e;
        if (e = av_dict_get(options, "", NULL, AV_DICT_IGNORE_SUFFIX)) {
        fprintf(stderr, "Option %s not recognized by the demuxer.\n", e->key);
        abort();
        }

  * Close the file with avformat_close_input()

   * Reading from an opened file -> lavf_decoding_read (AVFormatContext)
       * av_read_frame() ->
          AVPacket (AVStream)
          AVPacket.stream_index
       * Packet can be passed directly to
          avcodec_decode_video2()
          avcodec_decode_audio4()
          avcodec_decode_subtitle2()
       * Timing information will be set:
            AVPacket.pts
            AVPacket.dts
            AVPacket.duration
            or AV_NOPTS_VALUE for pts/dts, 0 for duration
            Units:  AVStream.time_base units, i.e. seconds.
       * AVPacket.buf is set on the returned packet
            allocated dynamically and the user may keep it indefinitely.
            if AVPacket.buf == NULL
              use next av_read_frame() or close the file.
              use av_dup_packet() to make an av_malloc()ed (copy)
              av_free_packet() to close
       * Other options
            lavf_decoding_seek Seeking
            lavf_encoding Muxing
            lavf_io I/O Read/Write
            lavf_codec Demuxers
            lavf_codec_native Native Demuxers
            lavf_codec_wrappers External library wrappers
            lavf_protos I/O Protocols
            lavf_internal Internal


AVDictionary [key, value] pair functions
==========================================

# AVUtil/v52/dict.jl

 av_dict_get,            #check that options is there
 av_dict_count,
 av_dict_set,            #set option:  e.g., av_dict_set(&options, "video_size", "640x480", 0)
 av_dict_parse_string,
 av_dict_copy,
 av_dict_free

# AVUtil/v52/frame.jl
function av_frame_get_metadata(frame)
    ccall((:av_frame_get_metadata,libavutil),Ptr{AVDictionary},(Ptr{AVFrame},),frame)
end

function av_frame_set_metadata(frame,val)
    ccall((:av_frame_set_metadata,libavutil),Void,(Ptr{AVFrame},Ptr{AVDictionary}),frame,val)
end

function avpriv_frame_get_metadatap(frame)
    ccall((:avpriv_frame_get_metadatap,libavutil),Ptr{Ptr{AVDictionary}},(Ptr{AVFrame},),frame)
end

# avformat.jl
function avformat_open_input(ps,filename,fmt,options)
    ccall((:avformat_open_input,libavformat),Cint,(Ptr{Ptr{AVFormatContext}},Ptr{Uint8},Ptr{AVInputFormat},Ptr{Ptr{AVDictionary}}),ps,filename,fmt,options)
end

function avformat_find_stream_info(ic,options)
    ccall((:avformat_find_stream_info,libavformat),Cint,(Ptr{AVFormatContext},Ptr{Ptr{AVDictionary}}),ic,options)
end

function avformat_write_header(s,options)
    ccall((:avformat_write_header,libavformat),Cint,(Ptr{AVFormatContext},Ptr{Ptr{AVDictionary}}),s,options)
end

# avio.jl
function avio_open2(s,url,flags::Integer,int_cb,options)
    ccall((:avio_open2,libavformat),Cint,(Ptr{Ptr{AVIOContext}},Ptr{Uint8},Cint,Ptr{AVIOInterruptCB},Ptr{Ptr{AVDictionary}}),s,url,flags,int_cb,options)
end

# avcodec.jl
function avcodec_open2(avctx,codec,options)
    ccall((:avcodec_open2,libavcodec),Cint,(Ptr{AVCodecContext},Ptr{AVCodec},Ptr{Ptr{AVDictionary}}),avctx,codec,options)
end
function av_packet_pack_dictionary(dict,size)
    ccall((:av_packet_pack_dictionary,libavcodec),Ptr{Uint8},(Ptr{AVDictionary},Ptr{Cint}),dict,size)
end
function av_packet_unpack_dictionary(data,size::Integer,dict)
    ccall((:av_packet_unpack_dictionary,libavcodec),Cint,(Ptr{Uint8},Cint,Ptr{Ptr{AVDictionary}}),data,size,dict)
end

# avdevice.jl
function avdevice_capabilities_create(caps,s,device_options)
    ccall((:avdevice_capabilities_create,libavdevice),Cint,(Ptr{Ptr{AVDeviceCapabilitiesQuery}},Ptr{AVFormatContext},Ptr{Ptr{AVDictionary}}),caps,s,device_options)
end


AVDeviceCapabilitiesQuery functions
===================================
# avdevice.jl
function avdevice_capabilities_create(caps,s,device_options)
    ccall((:avdevice_capabilities_create,libavdevice),Cint,(Ptr{Ptr{AVDeviceCapabilitiesQuery}},Ptr{AVFormatContext},Ptr{Ptr{AVDictionary}}),caps,s,device_options)
end

function avdevice_capabilities_free(caps,s)
    ccall((:avdevice_capabilities_free,libavdevice),Void,(Ptr{Ptr{AVDeviceCapabilitiesQuery}},Ptr{AVFormatContext}),caps,s)
end


AVDictionary support
=================
libav/dict.h
liabavutil -> http://www.libav.org/doxygen/release/0.7/dict_8h_source.html
ffmpeg/dict.h
libavutil  -> https://www.ffmpeg.org/doxygen/trunk/dict_8h_source.html
libav/dict.c
https://www.ffmpeg.org/doxygen/2.4/dict_8c_source.html
---------------------------------------------------------------------------
In libavutil_h.jl
---------------------------------------------------------------------------
# AVDictionary
immutable AVDictionaryEntry
  key::Ptr{Uint8}               # char *key
  value::Ptr{Uint8}             # char *value
end

typealias AVDictionary Void     # AVDictionary = NULL

    type AVDictionary               # struct in dict.c
    count::Int32
    elems:Ptr{AVDictionaryEntry}
    end

---------------------------------------------------------------------------

# options = Ptr -> empty AVDictionary
options = Ptr{AVDictionary}

# Call av_dict_set() function
   av_dict_set(Ptr{Ptr{AVDictionary}}, key::Ptr{Uint8}, value::Ptr{Uint8},
   flags::Integer)

# private options -> demuxer
av_dict_set(Ptr{options}, "probesize", "1000000", 0)    # probesize: size of data to probe
av_dict_set(Ptr{options}, "pixel_format", "rgb24", 0);  # pixel_format: RGB24

if (avformat_open_input(avin.apFormatContext[1], source::String, NULL, Ptr{options}) != 0
      error("Unable to open input")
end

av_dict_free(options)

# Checking whether entry is recognized

if (e::Ptr{AVDictionaryEntry} = av_dict_get(options, "", NULL, AV_DICT_IGNORE_SUFFIX))
  error("Option $(e.key) is not recognized by the demuxer)
end


 ffmpeg AVDictionary
 dict.h --> dict.jl
---------------------------------------------------------------------------
 * AVDictionary *options = NULL;
 * av_dict_set(&options, "video_size", "640x480", 0);
 * av_dict_set(&options, "pixel_format", "rgb24", 0);
 *
 * if (avformat_open_input(&s, url, NULL, &options) < 0)
 *     abort();
 * av_dict_free(&options);
 ---------------------------------------------------------------------------

---------------------------------------------------------------------------
AVDictionary *d = NULL;           // "create" an empty dictionary
AVDictionaryEntry *t = NULL;
av_dict_set(&d, "foo", "bar", 0); // add an entry
char *k = av_strdup("key");       // if your strings are already allocated,
char *v = av_strdup("value");     // you can avoid copying them like this
av_dict_set(&d, k, v, AV_DICT_DONT_STRDUP_KEY | AV_DICT_DONT_STRDUP_VAL);
while (t = av_dict_get(d, "", t, AV_DICT_IGNORE_SUFFIX)) {
    <....>            // iterate over all entries in d
}
av_dict_free(&d);
---------------------------------------------------------------------------





