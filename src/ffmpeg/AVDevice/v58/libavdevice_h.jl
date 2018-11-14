# Automatically generated using Clang.jl wrap_c, version 0.0.0


export
    unix,
    linux,
    LIBAVDEVICE_VERSION_MAJOR,
    LIBAVDEVICE_VERSION_MINOR,
    LIBAVDEVICE_VERSION_MICRO,
    LIBAVDEVICE_BUILD,
    AVDeviceRect,
    AVAppToDevMessageType,
    AV_APP_TO_DEV_NONE,
    AV_APP_TO_DEV_WINDOW_SIZE,
    AV_APP_TO_DEV_WINDOW_REPAINT,
    AV_APP_TO_DEV_PAUSE,
    AV_APP_TO_DEV_PLAY,
    AV_APP_TO_DEV_TOGGLE_PAUSE,
    AV_APP_TO_DEV_SET_VOLUME,
    AV_APP_TO_DEV_MUTE,
    AV_APP_TO_DEV_UNMUTE,
    AV_APP_TO_DEV_TOGGLE_MUTE,
    AV_APP_TO_DEV_GET_VOLUME,
    AV_APP_TO_DEV_GET_MUTE,
    AVDevToAppMessageType,
    AV_DEV_TO_APP_NONE,
    AV_DEV_TO_APP_CREATE_WINDOW_BUFFER,
    AV_DEV_TO_APP_PREPARE_WINDOW_BUFFER,
    AV_DEV_TO_APP_DISPLAY_WINDOW_BUFFER,
    AV_DEV_TO_APP_DESTROY_WINDOW_BUFFER,
    AV_DEV_TO_APP_BUFFER_OVERFLOW,
    AV_DEV_TO_APP_BUFFER_UNDERFLOW,
    AV_DEV_TO_APP_BUFFER_READABLE,
    AV_DEV_TO_APP_BUFFER_WRITABLE,
    AV_DEV_TO_APP_MUTE_STATE_CHANGED,
    AV_DEV_TO_APP_VOLUME_LEVEL_CHANGED,
    AVDeviceCapabilitiesQuery,
    AVDeviceInfo,
    AVDeviceInfoList


const unix = 1
const linux = 1
const LIBAVDEVICE_VERSION_MAJOR = 58
const LIBAVDEVICE_VERSION_MINOR = 5
const LIBAVDEVICE_VERSION_MICRO = 100

# Skipping MacroDefinition: LIBAVDEVICE_VERSION_INT AV_VERSION_INT ( LIBAVDEVICE_VERSION_MAJOR , LIBAVDEVICE_VERSION_MINOR , LIBAVDEVICE_VERSION_MICRO )
# Skipping MacroDefinition: LIBAVDEVICE_VERSION AV_VERSION ( LIBAVDEVICE_VERSION_MAJOR , LIBAVDEVICE_VERSION_MINOR , LIBAVDEVICE_VERSION_MICRO )

const LIBAVDEVICE_BUILD = LIBAVDEVICE_VERSION_INT

# Skipping MacroDefinition: LIBAVDEVICE_IDENT "Lavd" AV_STRINGIFY ( LIBAVDEVICE_VERSION )

struct AVDeviceRect
    x::Cint
    y::Cint
    width::Cint
    height::Cint
end

# begin enum AVAppToDevMessageType
const AVAppToDevMessageType = UInt32
const AV_APP_TO_DEV_NONE = 1313820229 |> UInt32
const AV_APP_TO_DEV_WINDOW_SIZE = 1195724621 |> UInt32
const AV_APP_TO_DEV_WINDOW_REPAINT = 1380274241 |> UInt32
const AV_APP_TO_DEV_PAUSE = 1346458912 |> UInt32
const AV_APP_TO_DEV_PLAY = 1347174745 |> UInt32
const AV_APP_TO_DEV_TOGGLE_PAUSE = 1346458964 |> UInt32
const AV_APP_TO_DEV_SET_VOLUME = 1398165324 |> UInt32
const AV_APP_TO_DEV_MUTE = 541939028 |> UInt32
const AV_APP_TO_DEV_UNMUTE = 1431131476 |> UInt32
const AV_APP_TO_DEV_TOGGLE_MUTE = 1414354260 |> UInt32
const AV_APP_TO_DEV_GET_VOLUME = 1196838732 |> UInt32
const AV_APP_TO_DEV_GET_MUTE = 1196250452 |> UInt32
# end enum AVAppToDevMessageType

# begin enum AVDevToAppMessageType
const AVDevToAppMessageType = UInt32
const AV_DEV_TO_APP_NONE = 1313820229 |> UInt32
const AV_DEV_TO_APP_CREATE_WINDOW_BUFFER = 1111708229 |> UInt32
const AV_DEV_TO_APP_PREPARE_WINDOW_BUFFER = 1112560197 |> UInt32
const AV_DEV_TO_APP_DISPLAY_WINDOW_BUFFER = 1111771475 |> UInt32
const AV_DEV_TO_APP_DESTROY_WINDOW_BUFFER = 1111770451 |> UInt32
const AV_DEV_TO_APP_BUFFER_OVERFLOW = 1112491596 |> UInt32
const AV_DEV_TO_APP_BUFFER_UNDERFLOW = 1112884812 |> UInt32
const AV_DEV_TO_APP_BUFFER_READABLE = 1112687648 |> UInt32
const AV_DEV_TO_APP_BUFFER_WRITABLE = 1113018912 |> UInt32
const AV_DEV_TO_APP_MUTE_STATE_CHANGED = 1129141588 |> UInt32
const AV_DEV_TO_APP_VOLUME_LEVEL_CHANGED = 1129729868 |> UInt32
# end enum AVDevToAppMessageType

struct AVDeviceCapabilitiesQuery
    av_class::Ptr{AVClass}
    device_context::Ptr{AVFormatContext}
    codec::Cvoid
    sample_format::Cvoid
    pixel_format::Cvoid
    sample_rate::Cint
    channels::Cint
    channel_layout::Int64
    window_width::Cint
    window_height::Cint
    frame_width::Cint
    frame_height::Cint
    fps::AVRational
end

struct AVDeviceInfo
    device_name::Cstring
    device_description::Cstring
end

struct AVDeviceInfoList
    devices::Ptr{Ptr{AVDeviceInfo}}
    nb_devices::Cint
    default_device::Cint
end
