
#### AVOptions:  Extending interface for VideoIO
=================================================================
Extending "generic" and "private" options:
* Codecs
* Camera format
* Camera devices
* Filters (simple and complex filtergraphs)
* Resampling
* Scaling

* Global options (affect whole program instead of just one file):

        **AVCodecContext**
        **AVFormatContext**
        -loglevel loglevel  set logging level
        -v loglevel         set logging level
        -report             generate a report
        -max_alloc bytes    set maximum size of a single allocated block
        -y                  overwrite output files
        -n                  never overwrite output files
        -stats              print progress report during encoding
        -max_error_rate     (0.0- 1.0: 100% error rate)
        -bits_per_raw_sample number  set the number of bits per raw sample
        -vol volume         change audio volume (256=normal)


* Private options
        -f fmt              force format
        -c codec            codec name
        -codec codec        codec name
        -pre preset         preset name
        -map_metadata outfile[,metadata]:infile[,metadat
        set metadata information of outfile from infile
        -t duration         record or transcode "duration" seconds of audio/video
        -to time_stop       record or transcode stop time
        -fs limit_size      set the limit file size in bytes
        -ss time_off        set the start time offset
        -timestamp time     set timestamp ('now' to set the current time)
        -metadata string=string  add metadata
        -target type        specify target file type ("vcd", "svcd", "dvd", "dv",
        "dv50", "pal-vcd", "ntsc-svcd", ...)
        -apad               audio pad
        -frames number      set the number of frames to record
        -filter filter_graph  set stream filtergraph
        -filter_script filename  read stream filtergraph description from a file
        -reinit_filter      reinit filtergraph on input parameter changes
        -discard            discard

* Calling AVOptions from libavcodec_h.jl
 <!--
 immutable AVCodecContext
     width::Cint
     height::Cint-->

### Source libraries

**ffmpeg 2.2**
  libavutil      52
  libavcodec     55
  libavformat    55
  libavdevice    55
  libavfilter     4
  libavresample   1
  libswscale      2
  libswresample   0
  libpostproc    52

1. libavcodec v55

File                 Contents
-----------------------------------------------------------------------------------
avcodec.jl           ccall AV Codec function calls (avcodec.h wrapper)
dv_profile.jl        ccall AV profile function calls (dv_profile.h wrapper)
LIBAVCODEC.jl        include "avcodec.jl" and "libavcodec_h.jl"
libavcodec_h.jl      Type declarations and constants
vdpau.jl             ccall hardware acceleration function calls (vdpau.h wrapper)


*AVCodecContext
AVCodec/v55
AVCodecContext        libavcodec_h.jl

AVUtil/v52/
AVFrame               libavutil_h.jl
AVFrame()             LIBAVUTIL.jl


immutable AVCodecContext
    av_class::Ptr{AVClass}
    log_level_offset::Cint
    codec_type::AVMediaType
    codec::Ptr{AVCodec}
    codec_name::Array_32_Uint8
    codec_id::AVCodecID
    codec_tag::Uint32
    stream_codec_tag::Uint32
    priv_data::Ptr{Void}
    internal::Ptr{AVCodecInternal}
    opaque::Ptr{Void}
    bit_rate::Cint
    bit_rate_tolerance::Cint
    global_quality::Cint
    compression_level::Cint
    flags::Cint
    flags2::Cint
    extradata::Ptr{Uint8}
    extradata_size::Cint
    time_base::AVRational
    ticks_per_frame::Cint
    delay::Cint
    width::Cint
    height::Cint
    coded_width::Cint
    coded_height::Cint
    gop_size::Cint
    pix_fmt::AVPixelFormat
    me_method::Cint
    draw_horiz_band::Ptr{Void}
    get_format::Ptr{Void}
    max_b_frames::Cint
    b_quant_factor::Cfloat
    rc_strategy::Cint
    b_frame_strategy::Cint
    b_quant_offset::Cfloat
    has_b_frames::Cint
    mpeg_quant::Cint
    i_quant_factor::Cfloat
    i_quant_offset::Cfloat
    lumi_masking::Cfloat
    temporal_cplx_masking::Cfloat
    spatial_cplx_masking::Cfloat
    p_masking::Cfloat
    dark_masking::Cfloat
    slice_count::Cint
    prediction_method::Cint
    slice_offset::Ptr{Cint}
    sample_aspect_ratio::AVRational
    me_cmp::Cint
    me_sub_cmp::Cint
    mb_cmp::Cint
    ildct_cmp::Cint
    dia_size::Cint
    last_predictor_count::Cint
    pre_me::Cint
    me_pre_cmp::Cint
    pre_dia_size::Cint
    me_subpel_quality::Cint
    dtg_active_format::Cint
    me_range::Cint
    intra_quant_bias::Cint
    inter_quant_bias::Cint
    slice_flags::Cint
    xvmc_acceleration::Cint
    mb_decision::Cint
    intra_matrix::Ptr{Uint16}
    inter_matrix::Ptr{Uint16}
    scenechange_threshold::Cint
    noise_reduction::Cint
    me_threshold::Cint
    mb_threshold::Cint
    intra_dc_precision::Cint
    skip_top::Cint
    skip_bottom::Cint
    border_masking::Cfloat
    mb_lmin::Cint
    mb_lmax::Cint
    me_penalty_compensation::Cint
    bidir_refine::Cint
    brd_scale::Cint
    keyint_min::Cint
    refs::Cint
    chromaoffset::Cint
    scenechange_factor::Cint
    mv0_threshold::Cint
    b_sensitivity::Cint
    color_primaries::AVColorPrimaries
    color_trc::AVColorTransferCharacteristic
    colorspace::AVColorSpace
    color_range::AVColorRange
    chroma_sample_location::AVChromaLocation
    slices::Cint
    field_order::AVFieldOrder
    sample_rate::Cint
    channels::Cint
    sample_fmt::AVSampleFormat
    frame_size::Cint
    frame_number::Cint
    block_align::Cint
    cutoff::Cint
    request_channels::Cint
    channel_layout::Uint64
    request_channel_layout::Uint64
    audio_service_type::AVAudioServiceType
    request_sample_fmt::AVSampleFormat
    get_buffer::Ptr{Void}
    release_buffer::Ptr{Void}
    reget_buffer::Ptr{Void}
    get_buffer2::Ptr{Void}
    refcounted_frames::Cint
    qcompress::Cfloat
    qblur::Cfloat
    qmin::Cint
    qmax::Cint
    max_qdiff::Cint
    rc_qsquish::Cfloat
    rc_qmod_amp::Cfloat
    rc_qmod_freq::Cint
    rc_buffer_size::Cint
    rc_override_count::Cint
    rc_override::Ptr{RcOverride}
    rc_eq::Ptr{Uint8}
    rc_max_rate::Cint
    rc_min_rate::Cint
    rc_buffer_aggressivity::Cfloat
    rc_initial_cplx::Cfloat
    rc_max_available_vbv_use::Cfloat
    rc_min_vbv_overflow_use::Cfloat
    rc_initial_buffer_occupancy::Cint
    coder_type::Cint
    context_model::Cint
    lmin::Cint
    lmax::Cint
    frame_skip_threshold::Cint
    frame_skip_factor::Cint
    frame_skip_exp::Cint
    frame_skip_cmp::Cint
    trellis::Cint
    min_prediction_order::Cint
    max_prediction_order::Cint
    timecode_frame_start::Int64
    rtp_callback::Ptr{Void}
    rtp_payload_size::Cint
    mv_bits::Cint
    header_bits::Cint
    i_tex_bits::Cint
    p_tex_bits::Cint
    i_count::Cint
    p_count::Cint
    skip_count::Cint
    misc_bits::Cint
    frame_bits::Cint
    stats_out::Ptr{Uint8}
    stats_in::Ptr{Uint8}
    workaround_bugs::Cint
    strict_std_compliance::Cint
    error_concealment::Cint
    debug::Cint
    debug_mv::Cint
    err_recognition::Cint
    reordered_opaque::Int64
    hwaccel::Ptr{AVHWAccel}
    hwaccel_context::Ptr{Void}
    error::Array_8_Uint64
    dct_algo::Cint
    idct_algo::Cint
    bits_per_coded_sample::Cint
    bits_per_raw_sample::Cint
    lowres::Cint
    coded_frame::Ptr{AVFrame}
    thread_count::Cint
    thread_type::Cint
    active_thread_type::Cint
    thread_safe_callbacks::Cint
    execute::Ptr{Void}
    execute2::Ptr{Void}
    thread_opaque::Ptr{Void}
    nsse_weight::Cint
    profile::Cint
    level::Cint
    skip_loop_filter::AVDiscard
    skip_idct::AVDiscard
    skip_frame::AVDiscard
    subtitle_header::Ptr{Uint8}
    subtitle_header_size::Cint
    error_rate::Cint
    pkt::Ptr{AVPacket}
    vbv_delay::Uint64
    side_data_only_packets::Cint
    pkt_timebase::AVRational
    codec_descriptor::Ptr{AVCodecDescriptor}
    pts_correction_num_faulty_pts::Int64
    pts_correction_num_faulty_dts::Int64
    pts_correction_last_pts::Int64
    pts_correction_last_dts::Int64
    sub_charenc::Ptr{Uint8}
    sub_charenc_mode::Cint
    skip_alpha::Cint
    seek_preroll::Cint
    chroma_intra_matrix::Ptr{Uint16}
end

*AVFormatContext
AVFormatContext                    libavformat_h.jl

immutable AVFormatContext

    ctx_flags::Cint
    bit_rate::Cint
    max_delay::Cint
    flags::Cint
    max_analyze_duration::Cint
    keylen::Cint
    fps_probe_size::Cint
    error_recognition::Cint
    debug::Cint
    strict_std_compliance::Cint
    ts_id::Cint
    audio_preload::Cint
    max_chunk_duration::Cint
    max_chunk_size::Cint
    use_wallclock_as_timestamps::Cint
    avoid_negative_ts::Cint
    avio_flags::Cint
    seek2any::Cint
    flush_packets::Cint
    probe_score::Cint
    format_probesize::Cint

    data_offset::Int64
    raw_packet_buffer::Ptr{AVPacketList}
    raw_packet_buffer_end::Ptr{AVPacketList}
    parse_queue::Ptr{AVPacketList}
    parse_queue_end::Ptr{AVPacketList}
    raw_packet_buffer_remaining_size::Cint
    offset::Int64
    offset_timebase::AVRational
    internal::Ptr{AVFormatInternal}
    io_repositioned::Cint
    video_codec::Ptr{AVCodec}
    audio_codec::Ptr{AVCodec}
    subtitle_codec::Ptr{AVCodec}
    metadata_header_padding::Cint
    opaque::Ptr{Void}
    control_message_cb::av_format_control_message
    output_ts_offset::Int64
    max_analyze_duration2::Int64
end




