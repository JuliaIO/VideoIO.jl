# Julia wrapper for header: /usr/include/libavcodec/avcodec.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


export
    av_codec_next,
    #avcodec_version,
    avcodec_configuration,
    avcodec_license,
    avcodec_register,
    avcodec_register_all,
    avcodec_alloc_context3,
    avcodec_get_context_defaults3,
    avcodec_get_class,
    avcodec_copy_context,
    avcodec_alloc_frame,
    avcodec_get_frame_defaults,
    avcodec_free_frame,
    avcodec_open2,
    avcodec_close,
    avsubtitle_free,
    av_destruct_packet,
    av_init_packet,
    av_new_packet,
    av_shrink_packet,
    av_grow_packet,
    av_dup_packet,
    av_free_packet,
    av_packet_new_side_data,
    av_packet_shrink_side_data,
    av_packet_get_side_data,
    avcodec_find_decoder,
    avcodec_find_decoder_by_name,
    avcodec_default_get_buffer,
    avcodec_default_release_buffer,
    avcodec_default_reget_buffer,
    avcodec_get_edge_width,
    avcodec_align_dimensions,
    avcodec_align_dimensions2,
    avcodec_decode_audio3,
    avcodec_decode_audio4,
    avcodec_decode_video2,
    avcodec_decode_subtitle2,
    av_parser_next,
    av_register_codec_parser,
    av_parser_init,
    av_parser_parse2,
    av_parser_change,
    av_parser_close,
    avcodec_find_encoder,
    avcodec_find_encoder_by_name,
    avcodec_encode_audio,
    avcodec_encode_audio2,
    avcodec_encode_video,
    avcodec_encode_video2,
    avcodec_encode_subtitle,
    av_audio_resample_init,
    audio_resample,
    audio_resample_close,
    av_resample_init,
    av_resample,
    av_resample_compensate,
    av_resample_close,
    avpicture_alloc,
    avpicture_free,
    avpicture_fill,
    avpicture_layout,
    avpicture_get_size,
    avpicture_deinterlace,
    av_picture_copy,
    av_picture_crop,
    av_picture_pad,
    avcodec_get_chroma_sub_sample,
    avcodec_pix_fmt_to_codec_tag,
    avcodec_get_pix_fmt_loss,
    avcodec_find_best_pix_fmt,
    avcodec_find_best_pix_fmt2,
    avcodec_default_get_format,
    avcodec_set_dimensions,
    av_get_codec_tag_string,
    avcodec_string,
    av_get_profile_name,
    avcodec_default_execute,
    avcodec_default_execute2,
    avcodec_fill_audio_frame,
    avcodec_flush_buffers,
    avcodec_default_free_buffers,
    av_get_bits_per_sample,
    av_get_exact_bits_per_sample,
    av_get_audio_frame_duration,
    av_register_bitstream_filter,
    av_bitstream_filter_init,
    av_bitstream_filter_filter,
    av_bitstream_filter_close,
    av_bitstream_filter_next,
    av_fast_realloc,
    av_fast_malloc,
    av_fast_padded_malloc,
    av_xiphlacing,
    av_log_missing_feature,
    av_register_hwaccel,
    av_hwaccel_next,
    av_lockmgr_register,
    avcodec_get_type,
    avcodec_is_open,
    av_codec_is_encoder,
    av_codec_is_decoder,
    avcodec_descriptor_get,
    avcodec_descriptor_next,
    avcodec_descriptor_get_by_name


function av_codec_next(c)
    ccall((:av_codec_next,libavcodec),Ptr{AVCodec},(Ptr{AVCodec},),c)
end

function avcodec_version()
    ccall((:avcodec_version,libavcodec),UInt32,())
end

function avcodec_configuration()
    ccall((:avcodec_configuration,libavcodec),Ptr{UInt8},())
end

function avcodec_license()
    ccall((:avcodec_license,libavcodec),Ptr{UInt8},())
end

function avcodec_register(codec)
    ccall((:avcodec_register,libavcodec),Void,(Ptr{AVCodec},),codec)
end

