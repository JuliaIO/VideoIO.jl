###############################################################################################################
# AVOptions API for VideoIO.jl
#
# Max Suster
# October 2014
###############################################################################################################

# AVOptions provides a generic system to get/set options for Devices, formats and Codecs.
# It relies on AVOptions, AVDictionary and AVDeviceCapabilitiesQuery APIs.

# The API consists of 3 modules:
#    Evaluate option strings  -> eval "string" option, return 0/-1
#    Option setting functions -> set value for a key string, if not string, then parsed
#    Option getting functions -> get value for a key string, if not string, then parsed

# Options are stored in 3 structure types:
#    AVOption
#    AVOptionRange
#    AVOptionRanges

#  key, value pairs can be optionally passed to AVOption functions using AVDictionary
#       typealias AVDictionary Void in libavutil.h
#       in ffmpeg dict.c
#       struct AVDictionary {
#         int count
#         AVDictionaryEntry *elems
#       }

#  To access options, the object(structure) must have Ptr{AVClass} as the first element,
#  because option keys and values are stored in AVOption, a child of AVClass.
#  e.g., avin::AVInput (see VideoIO/avio.jl)
#       -> avin.apFormatContext[1] = Ptr{AVFormatContext}
#       AVFormatContext has av_class::Ptr{AVClass} as first field
#       AVClass has option::Ptr{AVOption}
#       1. AVFormatContext
#            av_class:: Ptr{AVClass}
#              AVClass
#                 option::Ptr{AVOption}
#       2. AVCodecContext
#           av_class:: Ptr{AVClass}
#              AVClass
#                 option::Ptr{AVOption}
#       3.  AVDeviceCapabilitiesQuery
#            av_class:: Ptr{AVClass}
#               AVClass
#                 option::Ptr{AVOption}

# Initialized structures:
# formats => avin::AVInput
#                apFormatContext::Vector{Ptr{AVFormatContext}}

# codecs  => avin::AVInput
#               video_info::Vector{StreamInfo}
#                   stream_info::StreamInfo
#                     codec_ctx::AVCodecContext

# Devices => avdeviceQuery::AVDeviceCapabilitiesQuery

# issues to solve
#25  -> AVFormatContext.iformat
#31  -> AVDeviceCapabilitiesQuery


# **************************************************************************************************************

export avopt_view_all_options,
       avopt_set_default_options,
       av_set_options_using_strings,
       av_set_options_using_stringdict,
       avopt_find_option,
       avopt_get_value,
       avopt_get_imageSize,
       testdict,
       create_avdictionary,
       avopt_set_pixel_format,
       avopt_set_options_with_dict,
       avdev_query_ranges,
       avdev_list_devices,
       avdev_query_set,
       avopt_get_metadata

# **************************************************************************************************************

function avopt_view_all_options(I::AVInput)
  if !I.isopen
    error("No input file/device open!")
  end

  # Set default formats on Ptr{AVFormatContext}
  pFormatContext = I.apFormatContext[1]
  prevs = Ptr{AVOption}[C_NULL]
  prev = prevs[1]

  # Initialize the search of AVOption with Ptr{AVFormatContext}
  obj = pFormatContext
  # Create a dictionary of {option => [minvalue, maxvalue]}
  options = Dict{String,Vector{Cdouble}}()

  # Run through all AVOptions and store them in options
  while(true)
    while (true)
       prev = av_opt_next(obj, prev)
       if prev ==C_NULL
         break
       end
       avoption = unsafe_load(prev)
       name = bytestring(avoption.name)
       options["$name"] = [avoption.min, avoption.max]
    end

    obj = av_opt_child_next(obj, prev)
    if obj == C_NULL
      break
    end
  end

  # Sort keys alphabetically for easier viewing
  optionKeys = collect(keys(options))
  longest = maximum(map(i -> length(optionKeys[i]), 1:length(optionKeys)))
  sort!(vec(optionKeys))

  # Print options
  println("-"^75,"\n ", " "^10, "LIST OF ALL OPTIONS FOR FORMAT, CODEC AND DEVICES\n","-"^75)
  for i=1:length(optionKeys)
    name = optionKeys[i]
    println(name, " "^(longest-length(optionKeys[i]) +1), "=>  min: ",
            options[optionKeys[i]][1], " , max: " , options[optionKeys[i]][2])
  end
  println("\n\n")

  options
