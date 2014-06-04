# Julia wrapper for header: /usr/include/libavcodec/avcodec.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


function av_destruct_packet_nofree(_pkt::Ptr)
    pkt = convert(Ptr{AVPacket},_pkt)
    ccall((:av_destruct_packet_nofree,libavcodec),Void,(Ptr{AVPacket},),pkt)
end
function av_destruct_packet(_pkt::Ptr)
    pkt = convert(Ptr{AVPacket},_pkt)
    ccall((:av_destruct_packet,libavcodec),Void,(Ptr{AVPacket},),pkt)
end
function av_init_packet(_pkt::Ptr)
    pkt = convert(Ptr{AVPacket},_pkt)
    ccall((:av_init_packet,libavcodec),Void,(Ptr{AVPacket},),pkt)
end
function av_new_packet(_pkt::Ptr,_size::Integer)
    pkt = convert(Ptr{AVPacket},_pkt)
    size = int32(_size)
    ccall((:av_new_packet,libavcodec),Cint,(Ptr{AVPacket},Cint),pkt,size)
end
function av_shrink_packet(_pkt::Ptr,_size::Integer)
    pkt = convert(Ptr{AVPacket},_pkt)
    size = int32(_size)
    ccall((:av_shrink_packet,libavcodec),Void,(Ptr{AVPacket},Cint),pkt,size)
end
function av_grow_packet(_pkt::Ptr,_grow_by::Integer)
    pkt = convert(Ptr{AVPacket},_pkt)
    grow_by = int32(_grow_by)
    ccall((:av_grow_packet,libavcodec),Cint,(Ptr{AVPacket},Cint),pkt,grow_by)
end
function av_dup_packet(_pkt::Ptr)
    pkt = convert(Ptr{AVPacket},_pkt)
    ccall((:av_dup_packet,libavcodec),Cint,(Ptr{AVPacket},),pkt)
end
function av_free_packet(_pkt::Ptr)
    pkt = convert(Ptr{AVPacket},_pkt)
    ccall((:av_free_packet,libavcodec),Void,(Ptr{AVPacket},),pkt)
end
function av_packet_new_side_data(_pkt::Ptr,_type::AVPacketSideDataType,_size::Integer)
    pkt = convert(Ptr{AVPacket},_pkt)
    size = int32(_size)
    ccall((:av_packet_new_side_data,libavcodec),Ptr{Uint8},(Ptr{AVPacket},AVPacketSideDataType,Cint),pkt,_type,size)
end
function av_packet_get_side_data(_pkt::Ptr,_type::AVPacketSideDataType,_size::Ptr)
    pkt = convert(Ptr{AVPacket},_pkt)
    size = convert(Ptr{Cint},_size)
    ccall((:av_packet_get_side_data,libavcodec),Ptr{Uint8},(Ptr{AVPacket},AVPacketSideDataType,Ptr{Cint}),pkt,_type,size)
end
function av_audio_resample_init(_output_channels::Integer,_input_channels::Integer,_output_rate::Integer,_input_rate::Integer,sample_fmt_out::AVSampleFormat,sample_fmt_in::AVSampleFormat,_filter_length::Integer,_log2_phase_count::Integer,_linear::Integer,cutoff::Cdouble)
    output_channels = int32(_output_channels)
    input_channels = int32(_input_channels)
    output_rate = int32(_output_rate)
    input_rate = int32(_input_rate)
    filter_length = int32(_filter_length)
    log2_phase_count = int32(_log2_phase_count)
    linear = int32(_linear)
    ccall((:av_audio_resample_init,libavcodec),Ptr{ReSampleContext},(Cint,Cint,Cint,Cint,AVSampleFormat,AVSampleFormat,Cint,Cint,Cint,Cdouble),output_channels,input_channels,output_rate,input_rate,sample_fmt_out,sample_fmt_in,filter_length,log2_phase_count,linear,cutoff)
end
function audio_resample(_s::Ptr,_output::Ptr,_input::Ptr,_nb_samples::Integer)
    s = convert(Ptr{ReSampleContext},_s)
    output = convert(Ptr{Int16},_output)
    input = convert(Ptr{Int16},_input)
    nb_samples = int32(_nb_samples)
    ccall((:audio_resample,libavcodec),Cint,(Ptr{ReSampleContext},Ptr{Int16},Ptr{Int16},Cint),s,output,input,nb_samples)
end
function audio_resample_close(_s::Ptr)
    s = convert(Ptr{ReSampleContext},_s)
    ccall((:audio_resample_close,libavcodec),Void,(Ptr{ReSampleContext},),s)