function avcodec_register_all()
    ccall((:avcodec_register_all,libavcodec),Void,())
end

function avcodec_alloc_context3(codec)
    ccall((:avcodec_alloc_context3,libavcodec),Ptr{AVCodecContext},(Ptr{AVCodec},),codec)
end

function avcodec_get_context_defaults3(s,codec)
    ccall((:avcodec_get_context_defaults3,libavcodec),Cint,(Ptr{AVCodecContext},Ptr{AVCodec}),s,codec)
end

function avcodec_get_class()
    ccall((:avcodec_get_class,libavcodec),Ptr{AVClass},())
end

function avcodec_copy_context(dest,src)
    ccall((:avcodec_copy_context,libavcodec),Cint,(Ptr{AVCodecContext},Ptr{AVCodecContext}),dest,src)
end

function avcodec_alloc_frame()
    ccall((:avcodec_alloc_frame,libavcodec),Ptr{AVFrame},())
end

function avcodec_get_frame_defaults(frame)
    ccall((:avcodec_get_frame_defaults,libavcodec),Void,(Ptr{AVFrame},),frame)
end

function avcodec_free_frame(frame)
    ccall((:avcodec_free_frame,libavcodec),Void,(Ptr{Ptr{AVFrame}},),frame)
end

function avcodec_open2(avctx,codec,options)
    ccall((:avcodec_open2,libavcodec),Cint,(Ptr{AVCodecContext},Ptr{AVCodec},Ptr{Ptr{AVDictionary}}),avctx,codec,options)
end

function avcodec_close(avctx)
    ccall((:avcodec_close,libavcodec),Cint,(Ptr{AVCodecContext},),avctx)
end

function avsubtitle_free(sub)
    ccall((:avsubtitle_free,libavcodec),Void,(Ptr{AVSubtitle},),sub)
end

function av_destruct_packet(pkt)
    ccall((:av_destruct_packet,libavcodec),Void,(Ptr{AVPacket},),pkt)
end

function av_init_packet(pkt)
    ccall((:av_init_packet,libavcodec),Void,(Ptr{AVPacket},),pkt)
end

function av_new_packet(pkt,size::Integer)
    ccall((:av_new_packet,libavcodec),Cint,(Ptr{AVPacket},Cint),pkt,size)
end

function av_shrink_packet(pkt,size::Integer)
    ccall((:av_shrink_packet,libavcodec),Void,(Ptr{AVPacket},Cint),pkt,size)
end

function av_grow_packet(pkt,grow_by::Integer)
    ccall((:av_grow_packet,libavcodec),Cint,(Ptr{AVPacket},Cint),pkt,grow_by)
end

function av_dup_packet(pkt)
    ccall((:av_dup_packet,libavcodec),Cint,(Ptr{AVPacket},),pkt)
end

function av_free_packet(pkt)
    ccall((:av_free_packet,libavcodec),Void,(Ptr{AVPacket},),pkt)
end

function av_packet_new_side_data(pkt,_type::AVPacketSideDataType,size::Integer)
    ccall((:av_packet_new_side_data,libavcodec),Ptr{UInt8},(Ptr{AVPacket},AVPacketSideDataType,Cint),pkt,_type,size)
end

function av_packet_shrink_side_data(pkt,_type::AVPacketSideDataType,size::Integer)
    ccall((:av_packet_shrink_side_data,libavcodec),Cint,(Ptr{AVPacket},AVPacketSideDataType,Cint),pkt,_type,size)
end

function av_packet_get_side_data(pkt,_type::AVPacketSideDataType,size)
    ccall((:av_packet_get_side_data,libavcodec),Ptr{UInt8},(Ptr{AVPacket},AVPacketSideDataType,Ptr{Cint}),pkt,_type,size)
end

function avcodec_find_decoder(id::AVCodecID)
    ccall((:avcodec_find_decoder,libavcodec),Ptr{AVCodec},(AVCodecID,),id)
end

function avcodec_find_decoder_by_name(name)
    ccall((:avcodec_find_decoder_by_name,libavcodec),Ptr{AVCodec},(Ptr{UInt8},),name)
