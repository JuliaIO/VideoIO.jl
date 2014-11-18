###############################################################################################################
# AVOptions API for VideoIO.jl
#
# October 2014
# See README_AVOptions.md
###############################################################################################################

export document_all_options,
       print_options,
       is_option,
       set_default_options,
       set_option,
       get_option_basic,
       create_dictionary,
       set_options_with_dictionary,
       query_device_ranges,
       get_videodevice_settings

@osx? include("avoptions_non_linux.jl") : @windows? include("avoptions_non_linux.jl") : nothing

# Support functions
cint(n) = convert(Cint,n)

# **************************************************************************************************************
# Document and view (optional) options
# 1. document_all_options => create a dictionary (from AVOption-enabled structures)
# 2. print_options
# **************************************************************************************************************

function document_all_options(I::VideoReader, view=false)
    if !I.avin.isopen
        error("No input file/device open!")
    end

    # Retrieve Ptr{AVFormatContext}
    pFormatContext = I.avin.apFormatContext[1]

    # Retrieve Ptr{AVCodecContext}
    pCodecContext = I.pVideoCodecContext

   # Create a dictionary of {option => [minvalue, maxvalue]}
    fmt_options = Dict{String,Vector{Cdouble}}()
    codec_options = Dict{String,Vector{Cdouble}}()

    for i in [pFormatContext, obj=pCodecContext]
        prevs = Ptr{AVOption}[C_NULL]
        prev = prevs[1]

        # Initialize the search of AVOption with Ptr{AVFormatContext}
        obj= i

        # Run through all AVOptions and store them in options
        while (true)
            prev = av_opt_next(obj, prev)
            if prev ==C_NULL
                break
            end
            avoption = unsafe_load(prev)
            name = bytestring(avoption.name)
            if i == pFormatContext
                fmt_options[string(name)] = [avoption.min, avoption.max]
            else
                codec_options[string(name)] = [avoption.min, avoption.max]
            end
        end
    end

    if view
        # Print options
        println("-"^75,"\n ", " "^10, "Format context options in AVOptions API \n","-"^75)
        print_options(fmt_options)
        println("-"^75,"\n ", " "^10, "Codec context options in AVOptions API \n","-"^75)
        print_options(codec_options)

        return fmt_options, codec_options
    end
end

function print_options(options::Dict{String,Vector{Cdouble}})
    if isempty(options)
        error("Options dictionary is empty!")
    end

    # Display options (sorted alphabetically)
    optionKeys = collect(keys(options))
    longest = maximum(map(i -> length(optionKeys[i]), 1:length(optionKeys)))
    sort!(vec(optionKeys))

    for i=1:length(optionKeys)
        name = optionKeys[i]
        println(name, " "^(longest-length(optionKeys[i]) +1), "=>  min: ",
                options[optionKeys[i]][1], " , max: " , options[optionKeys[i]][2])
     end
     println("\n")
end

# **************************************************************************************************************
# Set options
# 1. set_default_options  => Set all options to default values
# 2. set_option           => Set using "key", "value" pairs
# **************************************************************************************************************

function set_default_options(I::VideoReader)
    if !I.avin.isopen
        error("No input file/device open!")
    end

    # Set default formats on Ptr{AVFormatContext}
    pFormatContext = I.avin.apFormatContext[1]
    # av_opt_set_defaults2 (mask = 0, flags = 0)
    av_opt_set_defaults(pFormatContext) # input is Ptr{Void}

    # Set default codecs on Ptr{AVCodecContext}
    pCodecContext = I.pVideoCodecContext
    av_opt_set_defaults(pCodecContext)
    av_opt_free(pFormatContext)
end