end
function av_resample_init(_out_rate::Integer,_in_rate::Integer,_filter_length::Integer,_log2_phase_count::Integer,_linear::Integer,cutoff::Cdouble)
    out_rate = int32(_out_rate)
    in_rate = int32(_in_rate)
    filter_length = int32(_filter_length)
    log2_phase_count = int32(_log2_phase_count)
    linear = int32(_linear)
    ccall((:av_resample_init,libavcodec),Ptr{AVResampleContext},(Cint,Cint,Cint,Cint,Cint,Cdouble),out_rate,in_rate,filter_length,log2_phase_count,linear,cutoff)
end
function av_resample(_c::Ptr,_dst::Ptr,_src::Ptr,_consumed::Ptr,_src_size::Integer,_dst_size::Integer,_update_ctx::Integer)
    c = convert(Ptr{AVResampleContext},_c)
    dst = convert(Ptr{Int16},_dst)
    src = convert(Ptr{Int16},_src)
    consumed = convert(Ptr{Cint},_consumed)
    src_size = int32(_src_size)
    dst_size = int32(_dst_size)
    update_ctx = int32(_update_ctx)
    ccall((:av_resample,libavcodec),Cint,(Ptr{AVResampleContext},Ptr{Int16},Ptr{Int16},Ptr{Cint},Cint,Cint,Cint),c,dst,src,consumed,src_size,dst_size,update_ctx)
end
function av_resample_compensate(_c::Ptr,_sample_delta::Integer,_compensation_distance::Integer)
    c = convert(Ptr{AVResampleContext},_c)
    sample_delta = int32(_sample_delta)
    compensation_distance = int32(_compensation_distance)
    ccall((:av_resample_compensate,libavcodec),Void,(Ptr{AVResampleContext},Cint,Cint),c,sample_delta,compensation_distance)
end
function av_resample_close(_c::Ptr)
    c = convert(Ptr{AVResampleContext},_c)
    ccall((:av_resample_close,libavcodec),Void,(Ptr{AVResampleContext},),c)
end
function avpicture_alloc(_picture::Ptr,pix_fmt::PixelFormat,_width::Integer,_height::Integer)
    picture = convert(Ptr{AVPicture},_picture)
    width = int32(_width)
    height = int32(_height)
    ccall((:avpicture_alloc,libavcodec),Cint,(Ptr{AVPicture},PixelFormat,Cint,Cint),picture,pix_fmt,width,height)
end
function avpicture_free(_picture::Ptr)
    picture = convert(Ptr{AVPicture},_picture)
    ccall((:avpicture_free,libavcodec),Void,(Ptr{AVPicture},),picture)
end
function avpicture_fill(_picture::Ptr,_ptr::Union(Ptr,ByteString),pix_fmt::PixelFormat,_width::Integer,_height::Integer)
    picture = convert(Ptr{AVPicture},_picture)
    ptr = convert(Ptr{Uint8},_ptr)
    width = int32(_width)
    height = int32(_height)
    ccall((:avpicture_fill,libavcodec),Cint,(Ptr{AVPicture},Ptr{Uint8},PixelFormat,Cint,Cint),picture,ptr,pix_fmt,width,height)
end
function avpicture_layout(_src::Ptr,pix_fmt::PixelFormat,_width::Integer,_height::Integer,_dest::Ptr,_dest_size::Integer)
    src = convert(Ptr{AVPicture},_src)
    width = int32(_width)
    height = int32(_height)
    dest = convert(Ptr{Cuchar},_dest)
    dest_size = int32(_dest_size)
    ccall((:avpicture_layout,libavcodec),Cint,(Ptr{AVPicture},PixelFormat,Cint,Cint,Ptr{Cuchar},Cint),src,pix_fmt,width,height,dest,dest_size)
end
function avpicture_get_size(pix_fmt::PixelFormat,_width::Integer,_height::Integer)
    width = int32(_width)
    height = int32(_height)
    ccall((:avpicture_get_size,libavcodec),Cint,(PixelFormat,Cint,Cint),pix_fmt,width,height)
end
function avcodec_get_chroma_sub_sample(pix_fmt::PixelFormat,_h_shift::Ptr,_v_shift::Ptr)
    h_shift = convert(Ptr{Cint},_h_shift)
    v_shift = convert(Ptr{Cint},_v_shift)
    ccall((:avcodec_get_chroma_sub_sample,libavcodec),Void,(PixelFormat,Ptr{Cint},Ptr{Cint}),pix_fmt,h_shift,v_shift)
end
function avcodec_get_pix_fmt_name(pix_fmt::PixelFormat)
    ccall((:avcodec_get_pix_fmt_name,libavcodec),Ptr{Uint8},(PixelFormat,),pix_fmt)
end
function avcodec_set_dimensions(_s::Ptr,_width::Integer,_height::Integer)
    s = convert(Ptr{AVCodecContext},_s)
    width = int32(_width)
    height = int32(_height)
    ccall((:avcodec_set_dimensions,libavcodec),Void,(Ptr{AVCodecContext},Cint,Cint),s,width,height)
