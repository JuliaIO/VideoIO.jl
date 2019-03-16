# Automatically generated using Clang.jl wrap_c, version 0.0.0


export
    unix,
    linux,
    AVIO_SEEKABLE_NORMAL,
    AVIO_SEEKABLE_TIME,
    AVSEEK_SIZE,
    AVSEEK_FORCE,
    AVIO_FLAG_READ,
    AVIO_FLAG_WRITE,
    AVIO_FLAG_READ_WRITE,
    AVIO_FLAG_NONBLOCK,
    AVIO_FLAG_DIRECT,
    AVIOInterruptCB,
    AVIODirEntryType,
    AVIO_ENTRY_UNKNOWN,
    AVIO_ENTRY_BLOCK_DEVICE,
    AVIO_ENTRY_CHARACTER_DEVICE,
    AVIO_ENTRY_DIRECTORY,
    AVIO_ENTRY_NAMED_PIPE,
    AVIO_ENTRY_SYMBOLIC_LINK,
    AVIO_ENTRY_SOCKET,
    AVIO_ENTRY_FILE,
    AVIO_ENTRY_SERVER,
    AVIO_ENTRY_SHARE,
    AVIO_ENTRY_WORKGROUP,
    AVIODirEntry,
    AVIODirContext,
    AVIODataMarkerType,
    AVIO_DATA_MARKER_HEADER,
    AVIO_DATA_MARKER_SYNC_POINT,
    AVIO_DATA_MARKER_BOUNDARY_POINT,
    AVIO_DATA_MARKER_UNKNOWN,
    AVIO_DATA_MARKER_TRAILER,
    AVIO_DATA_MARKER_FLUSH_POINT,
    AVIOContext,
    AVBPrint,
    AVPROBE_SCORE_MAX,
    AVPROBE_SCORE_RETRY,
    AVPROBE_SCORE_STREAM_RETRY,
    AVPROBE_SCORE_EXTENSION,
    AVPROBE_SCORE_MIME,
    AVPROBE_PADDING_SIZE,
    AVFMT_NOFILE,
    AVFMT_NEEDNUMBER,
    AVFMT_SHOW_IDS,
    AVFMT_GLOBALHEADER,
    AVFMT_NOTIMESTAMPS,
    AVFMT_GENERIC_INDEX,
    AVFMT_TS_DISCONT,
    AVFMT_VARIABLE_FPS,
    AVFMT_NODIMENSIONS,
    AVFMT_NOSTREAMS,
    AVFMT_NOBINSEARCH,
    AVFMT_NOGENSEARCH,
    AVFMT_NO_BYTE_SEEK,
    AVFMT_ALLOW_FLUSH,
    AVFMT_TS_NONSTRICT,
    AVFMT_TS_NEGATIVE,
    AVFMT_SEEK_TO_PTS,
    AVINDEX_KEYFRAME,
    AVINDEX_DISCARD_FRAME,
    AV_DISPOSITION_DEFAULT,
    AV_DISPOSITION_DUB,
    AV_DISPOSITION_ORIGINAL,
    AV_DISPOSITION_COMMENT,
    AV_DISPOSITION_LYRICS,
    AV_DISPOSITION_KARAOKE,
    AV_DISPOSITION_FORCED,
    AV_DISPOSITION_HEARING_IMPAIRED,
    AV_DISPOSITION_VISUAL_IMPAIRED,
    AV_DISPOSITION_CLEAN_EFFECTS,
    AV_DISPOSITION_ATTACHED_PIC,
    AV_DISPOSITION_TIMED_THUMBNAILS,
    AV_DISPOSITION_CAPTIONS,
    AV_DISPOSITION_DESCRIPTIONS,
    AV_DISPOSITION_METADATA,
    AV_DISPOSITION_DEPENDENT,
    AV_DISPOSITION_STILL_IMAGE,
    AV_PTS_WRAP_IGNORE,
    AV_PTS_WRAP_ADD_OFFSET,
    AV_PTS_WRAP_SUB_OFFSET,
    AVSTREAM_EVENT_FLAG_METADATA_UPDATED,
    MAX_STD_TIMEBASES,
    MAX_REORDER_DELAY,
    AV_PROGRAM_RUNNING,
    AVFMTCTX_NOHEADER,
    AVFMTCTX_UNSEEKABLE,
    AVFMT_FLAG_GENPTS,
    AVFMT_FLAG_IGNIDX,
    AVFMT_FLAG_NONBLOCK,
    AVFMT_FLAG_IGNDTS,
    AVFMT_FLAG_NOFILLIN,
    AVFMT_FLAG_NOPARSE,
    AVFMT_FLAG_NOBUFFER,
    AVFMT_FLAG_CUSTOM_IO,
    AVFMT_FLAG_DISCARD_CORRUPT,
    AVFMT_FLAG_FLUSH_PACKETS,
    AVFMT_FLAG_BITEXACT,
    AVFMT_FLAG_MP4A_LATM,
    AVFMT_FLAG_SORT_DTS,
    AVFMT_FLAG_PRIV_OPT,
    AVFMT_FLAG_KEEP_SIDE_DATA,
    AVFMT_FLAG_FAST_SEEK,
    AVFMT_FLAG_SHORTEST,
    AVFMT_FLAG_AUTO_BSF,
    AVFMT_EVENT_FLAG_METADATA_UPDATED,
    AVFMT_AVOID_NEG_TS_AUTO,
    AVFMT_AVOID_NEG_TS_MAKE_NON_NEGATIVE,
    AVFMT_AVOID_NEG_TS_MAKE_ZERO,
    AVSEEK_FLAG_BACKWARD,
    AVSEEK_FLAG_BYTE,
    AVSEEK_FLAG_ANY,
    AVSEEK_FLAG_FRAME,
    AVSTREAM_INIT_IN_WRITE_HEADER,
    AVSTREAM_INIT_IN_INIT_OUTPUT,
    AV_FRAME_FILENAME_FLAGS_MULTIPLE,
    AVCodecTag,
    AVInputFormat,
    AVOutputFormat,
    AVStreamParseType,
    AVSTREAM_PARSE_NONE,
    AVSTREAM_PARSE_FULL,
    AVSTREAM_PARSE_HEADERS,
    AVSTREAM_PARSE_TIMESTAMPS,
    AVSTREAM_PARSE_FULL_ONCE,
    AVSTREAM_PARSE_FULL_RAW,
    AVPacketList,
    AVProbeData,
    AVIndexEntry,
    AVStreamInternal,
    AVStream,
    AVProgram,
    AVChapter,
    AVDurationEstimationMethod,
    AVFMT_DURATION_FROM_PTS,
    AVFMT_DURATION_FROM_STREAM,
    AVFMT_DURATION_FROM_BITRATE,
    AVFormatInternal,
    av_format_control_message,
    AVFormatContext,
    AVDeviceInfoList,
    AVDeviceCapabilitiesQuery,
    AVOpenCallback,
    AVTimebaseSource,
    AVFMT_TBCF_AUTO,
    AVFMT_TBCF_DECODER,
    AVFMT_TBCF_DEMUXER,
    AVFMT_TBCF_R_FRAMERATE,
    LIBAVFORMAT_VERSION_MAJOR,
    LIBAVFORMAT_VERSION_MINOR,
    LIBAVFORMAT_VERSION_MICRO
    # LIBAVFORMAT_BUILD


