##AVOptions API for VideoIO.jl



VideoIO/src/avoptions.jl<br>
updated for [FFmpeg 2.4.2](http://www.ffmpeg.org/download.html#release_2.4)

2014, Maximiliano Suster


##Introduction

AVOptions provides a generic system to get/set options for devices, formats and codecs.
It relies on [AVOptions](https://www.ffmpeg.org/doxygen/2.4/group__avoptions.html), [AVDictionary](https://www.ffmpeg.org/doxygen/2.4/structAVDictionary.html) and [AVDeviceCapabilitiesQuery](https://www.ffmpeg.org/doxygen/2.4/structAVDeviceCapabilitiesQuery.html) APIs.

The API consists of 3 modules:

[Evaluate option strings](https://www.ffmpeg.org/doxygen/2.4/group__opt__eval__funcs.html): eval "string" option, return 0/-1<br>
[Option setting functions](https://www.ffmpeg.org/doxygen/2.4/group__opt__set__funcs.html): set value for a key string, if not string, then parsed<br>
[Option getting functions](https://www.ffmpeg.org/doxygen/2.4/group__opt__get__funcs.html): get value for a key string, if not string, then parsed

Options are stored in 3 structure types: [AVOption](https://www.ffmpeg.org/doxygen/2.4/structAVOption.html), [AVOptionRange](https://www.ffmpeg.org/doxygen/2.4/structAVOptionRange.html), [AVOptionRanges](https://www.ffmpeg.org/doxygen/2.4/structAVOptionRanges.html)

Key, value pairs can be optionally passed to `AVOption` functions using `AVDictionary`, as an opaque pointer (Ptr{Void}).  In turn, dict.c in the FFmpeg library declares `AVDictionary` to store entry count, key and value:

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
    all its children are enabled for the AVOptions API

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

     julia>Pkg.update()
     julia>Pkg.build("Video")

## How to use the AVOptions API

#### <span style= "color:green">List available input devices and formats<span>

    julia> using VideoIO
    julia> devices_list = discover_devices()
    Input devices:
    [1] : AVFoundation input device
    [2] : Libavfilter virtual input device
    [3] : QTKit input device
    Output devices:
    No output format detected!

#### <span style= "color:green">Open an input device<span>
You can try to open the "default" device (e.g., webcam) as described in [VideoIO.jl](https://github.com/kmsquire/VideoIO.jl). However, this is limited and may not work, so the AVOptions API provides a more general solution.

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

Then open the "Built-in-iSight" webcam

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

#### <span style= "color:green">Document all options in the API and store them for later use<span>

We can now view (and store) all AVOptions associated with this device, and their range of values (min and max).

    julia> OptionsDictionary = document_all_options(f.avin, true)
    ---------------------------------------------------------------------------
               LIST OF ALL OPTIONS FOR FORMAT, CODEC AND DEVICES
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
    false                       =>  min: 0.0 , max: 0.0
    fdebug                      =>  min: 0.0 , max: 2.147483647e9
    fflags                      =>  min: -2.147483648e9 , max: 2.147483647e9
    flush_packets               =>  min: 0.0 , max: 1.0
    formatprobesize             =>  min: 0.0 , max: 2.147483646e9
    fpsprobesize                =>  min: -1.0 , max: 2.147483646e9
    frame_rate                  =>  min: 0.1 , max: 30.0
    genpts                      =>  min: -2.147483648e9 , max: 2.147483647e9
    igndts                      =>  min: -2.147483648e9 , max: 2.147483647e9
    ignidx                      =>  min: -2.147483648e9 , max: 2.147483647e9
    ignore_err                  =>  min: -2.147483648e9 , max: 2.147483647e9
    indexmem                    =>  min: 0.0 , max: 2.147483647e9
    keepside                    =>  min: -2.147483648e9 , max: 2.147483647e9
    latm                        =>  min: -2.147483648e9 , max: 2.147483647e9
    list_devices                =>  min: 0.0 , max: 1.0
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
    pixel_format                =>  min: 0.0 , max: 2.147483647e9
    probesize                   =>  min: 32.0 , max: 9.223372036854776e18
    rtbufsize                   =>  min: 0.0 , max: 2.147483647e9
    seek2any                    =>  min: 0.0 , max: 1.0
    skip_initial_bytes          =>  min: 0.0 , max: 9.223372036854776e18
    sortdts                     =>  min: -2.147483648e9 , max: 2.147483647e9
    start_time_realtime         =>  min: -9.223372036854776e18 , max: 9.223372036854776e18
    strict                      =>  min: -2.147483648e9 , max: 2.147483647e9
    true                        =>  min: 0.0 , max: 0.0
    ts                          =>  min: -2.147483648e9 , max: 2.147483647e9
    use_wallclock_as_timestamps =>  min: 0.0 , max: 2.147483646e9
    video_device_index          =>  min: -1.0 , max: 2.147483647e9



#### <span style= "color:green">Check whether an option exists and set defaults<span>

First check whether an option exists<br>

    julia>is_option(f.avin, "probesize")
    probesize found!

You can set all options to default values

    julia> set_default_options(f.avin)
    Set default format and codec options

#### <span style= "color:green">Set and get options with (name, value) strings<span>

1.Get **`pixel_format`** and then set it to **`0RGB`**

    julia> get_option(f.avin, "pixel_format")
    pixel_format = uyvy422

    julia> set_option(f.avin, "pixel_format", string(VideoIO.AV_PIX_FMT_0RGB))
    pixel_format set to 295.

2.Get **`frame_rate`** and then set it to **`15 fps`**

    julia> get_option(f.avin, "frame_rate")
    frame_rate = 30.000000

    julia> set_option(f.avin, "frame_rate", "15")
    frame_rate set to 15.

3.Get **`list_devices`** and then set to **`true`**

    julia> get_option(f.avin, "list_devices")
    list_devices = 0

    julia> set_option(f.avin, "list_devices", "1")
    list_devices set to 1.

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

    julia> set_options_with_dictionary(f.avin, pDictionary)
    Set all options in dictionary

### <span style= "color:green">Probe device capabilities with AVDeviceCapabilitiesQuery<span>






## To do
* Testing in Linux, Windows OS
* Use API to implement seeking in video stream


## Acknowledgements
Thanks to Kevin Squire for guidance in putting this API together.
