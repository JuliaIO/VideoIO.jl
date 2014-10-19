**************************************************************************************************
# List of AVOptions
************************************************************************************************

Fixed segmentation fault issue #44
Fixed #25, #31


1. Select device
    get_camera_devices()
    avdevice_list_devices()

2. Select pixel format
Use Regex, search and match to identify AVPixelFormat constant
PIXFMT = Regex(_PIX_FMT_)
search("PIX_FMT_VAAPI_IDCT", "_FMT_")

3. Select frame rate

4. Select color format

5. Set recording time

    # Set codecs (Ptr{AVCodecContext})
       for i = 1:FormatContext.nb_streams
        pStream = unsafe_load(FormatContext.streams,i)
        stream = unsafe_load(pStream)
        pCodecContext = stream.codec
        if (av_opt_set_dict2(pCodecContext, pDictionary, search_flags)==0)
         println("Codec option was set!")
        end
       end
     end
    end


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


AVOption-enabled objects (i.e., AVClass is the first element of the object)
Selected fields that can be set with av_opt_set_from_string

***AVFormatContext***
ctx_flags::Cint
nb_streams::Uint32
filename::Array_1024_Uint8
start_time::Int64
duration::Int64
bit_rate::Cint
packet_size::Uint32
max_delay::Cint
flags::Cint
probesize::Uint32
max_analyze_duration::Cint
key::Ptr{Uint8}
keylen::Cint
nb_programs::Uint32
max_index_size::Uint32
max_picture_buffer::Uint32
nb_chapters::Uint32
start_time_realtime::Int64
fps_probe_size::Cint
error_recognition::Cint
debug::Cint
max_interleave_delta::Int64
strict_std_compliance::Cint
ts_id::Cint
audio_preload::Cint
max_chunk_duration::Cint
max_chunk_size::Cint
use_wallclock_as_timestamps::Cint
avoid_negative_ts::Cint
avio_flags::Cint
skip_initial_bytes::Int64
correct_ts_overflow::Uint32
seek2any::Cint
flush_packets::Cint
probe_score::Cint
format_probesize::Cint
data_offset::Int64
raw_packet_buffer_remaining_size::Cint
offset::Int64
io_repositioned::Cint
metadata_header_padding::Cint
output_ts_offset::Int64
max_analyze_duration2::Int64


