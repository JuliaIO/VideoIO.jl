# not compatible with Debian Linux (libavutil <v53)

export get_option,
       discover_devices

# **************************************************************************************************************
# Get an option's value
# get_option => return value (string) for a given key (string)
# **************************************************************************************************************

function assert_type(ex::String)
    if !(ex=="" || ex=="image_size" || ex=="pixel_fmt" || ex=="video_rate")
     throw(ArgumentError("option does not exist!"))
   end
end

function get_option(I::VideoReader, key::String, OPTION_TYPE="")
    assert_type(OPTION_TYPE)
    pFormatContext = I.avin.apFormatContext[1]

    # Retrieve Ptr{AVCodecContext}
    pCodecContext = I.pVideoCodecContext

    # Get value from children of FormatContext -> AVCodecContext
    search_flags = cint(AV_OPT_SEARCH_CHILDREN)

    if option==:default
        outval = Array(Ptr{Uint8},1)
        if (av_opt_get(pFormatContext,pointer(key),search_flags, outval)<0)
            throw(ArgumentError("Input key does not match any option!"))
        else
            val = bytestring(outval[1])
            return val
        end
    elseif option ==:image_size
        out1 = Array(Ptr{Cint},1); pwidth = out1[1]
        out2 = Array(Ptr{Cint},1); pheight = out2[1]
        if (av_opt_get_image_size(pFormatContext,pointer(key),search_flags, pwidth, pheight)<0)
            throw(ArgumentError("Input key does not match any option!"))
        else
            fval1 = convert(Int64, unsafe_load(pwidth))
            fval2 = convert(Int64, unsafe_load(pheight))
            return val1, val2
        end
    elseif option ==:pixel_fmt
        out = Array(Ptr{AVPixelFormat},1); ppix_fmt = out[1]
        if (av_opt_get_pixel_fmt(pFormatContext,pointer(key),search_flags, ppix_fmt)<0)
            throw(ArgumentError("Input key does not match any option!"))
        else
            pix_fmt = convert(Int64, unsafe_load(ppix_fmt))
            return pix_fmt
        end
    elseif option ==:video_rate
        out = Array(Ptr{AVRational},1); pvideorate = out[1]
        if (av_opt_get_video_rate(pFormatContext,pointer(key),search_flags, pvideorate)<0)
            throw(ArgumentError("Input key does not match any option!"))
        else
            frame_rate = unsafe_load(pvideorate)
            return fps
        end
    end
end

# **************************************************************************************************************
# List all devices available
# discover_devices()
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
        iformat = unsafe_load(piformat)
        idevice_name = bytestring(iformat.long_name)
        push!(devices_list.idevice_name, string(idevice_name))
    end

    while (poformat = av_output_video_device_next(poformat) !=C_NULL)
        poformat = av_output_video_device_next(poformat)
        if poformat==C_NULL
            break
        end
        push!(devices_list.vpoformat, poformat)
        oformat = unsafe_load(poformat)
        odevice_name = bytestring(oformat.long_name)
        push!(devices_list.odevice_name, string(odevice_name))
    end

    println("Input devices: \n")
    if length(devices_list.idevice_name) > 0
        for i=1:length(devices_list.idevice_name)
            println("[$i] : ", devices_list.idevice_name[i])
        end
    end

    println("Output devices:")
    if length(devices_list.odevice_name) > 0
        for i=1:length(devices_list.odevice_name)
            println("[$i] : ", devices_list.odevice_name[i])
        end
    end

  return devices_list
end

