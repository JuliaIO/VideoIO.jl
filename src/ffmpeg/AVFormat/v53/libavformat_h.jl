
import Base.zero


export
    AVIO_SEEKABLE_NORMAL,
    URL_PROTOCOL_FLAG_NESTED_SCHEME,
    URL_PROTOCOL_FLAG_NETWORK,
    URL_RDONLY,
    URL_WRONLY,
    URL_RDWR,
    URL_FLAG_NONBLOCK,
    URL_EOF,
    AVSEEK_SIZE,
    AVSEEK_FORCE,
    AVIO_FLAG_READ,
    AVIO_FLAG_WRITE,
    AVIO_FLAG_READ_WRITE,
    AVIO_FLAG_NONBLOCK,
    AVIOInterruptCB,
    AVIOContext,
    URLProtocol,
    URLContext,
    URLPollEntry,
    ByteIOContext,
    AV_METADATA_MATCH_CASE,
    AV_METADATA_IGNORE_SUFFIX,
    AV_METADATA_DONT_STRDUP_KEY,
    AV_METADATA_DONT_STRDUP_VAL,
    AV_METADATA_DONT_OVERWRITE,
    AVPROBE_SCORE_MAX,
    AVPROBE_PADDING_SIZE,
    AVFMT_NOFILE,
    AVFMT_NEEDNUMBER,
    AVFMT_SHOW_IDS,
    AVFMT_RAWPICTURE,
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
    AVINDEX_KEYFRAME,
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
    MAX_REORDER_DELAY,
    MAX_PROBE_PACKETS,
    MAX_STD_TIMEBASES,
    AV_PROGRAM_RUNNING,
    AVFMTCTX_NOHEADER,
    AVFMT_NOOUTPUTLOOP,
    AVFMT_INFINITEOUTPUTLOOP,
    AVFMT_FLAG_GENPTS,
    AVFMT_FLAG_IGNIDX,
    AVFMT_FLAG_NONBLOCK,
    AVFMT_FLAG_IGNDTS,
    AVFMT_FLAG_NOFILLIN,
    AVFMT_FLAG_NOPARSE,
    AVFMT_FLAG_RTP_HINT,
    AVFMT_FLAG_CUSTOM_IO,
    AVFMT_FLAG_DISCARD_CORRUPT,
    RAW_PACKET_BUFFER_SIZE,
    AVSEEK_FLAG_BACKWARD,
    AVSEEK_FLAG_BYTE,
    AVSEEK_FLAG_ANY,
    AVSEEK_FLAG_FRAME,
    AVCodecTag,
    AVMetadataConv,
    AVInputFormat,
    AVOutputFormat,
    AVFrac,
    AVStreamParseType,
    AVSTREAM_PARSE_NONE,
    AVSTREAM_PARSE_FULL,
    AVSTREAM_PARSE_HEADERS,
    AVSTREAM_PARSE_TIMESTAMPS,
    AVSTREAM_PARSE_FULL_ONCE,
    AVIndexEntry,
    AVProbeData,
    AVPacketList,
    AVStream,
    AVProgram,
    AVChapter,
    AVFormatContext,
    AVMetadata,
    AVMetadataTag,
    AVFormatParameters


const AVIO_SEEKABLE_NORMAL  =  0x0001
const URL_PROTOCOL_FLAG_NESTED_SCHEME  =  1
const URL_PROTOCOL_FLAG_NETWORK  =  2
const URL_RDONLY  =  1
const URL_WRONLY  =  2
const URL_RDWR  =  URL_RDONLY | URL_WRONLY
const URL_FLAG_NONBLOCK  =  8
const URL_EOF  =  -1
const AVSEEK_SIZE  =  0x00010000
const AVSEEK_FORCE  =  0x00020000
const AVIO_FLAG_READ  =  1
const AVIO_FLAG_WRITE  =  2
const AVIO_FLAG_READ_WRITE  =  AVIO_FLAG_READ | AVIO_FLAG_WRITE
const AVIO_FLAG_NONBLOCK  =  8

