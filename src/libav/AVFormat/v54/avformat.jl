# Julia wrapper for header: /usr/include/libavformat/avformat.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


export
    av_get_packet,
    av_append_packet,
    #avformat_version,
    avformat_configuration,
    avformat_license,
    av_register_all,
    av_register_input_format,
    av_register_output_format,
    avformat_network_init,
    avformat_network_deinit,
    av_iformat_next,
    av_oformat_next,
    avformat_alloc_context,
    avformat_free_context,
    avformat_get_class,
    avformat_new_stream,
    av_new_program,
    av_find_input_format,
    av_probe_input_format,
    av_probe_input_format2,
    av_probe_input_buffer,
    avformat_open_input,
    avformat_find_stream_info,
    av_find_best_stream,
    av_read_packet,
    av_read_frame,
    av_seek_frame,
    avformat_seek_file,
    av_read_play,
    av_read_pause,
    av_close_input_file,
    avformat_close_input,
    avformat_write_header,
    av_write_frame,
    av_interleaved_write_frame,
    av_interleave_packet_per_dts,
    av_write_trailer,
    av_guess_format,
    av_guess_codec,
    av_hex_dump,
    av_hex_dump_log,
    av_pkt_dump2,
    av_pkt_dump_log2,
    av_codec_get_id,
    av_codec_get_tag,
    av_find_default_stream_index,
    av_index_search_timestamp,
    av_add_index_entry,
    av_url_split,
    av_dump_format,
    av_get_frame_filename,
    av_filename_number_test,
    av_sdp_create,
    av_match_ext,
    avformat_query_codec,
    avformat_get_riff_video_tags,
    avformat_get_riff_audio_tags


function av_get_packet(s,pkt,size::Integer)
    ccall((:av_get_packet,libavformat),Cint,(Ptr{AVIOContext},Ptr{AVPacket},Cint),s,pkt,size)
end

function av_append_packet(s,pkt,size::Integer)
    ccall((:av_append_packet,libavformat),Cint,(Ptr{AVIOContext},Ptr{AVPacket},Cint),s,pkt,size)
end

function avformat_version()
    ccall((:avformat_version,libavformat),UInt32,())
end

function avformat_configuration()
    ccall((:avformat_configuration,libavformat),Ptr{UInt8},())
end

function avformat_license()
    ccall((:avformat_license,libavformat),Ptr{UInt8},())
end

function av_register_all()
    ccall((:av_register_all,libavformat),Void,())
end

function av_register_input_format(format)
    ccall((:av_register_input_format,libavformat),Void,(Ptr{AVInputFormat},),format)
end

function av_register_output_format(format)
    ccall((:av_register_output_format,libavformat),Void,(Ptr{AVOutputFormat},),format)
end

function avformat_network_init()
    ccall((:avformat_network_init,libavformat),Cint,())
end

function avformat_network_deinit()
    ccall((:avformat_network_deinit,libavformat),Cint,())
end

function av_iformat_next(f)
    ccall((:av_iformat_next,libavformat),Ptr{AVInputFormat},(Ptr{AVInputFormat},),f)
end

function av_oformat_next(f)
    ccall((:av_oformat_next,libavformat),Ptr{AVOutputFormat},(Ptr{AVOutputFormat},),f)
end

function avformat_alloc_context()
    ccall((:avformat_alloc_context,libavformat),Ptr{AVFormatContext},())
end

function avformat_free_context(s)
    ccall((:avformat_free_context,libavformat),Void,(Ptr{AVFormatContext},),s)
end

function avformat_get_class()
    ccall((:avformat_get_class,libavformat),Ptr{AVClass},())
end

function avformat_new_stream(s,c)
    ccall((:avformat_new_stream,libavformat),Ptr{AVStream},(Ptr{AVFormatContext},Ptr{AVCodec}),s,c)
end

function av_new_program(s,id::Integer)
    ccall((:av_new_program,libavformat),Ptr{AVProgram},(Ptr{AVFormatContext},Cint),s,id)
end

function av_find_input_format(short_name)
    ccall((:av_find_input_format,libavformat),Ptr{AVInputFormat},(Ptr{UInt8},),short_name)
end

function av_probe_input_format(pd,is_opened::Integer)
    ccall((:av_probe_input_format,libavformat),Ptr{AVInputFormat},(Ptr{AVProbeData},Cint),pd,is_opened)
end

