##AVOptions API for VideoIO.jl



VideoIO/src/avoptions.jl<br>
updated for FFmpeg 2.4.2

2014, Maximiliano Suster


##Introduction

[VideoIO.jl](https://github.com/kmsquire/VideoIO.jl) is a Julia wrapper for [FFmpeg/Libav C libraries](http://www.ffmpeg.org/download.html#release_2.4) used for video and audio streaming. The AVOptions API provides a generic system to get/set options for devices, formats and codecs. It relies on [AVOptions](https://www.ffmpeg.org/doxygen/2.4/group__avoptions.html), [AVDictionary](https://www.ffmpeg.org/doxygen/2.4/structAVDictionary.html) and [AVDeviceCapabilitiesQuery](https://www.ffmpeg.org/doxygen/2.4/structAVDeviceCapabilitiesQuery.html). Currently functionality is enabled primarily for video streaming. 

The AVOptions API consists of 3 modules:

[Evaluate option strings](https://www.ffmpeg.org/doxygen/2.4/group__opt__eval__funcs.html): eval "string" option, return 0/-1<br>
[Option setting functions](https://www.ffmpeg.org/doxygen/2.4/group__opt__set__funcs.html): set value for a key string, if not string, then parsed<br>
[Option getting functions](https://www.ffmpeg.org/doxygen/2.4/group__opt__get__funcs.html): get value for a key string, if not string, then parsed

Options are stored in 3 structure types: [AVOption](https://www.ffmpeg.org/doxygen/2.4/structAVOption.html), [AVOptionRange](https://www.ffmpeg.org/doxygen/2.4/structAVOptionRange.html), [AVOptionRanges](https://www.ffmpeg.org/doxygen/2.4/structAVOptionRanges.html).

Key, value pairs can be optionally passed to AVOption functions using AVDictionary, as an opaque pointer (Ptr{Void}).  In turn, dict.c in the FFmpeg library declares AVDictionary to store entry count, key and value:

    struct AVDictionary {
        int count
        AVDictionaryEntry *elems
    }

Entries are then retrieved in Julia using the corresponding `AVDictionaryEntry` immutable type.

    immutable AVDictionaryEntry
      key::Ptr{Uint8}
      value::Ptr{Uint8}
    end


To access/modify option fields, the object(structure) must have `Ptr{AVClass}` as the **first** element, because option keys and values are stored in `AVOption`, a child of `AVClass`.

e.g., Starting with the input device structure `avin::AVInput` (see VideoIO/avio.jl)

    -> avin.apFormatContext holds a vector of Ptr{AVFormatContext},
    The following structures are enabled for the AVOptions API

    AVFormatContext -> Ptr{AVClass} -> AVClass -> Ptr{AVOption}
    AVCodecContext  -> Ptr{AVClass} -> AVClass -> Ptr{AVOption}
    AVDeviceCapabilitiesQuery  -> Ptr{AVClass} -> AVClass -> Ptr{AVOption}

## Installation

Some of the functions in the AVOptions API require new versions of FFmpeg (> 2.3.3) and it is likely that some options will change again in the future. To ensure full compatibility, update FFmpeg to the most recent version supported by VideoIO (as of today, 2.4.2). Open a shell terminal, and type these commands to update FFmpeg using homebrew:

     $ brew info ffmpeg
     $ cd /usr/local/Library/Formula
     $ brew update && brew upgrade ffmpeg
     $ ffmpeg -version
     ffmpeg version 2.4.2 Copyright (c) 2000-2014 the FFmpeg developers
     built on Oct 19 2014 18:31:37 with Apple LLVM version 6.0 (clang-600.0.51)...

To install the updated VideoIO with AVOptions in Julia, type these commands at the terminal:

<!-- julia>Pkg.release("Images") if branch is master -->
     julia>Pkg.update()
     julia>Pkg.build("Video")


The package will be tested as part of the VideoIO package (see test/avoptions_tests.jl):

     julia>Pkg.test("VideoIO")

## How to use the AVOptions API

#### <span style= "color:green">List recognized input devices and formats<span>

    julia> using VideoIO
    julia> devices_list = discover_devices()
    Input devices:
    [1] : AVFoundation input device
    [2] : Libavfilter virtual input device
    [3] : QTKit input device
    Output devices:
    No output format detected!

#### <span style= "color:green">Open an input device<span>
You can try to open the "default" device (e.g., webcam) as described in [VideoIO.jl](https://github.com/kmsquire/VideoIO.jl). However, this does not always work.

Here we will select an input device and its format from `devices_list array`:

    julia> devices_list.idevice_name
    3-element Array{String,1}:
     "AVFoundation input device"
     "Libavfilter virtual input device"
     "QTKit input device"

    julia> format = devices_list.vpiformat[1]
    Ptr{AVInputFormat} @0x00000001137b8f30

Next we get the name of the AVFoundation camera device using FFmpeg from Julia

    julia> open(`ffmpeg -f avfoundation -list_devices true -i ""`)
    ->[AVFoundation input device @ 0x7fd9eb600000] [0] Built-in iSight
    
Then open the selected built-in webcam

    julia> f = opencamera("Built-in-iSight", format)
    [avfoundation @ 0x7fac88e01c00] Selected pixel format (yuv420p)
    is not supported by the input device.
    [avfoundation @ 0x7fac88e01c00] Supported pixel formats:
    [avfoundation @ 0x7fac88e01c00]   uyvy422
    [avfoundation @ 0x7fac88e01c00]   yuyv422
    [avfoundation @ 0x7fac88e01c00]   nv12
    [avfoundation @ 0x7fac88e01c00]   0rgb
    [avfoundation @ 0x7fac88e01c00]   bgr0
    VideoReader(...)

#### <span style= "color:green">Document all API options and store them for later use<span>

We can now view (and store) most (but not all) AVOptions associated with this device, and their range of values (min and max), type the following:

     julia> fmt_options, codec_options = document_all_options(f, true)
    ---------------------------------------------------------------------------
               Format context options in AVOptions API 
    ---------------------------------------------------------------------------
    aggressive                  =>  min: -2.147483648e9 , max: 2.147483647e9
    analyzeduration             =>  min: 0.0 , max: 9.223372036854776e18
    audio_preload               =>  min: 0.0 , max: 2.147483646e9
    auto                        =>  min: -2.147483648e9 , max: 2.147483647e9
    avioflags                   =>  min: -2.147483648e9 , max: 2.147483647e9
    avoid_negative_ts           =>  min: -1.0 , max: 2.0
    bitexact                    =>  min: 0.0 , max: 0.0
    bitstream                   =>  min: -2.147483648e9 , max: 2.147483647e9
    buffer                      =>  min: -2.147483648e9 , max: 2.147483647e9
    careful                     =>  min: -2.147483648e9 , max: 2.147483647e9
    chunk_duration              =>  min: 0.0 , max: 2.147483646e9
    chunk_size                  =>  min: 0.0 , max: 2.147483646e9
    compliant                   =>  min: -2.147483648e9 , max: 2.147483647e9
    correct_ts_overflow         =>  min: 0.0 , max: 1.0
    crccheck                    =>  min: -2.147483648e9 , max: 2.147483647e9
    cryptokey                   =>  min: 0.0 , max: 0.0
    direct                      =>  min: -2.147483648e9 , max: 2.147483647e9
    disabled                    =>  min: -2.147483648e9 , max: 2.147483647e9
    discardcorrupt              =>  min: -2.147483648e9 , max: 2.147483647e9
    err_detect                  =>  min: -2.147483648e9 , max: 2.147483647e9
    experimental                =>  min: -2.147483648e9 , max: 2.147483647e9
    explode                     =>  min: -2.147483648e9 , max: 2.147483647e9
    f_err_detect                =>  min: -2.147483648e9 , max: 2.147483647e9
    f_strict                    =>  min: -2.147483648e9 , max: 2.147483647e9
    fdebug                      =>  min: 0.0 , max: 2.147483647e9
    fflags                      =>  min: -2.147483648e9 , max: 2.147483647e9
    flush_packets               =>  min: 0.0 , max: 1.0
    formatprobesize             =>  min: 0.0 , max: 2.147483646e9
    fpsprobesize                =>  min: -1.0 , max: 2.147483646e9
    genpts                      =>  min: -2.147483648e9 , max: 2.147483647e9
    igndts                      =>  min: -2.147483648e9 , max: 2.147483647e9
    ignidx                      =>  min: -2.147483648e9 , max: 2.147483647e9
    ignore_err                  =>  min: -2.147483648e9 , max: 2.147483647e9
    indexmem                    =>  min: 0.0 , max: 2.147483647e9
    keepside                    =>  min: -2.147483648e9 , max: 2.147483647e9
    latm                        =>  min: -2.147483648e9 , max: 2.147483647e9
    make_non_negative           =>  min: -2.147483648e9 , max: 2.147483647e9
    make_zero                   =>  min: -2.147483648e9 , max: 2.147483647e9
    max_delay                   =>  min: -1.0 , max: 2.147483647e9
    max_interleave_delta        =>  min: 0.0 , max: 9.223372036854776e18
    max_ts_probe                =>  min: 0.0 , max: 2.147483647e9
    metadata_header_padding     =>  min: -1.0 , max: 2.147483647e9
    nobuffer                    =>  min: 0.0 , max: 2.147483647e9
    nofillin                    =>  min: -2.147483648e9 , max: 2.147483647e9
    noparse                     =>  min: -2.147483648e9 , max: 2.147483647e9
    normal                      =>  min: -2.147483648e9 , max: 2.147483647e9
    output_ts_offset            =>  min: -9.223372036854776e18 , max: 9.223372036854776e18
    packetsize                  =>  min: 0.0 , max: 2.147483647e9
    probesize                   =>  min: 32.0 , max: 9.223372036854776e18
    rtbufsize                   =>  min: 0.0 , max: 2.147483647e9
    seek2any                    =>  min: 0.0 , max: 1.0
    skip_initial_bytes          =>  min: 0.0 , max: 9.223372036854776e18
    sortdts                     =>  min: -2.147483648e9 , max: 2.147483647e9
    start_time_realtime         =>  min: -9.223372036854776e18 , max: 9.223372036854776e18
    strict                      =>  min: -2.147483648e9 , max: 2.147483647e9
    ts                          =>  min: -2.147483648e9 , max: 2.147483647e9
    use_wallclock_as_timestamps =>  min: 0.0 , max: 2.147483646e9

    ---------------------------------------------------------------------------
               Codec context options in AVOptions API 
    ---------------------------------------------------------------------------
    aac_eld                =>  min: -2.147483648e9 , max: 2.147483647e9
    aac_he                 =>  min: -2.147483648e9 , max: 2.147483647e9
    aac_he_v2              =>  min: -2.147483648e9 , max: 2.147483647e9
    aac_ld                 =>  min: -2.147483648e9 , max: 2.147483647e9
    aac_low                =>  min: -2.147483648e9 , max: 2.147483647e9
    aac_ltp                =>  min: -2.147483648e9 , max: 2.147483647e9
    aac_main               =>  min: -2.147483648e9 , max: 2.147483647e9
    aac_ssr                =>  min: -2.147483648e9 , max: 2.147483647e9
    ab                     =>  min: 0.0 , max: 2.147483647e9
    ac                     =>  min: -2.147483648e9 , max: 2.147483647e9
    ac_vlc                 =>  min: -2.147483648e9 , max: 2.147483647e9
    aggressive             =>  min: -2.147483648e9 , max: 2.147483647e9
    aic                    =>  min: -2.147483648e9 , max: 2.147483647e9
    all                    =>  min: -2.147483648e9 , max: 2.147483647e9
    altivec                =>  min: -2.147483648e9 , max: 2.147483647e9
    amv                    =>  min: -2.147483648e9 , max: 2.147483647e9
    ar                     =>  min: -2.147483648e9 , max: 2.147483647e9
    arm                    =>  min: -2.147483648e9 , max: 2.147483647e9
    aspect                 =>  min: 0.0 , max: 10.0
    audio_service_type     =>  min: 0.0 , max: 8.0
    auto                   =>  min: -2.147483648e9 , max: 2.147483647e9
    autodetect             =>  min: -2.147483648e9 , max: 2.147483647e9
    b                      =>  min: 0.0 , max: 2.147483647e9
    b_qfactor              =>  min: -3.4028234663852886e38 , max: 3.4028234663852886e38
    b_qoffset              =>  min: -3.4028234663852886e38 , max: 3.4028234663852886e38
    b_sensitivity          =>  min: 1.0 , max: 2.147483647e9
    b_strategy             =>  min: -2.147483648e9 , max: 2.147483647e9
    bb                     =>  min: 0.0 , max: 0.0
    bf                     =>  min: -2.147483648e9 , max: 2.147483647e9
    bidir                  =>  min: -2.147483648e9 , max: 2.147483647e9
    bidir_refine           =>  min: 0.0 , max: 4.0
    bit                    =>  min: -2.147483648e9 , max: 2.147483647e9
    bitexact               =>  min: -2.147483648e9 , max: 2.147483647e9
    bits                   =>  min: -2.147483648e9 , max: 2.147483647e9
    bits_per_coded_sample  =>  min: -2.147483648e9 , max: 2.147483647e9
    bits_per_raw_sample    =>  min: -2.147483648e9 , max: 2.147483647e9
    bitstream              =>  min: -2.147483648e9 , max: 2.147483647e9
    block_align            =>  min: -2.147483648e9 , max: 2.147483647e9
    border_mask            =>  min: -3.4028234663852886e38 , max: 3.4028234663852886e38
    brd_scale              =>  min: 0.0 , max: 10.0
    bt                     =>  min: 0.0 , max: 0.0
    bt1361                 =>  min: -2.147483648e9 , max: 2.147483647e9
    bt2020                 =>  min: -2.147483648e9 , max: 2.147483647e9
    bt2020_10bit           =>  min: -2.147483648e9 , max: 2.147483647e9
    bt2020_12bit           =>  min: -2.147483648e9 , max: 2.147483647e9
    bt2020_cl              =>  min: -2.147483648e9 , max: 2.147483647e9
    bt2020_ncl             =>  min: -2.147483648e9 , max: 2.147483647e9
    bt470bg                =>  min: -2.147483648e9 , max: 2.147483647e9
    bt470m                 =>  min: -2.147483648e9 , max: 2.147483647e9
    bt709                  =>  min: -2.147483648e9 , max: 2.147483647e9
    buffer                 =>  min: -2.147483648e9 , max: 2.147483647e9
    buffers                =>  min: -2.147483648e9 , max: 2.147483647e9
    bufsize                =>  min: -2.147483648e9 , max: 2.147483647e9
    bug                    =>  min: -2.147483648e9 , max: 2.147483647e9
    bugs                   =>  min: -2.147483648e9 , max: 2.147483647e9
    careful                =>  min: -2.147483648e9 , max: 2.147483647e9
    cgop                   =>  min: -2.147483648e9 , max: 2.147483647e9
    channel_layout         =>  min: 0.0 , max: 9.223372036854776e18
    chroma                 =>  min: -2.147483648e9 , max: 2.147483647e9
    chroma_sample_location =>  min: 0.0 , max: 6.0
    chromaoffset           =>  min: -2.147483648e9 , max: 2.147483647e9
    chunks                 =>  min: -2.147483648e9 , max: 2.147483647e9
    cmp                    =>  min: -2.147483648e9 , max: 2.147483647e9
    co                     =>  min: -2.147483648e9 , max: 2.147483647e9
    codec_tag              =>  min: -2.147483648e9 , max: 2.147483647e9
    coder                  =>  min: -2.147483648e9 , max: 2.147483647e9
    color_primaries        =>  min: 1.0 , max: 9.0
    color_range            =>  min: 0.0 , max: 2.0
    color_trc              =>  min: 1.0 , max: 15.0
    colorspace             =>  min: 1.0 , max: 10.0
    compliant              =>  min: -2.147483648e9 , max: 2.147483647e9
    compression_level      =>  min: -2.147483648e9 , max: 2.147483647e9
    context                =>  min: -2.147483648e9 , max: 2.147483647e9
    crccheck               =>  min: -2.147483648e9 , max: 2.147483647e9
    cutoff                 =>  min: -2.147483648e9 , max: 2.147483647e9
    dark_mask              =>  min: -3.4028234663852886e38 , max: 3.4028234663852886e38
    dc                     =>  min: -8.0 , max: 16.0
    dc_clip                =>  min: -2.147483648e9 , max: 2.147483647e9
    dct                    =>  min: -2.147483648e9 , max: 2.147483647e9
    dct_coeff              =>  min: -2.147483648e9 , max: 2.147483647e9
    dctmax                 =>  min: -2.147483648e9 , max: 2.147483647e9
    deblock                =>  min: -2.147483648e9 , max: 2.147483647e9
    debug                  =>  min: 0.0 , max: 2.147483647e9
    default                =>  min: -2.147483648e9 , max: 2.147483647e9
    deflate                =>  min: -2.147483648e9 , max: 2.147483647e9
    delay                  =>  min: -2.147483648e9 , max: 2.147483647e9
    di                     =>  min: -2.147483648e9 , max: 2.147483647e9
    dia                    =>  min: -2.147483648e9 , max: 2.147483647e9
    dia_size               =>  min: -2.147483648e9 , max: 2.147483647e9
    direct_blocksize       =>  min: -2.147483648e9 , max: 2.147483647e9
    do_nothing             =>  min: -2.147483648e9 , max: 2.147483647e9
    dtg_active_format      =>  min: -2.147483648e9 , max: 2.147483647e9
    dts                    =>  min: -2.147483648e9 , max: 2.147483647e9
    dts_96_24              =>  min: -2.147483648e9 , max: 2.147483647e9
    dts_es                 =>  min: -2.147483648e9 , max: 2.147483647e9
    dts_hd_hra             =>  min: -2.147483648e9 , max: 2.147483647e9
    dts_hd_ma              =>  min: -2.147483648e9 , max: 2.147483647e9
    ec                     =>  min: -2.147483648e9 , max: 2.147483647e9
    edge                   =>  min: -2.147483648e9 , max: 2.147483647e9
    ef                     =>  min: -2.147483648e9 , max: 2.147483647e9
    em                     =>  min: -2.147483648e9 , max: 2.147483647e9
    emu_edge               =>  min: -2.147483648e9 , max: 2.147483647e9
    epzs                   =>  min: -2.147483648e9 , max: 2.147483647e9
    er                     =>  min: -2.147483648e9 , max: 2.147483647e9
    err_detect             =>  min: -2.147483648e9 , max: 2.147483647e9
    error                  =>  min: -2.147483648e9 , max: 2.147483647e9
    esa                    =>  min: -2.147483648e9 , max: 2.147483647e9
    experimental           =>  min: -2.147483648e9 , max: 2.147483647e9
    explode                =>  min: -2.147483648e9 , max: 2.147483647e9
    export_mvs             =>  min: -2.147483648e9 , max: 2.147483647e9
    extradata_size         =>  min: -2.147483648e9 , max: 2.147483647e9
    faan                   =>  min: -2.147483648e9 , max: 2.147483647e9
    faani                  =>  min: -2.147483648e9 , max: 2.147483647e9
    fast                   =>  min: -2.147483648e9 , max: 2.147483647e9
    fastint                =>  min: -2.147483648e9 , max: 2.147483647e9
    favor_inter            =>  min: -2.147483648e9 , max: 2.147483647e9
    fcc                    =>  min: -2.147483648e9 , max: 2.147483647e9
    field_order            =>  min: 0.0 , max: 5.0
    film                   =>  min: -2.147483648e9 , max: 2.147483647e9
    flags                  =>  min: 0.0 , max: 4.294967295e9
    flags2                 =>  min: 0.0 , max: 4.294967295e9
    frame                  =>  min: -2.147483648e9 , max: 2.147483647e9
    frame_bits             =>  min: -2.147483648e9 , max: 2.147483647e9
    frame_number           =>  min: -2.147483648e9 , max: 2.147483647e9
    frame_size             =>  min: -2.147483648e9 , max: 2.147483647e9
    full                   =>  min: -2.147483648e9 , max: 2.147483647e9
    g                      =>  min: -2.147483648e9 , max: 2.147483647e9
    gamma22                =>  min: -2.147483648e9 , max: 2.147483647e9
    gamma28                =>  min: -2.147483648e9 , max: 2.147483647e9
    global_header          =>  min: -2.147483648e9 , max: 2.147483647e9
    global_quality         =>  min: -2.147483648e9 , max: 2.147483647e9
    gmc                    =>  min: -2.147483648e9 , max: 2.147483647e9
    gray                   =>  min: -2.147483648e9 , max: 2.147483647e9
    guess_mvs              =>  min: -2.147483648e9 , max: 2.147483647e9
    has_b_frames           =>  min: -2.147483648e9 , max: 2.147483647e9
    header_bits            =>  min: -2.147483648e9 , max: 2.147483647e9
    hex                    =>  min: -2.147483648e9 , max: 2.147483647e9
    hi                     =>  min: -2.147483648e9 , max: 2.147483647e9
    hpel_chroma            =>  min: -2.147483648e9 , max: 2.147483647e9
    i_count                =>  min: -2.147483648e9 , max: 2.147483647e9
    i_qfactor              =>  min: -3.4028234663852886e38 , max: 3.4028234663852886e38
    i_qoffset              =>  min: -3.4028234663852886e38 , max: 3.4028234663852886e38
    i_tex_bits             =>  min: -2.147483648e9 , max: 2.147483647e9
    ibias                  =>  min: -2.147483648e9 , max: 2.147483647e9
    idct                   =>  min: 0.0 , max: 2.147483647e9
    iec61966_2_1           =>  min: -2.147483648e9 , max: 2.147483647e9
    iec61966_2_4           =>  min: -2.147483648e9 , max: 2.147483647e9
    ignore_err             =>  min: -2.147483648e9 , max: 2.147483647e9
    ignorecrop             =>  min: -2.147483648e9 , max: 2.147483647e9
    ildct                  =>  min: -2.147483648e9 , max: 2.147483647e9
    ildctcmp               =>  min: -2.147483648e9 , max: 2.147483647e9
    ilme                   =>  min: -2.147483648e9 , max: 2.147483647e9
    input_preserved        =>  min: -2.147483648e9 , max: 2.147483647e9
    int                    =>  min: -2.147483648e9 , max: 2.147483647e9
    ipp                    =>  min: -2.147483648e9 , max: 2.147483647e9
    iter                   =>  min: -2.147483648e9 , max: 2.147483647e9
    jpeg                   =>  min: -2.147483648e9 , max: 2.147483647e9
    ka                     =>  min: -2.147483648e9 , max: 2.147483647e9
    keyint_min             =>  min: -2.147483648e9 , max: 2.147483647e9
    last_pred              =>  min: -2.147483648e9 , max: 2.147483647e9
    left                   =>  min: -2.147483648e9 , max: 2.147483647e9
    level                  =>  min: -2.147483648e9 , max: 2.147483647e9
    linear                 =>  min: -2.147483648e9 , max: 2.147483647e9
    lmax                   =>  min: 0.0 , max: 2.147483647e9
    lmin                   =>  min: 0.0 , max: 2.147483647e9
    local_header           =>  min: -2.147483648e9 , max: 2.147483647e9
    log                    =>  min: -2.147483648e9 , max: 2.147483647e9
    log_level_offset       =>  min: -2.147483648e9 , max: 2.147483647e9
    log_sqrt               =>  min: -2.147483648e9 , max: 2.147483647e9
    loop                   =>  min: -2.147483648e9 , max: 2.147483647e9
    low_delay              =>  min: -2.147483648e9 , max: 2.147483647e9
    lowres                 =>  min: 0.0 , max: 2.147483647e9
    lumi_mask              =>  min: -3.4028234663852886e38 , max: 3.4028234663852886e38
    ma                     =>  min: -2.147483648e9 , max: 2.147483647e9
    max_prediction_order   =>  min: -2.147483648e9 , max: 2.147483647e9
    maxrate                =>  min: 0.0 , max: 2.147483647e9
    mb_threshold           =>  min: -2.147483648e9 , max: 2.147483647e9
    mb_type                =>  min: -2.147483648e9 , max: 2.147483647e9
    mbcmp                  =>  min: -2.147483648e9 , max: 2.147483647e9
    mbd                    =>  min: 0.0 , max: 2.0
    mblmax                 =>  min: 1.0 , max: 32767.0
    mblmin                 =>  min: 1.0 , max: 32767.0
    me_method              =>  min: -2.147483648e9 , max: 2.147483647e9
    me_range               =>  min: -2.147483648e9 , max: 2.147483647e9
    me_threshold           =>  min: -2.147483648e9 , max: 2.147483647e9
    median                 =>  min: -2.147483648e9 , max: 2.147483647e9
    mepc                   =>  min: -2.147483648e9 , max: 2.147483647e9
    min_prediction_order   =>  min: -2.147483648e9 , max: 2.147483647e9
    minrate                =>  min: -2.147483648e9 , max: 2.147483647e9
    misc_bits              =>  min: -2.147483648e9 , max: 2.147483647e9
    mmco                   =>  min: -2.147483648e9 , max: 2.147483647e9
    mmx                    =>  min: -2.147483648e9 , max: 2.147483647e9
    mpeg                   =>  min: -2.147483648e9 , max: 2.147483647e9
    mpeg2_aac_he           =>  min: -2.147483648e9 , max: 2.147483647e9
    mpeg2_aac_low          =>  min: -2.147483648e9 , max: 2.147483647e9
    mpeg_quant             =>  min: -2.147483648e9 , max: 2.147483647e9
    ms                     =>  min: -2.147483648e9 , max: 2.147483647e9
    mv                     =>  min: -2.147483648e9 , max: 2.147483647e9
    mv0                    =>  min: -2.147483648e9 , max: 2.147483647e9
    mv0_threshold          =>  min: 0.0 , max: 2.147483647e9
    mv4                    =>  min: -2.147483648e9 , max: 2.147483647e9
    mv_bits                =>  min: -2.147483648e9 , max: 2.147483647e9
    naq                    =>  min: -2.147483648e9 , max: 2.147483647e9
    no_padding             =>  min: -2.147483648e9 , max: 2.147483647e9
    nointra                =>  min: -2.147483648e9 , max: 2.147483647e9
    nokey                  =>  min: -2.147483648e9 , max: 2.147483647e9
    nomc                   =>  min: -2.147483648e9 , max: 2.147483647e9
    none                   =>  min: -2.147483648e9 , max: 2.147483647e9
    noout                  =>  min: -2.147483648e9 , max: 2.147483647e9
    noref                  =>  min: -2.147483648e9 , max: 2.147483647e9
    normal                 =>  min: -2.147483648e9 , max: 2.147483647e9
    nr                     =>  min: -2.147483648e9 , max: 2.147483647e9
    nsse                   =>  min: -2.147483648e9 , max: 2.147483647e9
    nssew                  =>  min: -2.147483648e9 , max: 2.147483647e9
    old_msmpeg4            =>  min: -2.147483648e9 , max: 2.147483647e9
    output_corrupt         =>  min: -2.147483648e9 , max: 2.147483647e9
    p_count                =>  min: -2.147483648e9 , max: 2.147483647e9
    p_mask                 =>  min: -3.4028234663852886e38 , max: 3.4028234663852886e38
    p_tex_bits             =>  min: -2.147483648e9 , max: 2.147483647e9
    pass1                  =>  min: -2.147483648e9 , max: 2.147483647e9
    pass2                  =>  min: -2.147483648e9 , max: 2.147483647e9
    pbias                  =>  min: -2.147483648e9 , max: 2.147483647e9
    pf                     =>  min: -2.147483648e9 , max: 2.147483647e9
    phods                  =>  min: -2.147483648e9 , max: 2.147483647e9
    pict                   =>  min: -2.147483648e9 , max: 2.147483647e9
    pkt_timebase           =>  min: 0.0 , max: 2.147483647e9
    plane                  =>  min: -2.147483648e9 , max: 2.147483647e9
    pre_decoder            =>  min: -2.147483648e9 , max: 2.147483647e9
    pre_dia_size           =>  min: -2.147483648e9 , max: 2.147483647e9
    precmp                 =>  min: -2.147483648e9 , max: 2.147483647e9
    pred                   =>  min: -2.147483648e9 , max: 2.147483647e9
    preme                  =>  min: -2.147483648e9 , max: 2.147483647e9
    profile                =>  min: -2.147483648e9 , max: 2.147483647e9
    progressive            =>  min: 0.0 , max: 0.0
    ps                     =>  min: -2.147483648e9 , max: 2.147483647e9
    psnr                   =>  min: -2.147483648e9 , max: 2.147483647e9
    pts                    =>  min: -2.147483648e9 , max: 2.147483647e9
    qblur                  =>  min: -1.0 , max: 3.4028234663852886e38
    qcomp                  =>  min: -3.4028234663852886e38 , max: 3.4028234663852886e38
    qdiff                  =>  min: -2.147483648e9 , max: 2.147483647e9
    qmax                   =>  min: -1.0 , max: 1024.0
    qmin                   =>  min: -1.0 , max: 69.0
    qp                     =>  min: -2.147483648e9 , max: 2.147483647e9
    qpel                   =>  min: -2.147483648e9 , max: 2.147483647e9
    qpel_chroma            =>  min: -2.147483648e9 , max: 2.147483647e9
    qpel_chroma2           =>  min: -2.147483648e9 , max: 2.147483647e9
    qscale                 =>  min: -2.147483648e9 , max: 2.147483647e9
    qsquish                =>  min: 0.0 , max: 99.0
    raw                    =>  min: -2.147483648e9 , max: 2.147483647e9
    rc                     =>  min: -2.147483648e9 , max: 2.147483647e9
    rc_buf_aggressivity    =>  min: -3.4028234663852886e38 , max: 3.4028234663852886e38
    rc_eq                  =>  min: -128.0 , max: 127.0
    rc_init_cplx           =>  min: -3.4028234663852886e38 , max: 3.4028234663852886e38
    rc_init_occupancy      =>  min: -2.147483648e9 , max: 2.147483647e9
    rc_max_vbv_use         =>  min: 0.0 , max: 3.4028234663852886e38
    rc_min_vbv_use         =>  min: 0.0 , max: 3.4028234663852886e38
    rc_override_count      =>  min: -2.147483648e9 , max: 2.147483647e9
    rc_qmod_amp            =>  min: -3.4028234663852886e38 , max: 3.4028234663852886e38
    rc_qmod_freq           =>  min: -2.147483648e9 , max: 2.147483647e9
    rc_strategy            =>  min: -2.147483648e9 , max: 2.147483647e9
    rd                     =>  min: -2.147483648e9 , max: 2.147483647e9
    refcounted_frames      =>  min: 0.0 , max: 1.0
    refs                   =>  min: -2.147483648e9 , max: 2.147483647e9
    request_channel_layout =>  min: 0.0 , max: 9.223372036854776e18
    request_channels       =>  min: 0.0 , max: 2.147483647e9
    request_sample_fmt     =>  min: -1.0 , max: 2.147483647e9
    rgb                    =>  min: -2.147483648e9 , max: 2.147483647e9
    rle                    =>  min: -2.147483648e9 , max: 2.147483647e9
    sad                    =>  min: -2.147483648e9 , max: 2.147483647e9
    satd                   =>  min: -2.147483648e9 , max: 2.147483647e9
    sc_factor              =>  min: 0.0 , max: 2.147483647e9
    sc_threshold           =>  min: -2.147483648e9 , max: 2.147483647e9
    scplx_mask             =>  min: -3.4028234663852886e38 , max: 3.4028234663852886e38
    sh4                    =>  min: -2.147483648e9 , max: 2.147483647e9
    showall                =>  min: -2.147483648e9 , max: 2.147483647e9
    side_data_only_packets =>  min: 0.0 , max: 1.0
    simple                 =>  min: -2.147483648e9 , max: 2.147483647e9
    simplealpha            =>  min: -2.147483648e9 , max: 2.147483647e9
    simplearm              =>  min: -2.147483648e9 , max: 2.147483647e9
    simplearmv5te          =>  min: -2.147483648e9 , max: 2.147483647e9
    simplearmv6            =>  min: -2.147483648e9 , max: 2.147483647e9
    simpleauto             =>  min: -2.147483648e9 , max: 2.147483647e9
    simplemmx              =>  min: -2.147483648e9 , max: 2.147483647e9
    simpleneon             =>  min: -2.147483648e9 , max: 2.147483647e9
    skip                   =>  min: -2.147483648e9 , max: 2.147483647e9
    skip_alpha             =>  min: 0.0 , max: 1.0
    skip_bottom            =>  min: -2.147483648e9 , max: 2.147483647e9
    skip_count             =>  min: -2.147483648e9 , max: 2.147483647e9
    skip_exp               =>  min: -2.147483648e9 , max: 2.147483647e9
    skip_factor            =>  min: -2.147483648e9 , max: 2.147483647e9
    skip_frame             =>  min: -2.147483648e9 , max: 2.147483647e9
    skip_idct              =>  min: -2.147483648e9 , max: 2.147483647e9
    skip_loop_filter       =>  min: -2.147483648e9 , max: 2.147483647e9
    skip_threshold         =>  min: -2.147483648e9 , max: 2.147483647e9
    skip_top               =>  min: -2.147483648e9 , max: 2.147483647e9
    skipcmp                =>  min: -2.147483648e9 , max: 2.147483647e9
    slice                  =>  min: -2.147483648e9 , max: 2.147483647e9
    slice_count            =>  min: -2.147483648e9 , max: 2.147483647e9
    slice_flags            =>  min: -2.147483648e9 , max: 2.147483647e9
    slices                 =>  min: 0.0 , max: 2.147483647e9
    smpte170m              =>  min: -2.147483648e9 , max: 2.147483647e9
    smpte240m              =>  min: -2.147483648e9 , max: 2.147483647e9
    sse                    =>  min: -2.147483648e9 , max: 2.147483647e9
    startcode              =>  min: -2.147483648e9 , max: 2.147483647e9
    std_qpel               =>  min: -2.147483648e9 , max: 2.147483647e9
    stream_codec_tag       =>  min: -2.147483648e9 , max: 2.147483647e9
    strict                 =>  min: -2.147483648e9 , max: 2.147483647e9
    sub_charenc            =>  min: -128.0 , max: 127.0
    sub_charenc_mode       =>  min: -1.0 , max: 2.147483647e9
    subcmp                 =>  min: -2.147483648e9 , max: 2.147483647e9
    subq                   =>  min: -2.147483648e9 , max: 2.147483647e9
    tb                     =>  min: 0.0 , max: 0.0
    tcplx_mask             =>  min: -3.4028234663852886e38 , max: 3.4028234663852886e38
    tesa                   =>  min: -2.147483648e9 , max: 2.147483647e9
    thread_ops             =>  min: -2.147483648e9 , max: 2.147483647e9
    thread_type            =>  min: 0.0 , max: 2.147483647e9
    threads                =>  min: 0.0 , max: 2.147483647e9
    ticks_per_frame        =>  min: 1.0 , max: 2.147483647e9
    time_base              =>  min: -2.147483648e9 , max: 2.147483647e9
    timecode_frame_start   =>  min: 0.0 , max: 9.223372036854776e18
    trellis                =>  min: -2.147483648e9 , max: 2.147483647e9
    trunc                  =>  min: -2.147483648e9 , max: 2.147483647e9
    truncated              =>  min: -2.147483648e9 , max: 2.147483647e9
    tt                     =>  min: 0.0 , max: 0.0
    umh                    =>  min: -2.147483648e9 , max: 2.147483647e9
    ump4                   =>  min: -2.147483648e9 , max: 2.147483647e9
    unaligned              =>  min: -2.147483648e9 , max: 2.147483647e9
    unknown                =>  min: -2.147483648e9 , max: 2.147483647e9
    unofficial             =>  min: -2.147483648e9 , max: 2.147483647e9
    unspecified            =>  min: -2.147483648e9 , max: 2.147483647e9
    very                   =>  min: -2.147483648e9 , max: 2.147483647e9
    vi                     =>  min: -2.147483648e9 , max: 2.147483647e9
    vis_mb_type            =>  min: -2.147483648e9 , max: 2.147483647e9
    vis_qp                 =>  min: -2.147483648e9 , max: 2.147483647e9
    vismv                  =>  min: 0.0 , max: 2.147483647e9
    vlc                    =>  min: -2.147483648e9 , max: 2.147483647e9
    vo                     =>  min: -2.147483648e9 , max: 2.147483647e9
    vsad                   =>  min: -2.147483648e9 , max: 2.147483647e9
    vsse                   =>  min: -2.147483648e9 , max: 2.147483647e9
    w53                    =>  min: -2.147483648e9 , max: 2.147483647e9
    w97                    =>  min: -2.147483648e9 , max: 2.147483647e9
    x1                     =>  min: -2.147483648e9 , max: 2.147483647e9
    xvid                   =>  min: -2.147483648e9 , max: 2.147483647e9
    xvid_ilace             =>  min: -2.147483648e9 , max: 2.147483647e9
    xvidmmx                =>  min: -2.147483648e9 , max: 2.147483647e9
    xvmc_acceleration      =>  min: -2.147483648e9 , max: 2.147483647e9
    ycocg                  =>  min: -2.147483648e9 , max: 2.147483647e9
    zero                   =>  min: -2.147483648e9 , max: 2.147483647e9


#### To view supported pixel formats:

Given changes in the option names accross library versions, the most reliable way to list all the available pixel formats is by calling FFmpeg from Julia. You can select a device from the **idevice_name** array above (e.g., "avfoundation"):

    julia> open(`ffmpeg -f avfoundation -pix_fmts` all)
    -> Pixel formats:
    I.... = Supported Input  format for conversion
    .O... = Supported Output format for conversion
    ..H.. = Hardware accelerated format
    ...P. = Paletted format
    ....B = Bitstream format
    FLAGS NAME            NB_COMPONENTS BITS_PER_PIXEL
    IO... yuv420p                3            12
    IO... yuyv422                3            16
    IO... rgb24                  3            24
    IO... bgr24                  3            24
    . . . . many more

To set a pixel format with the AVOptions API (see example below), you need to preprend the format name, e.g., **yuv420p** as follows **`VideoIO.AV_PIX_FMT_YUV420P`**.

#### <span style= "color:green">Check options and set default values <span>

Check whether an option exists<br>

    julia>is_option(f, "probesize")
    probesize found!

You can set all options to default values

    julia> set_default_options(f)
    Set default format and codec options

#### <span style= "color:green">Get and set options with (name, value) strings<span>
1.Get **`video_device_index`**  (default = -1)

    julia> get_option(f, "video_device_index")
    video_device_index = -1

2.Get **`pixel_format`** and then set it to **`0RGB`**

    julia> pix_format = get_option(f, "pixel_format")
    pixel_format = uyvy422

    julia> set_option(f, "pixel_format", string(VideoIO.AV_PIX_FMT_0RGB))
    pixel_format set to 295.

3.Get **`frame_rate`** and then set it to **`15 fps`**

    julia> frame_rate = get_option(f, "frame_rate")
    frame_rate = 30.000000

    julia> set_option(f, "frame_rate", "15")
    frame_rate set to 15.

4.Get **`probesize`** and then set to **`1500000`**

    julia> get_option(f, "probesize")
    probesize = 5000000

    julia> set_option(f, "probesize", "1500000")
    probesize set to 1500000.

#### <span style= "color:green">Set options with AVDictionary<span>



Intialize the dictionary with entries as shown below:

    julia> entries = Dict{String,String}()
    Dict{String,String} with 0 entries

    julia> entries["frame_rate"] = "25";
    julia> entries["video_size"] = "640x480";
    julia> entries["pixel_format"] = string(VideoIO.AV_PIX_FMT_UYVY422);
    julia> entries["probesize"] = "1000000";
    julia> entries["duration"] = "3000";
    julia> entries["list_devices"] = "0";

    julia> pDictionary = create_dictionary(entries)
    The dictionary has 6 entries.
    1-element Array{Ptr{None},1}:
    Ptr{Void} @0x00007fac81ceaec0

Set options with the dictionary

    julia> set_options_with_dictionary(f, pDictionary)
    Set all options in dictionary

#### <span style= "color:green">Probe device options with Device Capabilities API <span>

Using AVOptionRange, you can also probe the range of values for a particular option with `query_device_ranges`:

    julia> query_device_ranges(f.avin, "frame_rate")
    frame_rate, mininum = 0.1, maximum = 30.0

    julia> query_device_ranges(f.avin, "pixel_format")
    pixel_format, mininum = 0.0, maximum = 2.147483647e9
    
    julia> query_device_ranges(f.avin, "probesize")
    probesize, mininum = 32.0, maximum = 9.223372036854776e18


Get and set video device properties (***further work needed***):

    julia> get_videodevice_settings (f)

    Properties of enabled video device: 
    window_width: 640
    window_height: 480
    framerate: 100//1
    pixel_format: 17
    codec_id: 14
    codec_name: rawvideo
    mininum buffer size: 16384

## History   
[#21 Default camera name wrong on OSX](https://github.com/kmsquire/VideoIO.jl/issues/21)<br>
[#25 Windows Issues](https://github.com/kmsquire/VideoIO.jl/issues/25#issuecomment-53836419)<br>
[#27 Implement AVOptions support](https://github.com/kmsquire/VideoIO.jl/issues/27)<br>
[#31 Get available pixel formats for camera device](https://github.com/kmsquire/VideoIO.jl/issues/31)<br>
[#47 PR: AVOptions API](https://github.com/kmsquire/VideoIO.jl/pull/47)

## To do 
* Test API in Windows and Linux
* Use API to implement seeking in video stream


## Acknowledgements 
Thanks to Kevin Squire for guidance.