end

# Examples:
# using VideoIO
# f = opencamera("Built-in iSight", VideoIO.DEFAULT_CAMERA_FORMAT)
# OptionsDictionary = avopt_view_all_options(f.avin)

# **************************************************************************************************************
# Setting options
#
# 1. Set all options to default values
# 2. Set options by reading lists of "key1, value2; key2, value2" pairs from the user
# **************************************************************************************************************

function avopt_set_default_options(I::AVInput)
  if  !I.isopen
    error("No input file/device open!")
  end

  # Set default formats on Ptr{AVFormatContext}
  pFormatContext = I.apFormatContext[1]
  # av_opt_set_defaults2 (mask = 0, flags = 0)
  av_opt_set_defaults(pFormatContext) # input is Ptr{Void}

  # Set default codecs on Ptr{AVCodecContext}
  FormatContext = unsafe_load(pFormatContext)
  for i = 1:FormatContext.nb_streams
    pStream = unsafe_load(FormatContext.streams,i)
    stream = unsafe_load(pStream)
    av_opt_set_defaults(stream.codec)
  end

  println("Set default Format and Codec options")
  av_opt_free(pFormatContext)
end

#  Example:
#  using VideoIO
#  f = opencamera("Built-in iSight", VideoIO.DEFAULT_CAMERA_FORMAT)

#  avopt_set_default_options(f.avin)
# **************************************************************************************************************

function av_set_options_using_strings(I::AVInput, key::String, val::String)
  if !I.isopen
    error("No input file/device open!")
  end

  # Set default formats (Ptr{AVFormatContext})
  pFormatContext = I.apFormatContext[1]

  # key, value and pair separators
  key_val_sep = ","
  pairs_sep = ";"
  opts = string(key, "," , val)

  res = av_set_options_string(pFormatContext, pointer(opts), pointer(key_val_sep), pointer(pairs_sep))
  if res < 0
    error("Could not set '$key' option.")
  else
   println("$key set to $val.")
  end

end

## Examples:
#  using VideoIO
#  f = opencamera("Built-in iSight", VideoIO.DEFAULT_CAMERA_FORMAT)

# set probing size (from 32 to INT_MAX)
#     av_set_options_using_strings(f.avin, "probesize", "100000000")

# set how many microseconds
#     av_set_options_using_strings(f.avin, "analyzeduration", "10000000")

# set number of frames used to probe -> fps (from -1 to 2.14748e+09)
#     av_set_options_using_strings(f.avin, "fpsprobesize", "10")
#     av_set_options_using_strings(f.avin, "formatprobesize", "50000000")

# set pixel format
#     av_set_options_using_strings(f.avin, "pixel_format", string(VideoIO.AV_PIX_FMT_UYVY422))
#     av_set_options_using_strings(f.avin, "pixel_format", string(VideoIO.AV_PIX_FMT_YUYV422))
#     av_set_options_using_strings(f.avin, "pixel_format", string(VideoIO.AV_PIX_FMT_NV12))
#     av_set_options_using_strings(f.avin, "pixel_format", string(VideoIO.AV_PIX_FMT_0RGB))
#     av_set_options_using_strings(f.avin, "pixel_format", string(VideoIO.AV_PIX_FMT_BGR0))

# set frame rate
#     av_set_options_using_strings(f.avin, "frame_rate", "15")

# **************************************************************************************************************


# **************************************************************************************************************
## Find an option given a string key
# **************************************************************************************************************

