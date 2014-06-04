# Julia wrapper for header: /usr/include/libavformat/avformat.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0

@c Int32 url_poll (Ptr{URLPollEntry}, Int32, Int32) libavformat
@c Int32 url_open_protocol (Ptr{Ptr{URLContext}}, Ptr{Void}, Ptr{Uint8}, Int32) libavformat
@c Int32 url_alloc (Ptr{Ptr{URLContext}}, Ptr{Uint8}, Int32) libavformat
@c Int32 url_connect (Ptr{URLContext},) libavformat
@c Int32 url_open (Ptr{Ptr{URLContext}}, Ptr{Uint8}, Int32) libavformat
@c Int32 url_read (Ptr{URLContext}, Ptr{Uint8}, Int32) libavformat
@c Int32 url_read_complete (Ptr{URLContext}, Ptr{Uint8}, Int32) libavformat
@c Int32 url_write (Ptr{URLContext}, Ptr{Uint8}, Int32) libavformat
@c int64_t url_seek (Ptr{URLContext}, int64_t, Int32) libavformat
@c Int32 url_close (Ptr{URLContext},) libavformat
@c int64_t url_filesize (Ptr{URLContext},) libavformat
@c Int32 url_get_file_handle (Ptr{URLContext},) libavformat
@c Int32 url_get_max_packet_size (Ptr{URLContext},) libavformat
@c None url_get_filename (Ptr{URLContext}, Ptr{Uint8}, Int32) libavformat
@c Int32 av_url_read_pause (Ptr{URLContext}, Int32) libavformat
@c int64_t av_url_read_seek (Ptr{URLContext}, Int32, int64_t, Int32) libavformat
@c None url_set_interrupt_cb (Ptr{Void},) libavformat
@c Ptr{URLProtocol} av_protocol_next (Ptr{URLProtocol},) libavformat
@c Int32 av_register_protocol2 (Ptr{URLProtocol}, Int32) libavformat
@c Int32 init_put_byte (Ptr{AVIOContext}, Ptr{Uint8}, Int32, Int32, Ptr{None}, Ptr{Void}, Ptr{Void}, Ptr{Void}) libavformat
@c Ptr{AVIOContext} av_alloc_put_byte (Ptr{Uint8}, Int32, Int32, Ptr{None}, Ptr{Void}, Ptr{Void}, Ptr{Void}) libavformat
@c Int32 get_buffer (Ptr{AVIOContext}, Ptr{Uint8}, Int32) libavformat
@c Int32 get_partial_buffer (Ptr{AVIOContext}, Ptr{Uint8}, Int32) libavformat
@c Int32 get_byte (Ptr{AVIOContext},) libavformat
@c Uint32 get_le16 (Ptr{AVIOContext},) libavformat
@c Uint32 get_le24 (Ptr{AVIOContext},) libavformat
@c Uint32 get_le32 (Ptr{AVIOContext},) libavformat
@c uint64_t get_le64 (Ptr{AVIOContext},) libavformat
@c Uint32 get_be16 (Ptr{AVIOContext},) libavformat
@c Uint32 get_be24 (Ptr{AVIOContext},) libavformat
@c Uint32 get_be32 (Ptr{AVIOContext},) libavformat
@c uint64_t get_be64 (Ptr{AVIOContext},) libavformat
@c None put_byte (Ptr{AVIOContext}, Int32) libavformat
@c None put_nbyte (Ptr{AVIOContext}, Int32, Int32) libavformat
@c None put_buffer (Ptr{AVIOContext}, Ptr{Uint8}, Int32) libavformat
@c None put_le64 (Ptr{AVIOContext}, uint64_t) libavformat
@c None put_be64 (Ptr{AVIOContext}, uint64_t) libavformat
@c None put_le32 (Ptr{AVIOContext}, Uint32) libavformat
@c None put_be32 (Ptr{AVIOContext}, Uint32) libavformat
@c None put_le24 (Ptr{AVIOContext}, Uint32) libavformat
@c None put_be24 (Ptr{AVIOContext}, Uint32) libavformat
@c None put_le16 (Ptr{AVIOContext}, Uint32) libavformat
@c None put_be16 (Ptr{AVIOContext}, Uint32) libavformat
@c None put_tag (Ptr{AVIOContext}, Ptr{Uint8}) libavformat
@c Int32 av_url_read_fpause (Ptr{AVIOContext}, Int32) libavformat
@c int64_t av_url_read_fseek (Ptr{AVIOContext}, Int32, int64_t, Int32) libavformat
@c Int32 url_fopen (Ptr{Ptr{AVIOContext}}, Ptr{Uint8}, Int32) libavformat
@c Int32 url_fclose (Ptr{AVIOContext},) libavformat
@c int64_t url_fseek (Ptr{AVIOContext}, int64_t, Int32) libavformat
@c Int32 url_fskip (Ptr{AVIOContext}, int64_t) libavformat
@c int64_t url_ftell (Ptr{AVIOContext},) libavformat
@c int64_t url_fsize (Ptr{AVIOContext},) libavformat
@c Int32 url_fgetc (Ptr{AVIOContext},) libavformat
@c Int32 url_setbufsize (Ptr{AVIOContext}, Int32) libavformat
@c Int32 url_fprintf (Ptr{AVIOContext}, Ptr{Uint8}) libavformat
@c None put_flush_packet (Ptr{AVIOContext},) libavformat
@c Int32 url_open_dyn_buf (Ptr{Ptr{AVIOContext}},) libavformat
@c Int32 url_open_dyn_packet_buf (Ptr{Ptr{AVIOContext}}, Int32) libavformat
@c Int32 url_close_dyn_buf (Ptr{AVIOContext}, Ptr{Ptr{uint8_t}}) libavformat
@c Int32 url_fdopen (Ptr{Ptr{AVIOContext}}, Ptr{URLContext}) libavformat
@c Int32 url_feof (Ptr{AVIOContext},) libavformat
@c Int32 url_ferror (Ptr{AVIOContext},) libavformat
@c Int32 udp_set_remote_url (Ptr{URLContext}, Ptr{Uint8}) libavformat
@c Int32 udp_get_local_port (Ptr{URLContext},) libavformat
@c None init_checksum (Ptr{AVIOContext}, Ptr{Void}, Uint64) libavformat
@c Uint64 get_checksum (Ptr{AVIOContext},) libavformat
@c None put_strz (Ptr{AVIOContext}, Ptr{Uint8}) libavformat
@c Ptr{Uint8} url_fgets (Ptr{AVIOContext}, Ptr{Uint8}, Int32) libavformat
@c Ptr{Uint8} get_strz (Ptr{AVIOContext}, Ptr{Uint8}, Int32) libavformat
@c Int32 url_is_streamed (Ptr{AVIOContext},) libavformat
@c Ptr{URLContext} url_fileno (Ptr{AVIOContext},) libavformat
@c Int32 url_fget_max_packet_size (Ptr{AVIOContext},) libavformat
@c Int32 url_open_buf (Ptr{Ptr{AVIOContext}}, Ptr{uint8_t}, Int32, Int32) libavformat
@c Int32 url_close_buf (Ptr{AVIOContext},) libavformat
@c Int32 url_exist (Ptr{Uint8},) libavformat
@c Int32 avio_check (Ptr{Uint8}, Int32) libavformat
@c None avio_set_interrupt_cb (Ptr{Void},) libavformat
@c Ptr{AVIOContext} avio_alloc_context (Ptr{Uint8}, Int32, Int32, Ptr{None}, Ptr{Void}, Ptr{Void}, Ptr{Void}) libavformat
@c None avio_w8 (Ptr{AVIOContext}, Int32) libavformat
@c None avio_write (Ptr{AVIOContext}, Ptr{Uint8}, Int32) libavformat
@c None avio_wl64 (Ptr{AVIOContext}, uint64_t) libavformat
@c None avio_wb64 (Ptr{AVIOContext}, uint64_t) libavformat
@c None avio_wl32 (Ptr{AVIOContext}, Uint32) libavformat
@c None avio_wb32 (Ptr{AVIOContext}, Uint32) libavformat
@c None avio_wl24 (Ptr{AVIOContext}, Uint32) libavformat
@c None avio_wb24 (Ptr{AVIOContext}, Uint32) libavformat
@c None avio_wl16 (Ptr{AVIOContext}, Uint32) libavformat
@c None avio_wb16 (Ptr{AVIOContext}, Uint32) libavformat
@c Int32 avio_put_str (Ptr{AVIOContext}, Ptr{Uint8}) libavformat
@c Int32 avio_put_str16le (Ptr{AVIOContext}, Ptr{Uint8}) libavformat
@c int64_t avio_seek (Ptr{AVIOContext}, int64_t, Int32) libavformat
@c int64_t avio_skip (Ptr{AVIOContext}, int64_t) libavformat
@c int64_t avio_tell (Ptr{AVIOContext},) libavformat
@c int64_t avio_size (Ptr{AVIOContext},) libavformat
@c Int32 avio_printf (Ptr{AVIOContext}, Ptr{Uint8}) libavformat
@c None avio_flush (Ptr{AVIOContext},) libavformat
@c Int32 avio_read (Ptr{AVIOContext}, Ptr{Uint8}, Int32) libavformat
@c Int32 avio_r8 (Ptr{AVIOContext},) libavformat
@c Uint32 avio_rl16 (Ptr{AVIOContext},) libavformat
@c Uint32 avio_rl24 (Ptr{AVIOContext},) libavformat
@c Uint32 avio_rl32 (Ptr{AVIOContext},) libavformat
@c uint64_t avio_rl64 (Ptr{AVIOContext},) libavformat
@c Uint32 avio_rb16 (Ptr{AVIOContext},) libavformat
@c Uint32 avio_rb24 (Ptr{AVIOContext},) libavformat
@c Uint32 avio_rb32 (Ptr{AVIOContext},) libavformat
@c uint64_t avio_rb64 (Ptr{AVIOContext},) libavformat
@c Int32 avio_get_str (Ptr{AVIOContext}, Int32, Ptr{Uint8}, Int32) libavformat
@c Int32 avio_get_str16le (Ptr{AVIOContext}, Int32, Ptr{Uint8}, Int32) libavformat
@c Int32 avio_get_str16be (Ptr{AVIOContext}, Int32, Ptr{Uint8}, Int32) libavformat
@c Int32 avio_open (Ptr{Ptr{AVIOContext}}, Ptr{Uint8}, Int32) libavformat
@c Int32 avio_open2 (Ptr{Ptr{AVIOContext}}, Ptr{Uint8}, Int32, Ptr{AVIOInterruptCB}, Ptr{Ptr{AVDictionary}}) libavformat
@c Int32 avio_close (Ptr{AVIOContext},) libavformat
@c Int32 avio_open_dyn_buf (Ptr{Ptr{AVIOContext}},) libavformat
@c Int32 avio_close_dyn_buf (Ptr{AVIOContext}, Ptr{Ptr{uint8_t}}) libavformat
@c Ptr{Uint8} avio_enum_protocols (Ptr{Ptr{None}}, Int32) libavformat
@c Int32 avio_pause (Ptr{AVIOContext}, Int32) libavformat
@c int64_t avio_seek_time (Ptr{AVIOContext}, Int32, int64_t, Int32) libavformat
@c Ptr{AVDictionaryEntry} av_metadata_get (Ptr{AVDictionary}, Ptr{Uint8}, Ptr{AVDictionaryEntry}, Int32) libavformat
@c Int32 av_metadata_set2 (Ptr{Ptr{AVDictionary}}, Ptr{Uint8}, Ptr{Uint8}, Int32) libavformat
@c None av_metadata_conv (Ptr{Void}, Ptr{AVMetadataConv}, Ptr{AVMetadataConv}) libavformat
@c None av_metadata_copy (Ptr{Ptr{AVDictionary}}, Ptr{AVDictionary}, Int32) libavformat
@c None av_metadata_free (Ptr{Ptr{AVDictionary}},) libavformat
@c Int32 av_get_packet (Ptr{AVIOContext}, Ptr{AVPacket}, Int32) libavformat
@c Int32 av_append_packet (Ptr{AVIOContext}, Ptr{AVPacket}, Int32) libavformat
@c Uint32 avformat_version () libavformat
@c Ptr{Uint8} avformat_configuration () libavformat
@c Ptr{Uint8} avformat_license () libavformat
@c None av_register_all () libavformat
@c None av_register_input_format (Ptr{AVInputFormat},) libavformat
@c None av_register_output_format (Ptr{AVOutputFormat},) libavformat
@c Int32 avformat_network_init () libavformat
@c Int32 avformat_network_deinit () libavformat
@c Ptr{AVInputFormat} av_iformat_next (Ptr{AVInputFormat},) libavformat
@c Ptr{AVOutputFormat} av_oformat_next (Ptr{AVOutputFormat},) libavformat
@c Ptr{AVFormatContext} avformat_alloc_context () libavformat
@c None avformat_free_context (Ptr{AVFormatContext},) libavformat
@c Ptr{AVClass} avformat_get_class () libavformat
@c Ptr{AVStream} avformat_new_stream (Ptr{AVFormatContext}, Ptr{AVCodec}) libavformat
@c Ptr{AVProgram} av_new_program (Ptr{AVFormatContext}, Int32) libavformat
@c Int32 av_guess_image2_codec (Ptr{Uint8},) libavformat
@c None av_pkt_dump (Ptr{FILE}, Ptr{AVPacket}, Int32) libavformat
@c None av_pkt_dump_log (Ptr{None}, Int32, Ptr{AVPacket}, Int32) libavformat
@c Ptr{AVInputFormat} av_find_input_format (Ptr{Uint8},) libavformat
@c Ptr{AVInputFormat} av_probe_input_format (Ptr{AVProbeData}, Int32) libavformat
@c Ptr{AVInputFormat} av_probe_input_format2 (Ptr{AVProbeData}, Int32, Ptr{Int32}) libavformat
@c Int32 av_probe_input_buffer (Ptr{AVIOContext}, Ptr{Ptr{AVInputFormat}}, Ptr{Uint8}, Ptr{None}, Uint32, Uint32) libavformat
@c Int32 av_open_input_stream (Ptr{Ptr{AVFormatContext}}, Ptr{AVIOContext}, Ptr{Uint8}, Ptr{AVInputFormat}, Ptr{AVFormatParameters}) libavformat
@c Int32 av_open_input_file (Ptr{Ptr{AVFormatContext}}, Ptr{Uint8}, Ptr{AVInputFormat}, Int32, Ptr{AVFormatParameters}) libavformat
@c Int32 avformat_open_input (Ptr{Ptr{AVFormatContext}}, Ptr{Uint8}, Ptr{AVInputFormat}, Ptr{Ptr{AVDictionary}}) libavformat
@c Int32 av_find_stream_info (Ptr{AVFormatContext},) libavformat
@c Int32 avformat_find_stream_info (Ptr{AVFormatContext}, Ptr{Ptr{AVDictionary}}) libavformat
@c Int32 av_find_best_stream (Ptr{AVFormatContext}, Void, Int32, Int32, Ptr{Ptr{AVCodec}}, Int32) libavformat
@c Int32 av_read_packet (Ptr{AVFormatContext}, Ptr{AVPacket}) libavformat
@c Int32 av_read_frame (Ptr{AVFormatContext}, Ptr{AVPacket}) libavformat
@c Int32 av_seek_frame (Ptr{AVFormatContext}, Int32, int64_t, Int32) libavformat
@c Int32 avformat_seek_file (Ptr{AVFormatContext}, Int32, int64_t, int64_t, int64_t, Int32) libavformat
@c Int32 av_read_play (Ptr{AVFormatContext},) libavformat
@c Int32 av_read_pause (Ptr{AVFormatContext},) libavformat
@c None av_close_input_stream (Ptr{AVFormatContext},) libavformat
@c None av_close_input_file (Ptr{AVFormatContext},) libavformat
@c None avformat_close_input (Ptr{Ptr{AVFormatContext}},) libavformat
@c Ptr{AVStream} av_new_stream (Ptr{AVFormatContext}, Int32) libavformat
@c None av_set_pts_info (Ptr{AVStream}, Int32, Uint32, Uint32) libavformat
@c Int32 av_seek_frame_binary (Ptr{AVFormatContext}, Int32, int64_t, Int32) libavformat
@c None av_update_cur_dts (Ptr{AVFormatContext}, Ptr{AVStream}, int64_t) libavformat
@c int64_t av_gen_search (Ptr{AVFormatContext}, Int32, int64_t, int64_t, int64_t, int64_t, int64_t, int64_t, Int32, Ptr{int64_t}, Ptr{Void}) libavformat
@c Int32 av_set_parameters (Ptr{AVFormatContext}, Ptr{AVFormatParameters}) libavformat
@c Int32 avformat_write_header (Ptr{AVFormatContext}, Ptr{Ptr{AVDictionary}}) libavformat
@c Int32 av_write_header (Ptr{AVFormatContext},) libavformat
@c Int32 av_write_frame (Ptr{AVFormatContext}, Ptr{AVPacket}) libavformat
@c Int32 av_interleaved_write_frame (Ptr{AVFormatContext}, Ptr{AVPacket}) libavformat
@c Int32 av_interleave_packet_per_dts (Ptr{AVFormatContext}, Ptr{AVPacket}, Ptr{AVPacket}, Int32) libavformat
@c Int32 av_write_trailer (Ptr{AVFormatContext},) libavformat
@c Ptr{AVOutputFormat} av_guess_format (Ptr{Uint8}, Ptr{Uint8}, Ptr{Uint8}) libavformat
@c Int32 av_guess_codec (Ptr{AVOutputFormat}, Ptr{Uint8}, Ptr{Uint8}, Ptr{Uint8}, Void) libavformat
@c None av_hex_dump (Ptr{FILE}, Ptr{uint8_t}, Int32) libavformat
@c None av_hex_dump_log (Ptr{None}, Int32, Ptr{uint8_t}, Int32) libavformat
@c None av_pkt_dump2 (Ptr{FILE}, Ptr{AVPacket}, Int32, Ptr{AVStream}) libavformat
@c None av_pkt_dump_log2 (Ptr{None}, Int32, Ptr{AVPacket}, Int32, Ptr{AVStream}) libavformat
@c Int32 av_codec_get_id (Ptr{Ptr{Void}}, Uint32) libavformat
@c Uint32 av_codec_get_tag (Ptr{Ptr{Void}}, Void) libavformat
@c Int32 av_find_default_stream_index (Ptr{AVFormatContext},) libavformat
@c Int32 av_index_search_timestamp (Ptr{AVStream}, int64_t, Int32) libavformat
@c Int32 av_add_index_entry (Ptr{AVStream}, int64_t, int64_t, Int32, Int32, Int32) libavformat
@c None av_url_split (Ptr{Uint8}, Int32, Ptr{Uint8}, Int32, Ptr{Uint8}, Int32, Ptr{Int32}, Ptr{Uint8}, Int32, Ptr{Uint8}) libavformat
@c None dump_format (Ptr{AVFormatContext}, Int32, Ptr{Uint8}, Int32) libavformat
@c None av_dump_format (Ptr{AVFormatContext}, Int32, Ptr{Uint8}, Int32) libavformat
@c int64_t parse_date (Ptr{Uint8}, Int32) libavformat
@c int64_t av_gettime () libavformat
@c Int32 find_info_tag (Ptr{Uint8}, Int32, Ptr{Uint8}, Ptr{Uint8}) libavformat
@c Int32 av_get_frame_filename (Ptr{Uint8}, Int32, Ptr{Uint8}, Int32) libavformat
@c Int32 av_filename_number_test (Ptr{Uint8},) libavformat
@c Int32 av_sdp_create (Ptr{Ptr{AVFormatContext}}, Int32, Ptr{Uint8}, Int32) libavformat
@c Int32 avf_sdp_create (Ptr{Ptr{AVFormatContext}}, Int32, Ptr{Uint8}, Int32) libavformat
@c Int32 av_match_ext (Ptr{Uint8}, Ptr{Uint8}) libavformat
@c Int32 avformat_query_codec (Ptr{AVOutputFormat}, Void, Int32) libavformat
@c Ptr{Void} avformat_get_riff_video_tags () libavformat
@c Ptr{Void} avformat_get_riff_audio_tags () libavformat

