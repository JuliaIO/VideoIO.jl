
# VideoIO.jl
<img align="right" width="90" src="docs/src/assets/logo.png">

*Reading and writing of video files in Julia.*

Functionality based on a dedicated build of ffmpeg via [FFMPEG.jl](https://github.com/JuliaIO/FFMPEG.jl) and the [JuliaPackaging/Yggdrasil](https://github.com/JuliaPackaging/Yggdrasil/tree/master/F/FFMPEG) cross-compiler.

**Docs**
[![][docs-stable-img]][docs-stable-url] [![][docs-dev-img]][docs-dev-url] [![Join the julia slack](https://img.shields.io/badge/chat-slack%23video-yellow.svg)](https://julialang.org/slack/)

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

- [![][docs-stable-img]][docs-stable-url]  &mdash; **documentation of the most recently tagged version.**
- [![][docs-dev-img]][docs-dev-url] &mdash; *documentation of the in-development version.*

## Project Status

The package is tested against, and being developed for, Julia `v1` on Linux, macOS, and Windows, for x86, x86_64, armv7 and armv8 (aarch64).

## Questions and Contributions

Usage questions can be posted on the [Julia Discourse forum][discourse-tag-url] under the `videoio` tag, and/or in the #video channel of the [Julia Slack](https://julialang.org/community/).

Contributions are very welcome, as are feature requests and suggestions. Please open an [issue][issues-url] if you encounter any problems.

[discourse-tag-url]: https://discourse.julialang.org/tags/videoio

[docs-dev-img]: https://img.shields.io/badge/docs-dev-blue.svg
[docs-dev-url]: https://juliaio.github.io/VideoIO.jl/latest

[docs-stable-img]: https://img.shields.io/badge/docs-stable-blue.svg
[docs-stable-url]: https://juliaio.github.io/VideoIO.jl/stable

[issues-url]: https://github.com/JuliaIO/VideoIO.jl/issues

____