end

function avcodec_default_get_buffer(s,pic)
    ccall((:avcodec_default_get_buffer,libavcodec),Cint,(Ptr{AVCodecContext},Ptr{AVFrame}),s,pic)
end

function avcodec_default_release_buffer(s,pic)
    ccall((:avcodec_default_release_buffer,libavcodec),Void,(Ptr{AVCodecContext},Ptr{AVFrame}),s,pic)
end

function avcodec_default_reget_buffer(s,pic)
    ccall((:avcodec_default_reget_buffer,libavcodec),Cint,(Ptr{AVCodecContext},Ptr{AVFrame}),s,pic)
end

function avcodec_get_edge_width()
    ccall((:avcodec_get_edge_width,libavcodec),UInt32,())
end

function avcodec_align_dimensions(s,width,height)
    ccall((:avcodec_align_dimensions,libavcodec),Void,(Ptr{AVCodecContext},Ptr{Cint},Ptr{Cint}),s,width,height)
end

function avcodec_align_dimensions2(s,width,height,linesize_align)
    ccall((:avcodec_align_dimensions2,libavcodec),Void,(Ptr{AVCodecContext},Ptr{Cint},Ptr{Cint},Ptr{Cint}),s,width,height,linesize_align)
end

function avcodec_decode_audio3(avctx,samples,frame_size_ptr,avpkt)
    ccall((:avcodec_decode_audio3,libavcodec),Cint,(Ptr{AVCodecContext},Ptr{Int16},Ptr{Cint},Ptr{AVPacket}),avctx,samples,frame_size_ptr,avpkt)
end

function avcodec_decode_audio4(avctx,frame,got_frame_ptr,avpkt)
    ccall((:avcodec_decode_audio4,libavcodec),Cint,(Ptr{AVCodecContext},Ptr{AVFrame},Ptr{Cint},Ptr{AVPacket}),avctx,frame,got_frame_ptr,avpkt)
end

function avcodec_decode_video2(avctx,picture,got_picture_ptr,avpkt)
    ccall((:avcodec_decode_video2,libavcodec),Cint,(Ptr{AVCodecContext},Ptr{AVFrame},Ptr{Cint},Ptr{AVPacket}),avctx,picture,got_picture_ptr,avpkt)
end

function avcodec_decode_subtitle2(avctx,sub,got_sub_ptr,avpkt)
    ccall((:avcodec_decode_subtitle2,libavcodec),Cint,(Ptr{AVCodecContext},Ptr{AVSubtitle},Ptr{Cint},Ptr{AVPacket}),avctx,sub,got_sub_ptr,avpkt)
end

function av_parser_next(c)
    ccall((:av_parser_next,libavcodec),Ptr{AVCodecParser},(Ptr{AVCodecParser},),c)
end

function av_register_codec_parser(parser)
    ccall((:av_register_codec_parser,libavcodec),Void,(Ptr{AVCodecParser},),parser)
end

function av_parser_init(codec_id::Integer)
    ccall((:av_parser_init,libavcodec),Ptr{AVCodecParserContext},(Cint,),codec_id)
end

function av_parser_parse2(s,avctx,poutbuf,poutbuf_size,buf,buf_size::Integer,pts::Int64,dts::Int64,pos::Int64)
    ccall((:av_parser_parse2,libavcodec),Cint,(Ptr{AVCodecParserContext},Ptr{AVCodecContext},Ptr{Ptr{UInt8}},Ptr{Cint},Ptr{UInt8},Cint,Int64,Int64,Int64),s,avctx,poutbuf,poutbuf_size,buf,buf_size,pts,dts,pos)
end

function av_parser_change(s,avctx,poutbuf,poutbuf_size,buf,buf_size::Integer,keyframe::Integer)
    ccall((:av_parser_change,libavcodec),Cint,(Ptr{AVCodecParserContext},Ptr{AVCodecContext},Ptr{Ptr{UInt8}},Ptr{Cint},Ptr{UInt8},Cint,Cint),s,avctx,poutbuf,poutbuf_size,buf,buf_size,keyframe)