function avopt_find_option(I::AVInput, key::String)
  pFormatContext = I.apFormatContext[1]
  #AVOptionType named constants (Ptr{Uint8})
  unit =  C_NULL  # "AVOptionType"?, but not clear from docs
  opt_flags = convert(Cint,0)

  #  AV_OPT_TYPE_ +
  #  INT,INT64,DOUBLE,FLOAT,STRING,RATIONAL
  #  BINARY,DICT,IMAGE_SIZE,PIXEL_FMT
  #  SAMPLE_FMT,VIDEO_RATE,DURATION
  #  COLOR,CHANNEL_LAYOUT

  # Search in nested objects (e.g., AVCodecContext)
  search_flags = convert(Cint, AV_OPT_SEARCH_CHILDREN)

  # Initialize a Ptr{AVOption}
  prevs = Ptr{AVOption}[C_NULL]
  prev = prevs[1]

  prev = av_opt_find(pFormatContext,pointer(key),unit, opt_flags, search_flags)
  if prev == C_NULL
    #av_opt_free(pFormatContext)  #deallocate
    error("$key not found! \n")
  else
    #av_opt_free(pFormatContext)  #deallocate
    println("$key found! \n")
  end
end

# Examples:
# using VideoIO
# f = opencamera("Built-in iSight", VideoIO.DEFAULT_CAMERA_FORMAT)
# avopt_find_option(f.avin, "probesize")
# avopt_find_option(f.avin, "list_devices")
# avopt_find_option(f.avin, "max_delay")
# avopt_find_option(f.avin, "analyzeduration")
# **************************************************************************************************************


# **************************************************************************************************************
#  Get the value of an option
# **************************************************************************************************************

# segmentation fault 11! (outval::uint8_t parsing problem?)
function avopt_get_value (I::AVInput, key::String)
  pFormatContext = I.apFormatContext[1]

  # Get value from children of FormatContext -> AVCodecContext
  search_flags = convert(Cint, AV_OPT_SEARCH_CHILDREN)
  val = Array(Uint8,128)
  out = pointer(val)
  outval = pointer(out)

  if (av_opt_get(pFormatContext,pointer(key),search_flags, outval)<0)
    error("Cannot get value for $key")
  else
    vall = unsafe_load(outval)
    fval = bytestring(convert(Ptr{Uint8}, vall))
    println("$key = $fval")
  end

  #deallocate
#   av_free(outval)
#   av_opt_free(pFormatContext)
end

function avopt_get_imageSize (I::AVInput, key::String)
  pFormatContext = I.apFormatContext[1]

  # Get value from children of FormatContext -> AVCodecContext
  search_flags = convert(Cint, AV_OPT_SEARCH_CHILDREN)
  out1_ = Ptr{Cint}[C_NULL]; out1 = out1_[1]
  out2_ = Ptr{Cint}[C_NULL]; out2 = out2_[1]

  if (av_opt_get_image_size(pFormatContext,pointer(key),search_flags, out1, out2)<0)
    error("Cannot get value for $key")
  else
    fval1 = convert(Int64, unsafe_load(out1))
    fval2 = convert(Int64, unsafe_load(out2))
    println("Width: $fval1, Height: $fval2")
  end

  #deallocate
#   av_free(outval)
#   av_opt_free(pFormatContext)
end

# avopt_get_value(f.avin, "iformat")
# avopt_get_value(f.avin, "oformat")
# avopt_get_value(f.avin, "duration")
# avopt_get_value(f.avin, "bit_rate")
# avopt_get_value(f.avin, "packet_size")
# avopt_get_value(f.avin, "max_delay")
# avopt_get_value(f.avin, "probesize")
# avopt_get_value(f.avin, "max_analyze_duration")


# **************************************************************************************************************
## Create a dictionary
# **************************************************************************************************************
# user_options = Dict{String,String}()
# user_options["probesize"] = "1000000"
# user_options["iformat"] = "mpeg"
# user_options["duration"] = "3000"

function testdict(key::String, val::String)

  dictionary = Ptr{Ptr{AVDictionary}}[C_NULL]  #(Void)
  dict = dictionary[1]

  flags = convert(Cint, AV_DICT_DONT_OVERWRITE)

  if(av_dict_set(dict, pointer(key), pointer(val),flags)< 0) #AV_DICT_DONT_OVERWRITE
      #returns Cint = 0 on success, AVERROR <0 on failure
      error("Can not create a dictionary")
  else
      println("Yes, it worked!")
    end
