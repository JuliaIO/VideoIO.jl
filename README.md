libAV.jl
========

Julia bindings for libav/ffmpeg.  

Currently, only video reading is supported, for the following 
library versions:

* libav 0.8, 9, 10
* ffmpeg 2.2, 2.3

High Level Interface
--------------------

A simple high-level interface exists which allows reading of 
video frames from a supported video file:

    using Images
    import AV
    import ImageView

    f = AV.open(video_file)
    img = read(f, Image)
    canvas, _ = ImageView.view(img)
    
    while !eof(f)
        read!(f, img)
        ImageView.view(canvas, img)
        #sleep(1/30)
    end

This code will read and (without the sleep) play a movie
file as fast as possible.


Low Level Interface
-------------------
Each libav and ffmpeg library has its own AV subpackage:

    libavcodec    -> AVCodecs
    libavdevice   -> AVDevice
    libavfilter   -> AVFilters
    libavformat   -> AVFormat
    libavutil     -> AVUtil
    libavresample -> AVResample (libav only)
    libswresample -> SWResample (ffmpeg only)
    libswscale    -> SWScale
    libpostproc   -> PostProc

After importing AV, you can import and use any of the subpackages directly

    import AV
    import SWResample  # SWResample functions are now available

Note that much of the functionality of these subpackages is not enabled
by default, to avoid long compilation times as they load.  To control
what is loaded, each library version has a file which imports that's
modules files.  For example, ffmpeg's libswscale-v2 files are loaded by 
$(AV_PKG_DIR)/src/ffmpeg/SWScale/v2/LIBSWSCALE.jl.

Check these files to enable any needed functionality that isn't already
enabled.  Note that you'll probably need to do this for each version 
of the package for both ffmpeg and libav, and that the interfaces do
change some from version to version.

Note that, in general, the low-level functions are not very fun to use,
so it is good to focus initially on enabling a nice, higher-level 
function for these interfaces.  Pull requests welcome!


Status
------
At this point, a simple video interface is available, for multiple
versions of libav and ffmpeg.  See TODO.md for some possible directions
forward.

Issues, requests, and/or pull requests for problems or additional 
functionality are very welcome.