end

function av_parser_close(s)
    ccall((:av_parser_close,libavcodec),Void,(Ptr{AVCodecParserContext},),s)
end

function avcodec_find_encoder(id::AVCodecID)
    ccall((:avcodec_find_encoder,libavcodec),Ptr{AVCodec},(AVCodecID,),id)
end

function avcodec_find_encoder_by_name(name)
    ccall((:avcodec_find_encoder_by_name,libavcodec),Ptr{AVCodec},(Ptr{UInt8},),name)
end

function avcodec_encode_audio(avctx,buf,buf_size::Integer,samples)
    ccall((:avcodec_encode_audio,libavcodec),Cint,(Ptr{AVCodecContext},Ptr{UInt8},Cint,Ptr{Int16}),avctx,buf,buf_size,samples)
end

function avcodec_encode_audio2(avctx,avpkt,frame,got_packet_ptr)
    ccall((:avcodec_encode_audio2,libavcodec),Cint,(Ptr{AVCodecContext},Ptr{AVPacket},Ptr{AVFrame},Ptr{Cint}),avctx,avpkt,frame,got_packet_ptr)
end

function avcodec_encode_video(avctx,buf,buf_size::Integer,pict)
    ccall((:avcodec_encode_video,libavcodec),Cint,(Ptr{AVCodecContext},Ptr{UInt8},Cint,Ptr{AVFrame}),avctx,buf,buf_size,pict)
end

function avcodec_encode_video2(avctx,avpkt,frame,got_packet_ptr)
    ccall((:avcodec_encode_video2,libavcodec),Cint,(Ptr{AVCodecContext},Ptr{AVPacket},Ptr{AVFrame},Ptr{Cint}),avctx,avpkt,frame,got_packet_ptr)
end

function avcodec_encode_subtitle(avctx,buf,buf_size::Integer,sub)
    ccall((:avcodec_encode_subtitle,libavcodec),Cint,(Ptr{AVCodecContext},Ptr{UInt8},Cint,Ptr{AVSubtitle}),avctx,buf,buf_size,sub)
end

function av_audio_resample_init(output_channels::Integer,input_channels::Integer,output_rate::Integer,input_rate::Integer,sample_fmt_out::AVSampleFormat,sample_fmt_in::AVSampleFormat,filter_length::Integer,log2_phase_count::Integer,linear::Integer,cutoff::Cdouble)
    ccall((:av_audio_resample_init,libavcodec),Ptr{ReSampleContext},(Cint,Cint,Cint,Cint,AVSampleFormat,AVSampleFormat,Cint,Cint,Cint,Cdouble),output_channels,input_channels,output_rate,input_rate,sample_fmt_out,sample_fmt_in,filter_length,log2_phase_count,linear,cutoff)
end

function audio_resample(s,output,input,nb_samples::Integer)
    ccall((:audio_resample,libavcodec),Cint,(Ptr{ReSampleContext},Ptr{Int16},Ptr{Int16},Cint),s,output,input,nb_samples)
end

function audio_resample_close(s)
    ccall((:audio_resample_close,libavcodec),Void,(Ptr{ReSampleContext},),s)
end

function av_resample_init(out_rate::Integer,in_rate::Integer,filter_length::Integer,log2_phase_count::Integer,linear::Integer,cutoff::Cdouble)
    ccall((:av_resample_init,libavcodec),Ptr{AVResampleContext},(Cint,Cint,Cint,Cint,Cint,Cdouble),out_rate,in_rate,filter_length,log2_phase_count,linear,cutoff)
end

function av_resample(c,dst,src,consumed,src_size::Integer,dst_size::Integer,update_ctx::Integer)
    ccall((:av_resample,libavcodec),Cint,(Ptr{AVResampleContext},Ptr{Int16},Ptr{Int16},Ptr{Cint},Cint,Cint,Cint),c,dst,src,consumed,src_size,dst_size,update_ctx)
end

