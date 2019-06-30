# Low level functionality

## FFMPEG log level
FFMPEG's built-in logging and warning level can be read and set with
```@docs
VideoIO.loglevel!
```
```@docs
VideoIO.loglevel
```

## FFMPEG interface
Each ffmpeg library has its own VideoIO subpackage:

    libavcodec    -> AVCodecs
    libavdevice   -> AVDevice
    libavfilter   -> AVFilters
    libavformat   -> AVFormat
    libavutil     -> AVUtil
    libswscale    -> SWScale

The following three files are related to ffmpeg, but currently not
exposed:

    libswresample -> SWResample
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
enabled. Note that you'll probably need to do this for each version
of the package for ffmpeg, and that the interfaces do
change some from version to version.

Note that, in general, the low-level functions are not very fun to use,
so it is good to focus initially on enabling a nice, higher-level
function for these interfaces.