const unix = 1
const linux = 1
const AVIO_SEEKABLE_NORMAL = 1 << 0
const AVIO_SEEKABLE_TIME = 1 << 1
const AVSEEK_SIZE = 0x00010000
const AVSEEK_FORCE = 0x00020000
const AVIO_FLAG_READ = 1
const AVIO_FLAG_WRITE = 2
const AVIO_FLAG_READ_WRITE = AVIO_FLAG_READ | AVIO_FLAG_WRITE
const AVIO_FLAG_NONBLOCK = 8
const AVIO_FLAG_DIRECT = 0x8000

struct AVIOInterruptCB
    callback::Ptr{Cvoid}
    opaque::Ptr{Cvoid}
end

# begin enum AVIODirEntryType
const AVIODirEntryType = UInt32
const AVIO_ENTRY_UNKNOWN = 0 |> UInt32
const AVIO_ENTRY_BLOCK_DEVICE = 1 |> UInt32
const AVIO_ENTRY_CHARACTER_DEVICE = 2 |> UInt32
const AVIO_ENTRY_DIRECTORY = 3 |> UInt32
const AVIO_ENTRY_NAMED_PIPE = 4 |> UInt32
const AVIO_ENTRY_SYMBOLIC_LINK = 5 |> UInt32
const AVIO_ENTRY_SOCKET = 6 |> UInt32
const AVIO_ENTRY_FILE = 7 |> UInt32
const AVIO_ENTRY_SERVER = 8 |> UInt32
const AVIO_ENTRY_SHARE = 9 |> UInt32
const AVIO_ENTRY_WORKGROUP = 10 |> UInt32
# end enum AVIODirEntryType

