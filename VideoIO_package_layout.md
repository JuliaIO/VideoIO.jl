AV Package Layout
=================

The FFMPEG and libav packages each distribute a number of libraries, which are mostly named the same and have the same or very similar interfaces.  

This package currently separates ffmpeg and libav support into different directories.  In theory, these should be mostly compatible, but I was finding enough differences that I thought it best to start here.

For each of the libraries, VideoIO.jl contains an additional submodule with a related name (e.g., libavcodec -> AVCodecs, libavdevice -> AVDevice, etc.).  Following Julia conventions, AVCodecs and AVFilters are pluralized (to allow types in them to be named AVCodec and AVFilter).  The remaining submodules are formed directly from the library name.

The directory structure looks something like this:

```
src
src/ffmpeg
src/ffmpeg/AVCodecs
src/ffmpeg/AVCodecs/src
src/ffmpeg/AVCodecs/v53
src/ffmpeg/AVCodecs/v54
src/ffmpeg/AVCodecs/v55
src/ffmpeg/AVDevice
src/ffmpeg/AVDevice/src
src/ffmpeg/AVDevice/v53
...
src/libav
src/libav/AVCodecs
src/libav/AVCodecs/src
src/libav/AVCodecs/v53
src/libav/AVDevice
src/libav/AVDevice/src
src/libav/AVDevice/v53
src/libav/AVDevice/v54
...
```

At the top level, `VideoIO.jl` is loaded.  It detects the library versions for each library (e.g., 'v53'), which are made available to the submodules.  The submodule can then loads the appropriate set of wrappers by including a top level file in the version subdirectory

Right now, `AVUtil`, `AVFormat`, `AVCodecs`, and `SWScale` are loaded by `VideoIO.jl`, which enables basic video functionality.

After loading VideoIO.jl, any of the other submodules can be loaded, e.g.:

```julia
import VideoIO
import AVDevice
```

This can also be done independently without loading VideoIO if `init.jl` is included or required:

```julia
include(joinpath(Pkg.dir("VideoIO"),"src","init.jl"))
import AVDevice
```

`av_capture.jl` provides a minimal video interface, which is used by `examples/playvid.jl`.