end

function create_avdictionary(user_options::Dict{String,String})

  # Check that user entries exist!
  fflag = cflag = dflag = false
  keyFormats = collect(names(AVFormatContext))
  keyCodecs = collect(names(AVCodecContext))
  keyDevices = collect(names(AVDeviceCapabilitiesQuery))
  UserKeys = collect(keys(user_options))
  for k= 1:length(UserKeys)
    if any(o-> symbol(UserKeys[k])==keyFormats[o], 1:length(keyFormats))
        fflag = true
    elseif any(o-> symbol(UserKeys[k])==keyCodecs[o], 1:length(keyCodecs))
        cflag = true
    elseif any(o-> symbol(UserKeys[k])==keyDevices[o], 1:length(keyDevices))
        dflag = true
     end
  end

  if fflag == false && cflag == false && dflag == false
    error("None of the key, value pairs are compatible with the AVOptions API")
  end

  dictionary = Ptr{Ptr{AVDictionary}}[C_NULL]  #(Void)
  dict = dictionary[1]
  entry = Ptr{AVDictionaryEntry}[C_NULL]
  dict_entry = entry[1]

  # Call av_dict_set() function
  Base.sigatomic_begin()
  for k = 1 #:length(UserKeys)
    if(av_dict_set(dictionary[1], pointer(UserKeys[k]), pointer(user_options[UserKeys[k]]), AV_DICT_DONT_OVERWRITE)< 0) #AV_DICT_DONT_OVERWRITE
      #returns Cint = 0 on success, AVERROR <0 on failure
      error("Can not create $(user_options[option_keys[k]]) a dictionary")
    end
  end
  Base.sigatomic_end()

  # Ptr{Ptr{AVDictionary}}
  return dictionary
  return [fflag,cflag,dflag]
end
# av_dict_free(dictionary)

# function dict_count(dictionary::Ptr{Ptr{AVDictionary}})
#   dictio = unsafe_load(dictionary)
#   count = av_dict_count(dictio[1])
#   println("The number of entries is $count")
# end
# **************************************************************************************************************


# **************************************************************************************************************
## Set options with Dict{key => value} read directly from the user
## Uses AVDictionary API
function avopt_set_options_with_dict (I::AVInput, user_options::Dict{String,String})
  #Create a dictionary from user_options Dict()
  dictionary, flags = createAVDictionary(user_options)
  # Retrieve AVFormatContext
  pFormatContext = I.apFormatContext[1]
  FormatContext = unsafe_load(pFormatContext)

  if flags[1]
    (av_opt_set_dict(FormatContext, dictionary[1]) !=0)
     println("Warning: format option can not be set!")
  end

  if flags[2]
   # Set codecs (AVCodecContext)
   for i = 1:FormatContext.nb_streams
     pStream = unsafe_load(FormatContext.streams,i)
     stream = unsafe_load(pStream)
     CodecContext = unsafe_load(stream.codec)
     if (av_opt_set_dict(CodecContext, dictionary[1])==0)
       println("Codec option was set!")
     end
    end
  end
  av_dict_free(dictionary)
  av_opt_free(FormatContext)
end
# **************************************************************************************************************


# user_options = Dict{String,String}()
# user_options["probesize"] = "1000000"
# user_options["iformat"] = "mpeg"
# user_options["duration"] = "3000"
# avopt_set_options_with_dict(avin, user_options)


# **************************************************************************************************************
## Set options with Dict{key => value} read directly from the user
## Uses AVDeviceCapabilitiesQuery API

## NOT WORKING YET
# Create a query
function createAVDeviceQuery(I::AVInput)
   pFormatContext = I.apFormatContext[1]
   queries = Ptr{Ptr{AVDeviceCapabilitiesQuery}}[C_NULL]  #(Void)
   query = queries[1]
   if (avdevice_capabilities_create(query,pFormatContext, C_NULL) < 0)
       error("Can not create a query")
   end
   avdevice_capabilities_free(query, pFormatContext)