struct AVIODirEntry
    name::Cstring
    _type::Cint
    utf8::Cint
    size::Int64
    modification_timestamp::Int64
    access_timestamp::Int64
    status_change_timestamp::Int64
    user_id::Int64
    group_id::Int64
    filemode::Int64
end

struct AVIODirContext
    # url_context::Ptr{URLContext}
    url_context::Ptr{Cvoid}
end

# begin enum AVIODataMarkerType
const AVIODataMarkerType = UInt32
const AVIO_DATA_MARKER_HEADER = 0 |> UInt32
const AVIO_DATA_MARKER_SYNC_POINT = 1 |> UInt32
const AVIO_DATA_MARKER_BOUNDARY_POINT = 2 |> UInt32
const AVIO_DATA_MARKER_UNKNOWN = 3 |> UInt32
const AVIO_DATA_MARKER_TRAILER = 4 |> UInt32
const AVIO_DATA_MARKER_FLUSH_POINT = 5 |> UInt32
# end enum AVIODataMarkerType

struct AVIOContext
    av_class::Ptr{AVClass}
    buffer::Ptr{Cuchar}
    buffer_size::Cint
    buf_ptr::Ptr{Cuchar}
    buf_end::Ptr{Cuchar}
    opaque::Ptr{Cvoid}
    read_packet::Ptr{Cvoid}
    write_packet::Ptr{Cvoid}
    seek::Ptr{Cvoid}
    pos::Int64
    eof_reached::Cint
    write_flag::Cint
    max_packet_size::Cint
    checksum::Culong
    checksum_ptr::Ptr{Cuchar}
    update_checksum::Ptr{Cvoid}
    error::Cint
    read_pause::Ptr{Cvoid}
    read_seek::Ptr{Cvoid}
    seekable::Cint
    maxsize::Int64
    direct::Cint
    bytes_read::Int64
    seek_count::Cint
    writeout_count::Cint
    orig_buffer_size::Cint
    short_seek_threshold::Cint
    protocol_whitelist::Cstring
    protocol_blacklist::Cstring
    write_data_type::Ptr{Cvoid}
    ignore_boundary_point::Cint
    current_type::AVIODataMarkerType
    last_time::Int64
    short_seek_get::Ptr{Cvoid}
    written::Int64
    buf_ptr_max::Ptr{Cuchar}
    min_packet_size::Cint
end

struct AVBPrint
end