end
function avcodec_pix_fmt_to_codec_tag(pix_fmt::PixelFormat)
    ccall((:avcodec_pix_fmt_to_codec_tag,libavcodec),Uint32,(PixelFormat,),pix_fmt)
end
function av_get_codec_tag_string(_buf::Union(Ptr,ByteString),buf_size::Csize_t,_codec_tag::Integer)
    buf = convert(Ptr{Uint8},_buf)
    codec_tag = uint32(_codec_tag)
    ccall((:av_get_codec_tag_string,libavcodec),Csize_t,(Ptr{Uint8},Csize_t,Uint32),buf,buf_size,codec_tag)
end
function avcodec_get_pix_fmt_loss(dst_pix_fmt::PixelFormat,src_pix_fmt::PixelFormat,_has_alpha::Integer)
    has_alpha = int32(_has_alpha)
    ccall((:avcodec_get_pix_fmt_loss,libavcodec),Cint,(PixelFormat,PixelFormat,Cint),dst_pix_fmt,src_pix_fmt,has_alpha)
end
function avcodec_find_best_pix_fmt(pix_fmt_mask::Int64,src_pix_fmt::PixelFormat,_has_alpha::Integer,_loss_ptr::Ptr)
    has_alpha = int32(_has_alpha)
    loss_ptr = convert(Ptr{Cint},_loss_ptr)
    ccall((:avcodec_find_best_pix_fmt,libavcodec),Cint,(Int64,PixelFormat,Cint,Ptr{Cint}),pix_fmt_mask,src_pix_fmt,has_alpha,loss_ptr)
end
function img_get_alpha_info(_src::Ptr,pix_fmt::PixelFormat,_width::Integer,_height::Integer)
    src = convert(Ptr{AVPicture},_src)
    width = int32(_width)
    height = int32(_height)
    ccall((:img_get_alpha_info,libavcodec),Cint,(Ptr{AVPicture},PixelFormat,Cint,Cint),src,pix_fmt,width,height)
end
function avpicture_deinterlace(_dst::Ptr,_src::Ptr,pix_fmt::PixelFormat,_width::Integer,_height::Integer)
    dst = convert(Ptr{AVPicture},_dst)
    src = convert(Ptr{AVPicture},_src)
    width = int32(_width)
    height = int32(_height)
    ccall((:avpicture_deinterlace,libavcodec),Cint,(Ptr{AVPicture},Ptr{AVPicture},PixelFormat,Cint,Cint),dst,src,pix_fmt,width,height)
end
function av_codec_next(_c::Ptr)
    c = convert(Ptr{AVCodec},_c)
    ccall((:av_codec_next,libavcodec),Ptr{AVCodec},(Ptr{AVCodec},),c)
end
function avcodec_version()
    ccall((:avcodec_version,libavcodec),Uint32,())
end
function avcodec_configuration()
    ccall((:avcodec_configuration,libavcodec),Ptr{Uint8},())
end
function avcodec_license()
    ccall((:avcodec_license,libavcodec),Ptr{Uint8},())
end
function avcodec_init()
    ccall((:avcodec_init,libavcodec),Void,())
end
function avcodec_register(_codec::Ptr)
    codec = convert(Ptr{AVCodec},_codec)
    ccall((:avcodec_register,libavcodec),Void,(Ptr{AVCodec},),codec)
end
function avcodec_find_encoder(id::CodecID)
    ccall((:avcodec_find_encoder,libavcodec),Ptr{AVCodec},(CodecID,),id)
end
function avcodec_find_encoder_by_name(_name::Union(Ptr,ByteString))
    name = convert(Ptr{Uint8},_name)
    ccall((:avcodec_find_encoder_by_name,libavcodec),Ptr{AVCodec},(Ptr{Uint8},),name)
end
function avcodec_find_decoder(id::CodecID)
    ccall((:avcodec_find_decoder,libavcodec),Ptr{AVCodec},(CodecID,),id)
end
function avcodec_find_decoder_by_name(_name::Union(Ptr,ByteString))
    name = convert(Ptr{Uint8},_name)
    ccall((:avcodec_find_decoder_by_name,libavcodec),Ptr{AVCodec},(Ptr{Uint8},),name)
end
function avcodec_string(_buf::Union(Ptr,ByteString),_buf_size::Integer,_enc::Ptr,_encode::Integer)
    buf = convert(Ptr{Uint8},_buf)
    buf_size = int32(_buf_size)
    enc = convert(Ptr{AVCodecContext},_enc)
    encode = int32(_encode)
    ccall((:avcodec_string,libavcodec),Void,(Ptr{Uint8},Cint,Ptr{AVCodecContext},Cint),buf,buf_size,enc,encode)
end
function av_get_profile_name(_codec::Ptr,_profile::Integer)
    codec = convert(Ptr{AVCodec},_codec)
    profile = int32(_profile)
    ccall((:av_get_profile_name,libavcodec),Ptr{Uint8},(Ptr{AVCodec},Cint),codec,profile)
