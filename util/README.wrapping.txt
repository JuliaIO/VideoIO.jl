Wrapping ffmpeg libraries
-------------------------------

Wrapping ffmpeg is currently achieved using the wrap_libav_split.jl
script, which uses Clang.jl.

============== Cut here ================

Steps after that are typically:

1. mkdir ffmpeg2.3 && cd ffmpeg2.3  # for example
2. julia ../wrap_libav_split.jl /usr/local/include

where /usr/local/include should be base of the location of the headers
you wish to wrap.

This will create and fill a series of directories which mirror the 
structure under src/libav and src/ffmpeg, e.g.:

AVCodecs/v55/
AVDevice/v55/
AVFilters/v4/
AVFormat/v55/
AVUtil/v52/
PostProc/v52/
SWResample/v0/
SWScale/v2/

Some of these directories likely exist already under src/libav or src/ffmpeg,
because the same library version existed in previous releases.

For those that don't exist, or for those you wish to update, copy the 
directory to the appropriate location under src/libav or src/ffmpeg, and
test, and make any necessary updates.  

Patch files in the subdirectories of src/libav or src/ffmpeg/ may give a 
hint about what updates are needed.  The patches themselves may even apply 
fully or partially--try something like

   cd src/ffmpeg/AVCodecs/v55
   patch -p1 < ../patch2

and fix what doesn't apply, if necessary.



If you wrap a version of the library not already included in VideoIO.jl, please
submit it as a pull request!
