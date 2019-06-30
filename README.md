
# VideoIO

*Reading and writing of video files in Julia.*

Functionality is based on a dedicated build of ffmpeg 4.1, provided via [FFMPEGBuilder](https://github.com/JuliaIO/FFMPEGBuilder)

| **VideoIO**                                                               | **Build Status**                                                                                |
|:-------------------------------------------------------------------------------:|:-----------------------------------------------------------------------------------------------:|
| [![][docs-stable-img]][docs-stable-url] [![][docs-dev-img]][docs-dev-url] | [![][travis-img]][travis-url] [![][appveyor-img]][appveyor-url] [![][codecov-img]][codecov-url] |


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

## Documentation

- [**STABLE**][docs-stable-url] &mdash; **documentation of the most recently tagged version.**
- [**DEVEL**][docs-dev-url] &mdash; *documentation of the in-development version.*

## Project Status

The package is tested against, and being developed for, Julia `1.0` and above on Linux, macOS, and Windows, for x86, x86_64, armv7 and armv8 (aarch64).


## Questions and Contributions

Usage questions can be posted on the [Julia Discourse forum][discourse-tag-url] under the `videoio` tag, and/or in the #video channel of the [Julia Slack](https://julialang.org/community/).

Contributions are very welcome, as are feature requests and suggestions. Please open an [issue][issues-url] if you encounter any problems.

[discourse-tag-url]: https://discourse.julialang.org/tags/videoio

[docs-dev-img]: https://img.shields.io/badge/docs-dev-blue.svg
[docs-dev-url]: https://juliadocs.github.io/Documenter.jl/latest

[docs-stable-img]: https://img.shields.io/badge/docs-stable-blue.svg
[docs-stable-url]: https://juliadocs.github.io/VideoIO.jl/stable

[travis-img]: https://travis-ci.org/JuliaIO/VideoIO.jl.svg?branch=master
[travis-url]: https://travis-ci.org/JuliaIO/VideoIO.jl

[appveyor-img]: https://ci.appveyor.com/api/projects/status/xx7nimfpnl1r4gx0?svg=true
[appveyor-url]: https://ci.appveyor.com/project/JuliaIO/videoio-jl

[codecov-img]: https://codecov.io/gh/JuliaIO/VideoIO.jl/branch/master/graph/badge.svg
[codecov-url]: https://codecov.io/gh/JuliaIO/VideoIO.jl

[issues-url]: https://github.com/JuliaIO/VideoIO.jl/issues