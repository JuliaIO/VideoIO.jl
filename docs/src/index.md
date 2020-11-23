# Introduction

This library provides methods for reading and writing video files.

Functionality is based on a dedicated build of ffmpeg, provided via [JuliaPackaging/Yggdrasil](https://github.com/JuliaPackaging/Yggdrasil/tree/master/F/FFMPEG)

Explore the source at [github.com/JuliaIO/VideoIO.jl](https://github.com/JuliaIO/VideoIO.jl)

### Platform Nodes:

- ARM: For truly lossless reading & writing, there is a known issue on ARM that results in small precision differences when reading/writing some video files. As such, tests for frame comparison are currently skipped on ARM. Issues/PRs welcome for helping to get this fixed.

## Installation
The package can be installed with the Julia package manager.
From the Julia REPL, type `]` to enter the Pkg REPL mode and run:

```
pkg> add VideoIO
```

Or, equivalently, via the `Pkg` API:

```julia
julia> import Pkg; Pkg.add("VideoIO")
```