immutable AVIOInterruptCB
    callback::Ptr{Void}
    opaque::Ptr{Void}
end

immutable AVIOContext
    buffer::Ptr{Cuchar}
    buffer_size::Cint
    buf_ptr::Ptr{Cuchar}
    buf_end::Ptr{Cuchar}
    opaque::Ptr{Void}
    read_packet::Ptr{Void}
    write_packet::Ptr{Void}
    seek::Ptr{Void}
    pos::Int64
    must_flush::Cint
    eof_reached::Cint
    write_flag::Cint
    is_streamed::Cint
    max_packet_size::Cint
    checksum::Culong
    checksum_ptr::Ptr{Cuchar}
    update_checksum::Ptr{Void}
    error::Cint
    read_pause::Ptr{Void}
    read_seek::Ptr{Void}
    seekable::Cint
end

immutable URLProtocol
    name::Ptr{UInt8}
    url_open::Ptr{Void}
    url_read::Ptr{Void}
    url_write::Ptr{Void}
    url_seek::Ptr{Void}
    url_close::Ptr{Void}
    next::Ptr{URLProtocol}
    url_read_pause::Ptr{Void}
    url_read_seek::Ptr{Void}
    url_get_file_handle::Ptr{Void}
    priv_data_size::Cint
    priv_data_class::Ptr{AVClass}
    flags::Cint
    url_check::Ptr{Void}
end

immutable URLContext
    av_class::Ptr{AVClass}
    prot::Ptr{URLProtocol}
    flags::Cint
    is_streamed::Cint
    max_packet_size::Cint
    priv_data::Ptr{Void}
    filename::Ptr{UInt8}
    is_connected::Cint
    interrupt_callback::AVIOInterruptCB
end

immutable URLPollEntry
    handle::Ptr{URLContext}
    events::Cint
    revents::Cint
end

const ByteIOContext = AVIOContext

const AV_METADATA_MATCH_CASE  =  AV_DICT_MATCH_CASE
const AV_METADATA_IGNORE_SUFFIX  =  AV_DICT_IGNORE_SUFFIX
const AV_METADATA_DONT_STRDUP_KEY  =  AV_DICT_DONT_STRDUP_KEY
const AV_METADATA_DONT_STRDUP_VAL  =  AV_DICT_DONT_STRDUP_VAL
const AV_METADATA_DONT_OVERWRITE  =  AV_DICT_DONT_OVERWRITE
const AVPROBE_SCORE_MAX  =  100
const AVPROBE_PADDING_SIZE  =  32
const AVFMT_NOFILE  =  0x0001
const AVFMT_NEEDNUMBER  =  0x0002
const AVFMT_SHOW_IDS  =  0x0008
const AVFMT_RAWPICTURE  =  0x0020
const AVFMT_GLOBALHEADER  =  0x0040
const AVFMT_NOTIMESTAMPS  =  0x0080
const AVFMT_GENERIC_INDEX  =  0x0100
const AVFMT_TS_DISCONT  =  0x0200
const AVFMT_VARIABLE_FPS  =  0x0400
const AVFMT_NODIMENSIONS  =  0x0800
const AVFMT_NOSTREAMS  =  0x1000
const AVFMT_NOBINSEARCH  =  0x2000
const AVFMT_NOGENSEARCH  =  0x4000
const AVFMT_NO_BYTE_SEEK  =  0x8000
const AVINDEX_KEYFRAME  =  0x0001
const AV_DISPOSITION_DEFAULT  =  0x0001
const AV_DISPOSITION_DUB  =  0x0002
const AV_DISPOSITION_ORIGINAL  =  0x0004
const AV_DISPOSITION_COMMENT  =  0x0008
const AV_DISPOSITION_LYRICS  =  0x0010
const AV_DISPOSITION_KARAOKE  =  0x0020
const AV_DISPOSITION_FORCED  =  0x0040
const AV_DISPOSITION_HEARING_IMPAIRED  =  0x0080
const AV_DISPOSITION_VISUAL_IMPAIRED  =  0x0100
const AV_DISPOSITION_CLEAN_EFFECTS  =  0x0200
const MAX_REORDER_DELAY  =  16
const MAX_PROBE_PACKETS  =  2500
const MAX_STD_TIMEBASES  =  60 * 12 + 5
const AV_PROGRAM_RUNNING  =  1
const AVFMTCTX_NOHEADER  =  0x0001
const AVFMT_NOOUTPUTLOOP  =  -1
const AVFMT_INFINITEOUTPUTLOOP  =  0
const AVFMT_FLAG_GENPTS  =  0x0001
const AVFMT_FLAG_IGNIDX  =  0x0002
const AVFMT_FLAG_NONBLOCK  =  0x0004
const AVFMT_FLAG_IGNDTS  =  0x0008
const AVFMT_FLAG_NOFILLIN  =  0x0010
const AVFMT_FLAG_NOPARSE  =  0x0020
const AVFMT_FLAG_RTP_HINT  =  0x0040
const AVFMT_FLAG_CUSTOM_IO  =  0x0080
const AVFMT_FLAG_DISCARD_CORRUPT  =  0x0100
const FF_FDEBUG_TS  =  0x0001
const RAW_PACKET_BUFFER_SIZE  =  2500000
const AVSEEK_FLAG_BACKWARD  =  1
const AVSEEK_FLAG_BYTE  =  2
const AVSEEK_FLAG_ANY  =  4
const AVSEEK_FLAG_FRAME  =  8

