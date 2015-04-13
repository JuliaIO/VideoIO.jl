
export
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


immutable AVDeviceRect
    x::Cint
    y::Cint
    width::Cint
    height::Cint
end

# begin enum AVAppToDevMessageType
typealias AVAppToDevMessageType Uint32
const AV_APP_TO_DEV_NONE = @compat UInt32(1313820229)
const AV_APP_TO_DEV_WINDOW_SIZE = @compat UInt32(1195724621)
const AV_APP_TO_DEV_WINDOW_REPAINT = @compat UInt32(1380274241)
const AV_APP_TO_DEV_PAUSE = @compat UInt32(1346458912)
const AV_APP_TO_DEV_PLAY = @compat UInt32(1347174745)
const AV_APP_TO_DEV_TOGGLE_PAUSE = @compat UInt32(1346458964)
const AV_APP_TO_DEV_SET_VOLUME = @compat UInt32(1398165324)
const AV_APP_TO_DEV_MUTE = @compat UInt32(541939028)
const AV_APP_TO_DEV_UNMUTE = @compat UInt32(1431131476)
const AV_APP_TO_DEV_TOGGLE_MUTE = @compat UInt32(1414354260)
const AV_APP_TO_DEV_GET_VOLUME = @compat UInt32(1196838732)
const AV_APP_TO_DEV_GET_MUTE = @compat UInt32(1196250452)
# end enum AVAppToDevMessageType

# begin enum AVDevToAppMessageType
typealias AVDevToAppMessageType Uint32
const AV_DEV_TO_APP_NONE = @compat UInt32(1313820229)
const AV_DEV_TO_APP_CREATE_WINDOW_BUFFER = @compat UInt32(1111708229)
const AV_DEV_TO_APP_PREPARE_WINDOW_BUFFER = @compat UInt32(1112560197)
const AV_DEV_TO_APP_DISPLAY_WINDOW_BUFFER = @compat UInt32(1111771475)
const AV_DEV_TO_APP_DESTROY_WINDOW_BUFFER = @compat UInt32(1111770451)
const AV_DEV_TO_APP_BUFFER_OVERFLOW = @compat UInt32(1112491596)
const AV_DEV_TO_APP_BUFFER_UNDERFLOW = @compat UInt32(1112884812)
const AV_DEV_TO_APP_BUFFER_READABLE = @compat UInt32(1112687648)
const AV_DEV_TO_APP_BUFFER_WRITABLE = @compat UInt32(1113018912)
const AV_DEV_TO_APP_MUTE_STATE_CHANGED = @compat UInt32(1129141588)
const AV_DEV_TO_APP_VOLUME_LEVEL_CHANGED = @compat UInt32(1129729868)
# end enum AVDevToAppMessageType

immutable AVDeviceCapabilitiesQuery
    av_class::Ptr{AVClass}
    device_context::Ptr{AVFormatContext}
    codec::AVCodecID
    sample_format::AVSampleFormat
    pixel_format::AVPixelFormat
    sample_rate::Cint
    channels::Cint
    channel_layout::Int64
    window_width::Cint
    window_height::Cint
    frame_width::Cint
    frame_height::Cint
    fps::AVRational
end

immutable AVDeviceInfo
    device_name::Ptr{Uint8}
    device_description::Ptr{Uint8}
end

immutable AVDeviceInfoList
    devices::Ptr{Ptr{AVDeviceInfo}}
    nb_devices::Cint
    default_device::Cint
end