***AVCodecContext***
log_level_offset::Cint
codec_name::Array_32_Uint8
codec_tag::Uint32
stream_codec_tag::Uint32
bit_rate::Cint
bit_rate_tolerance::Cint
global_quality::Cint
compression_level::Cint
flags::Cint
flags2::Cint
extradata::Ptr{Uint8}
extradata_size::Cint
ticks_per_frame::Cint
delay::Cint
width::Cint
height::Cint
coded_width::Cint
coded_height::Cint
gop_size::Cint
pix_fmt::AVPixelFormat
me_method::Cint
max_b_frames::Cint
b_quant_factor::Cfloat
rc_strategy::Cint
b_frame_strategy::Cint
b_quant_offset::Cfloat
has_b_frames::Cint
mpeg_quant::Cint
i_quant_factor::Cfloat
i_quant_offset::Cfloat
lumi_masking::Cfloat
temporal_cplx_masking::Cfloat
spatial_cplx_masking::Cfloat
p_masking::Cfloat
dark_masking::Cfloat
slice_count::Cint
prediction_method::Cint
slice_offset::Ptr{Cint}
sample_aspect_ratio::AVRational
me_cmp::Cint
me_sub_cmp::Cint
mb_cmp::Cint
ildct_cmp::Cint
dia_size::Cint
last_predictor_count::Cint
pre_me::Cint
me_pre_cmp::Cint
pre_dia_size::Cint
me_subpel_quality::Cint
dtg_active_format::Cint
me_range::Cint
intra_quant_bias::Cint
inter_quant_bias::Cint
slice_flags::Cint
xvmc_acceleration::Cint
mb_decision::Cint
intra_matrix::Ptr{Uint16}
inter_matrix::Ptr{Uint16}
scenechange_threshold::Cint
noise_reduction::Cint
me_threshold::Cint
mb_threshold::Cint
intra_dc_precision::Cint
skip_top::Cint
skip_bottom::Cint
border_masking::Cfloat
mb_lmin::Cint
mb_lmax::Cint
me_penalty_compensation::Cint
bidir_refine::Cint
brd_scale::Cint
keyint_min::Cint
refs::Cint
chromaoffset::Cint
scenechange_factor::Cint
mv0_threshold::Cint
b_sensitivity::Cint
color_primaries::AVColorPrimaries
color_trc::AVColorTransferCharacteristic
colorspace::AVColorSpace
color_range::AVColorRange
chroma_sample_location::AVChromaLocation
slices::Cint
field_order::AVFieldOrder
sample_rate::Cint
channels::Cint
sample_fmt::AVSampleFormat
frame_size::Cint
frame_number::Cint
block_align::Cint
cutoff::Cint
request_channels::Cint
channel_layout::Uint64
request_channel_layout::Uint64
equest_sample_fmt::AVSampleFormat
refcounted_frames::Cint
qcompress::Cfloat
qblur::Cfloat
qmin::Cint
qmax::Cint
max_qdiff::Cint
rc_qsquish::Cfloat
rc_qmod_amp::Cfloat
rc_qmod_freq::Cint
rc_buffer_size::Cint
rc_override_count::Cint
rc_max_rate::Cint
rc_min_rate::Cint
rc_buffer_aggressivity::Cfloat
rc_initial_cplx::Cfloat
rc_max_available_vbv_use::Cfloat
rc_min_vbv_overflow_use::Cfloat
rc_initial_buffer_occupancy::Cint
coder_type::Cint
context_model::Cint
lmin::Cint
lmax::Cint
frame_skip_threshold::Cint
frame_skip_factor::Cint
frame_skip_exp::Cint
frame_skip_cmp::Cint
trellis::Cint
min_prediction_order::Cint
max_prediction_order::Cint
timecode_frame_start::Int64
rtp_payload_size::Cint
mv_bits::Cint
header_bits::Cint
i_tex_bits::Cint
p_tex_bits::Cint
i_count::Cint
p_count::Cint
skip_count::Cint
misc_bits::Cint
frame_bits::Cint
stats_out::Ptr{Uint8}
stats_in::Ptr{Uint8}
workaround_bugs::Cint
strict_std_compliance::Cint
error_concealment::Cint
debug::Cint
debug_mv::Cint
err_recognition::Cint
reordered_opaque::Int64
error::Array_8_Uint64
dct_algo::Cint
idct_algo::Cint
bits_per_coded_sample::Cint
bits_per_raw_sample::Cint
lowres::Cint
thread_count::Cint
thread_type::Cint
active_thread_type::Cint
thread_safe_callbacks::Cint
nsse_weight::Cint
profile::Cint
level::Cint
skip_loop_filter::AVDiscard
skip_idct::AVDiscard
skip_frame::AVDiscard
subtitle_header::Ptr{Uint8}
subtitle_header_size::Cint
error_rate::Cint
vbv_delay::Uint64
side_data_only_packets::Cint
pkt_timebase::AVRational
pts_correction_num_faulty_pts::Int64
pts_correction_num_faulty_dts::Int64
pts_correction_last_pts::Int64
pts_correction_last_dts::Int64
sub_charenc::Ptr{Uint8}
sub_charenc_mode::Cint
skip_alpha::Cint
seek_preroll::Cint
chroma_intra_matrix::Ptr{Uint16}


***AVDeviceCapabilitiesQuery***
codec::AVCodecID
sample_format::AVSampleFormat  #Audio
pixel_format::AVPixelFormat
sample_rate::Cint  #Audio
channels::Cint
channel_layout::Int64  #Audio
window_width::Cint
window_height::Cint
frame_width::Cint
frame_height::Cint
fps::AVRational

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

immutable AVDeviceCapabilitiesQuery
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

immutable AVDeviceInfo
    device_name::Ptr{Uint8}
    device_description::Ptr{Uint8}
end

immutable AVDeviceInfoList
    devices::Ptr{Ptr{AVDeviceInfo}}
    nb_devices::Cint
    default_device::Cint