const AVCodecTag = Void
const AVMetadataConv = Void

immutable AVInputFormat
    name::Ptr{UInt8}
    long_name::Ptr{UInt8}
    priv_data_size::Cint
    read_probe::Ptr{Void}
    read_header::Ptr{Void}
    read_packet::Ptr{Void}
    read_close::Ptr{Void}
    read_seek::Ptr{Void}
    read_timestamp::Ptr{Void}
    flags::Cint
    extensions::Ptr{UInt8}
    value::Cint
    read_play::Ptr{Void}
    read_pause::Ptr{Void}
    codec_tag::Ptr{Ptr{AVCodecTag}}
    read_seek2::Ptr{Void}
    metadata_conv::Ptr{AVMetadataConv}
    priv_class::Ptr{AVClass}
    next::Ptr{AVInputFormat}
end

immutable AVOutputFormat
    name::Ptr{UInt8}
    long_name::Ptr{UInt8}
    mime_type::Ptr{UInt8}
    extensions::Ptr{UInt8}
    priv_data_size::Cint
    audio_codec::CodecID
    video_codec::CodecID
    write_header::Ptr{Void}
    write_packet::Ptr{Void}
    write_trailer::Ptr{Void}
    flags::Cint
    set_parameters::Ptr{Void}
    interleave_packet::Ptr{Void}
    codec_tag::Ptr{Ptr{AVCodecTag}}
    subtitle_codec::CodecID
    metadata_conv::Ptr{AVMetadataConv}
    priv_class::Ptr{AVClass}
    query_codec::Ptr{Void}
    next::Ptr{AVOutputFormat}
end

immutable AVFrac
    val::Int64
    num::Int64
    den::Int64
end

# begin enum AVStreamParseType
const AVStreamParseType = UInt32
const AVSTREAM_PARSE_NONE  =  UInt32(0)
const AVSTREAM_PARSE_FULL  =  UInt32(1)
const AVSTREAM_PARSE_HEADERS  =  UInt32(2)
const AVSTREAM_PARSE_TIMESTAMPS  =  UInt32(3)
const AVSTREAM_PARSE_FULL_ONCE  =  UInt32(4)
# end enum AVStreamParseType

immutable AVIndexEntry
    pos::Int64
    timestamp::Int64
    flags::Cint
    size::Cint
    min_distance::Cint
end

immutable AVProbeData
    filename::Ptr{UInt8}
    buf::Ptr{Cuchar}
    buf_size::Cint