end
function avcodec_get_context_defaults(_s::Ptr)
    s = convert(Ptr{AVCodecContext},_s)
    ccall((:avcodec_get_context_defaults,libavcodec),Void,(Ptr{AVCodecContext},),s)
end
function avcodec_get_context_defaults2(_s::Ptr,::AVMediaType)
    s = convert(Ptr{AVCodecContext},_s)
    ccall((:avcodec_get_context_defaults2,libavcodec),Void,(Ptr{AVCodecContext},AVMediaType),s,)
end
function avcodec_get_context_defaults3(_s::Ptr,_codec::Ptr)
    s = convert(Ptr{AVCodecContext},_s)
    codec = convert(Ptr{AVCodec},_codec)
    ccall((:avcodec_get_context_defaults3,libavcodec),Cint,(Ptr{AVCodecContext},Ptr{AVCodec}),s,codec)
end
function avcodec_alloc_context()
    ccall((:avcodec_alloc_context,libavcodec),Ptr{AVCodecContext},())
end
function avcodec_alloc_context2(::AVMediaType)
    ccall((:avcodec_alloc_context2,libavcodec),Ptr{AVCodecContext},(AVMediaType,),)
end
function avcodec_alloc_context3(_codec::Ptr)
    codec = convert(Ptr{AVCodec},_codec)
    ccall((:avcodec_alloc_context3,libavcodec),Ptr{AVCodecContext},(Ptr{AVCodec},),codec)
end
function avcodec_copy_context(_dest::Ptr,_src::Ptr)
    dest = convert(Ptr{AVCodecContext},_dest)
    src = convert(Ptr{AVCodecContext},_src)
    ccall((:avcodec_copy_context,libavcodec),Cint,(Ptr{AVCodecContext},Ptr{AVCodecContext}),dest,src)
end
function avcodec_get_frame_defaults(_pic::Ptr)
    pic = convert(Ptr{AVFrame},_pic)
    ccall((:avcodec_get_frame_defaults,libavcodec),Void,(Ptr{AVFrame},),pic)
end
function avcodec_alloc_frame()
    ccall((:avcodec_alloc_frame,libavcodec),Ptr{AVFrame},())
end
function avcodec_default_get_buffer(_s::Ptr,_pic::Ptr)
    s = convert(Ptr{AVCodecContext},_s)
    pic = convert(Ptr{AVFrame},_pic)
    ccall((:avcodec_default_get_buffer,libavcodec),Cint,(Ptr{AVCodecContext},Ptr{AVFrame}),s,pic)
end
function avcodec_default_release_buffer(_s::Ptr,_pic::Ptr)
    s = convert(Ptr{AVCodecContext},_s)
    pic = convert(Ptr{AVFrame},_pic)
    ccall((:avcodec_default_release_buffer,libavcodec),Void,(Ptr{AVCodecContext},Ptr{AVFrame}),s,pic)
end
function avcodec_default_reget_buffer(_s::Ptr,_pic::Ptr)
    s = convert(Ptr{AVCodecContext},_s)
    pic = convert(Ptr{AVFrame},_pic)
    ccall((:avcodec_default_reget_buffer,libavcodec),Cint,(Ptr{AVCodecContext},Ptr{AVFrame}),s,pic)
end
function avcodec_get_edge_width()
    ccall((:avcodec_get_edge_width,libavcodec),Uint32,())
end
function avcodec_align_dimensions(_s::Ptr,_width::Ptr,_height::Ptr)
    s = convert(Ptr{AVCodecContext},_s)
    width = convert(Ptr{Cint},_width)
    height = convert(Ptr{Cint},_height)
    ccall((:avcodec_align_dimensions,libavcodec),Void,(Ptr{AVCodecContext},Ptr{Cint},Ptr{Cint}),s,width,height)
end
function avcodec_align_dimensions2(_s::Ptr,_width::Ptr,_height::Ptr,_linesize_align::Ptr)
    s = convert(Ptr{AVCodecContext},_s)
    width = convert(Ptr{Cint},_width)
    height = convert(Ptr{Cint},_height)
    linesize_align = convert(Ptr{Cint},_linesize_align)
    ccall((:avcodec_align_dimensions2,libavcodec),Void,(Ptr{AVCodecContext},Ptr{Cint},Ptr{Cint},Ptr{Cint}),s,width,height,linesize_align)
end
function avcodec_default_get_format(_s::Ptr,_fmt::Ptr)
    s = convert(Ptr{AVCodecContext},_s)
    fmt = convert(Ptr{PixelFormat},_fmt)
    ccall((:avcodec_default_get_format,libavcodec),Cint,(Ptr{AVCodecContext},Ptr{PixelFormat}),s,fmt)