function set_option(I::VideoReader, key::String, val::String)
    if !I.avin.isopen
        error("No input file/device open!")
    end

    # Select Ptr{AVFormatContext}
    pFormatContext = I.avin.apFormatContext[1]
    # Retrieve Ptr{AVCodecContext}
    pCodecContext = I.pVideoCodecContext

    # key, value and pair separators
    key_val_sep = ","
    pairs_sep = ";"
    opts = string(key, "," , val)

    if (res = av_set_options_string(pFormatContext, pointer(opts),pointer(key_val_sep), pointer(pairs_sep))<0)
        error("Could not set '$key' option.")
    end
end

# **************************************************************************************************************
# Find an option
# is_option => check if an option exists
# **************************************************************************************************************

function is_option(I::VideoReader, key::String)
    pFormatContext = I.avin.apFormatContext[1]
    #AVOptionType named constants (Ptr{Uint8})
    # Retrieve Ptr{AVCodecContext}
    pCodecContext = I.pVideoCodecContext

    unit =  C_NULL  # "AVOptionType"?, but not clear from docs
    opt_flag = cint(0)

    # AV_OPT_INT
    # AV_OPT_INT64
    # AV_OPT_DOUBLE
    # AV_OPT_FLOAT
    # AV_OPT_STRING
    # AV_OPT_RATIONAL
    # AV_OPT_BINARY
    # AV_OPT_DICT
    # AV_OPT_IMAGE_SIZE
    # AV_OPT_PIXEL_FMT
    # AV_OPT_SAMPLE_FMT
    # AV_OPT_VIDEO_RATE
    # AV_OPT_DURATION
    # AV_OPT_COLOR
    # AV_OPT_CHANNEL_LAYOUT

    # Search in nested objects (e.g., AVCodecContext)
    search_flags = cint(AV_OPT_SEARCH_CHILDREN)

    # Initialize a Ptr{AVOption}
    prevs = Ptr{AVOption}[C_NULL]
    prev = prevs[1]

    if (prev = av_opt_find(pFormatContext,pointer(key),unit, opt_flag, search_flags)==C_NULL)
        error("$key not found!")
    end
end

# **************************************************************************************************************
# Get an option's value
# get_option_basic => return value (string) for a given key (string)
# same as calling get_option(VideoReader,key,"") in avoptions_non_linux.jl
# **************************************************************************************************************

function get_option_basic(I::VideoReader, key::String)
    pFormatContext = I.avin.apFormatContext[1]

    # Retrieve Ptr{AVCodecContext}
    pCodecContext = I.pVideoCodecContext

    # Get value from children of FormatContext -> AVCodecContext
    search_flags = cint(AV_OPT_SEARCH_CHILDREN)

    # Passing a double pointer
    outval = Array(Ptr{Uint8},1)
    if (av_opt_get(pFormatContext,pointer(key),search_flags, outval)<0)
        error("Cannot get value for $key")
    else
        val = bytestring(outval[1])
        return val
    end
end

# **************************************************************************************************************
# AVDictionary API
# 1. create_dictionary
#     Input: key,value pairs stored in a Dict{String,String}
# 2. set_options_with_dictionary
# **************************************************************************************************************

function create_dictionary(entries)
    # Get all the keys from the user entries
    entries_keys = collect(keys(entries))

    # Initialize a dictionary
    pDictionary = Ptr{AVDictionary}[C_NULL]

    flags = cint(AV_DICT_DONT_OVERWRITE)
    #AV_DICT_MATCH_CASE
    #AV_DICT_IGNORE_SUFFIX
    # to avoid clearing val from memory
    #AV_DICT_DONT_STRDUP_KEY | AV_DICT_DONT_STRDUP_VAL
    #AV_DICT_DONT_OVERWRITE
    #AV_DICT_APPEND

    for k = 1:length(entries_keys)
        # Call av_dict_set() function
        if(av_dict_set(pDictionary, pointer(entries_keys[k]), pointer(entries[entries_keys[k]]),flags)< 0)
        #Cint = 0 on success, AVERROR <0 on failure
           error("Can not create $(user_options[option_keys[k]]) a dictionary")
        end
    end

    count = av_dict_count(pDictionary[1])
    return pDictionary