end

immutable AVPacketList
    pkt::AVPacket
    next::Ptr{AVPacketList}
end

immutable AVStream
    index::Cint
    id::Cint
    codec::Ptr{AVCodecContext}
    r_frame_rate::AVRational
    priv_data::Ptr{Void}
    first_dts::Int64
    pts::AVFrac
    time_base::AVRational
    pts_wrap_bits::Cint
    stream_copy::Cint
    discard::AVDiscard
    quality::Cfloat
    start_time::Int64
    duration::Int64
    need_parsing::AVStreamParseType
    parser::Ptr{AVCodecParserContext}
    cur_dts::Int64
    last_IP_duration::Cint
    last_IP_pts::Int64
    index_entries::Ptr{AVIndexEntry}
    nb_index_entries::Cint
    index_entries_allocated_size::UInt32
    nb_frames::Int64
    disposition::Cint
    probe_data::AVProbeData
    pts_buffer::NTuple{17,Int64}
    sample_aspect_ratio::AVRational
    metadata::Ptr{AVDictionary}
    cur_ptr::Ptr{UInt8}
    cur_len::Cint
    cur_pkt::AVPacket
    reference_dts::Int64
    probe_packets::Cint
    last_in_packet_buffer::Ptr{AVPacketList}
    avg_frame_rate::AVRational
    codec_info_nb_frames::Cint
    info::Ptr{Void}
end

immutable AVProgram
    id::Cint
    flags::Cint
    discard::AVDiscard
    stream_index::Ptr{UInt32}
    nb_stream_indexes::UInt32
    metadata::Ptr{AVDictionary}
end

immutable AVChapter
    id::Cint
    time_base::AVRational
    start::Int64
    _end::Int64
    metadata::Ptr{AVDictionary}
end

immutable AVFormatContext
    av_class::Ptr{AVClass}
    iformat::Ptr{AVInputFormat}
    oformat::Ptr{AVOutputFormat}
    priv_data::Ptr{Void}
    pb::Ptr{AVIOContext}
    nb_streams::UInt32
    streams::Ptr{Ptr{AVStream}}
    filename::NTuple{1024,UInt8}
    timestamp::Int64
    ctx_flags::Cint
    packet_buffer::Ptr{AVPacketList}
    start_time::Int64
    duration::Int64
    file_size::Int64
    bit_rate::Cint
    cur_st::Ptr{AVStream}
    data_offset::Int64
    mux_rate::Cint
    packet_size::UInt32
    preload::Cint
    max_delay::Cint
    loop_output::Cint
    flags::Cint
    loop_input::Cint
    probesize::UInt32
    max_analyze_duration::Cint
    key::Ptr{UInt8}
    keylen::Cint
    nb_programs::UInt32
    programs::Ptr{Ptr{AVProgram}}
    video_codec_id::CodecID
    audio_codec_id::CodecID
    subtitle_codec_id::CodecID
    max_index_size::UInt32
    max_picture_buffer::UInt32
    nb_chapters::UInt32
    chapters::Ptr{Ptr{AVChapter}}
    debug::Cint
    raw_packet_buffer::Ptr{AVPacketList}
    raw_packet_buffer_end::Ptr{AVPacketList}
    packet_buffer_end::Ptr{AVPacketList}
    metadata::Ptr{AVDictionary}
    raw_packet_buffer_remaining_size::Cint
    start_time_realtime::Int64
    fps_probe_size::Cint
    error_recognition::Cint
    interrupt_callback::AVIOInterruptCB
end

const AVMetadata = AVDictionary
const AVMetadataTag = AVDictionaryEntry

immutable AVFormatParameters
    time_base::AVRational
    sample_rate::Cint
    channels::Cint
    width::Cint
    height::Cint
    pix_fmt::PixelFormat
    channel::Cint
    standard::Ptr{UInt8}
    mpeg2ts_raw::UInt32
    mpeg2ts_compute_pcr::UInt32
    initial_pause::UInt32
    prealloced_context::UInt32
end