function av_resample_compensate(c,sample_delta::Integer,compensation_distance::Integer)
    ccall((:av_resample_compensate,libavcodec),Void,(Ptr{AVResampleContext},Cint,Cint),c,sample_delta,compensation_distance)
end

function av_resample_close(c)
    ccall((:av_resample_close,libavcodec),Void,(Ptr{AVResampleContext},),c)
end

function avpicture_alloc(picture,pix_fmt::AVPixelFormat,width::Integer,height::Integer)
    ccall((:avpicture_alloc,libavcodec),Cint,(Ptr{AVPicture},AVPixelFormat,Cint,Cint),picture,pix_fmt,width,height)
end

function avpicture_free(picture)
    ccall((:avpicture_free,libavcodec),Void,(Ptr{AVPicture},),picture)
end

function avpicture_fill(picture,ptr,pix_fmt::AVPixelFormat,width::Integer,height::Integer)
    ccall((:avpicture_fill,libavcodec),Cint,(Ptr{AVPicture},Ptr{UInt8},AVPixelFormat,Cint,Cint),picture,ptr,pix_fmt,width,height)
end

function avpicture_layout(src,pix_fmt::AVPixelFormat,width::Integer,height::Integer,dest,dest_size::Integer)
    ccall((:avpicture_layout,libavcodec),Cint,(Ptr{AVPicture},AVPixelFormat,Cint,Cint,Ptr{Cuchar},Cint),src,pix_fmt,width,height,dest,dest_size)
end

function avpicture_get_size(pix_fmt::AVPixelFormat,width::Integer,height::Integer)
    ccall((:avpicture_get_size,libavcodec),Cint,(AVPixelFormat,Cint,Cint),pix_fmt,width,height)
end

function avpicture_deinterlace(dst,src,pix_fmt::AVPixelFormat,width::Integer,height::Integer)
    ccall((:avpicture_deinterlace,libavcodec),Cint,(Ptr{AVPicture},Ptr{AVPicture},AVPixelFormat,Cint,Cint),dst,src,pix_fmt,width,height)
end

function av_picture_copy(dst,src,pix_fmt::AVPixelFormat,width::Integer,height::Integer)
    ccall((:av_picture_copy,libavcodec),Void,(Ptr{AVPicture},Ptr{AVPicture},AVPixelFormat,Cint,Cint),dst,src,pix_fmt,width,height)
end

function av_picture_crop(dst,src,pix_fmt::AVPixelFormat,top_band::Integer,left_band::Integer)
    ccall((:av_picture_crop,libavcodec),Cint,(Ptr{AVPicture},Ptr{AVPicture},AVPixelFormat,Cint,Cint),dst,src,pix_fmt,top_band,left_band)
end

function av_picture_pad(dst,src,height::Integer,width::Integer,pix_fmt::AVPixelFormat,padtop::Integer,padbottom::Integer,padleft::Integer,padright::Integer,color)
    ccall((:av_picture_pad,libavcodec),Cint,(Ptr{AVPicture},Ptr{AVPicture},Cint,Cint,AVPixelFormat,Cint,Cint,Cint,Cint,Ptr{Cint}),dst,src,height,width,pix_fmt,padtop,padbottom,padleft,padright,color)
end

function avcodec_get_chroma_sub_sample(pix_fmt::AVPixelFormat,h_shift,v_shift)
    ccall((:avcodec_get_chroma_sub_sample,libavcodec),Void,(AVPixelFormat,Ptr{Cint},Ptr{Cint}),pix_fmt,h_shift,v_shift)
end

function avcodec_pix_fmt_to_codec_tag(pix_fmt::AVPixelFormat)
    ccall((:avcodec_pix_fmt_to_codec_tag,libavcodec),UInt32,(AVPixelFormat,),pix_fmt)
end

function avcodec_get_pix_fmt_loss(dst_pix_fmt::AVPixelFormat,src_pix_fmt::AVPixelFormat,has_alpha::Integer)
    ccall((:avcodec_get_pix_fmt_loss,libavcodec),Cint,(AVPixelFormat,AVPixelFormat,Cint),dst_pix_fmt,src_pix_fmt,has_alpha)