const AVPROBE_SCORE_MAX = 100
const AVPROBE_SCORE_RETRY = AVPROBE_SCORE_MAX / 4
const AVPROBE_SCORE_STREAM_RETRY = AVPROBE_SCORE_MAX / 4 - 1
const AVPROBE_SCORE_EXTENSION = 50
const AVPROBE_SCORE_MIME = 75
const AVPROBE_PADDING_SIZE = 32
const AVFMT_NOFILE = 0x0001
const AVFMT_NEEDNUMBER = 0x0002
const AVFMT_SHOW_IDS = 0x0008
const AVFMT_GLOBALHEADER = 0x0040
const AVFMT_NOTIMESTAMPS = 0x0080
const AVFMT_GENERIC_INDEX = 0x0100
const AVFMT_TS_DISCONT = 0x0200
const AVFMT_VARIABLE_FPS = 0x0400
const AVFMT_NODIMENSIONS = 0x0800
const AVFMT_NOSTREAMS = 0x1000
const AVFMT_NOBINSEARCH = 0x2000
const AVFMT_NOGENSEARCH = 0x4000
const AVFMT_NO_BYTE_SEEK = 0x8000
const AVFMT_ALLOW_FLUSH = 0x00010000
const AVFMT_TS_NONSTRICT = 0x00020000
const AVFMT_TS_NEGATIVE = 0x00040000
const AVFMT_SEEK_TO_PTS = 0x04000000
const AVINDEX_KEYFRAME = 0x0001
const AVINDEX_DISCARD_FRAME = 0x0002
const AV_DISPOSITION_DEFAULT = 0x0001
const AV_DISPOSITION_DUB = 0x0002
const AV_DISPOSITION_ORIGINAL = 0x0004
const AV_DISPOSITION_COMMENT = 0x0008
const AV_DISPOSITION_LYRICS = 0x0010
const AV_DISPOSITION_KARAOKE = 0x0020
const AV_DISPOSITION_FORCED = 0x0040
const AV_DISPOSITION_HEARING_IMPAIRED = 0x0080
const AV_DISPOSITION_VISUAL_IMPAIRED = 0x0100
const AV_DISPOSITION_CLEAN_EFFECTS = 0x0200
const AV_DISPOSITION_ATTACHED_PIC = 0x0400
const AV_DISPOSITION_TIMED_THUMBNAILS = 0x0800
const AV_DISPOSITION_CAPTIONS = 0x00010000
const AV_DISPOSITION_DESCRIPTIONS = 0x00020000
const AV_DISPOSITION_METADATA = 0x00040000
const AV_DISPOSITION_DEPENDENT = 0x00080000
const AV_DISPOSITION_STILL_IMAGE = 0x00100000
const AV_PTS_WRAP_IGNORE = 0
const AV_PTS_WRAP_ADD_OFFSET = 1
const AV_PTS_WRAP_SUB_OFFSET = -1
const AVSTREAM_EVENT_FLAG_METADATA_UPDATED = 0x0001
const MAX_STD_TIMEBASES = 30 * 12 + 30 + 3 + 6
const MAX_REORDER_DELAY = 16
const AV_PROGRAM_RUNNING = 1
const AVFMTCTX_NOHEADER = 0x0001
const AVFMTCTX_UNSEEKABLE = 0x0002
const AVFMT_FLAG_GENPTS = 0x0001
const AVFMT_FLAG_IGNIDX = 0x0002
const AVFMT_FLAG_NONBLOCK = 0x0004
const AVFMT_FLAG_IGNDTS = 0x0008
const AVFMT_FLAG_NOFILLIN = 0x0010
const AVFMT_FLAG_NOPARSE = 0x0020
const AVFMT_FLAG_NOBUFFER = 0x0040
const AVFMT_FLAG_CUSTOM_IO = 0x0080
const AVFMT_FLAG_DISCARD_CORRUPT = 0x0100
const AVFMT_FLAG_FLUSH_PACKETS = 0x0200
const AVFMT_FLAG_BITEXACT = 0x0400
const AVFMT_FLAG_MP4A_LATM = 0x8000
const AVFMT_FLAG_SORT_DTS = 0x00010000
const AVFMT_FLAG_PRIV_OPT = 0x00020000
const AVFMT_FLAG_KEEP_SIDE_DATA = 0x00040000
const AVFMT_FLAG_FAST_SEEK = 0x00080000
const AVFMT_FLAG_SHORTEST = 0x00100000
const AVFMT_FLAG_AUTO_BSF = 0x00200000
const FF_FDEBUG_TS = 0x0001
const AVFMT_EVENT_FLAG_METADATA_UPDATED = 0x0001
const AVFMT_AVOID_NEG_TS_AUTO = -1
const AVFMT_AVOID_NEG_TS_MAKE_NON_NEGATIVE = 1
const AVFMT_AVOID_NEG_TS_MAKE_ZERO = 2
const AVSEEK_FLAG_BACKWARD = 1
const AVSEEK_FLAG_BYTE = 2
const AVSEEK_FLAG_ANY = 4
const AVSEEK_FLAG_FRAME = 8
const AVSTREAM_INIT_IN_WRITE_HEADER = 0
const AVSTREAM_INIT_IN_INIT_OUTPUT = 1
const AV_FRAME_FILENAME_FLAGS_MULTIPLE = 1

struct AVCodecTag
end