end


Metadata API
=================================================================================
https://www.ffmpeg.org/doxygen/2.4/group__metadata__api.html

Keys
album        -- name of the set this work belongs to
album_artist -- main creator of the set/album, if different from artist.
                e.g. "Various Artists" for compilation albums.
artist       -- main creator of the work
comment      -- any additional description of the file.
composer     -- who composed the work, if different from artist.
copyright    -- name of copyright holder.
creation_time-- date when the file was created, preferably in ISO 8601.
date         -- date when the work was created, preferably in ISO 8601.
disc         -- number of a subset, e.g. disc in a multi-disc collection.
encoder      -- name/settings of the software/hardware that produced the file.
encoded_by   -- person/group who created the file.
filename     -- original name of the file.
genre        -- <self-evident>.
language     -- main language in which the work is performed, preferably
                in ISO 639-2 format. Multiple languages can be specified by
                separating them with commas.
performer    -- artist who performed the work, if different from artist.
                E.g for "Also sprach Zarathustra", artist would be "Richard
                Strauss" and performer "London Philharmonic Orchestra".
publisher    -- name of the label/publisher.
service_name     -- name of the service in broadcasting (channel name).
service_provider -- name of the service provider in broadcasting.
title        -- name of the work.
track        -- number of this work in the set, can be in form current/total.
variant_bitrate -- the total bitrate of the bitrate variant that the current stream is part of


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


# deallocate keys, values and AVOption structures

# av_free(outval)
# av_opt_free(pFormatContext)
# ffmpeg -f avfoundation -list_devices true -i ""
# ffmpeg -f qtkit -list_devices true -i ""


 **************************************************************************************************************
# AVDictionary API
# **************************************************************************************************************
# User must create a Dict with {key::String => val::String} pairs
# e.g.,
# user_options["probesize"] = "1000000"
# user_options["iformat"] = "mpeg"
#
# IMPORTANT!
# After using createAVDictionary, call
# av_dict_free(dictionary)
# **************************************************************************************************************

function AVDictionary(user_options::Dict{String,String})

  dictionary = Ptr{Ptr{AVDictionary}}[C_NULL]  #(Void)
  entry = Ptr{AVDictionaryEntry}[C_NULL]
   # key::Ptr{Uint8}
   # value::Ptr{Uint8}

  # Call av_dict_set() function
  option_keys = collect(keys(user_options))
  for k = 1::length(option_keys)
    if(av_dict_set(dictionary[1], option_keys[k], user_options[option_keys[k]], AV_DICT_DONT_OVERWRITE)< 0)
      #returns Cint = 0 on success, AVERROR <0 on failure
      error("Option $(option_keys[k]) is not recognized")
    end
  end

  return dictionary  # array of Ptr{Ptr{AVDictionary}}

  # Check whether entry is recognized
  #   if (entry[1] = av_dict_get(dictionary[1], "", C_NULL, AV_DICT_IGNORE_SUFFIX)== C_NULL)
  #      error("Option $(e.key) is not recognized")
  #   end

end

# **************************************************************************************************************
# AVDeviceCapabilitiesQuery API
# **************************************************************************************************************
# codec
# sample_format
# pixel format
# channels
# window_width
# window_height
# frame_width
# frame_height
# fps

# IMPORTANT!
# After using createAVDeviceQuery, call
# avdevice_capabilities_free(avdeviceQuery,pFormatContext)
# av_dict_free(dictionary)
# **************************************************************************************************************

function AVDeviceQuery(pFormatContext::Ptr{AVFormatContext}, dictionary=C_NULL)

   avQuery = Ptr{Ptr{AVDeviceCapabilitiesQuery}}[C_NULL]  #(Void)
   if (avdevice_capabilities_create(avQuery[1],pFormatContext, dictionary) < 0)
       error("Can not create a query")
   end

   return avQuery
end