end
function avcodec_thread_init(_s::Ptr,_thread_count::Integer)
    s = convert(Ptr{AVCodecContext},_s)
    thread_count = int32(_thread_count)
    ccall((:avcodec_thread_init,libavcodec),Cint,(Ptr{AVCodecContext},Cint),s,thread_count)
end
function avcodec_default_execute(_c::Ptr,_func::Ptr,_arg::Ptr,_ret::Ptr,_count::Integer,_size::Integer)
    c = convert(Ptr{AVCodecContext},_c)
    func = convert(Ptr{Void},_func)
    arg = convert(Ptr{Void},_arg)
    ret = convert(Ptr{Cint},_ret)
    count = int32(_count)
    size = int32(_size)
    ccall((:avcodec_default_execute,libavcodec),Cint,(Ptr{AVCodecContext},Ptr{Void},Ptr{Void},Ptr{Cint},Cint,Cint),c,func,arg,ret,count,size)
end
function avcodec_default_execute2(_c::Ptr,_func::Ptr,_arg::Ptr,_ret::Ptr,_count::Integer)
    c = convert(Ptr{AVCodecContext},_c)
    func = convert(Ptr{Void},_func)
    arg = convert(Ptr{Void},_arg)
    ret = convert(Ptr{Cint},_ret)
    count = int32(_count)
    ccall((:avcodec_default_execute2,libavcodec),Cint,(Ptr{AVCodecContext},Ptr{Void},Ptr{Void},Ptr{Cint},Cint),c,func,arg,ret,count)
end
function avcodec_open(_avctx::Ptr,_codec::Ptr)
    avctx = convert(Ptr{AVCodecContext},_avctx)
    codec = convert(Ptr{AVCodec},_codec)
    ccall((:avcodec_open,libavcodec),Cint,(Ptr{AVCodecContext},Ptr{AVCodec}),avctx,codec)
end
function avcodec_open2(_avctx::Ptr,_codec::Ptr,_options::Ptr)
    avctx = convert(Ptr{AVCodecContext},_avctx)
    codec = convert(Ptr{AVCodec},_codec)
    options = convert(Ptr{Ptr{AVDictionary}},_options)
    ccall((:avcodec_open2,libavcodec),Cint,(Ptr{AVCodecContext},Ptr{AVCodec},Ptr{Ptr{AVDictionary}}),avctx,codec,options)
end
function avcodec_decode_audio3(_avctx::Ptr,_samples::Ptr,_frame_size_ptr::Ptr,_avpkt::Ptr)
    avctx = convert(Ptr{AVCodecContext},_avctx)
    samples = convert(Ptr{Int16},_samples)
    frame_size_ptr = convert(Ptr{Cint},_frame_size_ptr)
    avpkt = convert(Ptr{AVPacket},_avpkt)
    ccall((:avcodec_decode_audio3,libavcodec),Cint,(Ptr{AVCodecContext},Ptr{Int16},Ptr{Cint},Ptr{AVPacket}),avctx,samples,frame_size_ptr,avpkt)
end
function avcodec_decode_audio4(_avctx::Ptr,_frame::Ptr,_got_frame_ptr::Ptr,_avpkt::Ptr)
    avctx = convert(Ptr{AVCodecContext},_avctx)
    frame = convert(Ptr{AVFrame},_frame)
    got_frame_ptr = convert(Ptr{Cint},_got_frame_ptr)
    avpkt = convert(Ptr{AVPacket},_avpkt)
    ccall((:avcodec_decode_audio4,libavcodec),Cint,(Ptr{AVCodecContext},Ptr{AVFrame},Ptr{Cint},Ptr{AVPacket}),avctx,frame,got_frame_ptr,avpkt)
end
function avcodec_decode_video2(_avctx::Ptr,_picture::Ptr,_got_picture_ptr::Ptr,_avpkt::Ptr)
    avctx = convert(Ptr{AVCodecContext},_avctx)
    picture = convert(Ptr{AVFrame},_picture)
    got_picture_ptr = convert(Ptr{Cint},_got_picture_ptr)
    avpkt = convert(Ptr{AVPacket},_avpkt)
    ccall((:avcodec_decode_video2,libavcodec),Cint,(Ptr{AVCodecContext},Ptr{AVFrame},Ptr{Cint},Ptr{AVPacket}),avctx,picture,got_picture_ptr,avpkt)
end
function avcodec_decode_subtitle2(_avctx::Ptr,_sub::Ptr,_got_sub_ptr::Ptr,_avpkt::Ptr)
    avctx = convert(Ptr{AVCodecContext},_avctx)
    sub = convert(Ptr{AVSubtitle},_sub)
    got_sub_ptr = convert(Ptr{Cint},_got_sub_ptr)
    avpkt = convert(Ptr{AVPacket},_avpkt)
    ccall((:avcodec_decode_subtitle2,libavcodec),Cint,(Ptr{AVCodecContext},Ptr{AVSubtitle},Ptr{Cint},Ptr{AVPacket}),avctx,sub,got_sub_ptr,avpkt)