struct AVInputFormat
    name::Cstring
    long_name::Cstring
    flags::Cint
    extensions::Cstring
    codec_tag::Ptr{Ptr{AVCodecTag}}
    priv_class::Ptr{AVClass}
    mime_type::Cstring
    next::Ptr{AVInputFormat}
    raw_codec_id::Cint
    priv_data_size::Cint
    read_probe::Ptr{Cvoid}
    read_header::Ptr{Cvoid}
    read_packet::Ptr{Cvoid}
    read_close::Ptr{Cvoid}
    read_seek::Ptr{Cvoid}
    read_timestamp::Ptr{Cvoid}
    read_play::Ptr{Cvoid}
    read_pause::Ptr{Cvoid}
    read_seek2::Ptr{Cvoid}
    get_device_list::Ptr{Cvoid}
    create_device_capabilities::Ptr{Cvoid}
    free_device_capabilities::Ptr{Cvoid}
end

struct AVOutputFormat
    name::Cstring
    long_name::Cstring
    mime_type::Cstring
    extensions::Cstring
    audio_codec::AVCodecID
    video_codec::AVCodecID
    subtitle_codec::AVCodecID
    flags::Cint
    codec_tag::Ptr{Ptr{AVCodecTag}}
    priv_class::Ptr{AVClass}
    next::Ptr{AVOutputFormat}
    priv_data_size::Cint
    write_header::Ptr{Cvoid}
    write_packet::Ptr{Cvoid}
    write_trailer::Ptr{Cvoid}
    interleave_packet::Ptr{Cvoid}
    query_codec::Ptr{Cvoid}
    get_output_timestamp::Ptr{Cvoid}
    control_message::Ptr{Cvoid}
    write_uncoded_frame::Ptr{Cvoid}
    get_device_list::Ptr{Cvoid}
    create_device_capabilities::Ptr{Cvoid}
    free_device_capabilities::Ptr{Cvoid}
    data_codec::AVCodecID
    init::Ptr{Cvoid}
    deinit::Ptr{Cvoid}
    check_bitstream::Ptr{Cvoid}
end

# begin enum AVStreamParseType
const AVStreamParseType = UInt32
const AVSTREAM_PARSE_NONE = 0 |> UInt32
const AVSTREAM_PARSE_FULL = 1 |> UInt32
const AVSTREAM_PARSE_HEADERS = 2 |> UInt32
const AVSTREAM_PARSE_TIMESTAMPS = 3 |> UInt32
const AVSTREAM_PARSE_FULL_ONCE = 4 |> UInt32
const AVSTREAM_PARSE_FULL_RAW = 5 |> UInt32
# end enum AVStreamParseType

struct AVPacketList
    pkt::AVPacket
    next::Ptr{AVPacketList}
end

struct AVProbeData
    filename::Cstring
    buf::Ptr{Cuchar}
    buf_size::Cint
    mime_type::Cstring
end

struct AVIndexEntry
    pos::Int64
    timestamp::Int64
    flags::Cint
    size::Cint
    min_distance::Cint
end

struct AVStreamInternal
end

struct AVStream
    index::Cint
    id::Cint
    codec::Ptr{AVCodecContext}
    priv_data::Ptr{Cvoid}
    time_base::AVRational
    start_time::Int64
    duration::Int64
    nb_frames::Int64
    disposition::Cint
    discard::AVDiscard
    sample_aspect_ratio::AVRational
    metadata::Ptr{AVDictionary}
    avg_frame_rate::AVRational
    attached_pic::AVPacket
    side_data::Ptr{AVPacketSideData}
    nb_side_data::Cint
    event_flags::Cint
    r_frame_rate::AVRational
    recommended_encoder_configuration::Cstring
    codecpar::Ptr{AVCodecParameters}
    info::Ptr{}
    pts_wrap_bits::Cint
    first_dts::Int64
    cur_dts::Int64
    last_IP_pts::Int64
    last_IP_duration::Cint
    probe_packets::Cint
    codec_info_nb_frames::Cint
    need_parsing::AVStreamParseType
    parser::Ptr{AVCodecParserContext}
    last_in_packet_buffer::Ptr{AVPacketList}
    probe_data::AVProbeData
    pts_buffer::NTuple{17, Int64}
    index_entries::Ptr{AVIndexEntry}
    nb_index_entries::Cint
    index_entries_allocated_size::UInt32
    stream_identifier::Cint
    program_num::Cint
    pmt_version::Cint
    pmt_stream_idx::Cint
    interleaver_chunk_size::Int64
    interleaver_chunk_duration::Int64
    request_probe::Cint
    skip_to_keyframe::Cint
    skip_samples::Cint
    start_skip_samples::Int64
    first_discard_sample::Int64
    last_discard_sample::Int64
    nb_decoded_frames::Cint
    mux_ts_offset::Int64
    pts_wrap_reference::Int64
    pts_wrap_behavior::Cint
    update_initial_durations_done::Cint
    pts_reorder_error::NTuple{17, Int64}
    pts_reorder_error_count::NTuple{17, UInt8}
    last_dts_for_order_check::Int64
    dts_ordered::UInt8
    dts_misordered::UInt8
    inject_global_side_data::Cint
    display_aspect_ratio::AVRational
    internal::Ptr{AVStreamInternal}
