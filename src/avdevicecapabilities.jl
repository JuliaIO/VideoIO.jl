
# Functions for Device capabilities API and AVOptions
# compatible with FFmpeg but not Libav

export get_option,
       discover_devices,
       create_device_query,
       set_device_with_query,
       list_devices


# **************************************************************************************************************
# Getting the value of an option
# Some functions require FFmpeg, not compatible with libavutil v53
# get_option => returns value for a given option string key
# **************************************************************************************************************

# Check the type of option to search for e.g., image_size, pixel_fmt

macro assert_type(ex)
    option =""
    return :($ex=="" ? option = :default:
             $ex=="image_size" ? option = :image_size:
             $ex=="pixel_fmt" ? option = :pixel_fmt :
             $ex=="video_rate" ? option = :video_rate :
              error("option", $(string(ex)), " does not exist!"))
    return option
end

function get_option(I::VideoReader, key::String, OPTION_TYPE="")
    option = @assert_type(OPTION_TYPE)
    pFormatContext = I.avin.apFormatContext[1]

    # Retrieve Ptr{AVCodecContext}
    pCodecContext = I.pVideoCodecContext

    # Get value from children of FormatContext -> AVCodecContext
    search_flags = cint(AV_OPT_SEARCH_CHILDREN)

    if option==:default
    # Passing a double pointer
        outval = Array(Ptr{Uint8},1)
        if (av_opt_get(pFormatContext,pointer(key),search_flags, outval)<0)
            if (av_opt_get(pCodecContext,pointer(key),search_flags, outval)<0)
                error("Cannot get value for $key")
            else
                val = bytestring(outval[1])
                println("$key = ", val)
                return val
            end
        else
            val = bytestring(outval[1])
            println("$key = ", val)
            return val
        end
    elseif option ==:image_size
        out1 = Array(Ptr{Cint},1); pwidth = out1[1]
        out2 = Array(Ptr{Cint},1); pheight = out2[1]
        if (av_opt_get_image_size(pFormatContext,pointer(key),search_flags, pwidth, pheight)<0)
            error("Cannot get value for $key")
        else
            fval1 = convert(Int64, unsafe_load(pwidth))
            fval2 = convert(Int64, unsafe_load(pheight))
            println("Width: $fval1, Height: $fval2")
            return val1, val2
        end
    elseif option ==:pixel_fmt
        out = Array(Ptr{AVPixelFormat},1); ppix_fmt = out[1]
        if (av_opt_get_pixel_fmt(pFormatContext,pointer(key),search_flags, ppix_fmt)<0)
            error("Cannot get value for $key")
        else
            pix_fmt = convert(Int64, unsafe_load(ppix_fmt))
            println("Pixel format is: $pix_fmt")
            return pix_fmt
        end
    elseif option ==:video_rate
        out = Array(Ptr{AVRational},1); pvideorate = out[1]
        if (av_opt_get_video_rate(pFormatContext,pointer(key),search_flags, pvideorate)<0)
            error("Cannot get value for $key")
        else
            frame_rate = unsafe_load(pvideorate)
            println("Frame rate is: $(frame_rate.num/frame_rate.den) fps")
            return fps
        end
    end
end

# Examples:
# using VideoIO
# f = opencamera()
# get_option(f, "probesize")
# get_option(f, "list_devices")
# get_option(f, "max_delay")
# get_option(f, "analyzeduration")
# **************************************************************************************************************


# **************************************************************************************************************
# Accessing devices for input and output
# av_input_video_device_next
# av_output_video_device_next
#**************************************************************************************************************

# Structure to store input and output devices
type devices
    idevice_name::Vector{String}
    odevice_name::Vector{String}
    vpiformat::Vector{Ptr{AVInputFormat}}
    vpoformat::Vector{Ptr{AVOutputFormat}}
end

function discover_devices()

    # Check the device version
    println("AVDevice v", string(VideoIO.avdevice_version()))

    # Initialize empty pointers
    piformat = C_NULL # Input format
    poformat = C_NULL # Output format

    devices_list = devices([],[], Ptr{AVInputFormat}[], Ptr{AVOutputFormat}[])

    while (true)
        piformat = av_input_video_device_next(piformat)
        if piformat==C_NULL
            break
        end
        push!(devices_list.vpiformat, piformat)

        #unload iformat::Ptr{AVInputFormat}
        iformat = unsafe_load(piformat)
        idevice_name = bytestring(iformat.long_name)
        push!(devices_list.idevice_name, string(idevice_name))

        #extensions = bytestring(iformat.extensions)
        #flags = iformat.flags
        #mime_type = bytestring(iformat.mime_type)
        #raw_codec_id = iformat.raw_codec_id
        #priv_data_size = iformat.priv_data_size
        #avclass = unsafe_load(iformat.priv_class)
    end

    while (poformat = av_output_video_device_next(poformat) !=C_NULL)
        poformat = av_output_video_device_next(poformat)
        if poformat==C_NULL
            println("No output format detected!")
            break
        end
        push!(devices_list.vpoformat, poformat)
        #unload oformat::Ptr{AVOutputFormat}
        oformat = unsafe_load(poformat)
        odevice_name = bytestring(oformat.long_name)
        push!(devices_list.odevice_name, string(odevice_name))
        #extensions = bytestring(oformat.extensions)
        #mime_type = bytestring(oformat.mime_type)
        #flags = oformat.flags
        #priv_data_size = oformat.priv_data_size
        #video_codec::AVCodecID
        #subtitle_codec::AVCodecID
    end

    println("Input devices: \n")
    if length(devices_list.idevice_name) > 0
        for i=1:length(devices_list.idevice_name)
            println("[$i] : ", devices_list.idevice_name[i])
        end
    else
        println("No devices detected!")
    end

    println("Output devices:")
    if length(devices_list.odevice_name) > 0
        for i=1:length(devices_list.odevice_name)
            println("[$i] : ", devices_list.odevice_name[i])
        end
    else
        println("No output format detected! \n")
    end

  return devices_list