end
function avsubtitle_free(_sub::Ptr)
    sub = convert(Ptr{AVSubtitle},_sub)
    ccall((:avsubtitle_free,libavcodec),Void,(Ptr{AVSubtitle},),sub)
end
function avcodec_encode_audio(_avctx::Ptr,_buf::Union(Ptr,ByteString),_buf_size::Integer,_samples::Ptr)
    avctx = convert(Ptr{AVCodecContext},_avctx)
    buf = convert(Ptr{Uint8},_buf)
    buf_size = int32(_buf_size)
    samples = convert(Ptr{Int16},_samples)
    ccall((:avcodec_encode_audio,libavcodec),Cint,(Ptr{AVCodecContext},Ptr{Uint8},Cint,Ptr{Int16}),avctx,buf,buf_size,samples)
end
function avcodec_encode_audio2(_avctx::Ptr,_avpkt::Ptr,_frame::Ptr,_got_packet_ptr::Ptr)
    avctx = convert(Ptr{AVCodecContext},_avctx)
    avpkt = convert(Ptr{AVPacket},_avpkt)
    frame = convert(Ptr{AVFrame},_frame)
    got_packet_ptr = convert(Ptr{Cint},_got_packet_ptr)
    ccall((:avcodec_encode_audio2,libavcodec),Cint,(Ptr{AVCodecContext},Ptr{AVPacket},Ptr{AVFrame},Ptr{Cint}),avctx,avpkt,frame,got_packet_ptr)
end
function avcodec_fill_audio_frame(_frame::Ptr,_nb_channels::Integer,sample_fmt::AVSampleFormat,_buf::Union(Ptr,ByteString),_buf_size::Integer,_align::Integer)
    frame = convert(Ptr{AVFrame},_frame)
    nb_channels = int32(_nb_channels)
    buf = convert(Ptr{Uint8},_buf)
    buf_size = int32(_buf_size)
    align = int32(_align)
    ccall((:avcodec_fill_audio_frame,libavcodec),Cint,(Ptr{AVFrame},Cint,AVSampleFormat,Ptr{Uint8},Cint,Cint),frame,nb_channels,sample_fmt,buf,buf_size,align)
end
function avcodec_encode_video(_avctx::Ptr,_buf::Union(Ptr,ByteString),_buf_size::Integer,_pict::Ptr)
    avctx = convert(Ptr{AVCodecContext},_avctx)
    buf = convert(Ptr{Uint8},_buf)
    buf_size = int32(_buf_size)
    pict = convert(Ptr{AVFrame},_pict)
    ccall((:avcodec_encode_video,libavcodec),Cint,(Ptr{AVCodecContext},Ptr{Uint8},Cint,Ptr{AVFrame}),avctx,buf,buf_size,pict)
end
function avcodec_encode_subtitle(_avctx::Ptr,_buf::Union(Ptr,ByteString),_buf_size::Integer,_sub::Ptr)
    avctx = convert(Ptr{AVCodecContext},_avctx)
    buf = convert(Ptr{Uint8},_buf)
    buf_size = int32(_buf_size)
    sub = convert(Ptr{AVSubtitle},_sub)
    ccall((:avcodec_encode_subtitle,libavcodec),Cint,(Ptr{AVCodecContext},Ptr{Uint8},Cint,Ptr{AVSubtitle}),avctx,buf,buf_size,sub)
end
function avcodec_close(_avctx::Ptr)
    avctx = convert(Ptr{AVCodecContext},_avctx)
    ccall((:avcodec_close,libavcodec),Cint,(Ptr{AVCodecContext},),avctx)
end
function avcodec_register_all()
    ccall((:avcodec_register_all,libavcodec),Void,())
end
function avcodec_flush_buffers(_avctx::Ptr)
    avctx = convert(Ptr{AVCodecContext},_avctx)
    ccall((:avcodec_flush_buffers,libavcodec),Void,(Ptr{AVCodecContext},),avctx)
end
function avcodec_default_free_buffers(_s::Ptr)
    s = convert(Ptr{AVCodecContext},_s)
    ccall((:avcodec_default_free_buffers,libavcodec),Void,(Ptr{AVCodecContext},),s)
end
function av_get_pict_type_char(_pict_type::Integer)
    pict_type = int32(_pict_type)
    ccall((:av_get_pict_type_char,libavcodec),Uint8,(Cint,),pict_type)
end
function av_get_bits_per_sample(codec_id::CodecID)
    ccall((:av_get_bits_per_sample,libavcodec),Cint,(CodecID,),codec_id)
end
function av_get_bits_per_sample_format(sample_fmt::AVSampleFormat)
    ccall((:av_get_bits_per_sample_format,libavcodec),Cint,(AVSampleFormat,),sample_fmt)