end

function avcodec_find_best_pix_fmt(pix_fmt_mask::Int64,src_pix_fmt::AVPixelFormat,has_alpha::Integer,loss_ptr)
    ccall((:avcodec_find_best_pix_fmt,libavcodec),Cint,(Int64,AVPixelFormat,Cint,Ptr{Cint}),pix_fmt_mask,src_pix_fmt,has_alpha,loss_ptr)
end

function avcodec_find_best_pix_fmt2(pix_fmt_list,src_pix_fmt::AVPixelFormat,has_alpha::Integer,loss_ptr)
    ccall((:avcodec_find_best_pix_fmt2,libavcodec),Cint,(Ptr{AVPixelFormat},AVPixelFormat,Cint,Ptr{Cint}),pix_fmt_list,src_pix_fmt,has_alpha,loss_ptr)
end

function avcodec_default_get_format(s,fmt)
    ccall((:avcodec_default_get_format,libavcodec),Cint,(Ptr{AVCodecContext},Ptr{AVPixelFormat}),s,fmt)
end

function avcodec_set_dimensions(s,width::Integer,height::Integer)
    ccall((:avcodec_set_dimensions,libavcodec),Void,(Ptr{AVCodecContext},Cint,Cint),s,width,height)
end

function av_get_codec_tag_string(buf,buf_size::Csize_t,codec_tag::Integer)
    ccall((:av_get_codec_tag_string,libavcodec),Csize_t,(Ptr{UInt8},Csize_t,UInt32),buf,buf_size,codec_tag)
end

function avcodec_string(buf,buf_size::Integer,enc,encode::Integer)
    ccall((:avcodec_string,libavcodec),Void,(Ptr{UInt8},Cint,Ptr{AVCodecContext},Cint),buf,buf_size,enc,encode)
end

function av_get_profile_name(codec,profile::Integer)
    ccall((:av_get_profile_name,libavcodec),Ptr{UInt8},(Ptr{AVCodec},Cint),codec,profile)
end

function avcodec_default_execute(c,func,arg,ret,count::Integer,size::Integer)
    ccall((:avcodec_default_execute,libavcodec),Cint,(Ptr{AVCodecContext},Ptr{Void},Ptr{Void},Ptr{Cint},Cint,Cint),c,func,arg,ret,count,size)
end

function avcodec_default_execute2(c,func,arg,ret,count::Integer)
    ccall((:avcodec_default_execute2,libavcodec),Cint,(Ptr{AVCodecContext},Ptr{Void},Ptr{Void},Ptr{Cint},Cint),c,func,arg,ret,count)
end

function avcodec_fill_audio_frame(frame,nb_channels::Integer,sample_fmt::AVSampleFormat,buf,buf_size::Integer,align::Integer)
    ccall((:avcodec_fill_audio_frame,libavcodec),Cint,(Ptr{AVFrame},Cint,AVSampleFormat,Ptr{UInt8},Cint,Cint),frame,nb_channels,sample_fmt,buf,buf_size,align)
end

function avcodec_flush_buffers(avctx)
    ccall((:avcodec_flush_buffers,libavcodec),Void,(Ptr{AVCodecContext},),avctx)
end

function avcodec_default_free_buffers(s)
    ccall((:avcodec_default_free_buffers,libavcodec),Void,(Ptr{AVCodecContext},),s)
end

function av_get_bits_per_sample(codec_id::AVCodecID)
    ccall((:av_get_bits_per_sample,libavcodec),Cint,(AVCodecID,),codec_id)
end

function av_get_exact_bits_per_sample(codec_id::AVCodecID)
    ccall((:av_get_exact_bits_per_sample,libavcodec),Cint,(AVCodecID,),codec_id)
end

function av_get_audio_frame_duration(avctx,frame_bytes::Integer)
    ccall((:av_get_audio_frame_duration,libavcodec),Cint,(Ptr{AVCodecContext},Cint),avctx,frame_bytes)
end

