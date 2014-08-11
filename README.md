[![Build Status](https://travis-ci.org/kmsquire/AV.jl.svg)](https://travis-ci.org/kmsquire/AV.jl) [![Coverage Status](https://coveralls.io/repos/kmsquire/AV.jl/badge.png)](https://coveralls.io/r/kmsquire/AV.jl)

libAV.jl
========

Julia bindings for libav/ffmpeg.  

Currently, only video reading is supported, for the following 
library versions:

* libav 0.8, 9, 10
* ffmpeg 2.2, 2.3

Feel free to request support for additional libav/ffmpeg 
versions, although earlier versions may be too challenging to
support.

Simple Interface
----------------
A trivial video player interface exists (no audio):

    using Images
    import ImageView
    import AV

    f = AV.testfile("annie_oakley")  # downloaded if not available
    AV.playvideo(f)  # no sound


High Level Interface
--------------------

AV contains a simple high-level interface which allows reading of 
video frames from a supported video file:

    using Images
    import ImageView
    import AV

    f = AV.openvideo(video_file)
    img = read(f, Image)
    canvas, _ = ImageView.view(img)
    
    while !eof(f)
        read!(f, img)
        ImageView.view(canvas, img)
        #sleep(1/30)
    end

This code is essentially the code in `playvideo`, and will read and 
(without the `sleep`) play a movie file as fast as possible.


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
function for these interfaces. 

Test Videos
-----------

A small number of test videos are available through AV.TestVideos.
These are short videos in a variety of formats with non-restrictive
(public domain or Creative Commons) licenses.

* `AV.TestVideos.available()` prints a list of all available test videos.
* `AV.testvideo("annie_oakley")` returns an AVInput object for the 
  `"annie_oakley"` video.  The video will be downloaded if it isn't available.
* `AV.TestVideos.download_all()` downloads all test videos
* `AV.TestVideos.remove_all()` removes all test videos


Status
------
At this point, a simple video interface is available, for multiple
versions of libav and ffmpeg.  See TODO.md for some possible directions
forward.

Issues, requests, and/or pull requests for problems or additional 
functionality are very welcome.
