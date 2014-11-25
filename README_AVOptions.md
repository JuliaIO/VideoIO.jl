
##AVOptions API

VideoIO/src/avoptions.jl<br>
VideoIO/src/avdevicecapabilities.jl<br>

2014, Maximiliano Suster


##Introduction

[VideoIO.jl](https://github.com/kmsquire/VideoIO.jl) is a wrapper for using the FFmpeg/Libav video and audio streaming C libraries in Julia. AVOptions is an API which provides generic functions to get/set options for devices, formats and codecs. It relies on [AVOptions](https://www.ffmpeg.org/doxygen/2.4/group__avoptions.html), [AVDictionary](https://www.ffmpeg.org/doxygen/2.4/structAVDictionary.html) and [AVDeviceCapabilitiesQuery](https://www.ffmpeg.org/doxygen/2.4/structAVDeviceCapabilitiesQuery.html). Currently the API is only enabled for video. 

AVOptions consists of 3 modules:<br>

* Evaluate option strings: eval "string" option, return 0/-1<br>
* Option setting functions: set value for a key string, if not string, then parsed<br>
* Option getting functions: get value for a key string, if not string, then parsed

Options are stored in 3 types of structures: AVOption, AVOptionRange, AVOptionRanges. To pass `key, value` pairs to AVOption functions, one may use the `AVDictionary` structure. We first fill the dictionary with the `key, value` pair entry and then pass it as an opaque pointer from Julia to C. 

The AVDictionary structure has two members, `count` and `AVDictionaryEntry`
```c
# In C (dict.c)
struct AVDictionary {
    int count
    AVDictionaryEntry *elems
}

# In Julia (libavutil_h.jl) 
immutable AVDictionaryEntry
    key::Ptr{Uint8}
    value::Ptr{Uint8}
end
```

To access/modify options using this API, the first element of the target structure must be a pointer to `AVClass`, because AVClass in turn holds the `AVOption` structure. The following structures are accessible by this API:
```sh
AVFormatContext            -> Ptr{AVClass} -> AVClass -> Ptr{AVOption}
AVCodecContext             -> Ptr{AVClass} -> AVClass -> Ptr{AVOption}
AVDeviceCapabilitiesQuery  -> Ptr{AVClass} -> AVClass -> Ptr{AVOption}
```

Note, currently, the `AVDeviceCapabilitiesQuery` structure that is used to 
probe device properties is not enabled in VideoIO. 

## Installation

To enable most functions in the AVOptions API, update your FFmpeg library to the most recent version supported by VideoIO (v2.4.2 as of today). ***Note***: Current versions of [Libav libraries] (https://libav.org/) in VideoIO.jl lack essential functions for accessing video devices and their format (illustrated in the first 2 sections below). This affects Debian Linux users. Although Julia Homebrew installs FFmpeg (hardcoded in VideoIO), you can also install/update FFmpeg on your own via homebrew:
```sh
$ brew info ffmpeg
$ cd /usr/local/Library/Formula
$ brew update && brew upgrade ffmpeg
$ ffmpeg -version
ffmpeg version 2.4.2 Copyright (c) 2000-2014 the FFmpeg developers
built on Oct 19 2014 18:31:37 with Apple LLVM version 6.0 (clang-600.0.51)...
```

```python
# To install and test VideoIO with AVOptions
julia>Pkg.update()
julia>Pkg.build("VideoIO")
# To test
julia>Pkg.test("VideoIO")
```

## How to use the AVOptions API

#### List recognized input devices
```python
julia> using VideoIO
julia> devices_list = discover_devices()
Input devices:
[1] : AVFoundation input device
[2] : Libavfilter virtual input device
[3] : QTKit input device
Output devices:
No output format detected!
```
#### Open an input device
```python
# select an input device and its format from devices_list[] (previous section)
julia> devices_list.idevice_name
3-element Array{String,1}:
"AVFoundation input device"
"Libavfilter virtual input device"
"QTKit input device"

# Get a pointer to AVInputFormat [1]
julia> format = devices_list.vpiformat[1]
Ptr{AVInputFormat} @0x00000001137b8f30

# Get the camera device name externaly by calling FFmpeg from Julia
julia> open(`ffmpeg -f avfoundation -list_devices true -i ""`)
->[AVFoundation input device @ 0x7fd9eb600000] [0] Built-in iSight

# Now open the selected built-in webcam
julia> f = opencamera("Built-in iSight", format)
[avfoundation @ 0x7fac88e01c00] Selected pixel format (yuv420p)
is not supported by the input device.
[avfoundation @ 0x7fac88e01c00] Supported pixel formats:
[avfoundation @ 0x7fac88e01c00]   uyvy422
[avfoundation @ 0x7fac88e01c00]   yuyv422
[avfoundation @ 0x7fac88e01c00]   nv12
[avfoundation @ 0x7fac88e01c00]   0rgb
[avfoundation @ 0x7fac88e01c00]   bgr0
VideoReader(...)
```

#### Documenting API options

```python
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
...

---------------------------------------------------------------------------
          Codec context options in AVOptions API 
---------------------------------------------------------------------------
aac_eld                    =>  min: -2.147483648e9 , max: 2.147483647e9
aac_he                     =>  min: -2.147483648e9 , max: 2.147483647e9
aac_he_v2                  =>  min: -2.147483648e9 , max: 2.147483647e9
aac_ld                     =>  min: -2.147483648e9 , max: 2.147483647e9
aac_low                    =>  min: -2.147483648e9 , max: 2.147483647e9
aac_ltp                    =>  min: -2.147483648e9 , max: 2.147483647e9
aac_main                   =>  min: -2.147483648e9 , max: 2.147483647e9
aac_ssr                    =>  min: -2.147483648e9 , max: 2.147483647e9
...
```

#### Check whether an option exists 
```python
julia>is_option(f, "probesize")
```
#### Set all options to default values
```python
julia> set_default_options(f)
```
#### Get and set options with strings (name, value)

```python
# Get video_device_index(default = -1)
julia> get_option(f, "video_device_index")
"-1"

# Get and set pixel format
julia> pix_format = get_option(f, "pixel_format")
"uyvy422"
julia> set_option(f, "pixel_format", string(VideoIO.AV_PIX_FMT_0RGB))

# Get and set frame rate
julia> frame_rate = get_option(f, "frame_rate")
"30.000000"
julia> set_option(f, "frame_rate", "15")

# Get and set probesize
julia> get_option(f, "probesize")
"5000000"
julia> set_option(f, "probesize", "1500000")
```
#### Set options with AVDictionary
```python
# Intialize the dictionary with entries as shown below:
julia> entries = Dict{String,String}()
Dict{String,String} with 0 entries

julia> entries["frame_rate"] = "25";
julia> entries["video_size"] = "640x480";
julia> entries["pixel_format"] = string(VideoIO.AV_PIX_FMT_UYVY422);
julia> entries["probesize"] = "1000000";
julia> entries["duration"] = "3000";
julia> entries["list_devices"] = "0";

julia> pDictionary = create_dictionary(entries)
1-element Array{Ptr{None},1}:
Ptr{Void} @0x00007fac81ceaec0

# Set options with the dictionary
julia> set_options_with_dictionary(f, pDictionary)
```
#### Query device option ranges
```python
# Here we probe the range of values for a particular option:
julia> query_device_ranges(f, "frame_rate")
(0.1,30.0)

julia> query_device_ranges(f, "pixel_format")
(0.0, 2.147483647e9)

julia> query_device_ranges(f, "probesize")
(32.0, 9.223372036854776e18)
```

#### Supplementary
Get and set video device properties
```python
julia> get_videodevice_settings (f)
Properties of enabled video device: 
window_width: 640
window_height: 480
framerate: 100//1
pixel_format: 17
codec_id: 14
codec_name: rawvideo
mininum buffer size: 16384
```

How to list supported pixel formats

```sh
# At the Julia prompt, type 
julia> open(`ffmpeg -f avfoundation -i ""`)
    
# In the shell prompt, type
$ ffmpeg -f avfoundation -pix_fmts all
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
```

```sh
To set the pixel format with set_option(), first convert the flag name as follows: 
yuv420p => VideoIO.AV_PIX_FMT_YUV420P
```

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