#    dictionary!=C_NULL? av_dict_free(dictionary): nothing
#    return queries
end

# Probe and set device capabilities
function avdev_query_ranges (I::AVInput, key::String, default=false)
  # Select Ptr{AVFormatContext}
  pFormatContext = I.apFormatContext[1]

  # Initialize AVOptionRanges
  ranges = Ptr{Ptr{AVOptionRanges}}[C_NULL]
  search_flags::Integer = AV_OPT_MULTI_COMPONENT_RANGE    #0

  # Create a device query
  queries = createAVDeviceQuery(pFormatContext, dictionary=C_NULL)
  query = unsafe_load(queries[1])

  # Probe default values or full range
  a = b = false
  default ?
      a = (av_opt_query_ranges_default(ranges[1],query, pointer(key),search_flags)<0):
      b = (av_opt_query_ranges(ranges[1],query,pointer(key),search_flags)<0)

  if (a ==true|| b==true)
    av_free(key)
    avdevice_capabilities_free(queries, pFormatContext)
    default ? av_opt_free_ranges(ranges): av_opt_freep_ranges(ranges) #deallocate
    error("Invalid device key input")
  else
    pRanges = unsafe_load(ranges[1])        #Ptr{AVOptionRanges}
    Ranges = unsafe_load(pRanges)           #AVOptionRanges
    pRange = unsafe_load(Ranges.range)      #Ptr{AVOptionRange}
    range = unsafe_load(pRange)             #AVOptionRange

    minVal = range.value_min  #Cdouble => Float64
    maxVal = range.value_max  #Cdouble => Float64

    println("$key, mininum = $minVal, maximum = $maxVal")

    #deallocate
    default ? av_opt_free_ranges(ranges): av_opt_freep_ranges(ranges)
    av_free(key)
    avdevice_capabilities_free(query, pFormatContext)
  end
end
# **************************************************************************************************************
#
# Video
# avdev_query_ranges(avin, "codec", false)
# avdev_query_ranges(avin, "pixel_format", false)
# avdev_query_ranges(avin, "window_width", false)
# avdev_query_ranges(avin, "window_height", false)
# avdev_query_ranges(avin, "frame_width", false)
# avdev_query_ranges(avin, "frame_height", false)
# avdev_query_ranges(avin, "fps", false)

# Audio
# avdev_query_ranges(avin, "sample_format", false)
# avdev_query_ranges(avin, "sample_rate", false)
# avdev_query_ranges(avin, "channels", false)
# avdev_query_ranges(avin, "channel_layout", false)


# **************************************************************************************************************

function avdev_query_set (I::AVInput, key::String, val::Uint32)
  # Select Ptr{AVFormatContext}
  pFormatContext = I.apFormatContext[1]

  # Create a device query
  queries = createAVDeviceQuery(pFormatContext, C_NULL)
  query = unsafe_load(queries[1])

  # Set the value
  pval = convert(Ptr{Uint8}, pointer_from_objref(val))
  if (av_opt_set(query, pointer(key), pval, 0) !=0) #set=0::Cint
   av_free(key)
   avdevice_capabilities_free(query, pFormatContext)
   error("Can not set device")
  else
   #deallocate
   av_free(key)
   av_free(pval)
   avdevice_capabilities_free(query, pFormatContext)
  end
end
# **************************************************************************************************************

# avdev_query_set(avin, "codec", AV_CODEC_ID_RAWVIDEO, 0)
# avdev_query_set(avin, "codec", AV_CODEC_ID_MPEG4, 0)
# avdev_query_set(avin, "pixel_format", AV_PIX_FMT_YUV420P, 0)
# avdev_query_set(avin, "fps", AV_PIX_FMT_YUV420P, 0)

# **************************************************************************************************************
# List devices available (may not be complete!)
# f = VideoIO.opencamera("Built-in iSight", VideoIO.DEFAULT_CAMERA_FORMAT)
# VideoIO.avdev_list_devices(f.avin)

function avdev_list_devices(I::AVInput)