end

struct AVProgram
    id::Cint
    flags::Cint
    discard::AVDiscard
    stream_index::Ptr{UInt32}
    nb_stream_indexes::UInt32
    metadata::Ptr{AVDictionary}
    program_num::Cint
    pmt_pid::Cint
    pcr_pid::Cint
    pmt_version::Cint
    start_time::Int64
    end_time::Int64
    pts_wrap_reference::Int64
    pts_wrap_behavior::Cint
end

struct AVChapter
    id::Cint
    time_base::AVRational
    start::Int64
    _end::Int64
    metadata::Ptr{AVDictionary}
end

# begin enum AVDurationEstimationMethod
const AVDurationEstimationMethod = UInt32
const AVFMT_DURATION_FROM_PTS = 0 |> UInt32
const AVFMT_DURATION_FROM_STREAM = 1 |> UInt32
const AVFMT_DURATION_FROM_BITRATE = 2 |> UInt32
# end enum AVDurationEstimationMethod

struct AVFormatInternal
end

const av_format_control_message = Ptr{Cvoid}

struct AVFormatContext
    av_class::Ptr{AVClass}
    iformat::Ptr{AVInputFormat}
    oformat::Ptr{AVOutputFormat}
    priv_data::Ptr{Cvoid}
    pb::Ptr{AVIOContext}
    ctx_flags::Cint
    nb_streams::UInt32
    streams::Ptr{Ptr{AVStream}}
    filename::NTuple{1024, UInt8}
    url::Cstring
    start_time::Int64
    duration::Int64
    bit_rate::Int64
    packet_size::UInt32
    max_delay::Cint
    flags::Cint
    probesize::Int64
    max_analyze_duration::Int64
    key::Ptr{UInt8}
    keylen::Cint
    nb_programs::UInt32
    programs::Ptr{Ptr{AVProgram}}
    video_codec_id::AVCodecID
    audio_codec_id::AVCodecID
    subtitle_codec_id::AVCodecID
    max_index_size::UInt32
    max_picture_buffer::UInt32
    nb_chapters::UInt32
    chapters::Ptr{Ptr{AVChapter}}
    metadata::Ptr{AVDictionary}
    start_time_realtime::Int64
    fps_probe_size::Cint
    error_recognition::Cint
    interrupt_callback::AVIOInterruptCB
    debug::Cint
    max_interleave_delta::Int64
    strict_std_compliance::Cint
    event_flags::Cint
    max_ts_probe::Cint
    avoid_negative_ts::Cint
    ts_id::Cint
    audio_preload::Cint
    max_chunk_duration::Cint
    max_chunk_size::Cint
    use_wallclock_as_timestamps::Cint
    avio_flags::Cint
    duration_estimation_method::AVDurationEstimationMethod
    skip_initial_bytes::Int64
    correct_ts_overflow::UInt32
    seek2any::Cint
    flush_packets::Cint
    probe_score::Cint
    format_probesize::Cint
    codec_whitelist::Cstring
    format_whitelist::Cstring
    internal::Ptr{AVFormatInternal}
    io_repositioned::Cint
    video_codec::Ptr{AVCodec}
    audio_codec::Ptr{AVCodec}
    subtitle_codec::Ptr{AVCodec}
    data_codec::Ptr{AVCodec}
    metadata_header_padding::Cint
    opaque::Ptr{Cvoid}
    control_message_cb::av_format_control_message
    output_ts_offset::Int64
    dump_separator::Ptr{UInt8}
    data_codec_id::AVCodecID
    open_cb::Ptr{Cvoid}
    protocol_whitelist::Cstring
    io_open::Ptr{Cvoid}
    io_close::Ptr{Cvoid}
    protocol_blacklist::Cstring
    max_streams::Cint
    skip_estimate_duration_from_pts::Cint