end
function av_parser_next(_c::Ptr)
    c = convert(Ptr{AVCodecParser},_c)
    ccall((:av_parser_next,libavcodec),Ptr{AVCodecParser},(Ptr{AVCodecParser},),c)
end
function av_register_codec_parser(_parser::Ptr)
    parser = convert(Ptr{AVCodecParser},_parser)
    ccall((:av_register_codec_parser,libavcodec),Void,(Ptr{AVCodecParser},),parser)
end
function av_parser_init(_codec_id::Integer)
    codec_id = int32(_codec_id)
    ccall((:av_parser_init,libavcodec),Ptr{AVCodecParserContext},(Cint,),codec_id)
end
function av_parser_parse2(_s::Ptr,_avctx::Ptr,_poutbuf::Ptr,_poutbuf_size::Ptr,_buf::Union(Ptr,ByteString),_buf_size::Integer,pts::Int64,dts::Int64,pos::Int64)
    s = convert(Ptr{AVCodecParserContext},_s)
    avctx = convert(Ptr{AVCodecContext},_avctx)
    poutbuf = convert(Ptr{Ptr{Uint8}},_poutbuf)
    poutbuf_size = convert(Ptr{Cint},_poutbuf_size)
    buf = convert(Ptr{Uint8},_buf)
    buf_size = int32(_buf_size)
    ccall((:av_parser_parse2,libavcodec),Cint,(Ptr{AVCodecParserContext},Ptr{AVCodecContext},Ptr{Ptr{Uint8}},Ptr{Cint},Ptr{Uint8},Cint,Int64,Int64,Int64),s,avctx,poutbuf,poutbuf_size,buf,buf_size,pts,dts,pos)
end
function av_parser_change(_s::Ptr,_avctx::Ptr,_poutbuf::Ptr,_poutbuf_size::Ptr,_buf::Union(Ptr,ByteString),_buf_size::Integer,_keyframe::Integer)
    s = convert(Ptr{AVCodecParserContext},_s)
    avctx = convert(Ptr{AVCodecContext},_avctx)
    poutbuf = convert(Ptr{Ptr{Uint8}},_poutbuf)
    poutbuf_size = convert(Ptr{Cint},_poutbuf_size)
    buf = convert(Ptr{Uint8},_buf)
    buf_size = int32(_buf_size)
    keyframe = int32(_keyframe)
    ccall((:av_parser_change,libavcodec),Cint,(Ptr{AVCodecParserContext},Ptr{AVCodecContext},Ptr{Ptr{Uint8}},Ptr{Cint},Ptr{Uint8},Cint,Cint),s,avctx,poutbuf,poutbuf_size,buf,buf_size,keyframe)
end
function av_parser_close(_s::Ptr)
    s = convert(Ptr{AVCodecParserContext},_s)
    ccall((:av_parser_close,libavcodec),Void,(Ptr{AVCodecParserContext},),s)
end
function av_register_bitstream_filter(_bsf::Ptr)
    bsf = convert(Ptr{AVBitStreamFilter},_bsf)
    ccall((:av_register_bitstream_filter,libavcodec),Void,(Ptr{AVBitStreamFilter},),bsf)
end
function av_bitstream_filter_init(_name::Union(Ptr,ByteString))
    name = convert(Ptr{Uint8},_name)
    ccall((:av_bitstream_filter_init,libavcodec),Ptr{AVBitStreamFilterContext},(Ptr{Uint8},),name)
end
function av_bitstream_filter_filter(_bsfc::Ptr,_avctx::Ptr,_args::Union(Ptr,ByteString),_poutbuf::Ptr,_poutbuf_size::Ptr,_buf::Union(Ptr,ByteString),_buf_size::Integer,_keyframe::Integer)
    bsfc = convert(Ptr{AVBitStreamFilterContext},_bsfc)
    avctx = convert(Ptr{AVCodecContext},_avctx)
    args = convert(Ptr{Uint8},_args)
    poutbuf = convert(Ptr{Ptr{Uint8}},_poutbuf)
    poutbuf_size = convert(Ptr{Cint},_poutbuf_size)
    buf = convert(Ptr{Uint8},_buf)
    buf_size = int32(_buf_size)
    keyframe = int32(_keyframe)
    ccall((:av_bitstream_filter_filter,libavcodec),Cint,(Ptr{AVBitStreamFilterContext},Ptr{AVCodecContext},Ptr{Uint8},Ptr{Ptr{Uint8}},Ptr{Cint},Ptr{Uint8},Cint,Cint),bsfc,avctx,args,poutbuf,poutbuf_size,buf,buf_size,keyframe)
end
function av_bitstream_filter_close(_bsf::Ptr)
    bsf = convert(Ptr{AVBitStreamFilterContext},_bsf)
    ccall((:av_bitstream_filter_close,libavcodec),Void,(Ptr{AVBitStreamFilterContext},),bsf)