# **************************************************************************************************************
function identify_AVType{T<:Union(AVInput, AVDeviceCapabilitiesQuery)}(obj::T, pointTO::bool)
  if isa(obj, AVInput)
     pFormatContext = obj.apFormatContext[1]          # avin::AVInput
     obj_ = unsafe_load(pFormatContext)
  elseif isa(obj, StreamInfo)
     obj_ = obj.codec_ctx                             # stream_info::StreamInfo
  elseif isa(obj, AVDeviceCapabilitiesQuery)
     obj_ = obj                                       # avdeviceQuery::AVDeviceCapabilitiesQuery
  end

  if (findfirst(names(obj_), symbol("av_class")) != 1)
     error("Structure is not AVOption-enabled: Ptr{AVClass} must be first element")
  end

  pointTO? return obj_:return unsafe_pointer_to_objref(obj_)
end

# **************************************************************************************************************
# Check if an option exists
# **************************************************************************************************************

function av_is_option{T<:Union(AVInput, AVDeviceCapabilitiesQuery)}(obj::T, option_name::String)

  obj_ = identify_AVType{T<:Union(AVInput,AVDeviceCapabilitiesQuery)}(obj::T, point_to_it=true)
  #option_name                # String -> Ptr{Void}
  unit = C_NULL               # AV_OPT_TYPE_DURATION or C_NULL
  opt_flags = 0               # AV_OPT_FLAG
  search_flags::Integer = 0   # AV_OPT_SEARCH_CHILDREN

  if ((avoption = av_opt_find(obj_,option_name, unit, opt_flags,search_flags)) == C_NULL)
    av_opt_free(obj_)  #deallocate obj
    error("Option not found")
  else
    av_opt_free(obj_)  #deallocate obj
    println("Option found")
  end
end

# **************************************************************************************************************
# Set option values
# **************************************************************************************************************

function av_set_option{T<:Union(AVInput,StreamInfo,AVDeviceCapabilitiesQuery)}(obj::T, key::String, val::String)

  obj_ = identify_AVType{T<:Union(AVInput,StreamInfo,AVDeviceCapabilitiesQuery)}(obj::T, point_to_it=false)
  search_flags::Integer = 0               # AV_OPT_SEARCH_CHILDREN (to search in children)

  if (av_opt_set(obj_,key,val,search_flags) !=0)
   # returns Cint = 0 if value was set
   av_opt_free(obj_)  #deallocate obj
   error("Can't set $name to $(int(val))")
  else
   av_opt_free(obj_)  #deallocate obj
  end
end


# **************************************************************************************************************
# Set all options to default values
# **************************************************************************************************************

function av_set_default_options{T<:Union(AVInput,AVDeviceCapabilitiesQuery)}(obj::T)
  obj_ = identify_AVType{T<:Union(AVInput,AVDeviceCapabilitiesQuery)}(obj::T, point_to_it=false)
  av_opt_set_defaults(obj_)   # av_opt_set_defaults2 with mask = 0, flags = 0
  av_opt_free(obj_)
end

# **************************************************************************************************************
# Get current option values
# **************************************************************************************************************

function av_get_option {T<:Union(AVInput,AVDeviceCapabilitiesQuery)}(obj::T, key::String)

  obj_ = identify_AVType{T<:Union(AVInput,AVDeviceCapabilitiesQuery)}(obj::T, point_to_it=false)
  search_flags::Integer = 0               # AV_OPT_SEARCH_CHILDREN (to search in children)
  val = Array(Uint8, 128)                 # create an array(128) of uint8s to hold string

  if (av_opt_get(obj_,key,search_flags, val)<0)
    error("Cannot get value for $key")
  else
    fval = bytestring(convert(Ptr{Uint8}, val))
    println("$key = $fval")
  end

  av_free(val)
  av_opt_free(obj_)  #deallocate obj
end


function av_set_options_with_dict {T<:Union(AVInput,AVDeviceCapabilitiesQuery)}(obj::T,user_options::Dict{String,String})

  obj_ = identify_AVType{T<:Union(AVInput,AVDeviceCapabilitiesQuery)}(obj::T, point_to_it=false)
  dictionary = AVDictionary(user_options)

  # Now set options in avin::AVInput with AVDictionary
  if (av_opt_set_dict(obj_,dictionary[1]) !=0)
    # returns Cint = 0 if value was set
     av_dict_free(dictionary) #deallocate dictionary!
     av_opt_free(obj_)  #deallocate obj!
     error("Can't set values in $name to $(int(val))")
  else
     av_dict_free(dictionary) # deallocate dictionary!
     av_opt_free(obj_)      # deallocate obj!
  end