end

struct AVDeviceInfoList
end

struct AVDeviceCapabilitiesQuery
end

const AVOpenCallback = Ptr{Cvoid}

# begin enum AVTimebaseSource
const AVTimebaseSource = Cint
const AVFMT_TBCF_AUTO = -1 |> Int32
const AVFMT_TBCF_DECODER = 0 |> Int32
const AVFMT_TBCF_DEMUXER = 1 |> Int32
const AVFMT_TBCF_R_FRAMERATE = 2 |> Int32
# end enum AVTimebaseSource

const LIBAVFORMAT_VERSION_MAJOR = 58
const LIBAVFORMAT_VERSION_MINOR = 20
const LIBAVFORMAT_VERSION_MICRO = 100

# Skipping MacroDefinition: LIBAVFORMAT_VERSION_INT AV_VERSION_INT ( LIBAVFORMAT_VERSION_MAJOR , LIBAVFORMAT_VERSION_MINOR , LIBAVFORMAT_VERSION_MICRO )
# Skipping MacroDefinition: LIBAVFORMAT_VERSION AV_VERSION ( LIBAVFORMAT_VERSION_MAJOR , LIBAVFORMAT_VERSION_MINOR , LIBAVFORMAT_VERSION_MICRO )

# const LIBAVFORMAT_BUILD = LIBAVFORMAT_VERSION_INT

# Skipping MacroDefinition: LIBAVFORMAT_IDENT "Lavf" AV_STRINGIFY ( LIBAVFORMAT_VERSION )
# Skipping MacroDefinition: FF_API_COMPUTE_PKT_FIELDS2 ( LIBAVFORMAT_VERSION_MAJOR < 59 )
# Skipping MacroDefinition: FF_API_OLD_OPEN_CALLBACKS ( LIBAVFORMAT_VERSION_MAJOR < 59 )
# Skipping MacroDefinition: FF_API_LAVF_AVCTX ( LIBAVFORMAT_VERSION_MAJOR < 59 )
# Skipping MacroDefinition: FF_API_HTTP_USER_AGENT ( LIBAVFORMAT_VERSION_MAJOR < 59 )
# Skipping MacroDefinition: FF_API_HLS_WRAP ( LIBAVFORMAT_VERSION_MAJOR < 59 )
# Skipping MacroDefinition: FF_API_HLS_USE_LOCALTIME ( LIBAVFORMAT_VERSION_MAJOR < 59 )
# Skipping MacroDefinition: FF_API_LAVF_KEEPSIDE_FLAG ( LIBAVFORMAT_VERSION_MAJOR < 59 )
# Skipping MacroDefinition: FF_API_OLD_ROTATE_API ( LIBAVFORMAT_VERSION_MAJOR < 59 )
# Skipping MacroDefinition: FF_API_FORMAT_GET_SET ( LIBAVFORMAT_VERSION_MAJOR < 59 )
# Skipping MacroDefinition: FF_API_OLD_AVIO_EOF_0 ( LIBAVFORMAT_VERSION_MAJOR < 59 )
# Skipping MacroDefinition: FF_API_LAVF_FFSERVER ( LIBAVFORMAT_VERSION_MAJOR < 59 )
# Skipping MacroDefinition: FF_API_FORMAT_FILENAME ( LIBAVFORMAT_VERSION_MAJOR < 59 )
# Skipping MacroDefinition: FF_API_OLD_RTSP_OPTIONS ( LIBAVFORMAT_VERSION_MAJOR < 59 )
# Skipping MacroDefinition: FF_API_NEXT ( LIBAVFORMAT_VERSION_MAJOR < 59 )
# Skipping MacroDefinition: FF_API_DASH_MIN_SEG_DURATION ( LIBAVFORMAT_VERSION_MAJOR < 59 )
# Skipping MacroDefinition: FF_API_LAVF_MP4A_LATM ( LIBAVFORMAT_VERSION_MAJOR < 59 )

const FF_API_R_FRAME_RATE = 1