function av_register_bitstream_filter(bsf)
    ccall((:av_register_bitstream_filter,libavcodec),Void,(Ptr{AVBitStreamFilter},),bsf)
end

function av_bitstream_filter_init(name)
    ccall((:av_bitstream_filter_init,libavcodec),Ptr{AVBitStreamFilterContext},(Ptr{UInt8},),name)
end

function av_bitstream_filter_filter(bsfc,avctx,args,poutbuf,poutbuf_size,buf,buf_size::Integer,keyframe::Integer)
    ccall((:av_bitstream_filter_filter,libavcodec),Cint,(Ptr{AVBitStreamFilterContext},Ptr{AVCodecContext},Ptr{UInt8},Ptr{Ptr{UInt8}},Ptr{Cint},Ptr{UInt8},Cint,Cint),bsfc,avctx,args,poutbuf,poutbuf_size,buf,buf_size,keyframe)
end

function av_bitstream_filter_close(bsf)
    ccall((:av_bitstream_filter_close,libavcodec),Void,(Ptr{AVBitStreamFilterContext},),bsf)
end

function av_bitstream_filter_next(f)
    ccall((:av_bitstream_filter_next,libavcodec),Ptr{AVBitStreamFilter},(Ptr{AVBitStreamFilter},),f)
end

function av_fast_realloc(ptr,size,min_size::Csize_t)
    ccall((:av_fast_realloc,libavcodec),Ptr{Void},(Ptr{Void},Ptr{UInt32},Csize_t),ptr,size,min_size)
end

function av_fast_malloc(ptr,size,min_size::Csize_t)
    ccall((:av_fast_malloc,libavcodec),Void,(Ptr{Void},Ptr{UInt32},Csize_t),ptr,size,min_size)
end

function av_fast_padded_malloc(ptr,size,min_size::Csize_t)
    ccall((:av_fast_padded_malloc,libavcodec),Void,(Ptr{Void},Ptr{UInt32},Csize_t),ptr,size,min_size)
end

function av_xiphlacing(s,v::Integer)
    ccall((:av_xiphlacing,libavcodec),UInt32,(Ptr{Cuchar},UInt32),s,v)
end

function av_log_missing_feature(avc,feature,want_sample::Integer)
    ccall((:av_log_missing_feature,libavcodec),Void,(Ptr{Void},Ptr{UInt8},Cint),avc,feature,want_sample)
end

function av_register_hwaccel(hwaccel)
    ccall((:av_register_hwaccel,libavcodec),Void,(Ptr{AVHWAccel},),hwaccel)
end

function av_hwaccel_next(hwaccel)
    ccall((:av_hwaccel_next,libavcodec),Ptr{AVHWAccel},(Ptr{AVHWAccel},),hwaccel)
end

function av_lockmgr_register(cb)
    ccall((:av_lockmgr_register,libavcodec),Cint,(Ptr{Void},),cb)
end

function avcodec_get_type(codec_id::AVCodecID)
    ccall((:avcodec_get_type,libavcodec),Cint,(AVCodecID,),codec_id)
end

function avcodec_is_open(s)
    ccall((:avcodec_is_open,libavcodec),Cint,(Ptr{AVCodecContext},),s)
end

function av_codec_is_encoder(codec)
    ccall((:av_codec_is_encoder,libavcodec),Cint,(Ptr{AVCodec},),codec)
end

function av_codec_is_decoder(codec)
    ccall((:av_codec_is_decoder,libavcodec),Cint,(Ptr{AVCodec},),codec)
end

function avcodec_descriptor_get(id::AVCodecID)
    ccall((:avcodec_descriptor_get,libavcodec),Ptr{AVCodecDescriptor},(AVCodecID,),id)
end

function avcodec_descriptor_next(prev)
    ccall((:avcodec_descriptor_next,libavcodec),Ptr{AVCodecDescriptor},(Ptr{AVCodecDescriptor},),prev)
end

function avcodec_descriptor_get_by_name(name)
    ccall((:avcodec_descriptor_get_by_name,libavcodec),Ptr{AVCodecDescriptor},(Ptr{UInt8},),name)
end