end

# Examples
# devices_list = discover_devices()
# name = devices_list.idevice_name
# format = devices_list.vpiformat[1]

# Find AVInputFormat based on short name, e.g., "AVFoundation"
# iformat = VideoIO.av_find_input_format(pointer("AVFoundation"))
# iformat = Ptr{AVInputFormat}

# **************************************************************************************************************
# AVDeviceCapabilitiesQuery API
# 1. create_device_query
# 2. query_device_ranges
# 3. set_device_with_query
# **************************************************************************************************************

# Create a new device query structure
function create_device_query(I::VideoReader, pDictionary)

    # Retrieve Ptr{AVFormatContext}
    pFormatContext = I.avin.apFormatContext[1]
    FormatContext = unsafe_load(pFormatContext)

#     pStream = unsafe_load(FormatContext.streams)
#     stream = unsafe_load(pStream)
#     codecContext = unsafe_load(stream.codec) #Ptr{AVCodecContext}
#     frame_width, frame_height = codecContext.width, codecContext.height
#     fps = AVRational(codecContext.time_base.den, codecContext.time_base.num)

    # Initialize a device query structure
#     DeviceQuery = AVDeviceCapabilitiesQuery (FormatContext.av_class,
#                                              pFormatContext,
#                                              AV_CODEC_ID_MPEG4,
#                                              AV_SAMPLE_FMT_NONE,
#                                              AV_PIX_FMT_YUYV422,
#                                              cint(0),
#                                              cint(0),
#                                              convert(Culonglong,0),
#                                              cint(640),
#                                              cint(480),
#                                              frame_width,
#                                              frame_height,
#                                              fps)

    queries= Ptr{AVDeviceCapabilitiesQuery}[C_NULL]
    pDictionary = Ptr{AVDictionary}[C_NULL]

    #pDictionary[1] = C_NULL

    # Can also set pDictionary => C_NULL
    if (avdevice_capabilities_create(queries,pFormatContext,pDictionary) < 0)
        error("Can not create a device query. Try again")
    end

    #avdevice_capabilities_free(queries, pFormatContext)
    return queries
end


function set_device_with_query(key::String, val::String, queries::Array{Ptr{AVDeviceCapabilitiesQuery}})

    # key, value and pair separators
    key_val_sep = ","
    pairs_sep = ";"
    opts = string(key, "," , val)

    #Ptr{AVDeviceCapabilitiesQuery}
    query = queries[1]

    res = av_set_options_string(query, pointer(opts), pointer(key_val_sep), pointer(pairs_sep))
    if res < 0
        error("Could not set '$key' option.")
    else
        println("$key set to $val.")
    end

    # deallocate
    # av_free(key)
    # av_free(pval)
    # avdevice_capabilities_free(query, pFormatContext)
end

# Examples:
# using VideoIO
# f = opencamera()
# set_device_with_query(f.avin, "codec", AV_CODEC_ID_RAWVIDEO, 0)
# set_device_with_query(f.avin, "codec", AV_CODEC_ID_MPEG4, 0)
# set_device_with_query(f.avin, "pixel_format", AV_PIX_FMT_YUV420P, 0)
# set_device_with_query(f.avin, "fps", AV_PIX_FMT_YUV420P, 0)


# **************************************************************************************************************
# List devices (may not be complete!)
#
# list_devices
# **************************************************************************************************************

function list_devices(I::AVInput)

  #VideoIO.av_setfield(f.avin.apFormatContext[1],:iformat,iformat)
  #pdevice_list = Ptr{VideoIO.AVDeviceInfoList}[C_NULL]
    # AVDeviceCapabilitiesQuery
    # AVDeviceCapabilitiesQuery.device_context::Ptr{AVFormatContext}

    # Select Ptr{AVFormatContext}
    # pFormatContext = I.apFormatContext[1]
    # apFormatContext = Ptr{AVFormatContext}[avformat_alloc_context()]
    pFormatContext = I.apFormatContext[1]

    # Initialize Ptr{AVDeviceInfoList} array
#     device_info0 = AVDeviceInfo(pointer("avfoundation"), pointer("avfoundation input device"))
#     apdevice_list0 = Ptr{AVDeviceInfo}[pointer_from_objref(device_info0)]
#     device_list0 = AVDeviceInfoList(pointer_from_objref(apdevice_list0[1]), cint(1), cint(0))
#     pdevice_list = Ptr{AVDeviceInfoList}[pointer_from_objref(device_list0)]
    pdevice_list = Ptr{AVDeviceInfoList}[C_NULL]

    if (avdevice_list_devices(pFormatContext, pdevice_list)<0)
        #avdevice_free_list_devices(device_list)
        error("Cannot list devices")
    else
        #get AVDeviceInfoList
        device_list = unsafe_load(pdevice_list)
        #number of autodetected devices
        nb_devices = device_list.nb_devices
        #index of default device or -1 if no default
        default_device =  device_list.default_device

        # get AVDeviceInfo
        pdevice_info = unsafe_load(device_list.devices)
        device_info = unsafe_load(pdevice_info)
        # get device_name and description
        device_name = bytestring(device_info.device_name)
        device_description = bytestring(device_info.device_description)

        println("Number of detected devices: $nb_devices")
        println("Default device index: $default_device")
        println(device_name,": ", device_description)

        #deallocate
        #avdevice_free_list_devices(device_list)
    end
end


# Examples:
# f = opencamera()
# list_devices(f.avin)
# **************************************************************************************************************