end


function set_options_with_dictionary(I::VideoReader, pDictionary::Array{Ptr{AVDictionary}})

    pDictionary[1]==C_NULL ? error("Dictionary is empty!") : nothing

    # Retrieve Ptr{AVFormatContext}
    pFormatContext = I.avin.apFormatContext[1]

    # Retrieve Ptr{AVCodecContext}
    pCodecContext = I.pVideoCodecContext

    # Set value in children of FormatContext -> AVCodecContext
    search_flags = cint(AV_OPT_SEARCH_CHILDREN)

    # Set options with dictionary
    # 0 on success, < 0 (AVERROR) if found in obj, but could not be set
    if (av_opt_set_dict2(pFormatContext, pDictionary, search_flags) !=0)
        error("Cannot set options with this dictionary. Check your dictionary!")
    end

    #av_dict_free(pDictionary)
    #av_opt_free(pFormatContext)
end

# **************************************************************************************************************
# Retrieve min and max values of a given option
# (currently not enabled for AVDeviceCapabilities API)
# **************************************************************************************************************

function query_device_ranges(I::VideoReader, key::String)
    # Select Ptr{AVFormatContext}
    pFormatContext = I.avin.apFormatContext[1]

    # Initialize AVOptionRanges
    ranges = Ptr{AVOptionRanges}[C_NULL]
    #search_flags = cint(AV_OPT_MULTI_COMPONENT_RANGE)
    search_flags = cint(AV_OPT_SEARCH_CHILDREN)

    # Query ranges
    if (av_opt_query_ranges(ranges,pFormatContext, pointer(key),search_flags)<0) #queries
        # av_free(key)
        # avdevice_capabilities_free(queries, pFormatContext)
        # av_opt_free_ranges(ranges): av_opt_freep_ranges(ranges) #deallocate
        error("Invalid input, failed to access device data.")

    else
        ranges = unsafe_load(ranges[1])         #Ptr{AVOptionRanges}}
        prange = unsafe_load(ranges.range)      #Ptr{AVOptionRange}
        range = unsafe_load(prange)             #AVOptionRange

        minVal = range.value_min  #Cdouble => Float64
        maxVal = range.value_max  #Cdouble => Float64

        return minVal, maxVal
        #deallocate
        #av_opt_free_ranges(ranges)
        #av_free(key)
        #avdevice_capabilities_free(query, pFormatContext)
    end
end

# **************************************************************************************************************
# List properties of the selected input device
# **************************************************************************************************************

function get_videodevice_settings (I::VideoReader)
    #Current video device settings

    # Image input format
    format = I.format
    window_width = I.width
    window_height = I.height
    framerate = I.framerate
    #aspect_ratio = I.aspect_ratio

    println("\nProperties of enabled video device: ")
    println("window_width: ", "$(window_width)")
    println("window_height: ", "$(window_height)")
    println("framerate: ", "$(framerate)")
    #println("aspect_ratio: ", "$(aspect_ratio)", "\n")

    # AVCodec
    codec_ctx = unsafe_load(I.pVideoCodecContext)
    pixel_format = codec_ctx.pix_fmt                            # AVPixelFormat (Cint)
    codec_id = convert(Int64,codec_ctx.codec_id)                # AVCodecID
    #frame_size = codec_ctx.frame_size

    println("pixel_format: ", "$(pixel_format)")
    println("codec_id: ", "$(codec_id)")

    video_codec = unsafe_load(I.pVideoCodec)
    scodec_name = bytestring(video_codec.name)                    #::Ptr{Uint8}
    lcodec_name = bytestring(video_codec.long_name)               #::Ptr{Uint8}
    video_codec_capabilities = video_codec.capabilities           #::Cint

    println("codec_name: ", "$(scodec_name)")
    println("mininum buffer size: ", "$(video_codec_capabilities)")
end