end
function av_bitstream_filter_next(_f::Ptr)
    f = convert(Ptr{AVBitStreamFilter},_f)
    ccall((:av_bitstream_filter_next,libavcodec),Ptr{AVBitStreamFilter},(Ptr{AVBitStreamFilter},),f)
end
function av_fast_realloc(_ptr::Ptr,_size::Ptr,min_size::Csize_t)
    ptr = convert(Ptr{Void},_ptr)
    size = convert(Ptr{Uint32},_size)
    ccall((:av_fast_realloc,libavcodec),Ptr{Void},(Ptr{Void},Ptr{Uint32},Csize_t),ptr,size,min_size)
end
function av_fast_malloc(_ptr::Ptr,_size::Ptr,min_size::Csize_t)
    ptr = convert(Ptr{Void},_ptr)
    size = convert(Ptr{Uint32},_size)
    ccall((:av_fast_malloc,libavcodec),Void,(Ptr{Void},Ptr{Uint32},Csize_t),ptr,size,min_size)
end
function av_picture_copy(_dst::Ptr,_src::Ptr,pix_fmt::PixelFormat,_width::Integer,_height::Integer)
    dst = convert(Ptr{AVPicture},_dst)
    src = convert(Ptr{AVPicture},_src)
    width = int32(_width)
    height = int32(_height)
    ccall((:av_picture_copy,libavcodec),Void,(Ptr{AVPicture},Ptr{AVPicture},PixelFormat,Cint,Cint),dst,src,pix_fmt,width,height)
end
function av_picture_crop(_dst::Ptr,_src::Ptr,pix_fmt::PixelFormat,_top_band::Integer,_left_band::Integer)
    dst = convert(Ptr{AVPicture},_dst)
    src = convert(Ptr{AVPicture},_src)
    top_band = int32(_top_band)
    left_band = int32(_left_band)
    ccall((:av_picture_crop,libavcodec),Cint,(Ptr{AVPicture},Ptr{AVPicture},PixelFormat,Cint,Cint),dst,src,pix_fmt,top_band,left_band)
end
function av_picture_pad(_dst::Ptr,_src::Ptr,_height::Integer,_width::Integer,pix_fmt::PixelFormat,_padtop::Integer,_padbottom::Integer,_padleft::Integer,_padright::Integer,_color::Ptr)
    dst = convert(Ptr{AVPicture},_dst)
    src = convert(Ptr{AVPicture},_src)
    height = int32(_height)
    width = int32(_width)
    padtop = int32(_padtop)
    padbottom = int32(_padbottom)
    padleft = int32(_padleft)
    padright = int32(_padright)
    color = convert(Ptr{Cint},_color)
    ccall((:av_picture_pad,libavcodec),Cint,(Ptr{AVPicture},Ptr{AVPicture},Cint,Cint,PixelFormat,Cint,Cint,Cint,Cint,Ptr{Cint}),dst,src,height,width,pix_fmt,padtop,padbottom,padleft,padright,color)
end
function av_xiphlacing(_s::Ptr,_v::Integer)
    s = convert(Ptr{Cuchar},_s)
    v = uint32(_v)
    ccall((:av_xiphlacing,libavcodec),Uint32,(Ptr{Cuchar},Uint32),s,v)
end
function av_log_missing_feature(_avc::Ptr,_feature::Union(Ptr,ByteString),_want_sample::Integer)
    avc = convert(Ptr{Void},_avc)
    feature = convert(Ptr{Uint8},_feature)
    want_sample = int32(_want_sample)
    ccall((:av_log_missing_feature,libavcodec),Void,(Ptr{Void},Ptr{Uint8},Cint),avc,feature,want_sample)
end
function av_register_hwaccel(_hwaccel::Ptr)
    hwaccel = convert(Ptr{AVHWAccel},_hwaccel)
    ccall((:av_register_hwaccel,libavcodec),Void,(Ptr{AVHWAccel},),hwaccel)
end
function av_hwaccel_next(_hwaccel::Ptr)
    hwaccel = convert(Ptr{AVHWAccel},_hwaccel)
    ccall((:av_hwaccel_next,libavcodec),Ptr{AVHWAccel},(Ptr{AVHWAccel},),hwaccel)
end
function av_lockmgr_register(_cb::Ptr)
    cb = convert(Ptr{Void},_cb)
    ccall((:av_lockmgr_register,libavcodec),Cint,(Ptr{Void},),cb)
end
function avcodec_get_type(codec_id::CodecID)
    ccall((:avcodec_get_type,libavcodec),Cint,(CodecID,),codec_id)
end
function avcodec_get_class()
    ccall((:avcodec_get_class,libavcodec),Ptr{AVClass},())
end
function avcodec_is_open(_s::Ptr)
    s = convert(Ptr{AVCodecContext},_s)
    ccall((:avcodec_is_open,libavcodec),Cint,(Ptr{AVCodecContext},),s)
end
