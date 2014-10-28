export create_device_query,
       set_device_with_query,
       list_devices,
       get_metadata


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


# **************************************************************************************************************
# Read metadata
# AVFormatContext
# -> metadata::Ptr{AVDictionary}
# f = opencamera()
# get_metadata(f.avin)
# **************************************************************************************************************

function get_metadata(I::AVInput,key::String)
    # Select Ptr{AVFormatContext}
    pFormatContext = I.apFormatContext[1]
    fmt_ctx = unsafe_load(pFormatContext)
    tags = Ptr{AVDictionaryEntry}[C_NULL]
    tag = tags[1]


    while(true)
        tag = av_dict_get(fmt_ctx.metadata, pointer(key), tag, cint(AV_DICT_IGNORE_SUFFIX))
        if tag !=C_NULL
            entry = unsafe_load(tag)
            metakey = bytestring(entry.key)
            metaentry = bytestring(entry.val)
            println(metakey, metaentry, "\n")
        else
            println("No entry!")
            break
        end
    end
end

# **************************************************************************************************************