end


function av_query_option_ranges{T<:Union(AVInput,AVDeviceCapabilitiesQuery)}(obj::T, query_key::String, default::bool = false)

  ranges = Ptr{Ptr{AVOptionRanges}}[C_NULL]
  key = convert(Ptr{Uint8}, pointer(query_key))
  search_flags::Integer = AV_OPT_MULTI_COMPONENT_RANGE    #0
  res1 = res2 = false

  default ?
      res1 = (av_opt_query_ranges_default(ranges[1],obj_, key,search_flags)<0):
      res2 = (av_opt_query_ranges(ranges[1],obj_, key,search_flags, val)<0)

  if res1 || res2
    av_free(key)
    default ? av_opt_free_ranges(ranges): av_opt_freep_ranges(ranges) #deallocate
    error("Cannot get range for $key")
  else
    OptionRanges = unsafe_load(pointer_from_objref(ranges[1]))   #AVOptionRanges
    range = unsafe_load(pointer_from_objref(OptionRanges.range)) #AVOptionRange
    minVal = range.value_min  #Cdouble => Float64
    maxVal = range.value_max  #Cdouble => Float64

    # min/max length (strings)
    # min/max pixel count (dims)
    # width/height in multi-component case

    println("$key, mininum = $minVal, maximum = $maxVal")
    default ? av_free(key) : av_free(key); av_free(val)
    default ? av_opt_free_ranges(ranges): av_opt_freep_ranges(ranges) #deallocate
  end

end


function av_set_option_with_query(I::AVInput, user_options::Dict(String, String))

  # Select Ptr{AVFormatContext}
  obj = I.apFormatContext[1]

  # Create a dictionary from the user's entries as Dict()
  dictionary = AVDictionary(user_options)

  # Create a query on Ptr{AVFormatContext}
  query = AVDeviceQuery(obj, dictionary)

  # Initialize AVOptionRanges
  ranges = Ptr{Ptr{AVOptionRanges}}[C_NULL]

  search_flags::Integer = AV_OPT_MULTI_COMPONENT_RANGE    #0

    key = convert(Ptr{Uint8}, pointer(user_options[i]))

    res1 = res2 = false

  default ?
      res1 = (av_opt_query_ranges_default(ranges[1],obj, key,search_flags)<0):
      res2 = (av_opt_query_ranges(ranges[1],obj, key,search_flags, val)<0)

  if res1 || res2
    av_free(key)
    default ? av_opt_free_ranges(ranges): av_opt_freep_ranges(ranges) #deallocate
    error("Cannot get range for $key")
  else
    OptionRanges = unsafe_load(pointer_from_objref(ranges[1]))   #AVOptionRanges
    range = unsafe_load(pointer_from_objref(OptionRanges.range)) #AVOptionRange
    minVal = range.value_min  #Cdouble => Float64
    maxVal = range.value_max  #Cdouble => Float64

    # min/max length (strings)
    # min/max pixel count (dims)
    # width/height in multi-component case

    println("$key, mininum = $minVal, maximum = $maxVal")
    default ? av_free(key) : av_free(key); av_free(val)
    default ? av_opt_free_ranges(ranges): av_opt_freep_ranges(ranges) #deallocate
  end

#  avdevice_capabilities_free(avQuery,pFormatContext)
#  av_dict_free(dictionary)

end

# **************************************************************************************************************
# AVDictionary support
# **************************************************************************************************************

# Create a dictionary
user_options = Dict{String,String}()
# Fill it
# user_options["probesize"] = "1000000"
dictionary = AVDictionary(user_options)
# array of Ptr{Ptr{AVDictionary}}

# Set format of input/output file
pFormatContext = avin.apFormatContext[1]
if (avformat_open_input(pFormatContext, C_NULL, C_NULL, dictionary[1]) != 0)
  av_dict_free(dictionary)
  error("Unable to open input")
