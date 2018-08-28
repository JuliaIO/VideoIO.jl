[![Build Status](https://travis-ci.org/kmsquire/VideoIO.jl.svg?branch=master)](https://travis-ci.org/kmsquire/VideoIO.jl) [![Coverage Status](https://coveralls.io/repos/kmsquire/VideoIO.jl/badge.png)](https://coveralls.io/r/kmsquire/VideoIO.jl)

VideoIO.jl
==========

Julia bindings for libav/ffmpeg.

Currently, only video reading is supported, for the following
library versions:

* libav 0.8, 9, 10
* ffmpeg 2.2 through 3.0

Video images may be read as raw arrays, or optionally, `Image`
objects (if `Images.jl` is installed and loaded first).

Feel free to request support for additional libav/ffmpeg
versions, although earlier versions may be too challenging to
support.

If you encounter any problems, please add the output
of `VideoIO.versioninfo()` to your report.

Installation
------------
Use the Julia package manager.  Within Julia, do:
```julia
Pkg.add("VideoIO")
```

Simple Interface
----------------
A trivial video player interface exists (no audio):

    import ImageView
    import VideoIO

    f = VideoIO.testvideo("annie_oakley")  # downloaded if not available
    VideoIO.playvideo(f)  # no sound

    # Aternatively, you can just open the camera
    #VideoIO.viewcam()

High Level Interface
--------------------

VideoIO contains a simple high-level interface which allows reading of
video frames from a supported video file, or from a camera device:

    using Images
    import ImageView
    import VideoIO

    io = VideoIO.open(video_file)
    f = VideoIO.openvideo(io)

    # As a shortcut for just video, you can upen the file directly
    # with openvideo
    #f = VideoIO.openvideo(video_file)

    # Alternatively, you can open the camera with opencamera().
    # The default device is "0" on Windows, "/dev/video0" on Linux,
    # and "Integrated Camera" on OSX.  If using something other
    # than the default, pass it in as the first parameter (as a string).
    #f = VideoIO.opencamera()

    # One can seek to an arbitrary position in the video
    seek(f,2.5)  ## The second parameter is the time in seconds and must be Float64
    img = read(f)
    canvas, _ = ImageView.view(img)

    while !eof(f)
        read!(f, img)
        ImageView.imshow(canvas, img)
        #sleep(1/30)
    end

This code is essentially the code in `playvideo`, and will read and
(without the `sleep`) play a movie file as fast as possible.

As with the `playvideo` function, the `Images` and `ImageView` packages
must be loaded for the appropriate functions to be available.


Low Level Interface
-------------------
Each libav and ffmpeg library has its own VideoIO subpackage:

    libavcodec    -> AVCodecs
    libavdevice   -> AVDevice
    libavfilter   -> AVFilters
    libavformat   -> AVFormat
    libavutil     -> AVUtil
    libswscale    -> SWScale

The following three files are related to ffmpeg/libav, but currently not
exposed:

    libavresample -> AVResample (libav only)
    libswresample -> SWResample (ffmpeg only)
    libpostproc   -> PostProc   (not wrapped)

After importing VideoIO, you can import and use any of the subpackages directly

    import VideoIO
    import SWResample  # SWResample functions are now available

Note that much of the functionality of these subpackages is not enabled
by default, to avoid long compilation times as they load.  To control
what is loaded, each library version has a file which imports that's
modules files.  For example, ffmpeg's libswscale-v2 files are loaded by
$(VideoIO_PKG_DIR)/src/ffmpeg/SWScale/v2/LIBSWSCALE.jl.

Check these files to enable any needed functionality that isn't already
enabled.  Note that you'll probably need to do this for each version
of the package for both ffmpeg and libav, and that the interfaces do
change some from version to version.

Note that, in general, the low-level functions are not very fun to use,
so it is good to focus initially on enabling a nice, higher-level
function for these interfaces.

Test Videos
-----------

A small number of test videos are available through VideoIO.TestVideos.
These are short videos in a variety of formats with non-restrictive
(public domain or Creative Commons) licenses.

* `VideoIO.TestVideos.available()` prints a list of all available test videos.
* `VideoIO.testvideo("annie_oakley")` returns an AVInput object for the
  `"annie_oakley"` video.  The video will be downloaded if it isn't available.
* `VideoIO.TestVideos.download_all()` downloads all test videos
* `VideoIO.TestVideos.remove_all()` removes all test videos


Status
------
At this point, a simple video interface is available, for multiple
versions of libav and ffmpeg.  See TODO.md for some possible directions
forward.

Issues, requests, and/or pull requests for problems or additional
functionality are very welcome.