#   AVDeviceCapabilitiesQuery
#   #AVDeviceCapabilitiesQuery.device_context::Ptr{AVFormatContext}

  # Select Ptr{AVFormatContext}
  pFormatContext = I.apFormatContext[1]

  # Initialize a Ptr{Ptr{AVDeviceInfoList}}
  pplist = Ptr{Ptr{AVDeviceInfoList}}[C_NULL]
  device_list = pplist[1]

  if (avdevice_list_devices(pFormatContext, device_list)<0)
    #avdevice_free_list_devices(device_list)
    error("Cannot list devices")
  else
    #get AVDeviceInfoList
    pdevice_list = unsafe_load(device_list)
    infolist = unsafe_load(pdevice_list)
    #number of autodetected devices
    nb_devices = infolist.nb_devices
    #index of default device or -1 if no default
    default_device =  infolist.default_device

    # get AVDeviceInfo
    pDeviceInfo = unsafe_load(infolist)
    DeviceInfo = unsafe_load(pDeviceInfo)
    # get device_name
    device_name = bytestring(DeviceInfo.device_name)
    device_description = bytestring(DeviceInfo.device_description)
    println("|",device_name,"|"," "^10, "|",device_description,"|");

    #deallocate
    #avdevice_free_list_devices(device_list)
  end
end
# **************************************************************************************************************


# avdev_list_devices(avin)
# http://www.ffmpeg.org/ffprobe-all.html
# alsa
# avfoundation
# bktr
# dshow


# **************************************************************************************************************
# Read metadata
# AVFormatContext
# -> metadata::Ptr{AVDictionary}
# f = VideoIO.opencamera("Built-in iSight", VideoIO.DEFAULT_CAMERA_FORMAT)
# VideoIO.av_opt_get_metadata(f.avin)

function av_opt_get_metadata (I::AVInput)
  # Select Ptr{AVFormatContext}
   pFormatContext = I.apFormatContext[1]
   fmt_ctx = unsafe_load(pFormatContext)
   tags = Ptr{AVDictionaryEntry}[C_NULL]
   tag = tags[1]

    while (true)
      if (av_dict_get(fmt_ctx.metadata, " ", tag, AV_DICT_IGNORE_SUFFIX)!=C_NULL)
        entry = unsafe_load(tag)
        metakey = bytestring(entry.key)
        metaentry = bytestring(entry.val)
        println("$metakey, $metaentry \n");
      else
       println("No entries!")
       break
      end
  end
end

# **************************************************************************************************************

# VideoIO.av_opt_get_metadata(f.avin)


## Other AVDictionary functions

# Set format of input/output file
# function open_input
#   createAVDictionary(user_options::Dict{String,String})
#   pFormatContext = avin.apFormatContext[1]
#   if (avformat_open_input(pFormatContext, C_NULL, C_NULL, dictionary[1]) != 0)
#     av_dict_free(dictionary)
#     error("Unable to open input")
#   else
#    av_dict_free(dictionary)
# end

# Not working!
# To use a list of multiple key, value pairs, use the following function
#optdict = Dict{String, String}()

# function av_set_options_using_stringdict(I::AVInput, optdict::Dict{String, String})
#   if !I.isopen
#     error("No input file/device open!")
#   end

#   # Set default formats (Ptr{AVFormatContext})
#   pFormatContext = I.apFormatContext[1]

#   # key, value and pair separators
#   key_val_sep = ","
#   pairs_sep = "//"

#   # Unpack the dictionary to a single string of key,val pairs
#   optdict = Dict{String, String}()
#   key_list = collect(keys(optdict))
#   list = ""
#   for i=1:length(key_list)
#    list = list*string(key_list[i],key_val_sep,optdict[key_list[i]], pairs_sep)
#   end
#   list = list[1:end-1]

#   res = av_set_options_string(pFormatContext, pointer(list), pointer(key_val_sep), pointer(pairs_sep))
#   if res < 0
#     error("Could not set any/all options.")
#   else
#    ok = convert(Int64, res)
#    ok < length(key_list)? println("$(ok) of $(length(key_list)) options were recognized."):
#       println("All options were set!")
#   end

# end