function av_probe_input_format2(pd,is_opened::Integer,score_max)
    ccall((:av_probe_input_format2,libavformat),Ptr{AVInputFormat},(Ptr{AVProbeData},Cint,Ptr{Cint}),pd,is_opened,score_max)
end

function av_probe_input_buffer(pb,fmt,filename,logctx,offset::Integer,max_probe_size::Integer)
    ccall((:av_probe_input_buffer,libavformat),Cint,(Ptr{AVIOContext},Ptr{Ptr{AVInputFormat}},Ptr{UInt8},Ptr{Void},UInt32,UInt32),pb,fmt,filename,logctx,offset,max_probe_size)
end

function avformat_open_input(ps,filename,fmt,options)
    ccall((:avformat_open_input,libavformat),Cint,(Ptr{Ptr{AVFormatContext}},Ptr{UInt8},Ptr{AVInputFormat},Ptr{Ptr{AVDictionary}}),ps,filename,fmt,options)
end

function avformat_find_stream_info(ic,options)
    ccall((:avformat_find_stream_info,libavformat),Cint,(Ptr{AVFormatContext},Ptr{Ptr{AVDictionary}}),ic,options)
end

function av_find_best_stream(ic,_type::AVMediaType,wanted_stream_nb::Integer,related_stream::Integer,decoder_ret,flags::Integer)
    ccall((:av_find_best_stream,libavformat),Cint,(Ptr{AVFormatContext},AVMediaType,Cint,Cint,Ptr{Ptr{AVCodec}},Cint),ic,_type,wanted_stream_nb,related_stream,decoder_ret,flags)
end

function av_read_packet(s,pkt)
    ccall((:av_read_packet,libavformat),Cint,(Ptr{AVFormatContext},Ptr{AVPacket}),s,pkt)
end

function av_read_frame(s,pkt)
    ccall((:av_read_frame,libavformat),Cint,(Ptr{AVFormatContext},Ptr{AVPacket}),s,pkt)
end

function av_seek_frame(s,stream_index::Integer,timestamp::Int64,flags::Integer)
    ccall((:av_seek_frame,libavformat),Cint,(Ptr{AVFormatContext},Cint,Int64,Cint),s,stream_index,timestamp,flags)
end

function avformat_seek_file(s,stream_index::Integer,min_ts::Int64,ts::Int64,max_ts::Int64,flags::Integer)
    ccall((:avformat_seek_file,libavformat),Cint,(Ptr{AVFormatContext},Cint,Int64,Int64,Int64,Cint),s,stream_index,min_ts,ts,max_ts,flags)
end

function av_read_play(s)
    ccall((:av_read_play,libavformat),Cint,(Ptr{AVFormatContext},),s)
end

function av_read_pause(s)
    ccall((:av_read_pause,libavformat),Cint,(Ptr{AVFormatContext},),s)
end

function av_close_input_file(s)
    ccall((:av_close_input_file,libavformat),Void,(Ptr{AVFormatContext},),s)
end

function avformat_close_input(s)
    ccall((:avformat_close_input,libavformat),Void,(Ptr{Ptr{AVFormatContext}},),s)
end

function avformat_write_header(s,options)
    ccall((:avformat_write_header,libavformat),Cint,(Ptr{AVFormatContext},Ptr{Ptr{AVDictionary}}),s,options)
end

function av_write_frame(s,pkt)
    ccall((:av_write_frame,libavformat),Cint,(Ptr{AVFormatContext},Ptr{AVPacket}),s,pkt)
end

function av_interleaved_write_frame(s,pkt)
    ccall((:av_interleaved_write_frame,libavformat),Cint,(Ptr{AVFormatContext},Ptr{AVPacket}),s,pkt)
end

function av_interleave_packet_per_dts(s,out,pkt,flush::Integer)
    ccall((:av_interleave_packet_per_dts,libavformat),Cint,(Ptr{AVFormatContext},Ptr{AVPacket},Ptr{AVPacket},Cint),s,out,pkt,flush)
end

function av_write_trailer(s)
    ccall((:av_write_trailer,libavformat),Cint,(Ptr{AVFormatContext},),s)
end

function av_guess_format(short_name,filename,mime_type)
    ccall((:av_guess_format,libavformat),Ptr{AVOutputFormat},(Ptr{UInt8},Ptr{UInt8},Ptr{UInt8}),short_name,filename,mime_type)
end

function av_guess_codec(fmt,short_name,filename,mime_type,_type::AVMediaType)
    ccall((:av_guess_codec,libavformat),Cint,(Ptr{AVOutputFormat},Ptr{UInt8},Ptr{UInt8},Ptr{UInt8},AVMediaType),fmt,short_name,filename,mime_type,_type)