else
  av_dict_free(dictionary)
end


# Allocate the stream private data and write the stream header to an output media file.
if (avformat_write_header(pFormatContext,dictionary[1]) != 0)
  av_dict_free(dictionary)
  error("Unable to write header to output")
else
  av_dict_free(dictionary)
end


# Get metadata field from AVFrame (::Ptr{AVDictionary})
frame = VideoReader.aVideoFrame[1]
dictn = Ptr{AVDictionary}[C_NULL]  #(Void)
dictn[1] = av_frame_get_metadata(unsafe_pointer_to_objref(frame))

# Set metadata field for AVFrame
av_frame_set_metadata(unsafe_pointer_to_objref(frame),unsafe_load(dictionary[1]))
av_dict_free(dictionary)

# Read packets of a media file to get stream information.
if avformat_find_stream_info(pFormatContext, dictionary[1]) < 0
  av_dict_free(dictionary)
  error("Unable to find stream information")
else
  av_dict_free(dictionary)
end


# **************************************************************************************************************
# URL Resource Access
# **************************************************************************************************************

# avio.jl
# Accessing URL resource
# avio_open2(s,url,flags::Integer,int_cb,options)

# **************************************************************************************************************
# AVOption-enabled structures REFERENCE
# **************************************************************************************************************
# immutable AVFormatContext
#     av_class::Ptr{AVClass}
#**#     iformat::Ptr{AVInputFormat}
#**#     oformat::Ptr{AVOutputFormat}
#**#     priv_data::Ptr{Void}
#**#     pb::Ptr{AVIOContext}
#**#     ctx_flags::Cint
#**#     nb_streams::Uint32
#**#    streams::Ptr{Ptr{AVStream}}
#**#     filename::Array_1024_Uint8
#     start_time::Int64
#**#     duration::Int64
#**#     bit_rate::Cint
#**#    packet_size::Uint32
#**#     max_delay::Cint
#**#     flags::Cint
#**#     probesize::Uint32
#**#     max_analyze_duration::Cint
#     key::Ptr{Uint8}
#     keylen::Cint
#     nb_programs::Uint32
#     programs::Ptr{Ptr{AVProgram}}
#**#     video_codec_id::AVCodecID
#**#     audio_codec_id::AVCodecID
#     subtitle_codec_id::AVCodecID
#     max_index_size::Uint32
#     max_picture_buffer::Uint32
#     nb_chapters::Uint32
#     chapters::Ptr{Ptr{AVChapter}}
#**#     metadata::Ptr{AVDictionary}      #metadata
#**#     start_time_realtime::Int64
#**#     fps_probe_size::Cint
#     error_recognition::Cint
#     interrupt_callback::AVIOInterruptCB
#     debug::Cint
#     max_interleave_delta::Int64
#     strict_std_compliance::Cint
#     ts_id::Cint
#     audio_preload::Cint
#     max_chunk_duration::Cint
#     max_chunk_size::Cint
#     use_wallclock_as_timestamps::Cint
#     avoid_negative_ts::Cint
#     avio_flags::Cint
#     duration_estimation_method::AVDurationEstimationMethod
#     skip_initial_bytes::Int64
#     correct_ts_overflow::Uint32
#     seek2any::Cint
#     flush_packets::Cint
#     probe_score::Cint
#     format_probesize::Cint
#     packet_buffer::Ptr{AVPacketList}
#     packet_buffer_end::Ptr{AVPacketList}
#     data_offset::Int64
#     raw_packet_buffer::Ptr{AVPacketList}
#     raw_packet_buffer_end::Ptr{AVPacketList}
#     parse_queue::Ptr{AVPacketList}
#     parse_queue_end::Ptr{AVPacketList}
#     raw_packet_buffer_remaining_size::Cint
#     offset::Int64
#     offset_timebase::AVRational
#     internal::Ptr{AVFormatInternal}
#     io_repositioned::Cint
#     video_codec::Ptr{AVCodec}
#     audio_codec::Ptr{AVCodec}
#     subtitle_codec::Ptr{AVCodec}
#**#     metadata_header_padding::Cint
#     opaque::Ptr{Void}
#     control_message_cb::av_format_control_message
#     output_ts_offset::Int64
#     max_analyze_duration2::Int64
# end

