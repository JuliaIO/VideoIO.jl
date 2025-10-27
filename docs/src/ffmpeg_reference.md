# FFmpeg Low-Level Reference

This page documents low-level FFmpeg constants, types, and functions that are available through VideoIO's `libffmpeg` module.

```@contents
Pages = ["ffmpeg_reference.md"]
Depth = 2
```

## Overview

VideoIO provides Julia bindings to FFmpeg through the `VideoIO.libffmpeg` module. This module contains over 1,000 functions, constants, and types from FFmpeg's C libraries. While most users will use VideoIO's high-level API (see [Reading Videos](@ref) and [Writing Videos](@ref)), advanced users may need direct access to FFmpeg functionality.

### FFmpeg Subpackages

Each FFmpeg library is exposed as a VideoIO subpackage:

| FFmpeg Library | VideoIO Module | Description |
|----------------|----------------|-------------|
| `libavcodec` | `AVCodecs` | Codec library - encoding/decoding |
| `libavdevice` | `AVDevice` | Device library - camera/screen capture |
| `libavfilter` | `AVFilters` | Filter library - video/audio processing |
| `libavformat` | `AVFormat` | Format library - muxing/demuxing |
| `libavutil` | `AVUtil` | Utility library - common functions |
| `libswscale` | `SWScale` | Scaling library - pixel format conversion |
| `libswresample` | `SWResample` | Resampling library - audio conversion |

### Usage Example

```julia
using VideoIO

# Access low-level FFmpeg functionality
import VideoIO.libffmpeg

# Check pixel format constant
pix_fmt = VideoIO.libffmpeg.AV_PIX_FMT_RGB24

# Use AVRational for time base
time_base = VideoIO.libffmpeg.AVRational(1, 30)  # 1/30 second per frame

# Convert to Julia Rational
julia_rational = Rational(time_base.num, time_base.den)
```

### Key Concepts

**Pixel Formats**: FFmpeg supports numerous pixel formats via `AV_PIX_FMT_*` constants. Common ones include:

- `AV_PIX_FMT_RGB24` - Packed RGB 8:8:8, 24bpp
- `AV_PIX_FMT_GRAY8` - Grayscale, 8bpp
- `AV_PIX_FMT_YUV420P` - Planar YUV 4:2:0, 12bpp

**Media Types**: Stream types are identified by `AVMEDIA_TYPE_*` constants:

- `AVMEDIA_TYPE_VIDEO` - Video stream
- `AVMEDIA_TYPE_AUDIO` - Audio stream
- `AVMEDIA_TYPE_SUBTITLE` - Subtitle stream

**Special Values**:

- `AV_NOPTS_VALUE` - Indicates no presentation timestamp (0x8000000000000000)
- `AVPROBE_SCORE_MAX` - Maximum probe score (100)

**Codec Properties**:

- `AV_CODEC_PROP_FIELDS` - Flag indicating field-based (interlaced) codec support

For detailed information on FFmpeg 8 compatibility changes, see:

- [FFmpeg ticks_per_frame deprecation](https://github.com/FFmpeg/FFmpeg/commit/7d1d61cc5f57708434ba720b03234b3dd93a4d1e)
- [AVCodecContext.time_base documentation](https://ffmpeg.org/doxygen/trunk/structAVCodecContext.html#a17f4c12d8b7693dbbcdab8ed765ab7ce)

## Complete API Reference

The following sections provide auto-generated documentation for all exported items in `VideoIO.libffmpeg`.

### Functions

```@autodocs
Modules = [VideoIO.libffmpeg]
Order   = [:function]
```

### Types

```@autodocs
Modules = [VideoIO.libffmpeg]
Order   = [:type]
```

### Constants

```@autodocs
Modules = [VideoIO.libffmpeg]
Order   = [:constant]
```

## See Also

- [Reading Videos](@ref)
- [Writing Videos](@ref)
- [Low level functionality](@ref)
- [FFmpeg Official Documentation](https://ffmpeg.org/documentation.html)