end

function av_hex_dump(f,buf,size::Integer)
    ccall((:av_hex_dump,libavformat),Void,(Ptr{FILE},Ptr{UInt8},Cint),f,buf,size)
end

function av_hex_dump_log(avcl,level::Integer,buf,size::Integer)
    ccall((:av_hex_dump_log,libavformat),Void,(Ptr{Void},Cint,Ptr{UInt8},Cint),avcl,level,buf,size)
end

function av_pkt_dump2(f,pkt,dump_payload::Integer,st)
    ccall((:av_pkt_dump2,libavformat),Void,(Ptr{FILE},Ptr{AVPacket},Cint,Ptr{AVStream}),f,pkt,dump_payload,st)
end

function av_pkt_dump_log2(avcl,level::Integer,pkt,dump_payload::Integer,st)
    ccall((:av_pkt_dump_log2,libavformat),Void,(Ptr{Void},Cint,Ptr{AVPacket},Cint,Ptr{AVStream}),avcl,level,pkt,dump_payload,st)
end

function av_codec_get_id(tags,tag::Integer)
    ccall((:av_codec_get_id,libavformat),Cint,(Ptr{Ptr{AVCodecTag}},UInt32),tags,tag)
end

function av_codec_get_tag(tags,id::AVCodecID)
    ccall((:av_codec_get_tag,libavformat),UInt32,(Ptr{Ptr{AVCodecTag}},AVCodecID),tags,id)
end

function av_find_default_stream_index(s)
    ccall((:av_find_default_stream_index,libavformat),Cint,(Ptr{AVFormatContext},),s)
end

function av_index_search_timestamp(st,timestamp::Int64,flags::Integer)
    ccall((:av_index_search_timestamp,libavformat),Cint,(Ptr{AVStream},Int64,Cint),st,timestamp,flags)
end

function av_add_index_entry(st,pos::Int64,timestamp::Int64,size::Integer,distance::Integer,flags::Integer)
    ccall((:av_add_index_entry,libavformat),Cint,(Ptr{AVStream},Int64,Int64,Cint,Cint,Cint),st,pos,timestamp,size,distance,flags)
end

function av_url_split(proto,proto_size::Integer,authorization,authorization_size::Integer,hostname,hostname_size::Integer,port_ptr,path,path_size::Integer,url)
    ccall((:av_url_split,libavformat),Void,(Ptr{UInt8},Cint,Ptr{UInt8},Cint,Ptr{UInt8},Cint,Ptr{Cint},Ptr{UInt8},Cint,Ptr{UInt8}),proto,proto_size,authorization,authorization_size,hostname,hostname_size,port_ptr,path,path_size,url)
end

function av_dump_format(ic,index::Integer,url,is_output::Integer)
    ccall((:av_dump_format,libavformat),Void,(Ptr{AVFormatContext},Cint,Ptr{UInt8},Cint),ic,index,url,is_output)
end

function av_get_frame_filename(buf,buf_size::Integer,path,number::Integer)
    ccall((:av_get_frame_filename,libavformat),Cint,(Ptr{UInt8},Cint,Ptr{UInt8},Cint),buf,buf_size,path,number)
end

function av_filename_number_test(filename)
    ccall((:av_filename_number_test,libavformat),Cint,(Ptr{UInt8},),filename)
end

function av_sdp_create(ac,n_files::Integer,buf,size::Integer)
    ccall((:av_sdp_create,libavformat),Cint,(Ptr{Ptr{AVFormatContext}},Cint,Ptr{UInt8},Cint),ac,n_files,buf,size)
end

function av_match_ext(filename,extensions)
    ccall((:av_match_ext,libavformat),Cint,(Ptr{UInt8},Ptr{UInt8}),filename,extensions)
end

function avformat_query_codec(ofmt,codec_id::AVCodecID,std_compliance::Integer)
    ccall((:avformat_query_codec,libavformat),Cint,(Ptr{AVOutputFormat},AVCodecID,Cint),ofmt,codec_id,std_compliance)
end

function avformat_get_riff_video_tags()
    ccall((:avformat_get_riff_video_tags,libavformat),Ptr{AVCodecTag},())
end

function avformat_get_riff_audio_tags()
    ccall((:avformat_get_riff_audio_tags,libavformat),Ptr{AVCodecTag},())
end