# immutable AVCodecContext
#     av_class::Ptr{AVClass}
#     log_level_offset::Cint
#     codec_type::AVMediaType
#     codec::Ptr{AVCodec}
#     codec_name::Array_32_Uint8
#     codec_id::AVCodecID
#     codec_tag::Uint32
#     stream_codec_tag::Uint32
#**#     priv_data::Ptr{Void}
#     internal::Ptr{AVCodecInternal}
#     opaque::Ptr{Void}
#**#     bit_rate::Cint
#**#     bit_rate_tolerance::Cint
#     global_quality::Cint
#**#     compression_level::Cint
#     flags::Cint
#     flags2::Cint
#     extradata::Ptr{Uint8}
#     extradata_size::Cint
#**#     time_base::AVRational
#**#     ticks_per_frame::Cint
#**#     delay::Cint
#**#     width::Cint
#**#     height::Cint
#**#     coded_width::Cint
#**#     coded_height::Cint
#     gop_size::Cint
#**#     pix_fmt::AVPixelFormat
#     me_method::Cint
#     draw_horiz_band::Ptr{Void}
#**#     get_format::Ptr{Void}
#**#     max_b_frames::Cint
#     b_quant_factor::Cfloat
#     rc_strategy::Cint
#     b_frame_strategy::Cint
#     b_quant_offset::Cfloat
#     has_b_frames::Cint
#     mpeg_quant::Cint
#     i_quant_factor::Cfloat
#     i_quant_offset::Cfloat
#     lumi_masking::Cfloat
#     temporal_cplx_masking::Cfloat
#     spatial_cplx_masking::Cfloat
#     p_masking::Cfloat
#     dark_masking::Cfloat
#     slice_count::Cint
#     prediction_method::Cint
#     slice_offset::Ptr{Cint}
#**#     sample_aspect_ratio::AVRational
#     me_cmp::Cint
#     me_sub_cmp::Cint
#     mb_cmp::Cint
#     ildct_cmp::Cint
#     dia_size::Cint
#     last_predictor_count::Cint
#     pre_me::Cint
#     me_pre_cmp::Cint
#     pre_dia_size::Cint
#     me_subpel_quality::Cint
#     dtg_active_format::Cint
#     me_range::Cint
#     intra_quant_bias::Cint
#     inter_quant_bias::Cint
#     slice_flags::Cint
#     xvmc_acceleration::Cint
#     mb_decision::Cint
#     intra_matrix::Ptr{Uint16}
#     inter_matrix::Ptr{Uint16}
#     scenechange_threshold::Cint
#**#     noise_reduction::Cint
#     me_threshold::Cint
#     mb_threshold::Cint
#     intra_dc_precision::Cint
#     skip_top::Cint
#     skip_bottom::Cint
#     border_masking::Cfloat
#     mb_lmin::Cint
#     mb_lmax::Cint
#     me_penalty_compensation::Cint
#     bidir_refine::Cint
#     brd_scale::Cint
#     keyint_min::Cint
#     refs::Cint
#     chromaoffset::Cint
#     scenechange_factor::Cint
#     mv0_threshold::Cint
#     b_sensitivity::Cint
#     color_primaries::AVColorPrimaries
#     color_trc::AVColorTransferCharacteristic
#     colorspace::AVColorSpace
#     color_range::AVColorRange
#     chroma_sample_location::AVChromaLocation
#     slices::Cint
#     field_order::AVFieldOrder
#**#     sample_rate::Cint
#**#     channels::Cint
#**#     sample_fmt::AVSampleFormat
#**#     frame_size::Cint
#**#     frame_number::Cint
#     block_align::Cint
#     cutoff::Cint
#**#     request_channels::Cint
#**#     channel_layout::Uint64
#     request_channel_layout::Uint64
#     audio_service_type::AVAudioServiceType
#**#     request_sample_fmt::AVSampleFormat
#     get_buffer::Ptr{Void}
#     release_buffer::Ptr{Void}
#     reget_buffer::Ptr{Void}
#     get_buffer2::Ptr{Void}
#     refcounted_frames::Cint
#     qcompress::Cfloat
#     qblur::Cfloat
#     qmin::Cint
#     qmax::Cint
#     max_qdiff::Cint
#     rc_qsquish::Cfloat
#     rc_qmod_amp::Cfloat
#     rc_qmod_freq::Cint
#     rc_buffer_size::Cint
#     rc_override_count::Cint
#     rc_override::Ptr{RcOverride}
#     rc_eq::Ptr{Uint8}
#     rc_max_rate::Cint
#     rc_min_rate::Cint
#     rc_buffer_aggressivity::Cfloat
#     rc_initial_cplx::Cfloat
#     rc_max_available_vbv_use::Cfloat
#     rc_min_vbv_overflow_use::Cfloat
#     rc_initial_buffer_occupancy::Cint
#     coder_type::Cint
#     context_model::Cint
#     lmin::Cint
#     lmax::Cint
#**#     frame_skip_threshold::Cint
#**#     frame_skip_factor::Cint
#**#     frame_skip_exp::Cint
#**#     frame_skip_cmp::Cint
#     trellis::Cint
#     min_prediction_order::Cint
#     max_prediction_order::Cint
#     timecode_frame_start::Int64
#     rtp_callback::Ptr{Void}
#     rtp_payload_size::Cint
#     mv_bits::Cint
#     header_bits::Cint
#     i_tex_bits::Cint
#     p_tex_bits::Cint
#     i_count::Cint
#     p_count::Cint
#     skip_count::Cint
#     misc_bits::Cint
#     frame_bits::Cint
#**#     stats_out::Ptr{Uint8}
#**#     stats_in::Ptr{Uint8}
#     workaround_bugs::Cint
#     strict_std_compliance::Cint
#     error_concealment::Cint
#     debug::Cint
#     debug_mv::Cint
#     err_recognition::Cint
#     reordered_opaque::Int64
#     hwaccel::Ptr{AVHWAccel}
#     hwaccel_context::Ptr{Void}
#     error::Array_8_Uint64
#     dct_algo::Cint
#     idct_algo::Cint
#     bits_per_coded_sample::Cint
#     bits_per_raw_sample::Cint
#     lowres::Cint
#     coded_frame::Ptr{AVFrame}
#     thread_count::Cint
#     thread_type::Cint
#     active_thread_type::Cint
#     thread_safe_callbacks::Cint
#     execute::Ptr{Void}
#     execute2::Ptr{Void}
#     thread_opaque::Ptr{Void}
#     nsse_weight::Cint
#     profile::Cint
#     level::Cint
#     skip_loop_filter::AVDiscard
#     skip_idct::AVDiscard
#     skip_frame::AVDiscard
#     subtitle_header::Ptr{Uint8}
#     subtitle_header_size::Cint
#     error_rate::Cint
#     pkt::Ptr{AVPacket}
#     vbv_delay::Uint64
#     side_data_only_packets::Cint
#     pkt_timebase::AVRational
#     codec_descriptor::Ptr{AVCodecDescriptor}
#     pts_correction_num_faulty_pts::Int64
#     pts_correction_num_faulty_dts::Int64
#     pts_correction_last_pts::Int64
#     pts_correction_last_dts::Int64
#     sub_charenc::Ptr{Uint8}
#     sub_charenc_mode::Cint
#     skip_alpha::Cint
#     seek_preroll::Cint
#     chroma_intra_matrix::Ptr{Uint16}
# end

# immutable AVDeviceCapabilitiesQuery
#     av_class::Ptr{AVClass}
#     device_context::Ptr{AVFormatContext}
#     codec::AVCodecID
#**#     sample_format::AVSampleFormat
#**#     pixel_format::AVPixelFormat
#**#     sample_rate::Cint
#**#     channels::Cint
#**#     channel_layout::Int64
#**#     window_width::Cint
#**#     window_height::Cint
#**#     frame_width::Cint
#**#     frame_height::Cint
#**#     fps::AVRational
# end

