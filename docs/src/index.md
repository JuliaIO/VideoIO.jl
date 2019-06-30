# Introduction

This library provides methods for reading and writing video files.

Functionality is based on a dedicated build of ffmpeg 4.1, provided via [FFMPEGBuilder](https://github.com/JuliaIO/FFMPEGBuilder)

### Platform Nodes: 

- ARM: There is a known issue on ARM that results in very small and rare precision differences when reading/writing some video files. As such, tests for frame comparison are currently skipped on ARM. Issues/PRs welcome for helping to get this fixed.

Installation
------------
Use the Julia package manager.  Within Julia, do:
```julia
]add VideoIO
```
