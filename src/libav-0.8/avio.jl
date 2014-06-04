# Julia wrapper for header: /usr/include/libavformat/avio.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


function url_poll(_poll_table::Ptr,_n::Integer,_timeout::Integer)
    poll_table = convert(Ptr{URLPollEntry},_poll_table)
    n = int32(_n)
    timeout = int32(_timeout)
    ccall((:url_poll,libavformat),Cint,(Ptr{URLPollEntry},Cint,Cint),poll_table,n,timeout)
end
function url_open_protocol(_puc::Ptr,_up::Ptr,_url::Union(Ptr,ByteString),_flags::Integer)
    puc = convert(Ptr{Ptr{URLContext}},_puc)
    up = convert(Ptr{URLProtocol},_up)
    url = convert(Ptr{Uint8},_url)
    flags = int32(_flags)
    ccall((:url_open_protocol,libavformat),Cint,(Ptr{Ptr{URLContext}},Ptr{URLProtocol},Ptr{Uint8},Cint),puc,up,url,flags)
end
function url_alloc(_h::Ptr,_url::Union(Ptr,ByteString),_flags::Integer)
    h = convert(Ptr{Ptr{URLContext}},_h)
    url = convert(Ptr{Uint8},_url)
    flags = int32(_flags)
    ccall((:url_alloc,libavformat),Cint,(Ptr{Ptr{URLContext}},Ptr{Uint8},Cint),h,url,flags)
end
function url_connect(_h::Ptr)
    h = convert(Ptr{URLContext},_h)
    ccall((:url_connect,libavformat),Cint,(Ptr{URLContext},),h)
end
function url_open(_h::Ptr,_url::Union(Ptr,ByteString),_flags::Integer)
    h = convert(Ptr{Ptr{URLContext}},_h)
    url = convert(Ptr{Uint8},_url)
    flags = int32(_flags)
    ccall((:url_open,libavformat),Cint,(Ptr{Ptr{URLContext}},Ptr{Uint8},Cint),h,url,flags)
end
function url_read(_h::Ptr,_buf::Ptr,_size::Integer)
    h = convert(Ptr{URLContext},_h)
    buf = convert(Ptr{Cuchar},_buf)
    size = int32(_size)
    ccall((:url_read,libavformat),Cint,(Ptr{URLContext},Ptr{Cuchar},Cint),h,buf,size)
end
function url_read_complete(_h::Ptr,_buf::Ptr,_size::Integer)
    h = convert(Ptr{URLContext},_h)
    buf = convert(Ptr{Cuchar},_buf)
    size = int32(_size)
    ccall((:url_read_complete,libavformat),Cint,(Ptr{URLContext},Ptr{Cuchar},Cint),h,buf,size)
end
function url_write(_h::Ptr,_buf::Ptr,_size::Integer)
    h = convert(Ptr{URLContext},_h)
    buf = convert(Ptr{Cuchar},_buf)
    size = int32(_size)
    ccall((:url_write,libavformat),Cint,(Ptr{URLContext},Ptr{Cuchar},Cint),h,buf,size)
end
function url_seek(_h::Ptr,pos::Int64,_whence::Integer)
    h = convert(Ptr{URLContext},_h)
    whence = int32(_whence)
    ccall((:url_seek,libavformat),Int64,(Ptr{URLContext},Int64,Cint),h,pos,whence)
end
function url_close(_h::Ptr)
    h = convert(Ptr{URLContext},_h)
    ccall((:url_close,libavformat),Cint,(Ptr{URLContext},),h)
end
function url_filesize(_h::Ptr)
    h = convert(Ptr{URLContext},_h)
    ccall((:url_filesize,libavformat),Int64,(Ptr{URLContext},),h)
end
function url_get_file_handle(_h::Ptr)
    h = convert(Ptr{URLContext},_h)
    ccall((:url_get_file_handle,libavformat),Cint,(Ptr{URLContext},),h)
end
function url_get_max_packet_size(_h::Ptr)
    h = convert(Ptr{URLContext},_h)
    ccall((:url_get_max_packet_size,libavformat),Cint,(Ptr{URLContext},),h)
end
function url_get_filename(_h::Ptr,_buf::Union(Ptr,ByteString),_buf_size::Integer)
    h = convert(Ptr{URLContext},_h)
    buf = convert(Ptr{Uint8},_buf)
    buf_size = int32(_buf_size)
    ccall((:url_get_filename,libavformat),Void,(Ptr{URLContext},Ptr{Uint8},Cint),h,buf,buf_size)
end
function av_url_read_pause(_h::Ptr,_pause::Integer)
    h = convert(Ptr{URLContext},_h)
    pause = int32(_pause)
    ccall((:av_url_read_pause,libavformat),Cint,(Ptr{URLContext},Cint),h,pause)
end
function av_url_read_seek(_h::Ptr,_stream_index::Integer,timestamp::Int64,_flags::Integer)
    h = convert(Ptr{URLContext},_h)
    stream_index = int32(_stream_index)
    flags = int32(_flags)
    ccall((:av_url_read_seek,libavformat),Int64,(Ptr{URLContext},Cint,Int64,Cint),h,stream_index,timestamp,flags)
end
function url_set_interrupt_cb(_interrupt_cb::Ptr)
    interrupt_cb = convert(Ptr{Void},_interrupt_cb)
    ccall((:url_set_interrupt_cb,libavformat),Void,(Ptr{Void},),interrupt_cb)
end
function av_protocol_next(_p::Ptr)
    p = convert(Ptr{URLProtocol},_p)
    ccall((:av_protocol_next,libavformat),Ptr{URLProtocol},(Ptr{URLProtocol},),p)
end
function av_register_protocol2(_protocol::Ptr,_size::Integer)
    protocol = convert(Ptr{URLProtocol},_protocol)
    size = int32(_size)
    ccall((:av_register_protocol2,libavformat),Cint,(Ptr{URLProtocol},Cint),protocol,size)
end
function init_put_byte(_s::Ptr,_buffer::Ptr,_buffer_size::Integer,_write_flag::Integer,_opaque::Ptr,_read_packet::Ptr,_write_packet::Ptr,_seek::Ptr)
    s = convert(Ptr{AVIOContext},_s)
    buffer = convert(Ptr{Cuchar},_buffer)
    buffer_size = int32(_buffer_size)
    write_flag = int32(_write_flag)
    opaque = convert(Ptr{Void},_opaque)
    read_packet = convert(Ptr{Void},_read_packet)
    write_packet = convert(Ptr{Void},_write_packet)
    seek = convert(Ptr{Void},_seek)
    ccall((:init_put_byte,libavformat),Cint,(Ptr{AVIOContext},Ptr{Cuchar},Cint,Cint,Ptr{Void},Ptr{Void},Ptr{Void},Ptr{Void}),s,buffer,buffer_size,write_flag,opaque,read_packet,write_packet,seek)
end
function av_alloc_put_byte(_buffer::Ptr,_buffer_size::Integer,_write_flag::Integer,_opaque::Ptr,_read_packet::Ptr,_write_packet::Ptr,_seek::Ptr)
    buffer = convert(Ptr{Cuchar},_buffer)
    buffer_size = int32(_buffer_size)
    write_flag = int32(_write_flag)
    opaque = convert(Ptr{Void},_opaque)
    read_packet = convert(Ptr{Void},_read_packet)
    write_packet = convert(Ptr{Void},_write_packet)
    seek = convert(Ptr{Void},_seek)
    ccall((:av_alloc_put_byte,libavformat),Ptr{AVIOContext},(Ptr{Cuchar},Cint,Cint,Ptr{Void},Ptr{Void},Ptr{Void},Ptr{Void}),buffer,buffer_size,write_flag,opaque,read_packet,write_packet,seek)
end
function get_buffer(_s::Ptr,_buf::Ptr,_size::Integer)
    s = convert(Ptr{AVIOContext},_s)
    buf = convert(Ptr{Cuchar},_buf)
    size = int32(_size)
    ccall((:get_buffer,libavformat),Cint,(Ptr{AVIOContext},Ptr{Cuchar},Cint),s,buf,size)
end
function get_partial_buffer(_s::Ptr,_buf::Ptr,_size::Integer)
    s = convert(Ptr{AVIOContext},_s)
    buf = convert(Ptr{Cuchar},_buf)
    size = int32(_size)
    ccall((:get_partial_buffer,libavformat),Cint,(Ptr{AVIOContext},Ptr{Cuchar},Cint),s,buf,size)
end
function get_byte(_s::Ptr)
    s = convert(Ptr{AVIOContext},_s)
    ccall((:get_byte,libavformat),Cint,(Ptr{AVIOContext},),s)
end
function get_le16(_s::Ptr)
    s = convert(Ptr{AVIOContext},_s)
    ccall((:get_le16,libavformat),Uint32,(Ptr{AVIOContext},),s)
end
function get_le24(_s::Ptr)
    s = convert(Ptr{AVIOContext},_s)
    ccall((:get_le24,libavformat),Uint32,(Ptr{AVIOContext},),s)
end
function get_le32(_s::Ptr)
    s = convert(Ptr{AVIOContext},_s)
    ccall((:get_le32,libavformat),Uint32,(Ptr{AVIOContext},),s)
end
function get_le64(_s::Ptr)
    s = convert(Ptr{AVIOContext},_s)
    ccall((:get_le64,libavformat),Uint64,(Ptr{AVIOContext},),s)
end
function get_be16(_s::Ptr)
    s = convert(Ptr{AVIOContext},_s)
    ccall((:get_be16,libavformat),Uint32,(Ptr{AVIOContext},),s)
end
function get_be24(_s::Ptr)
    s = convert(Ptr{AVIOContext},_s)
    ccall((:get_be24,libavformat),Uint32,(Ptr{AVIOContext},),s)
end
function get_be32(_s::Ptr)
    s = convert(Ptr{AVIOContext},_s)
    ccall((:get_be32,libavformat),Uint32,(Ptr{AVIOContext},),s)
end
function get_be64(_s::Ptr)
    s = convert(Ptr{AVIOContext},_s)
    ccall((:get_be64,libavformat),Uint64,(Ptr{AVIOContext},),s)
end
function put_byte(_s::Ptr,_b::Integer)
    s = convert(Ptr{AVIOContext},_s)
    b = int32(_b)
    ccall((:put_byte,libavformat),Void,(Ptr{AVIOContext},Cint),s,b)
end
function put_nbyte(_s::Ptr,_b::Integer,_count::Integer)
    s = convert(Ptr{AVIOContext},_s)
    b = int32(_b)
    count = int32(_count)
    ccall((:put_nbyte,libavformat),Void,(Ptr{AVIOContext},Cint,Cint),s,b,count)
end
function put_buffer(_s::Ptr,_buf::Ptr,_size::Integer)
    s = convert(Ptr{AVIOContext},_s)
    buf = convert(Ptr{Cuchar},_buf)
    size = int32(_size)
    ccall((:put_buffer,libavformat),Void,(Ptr{AVIOContext},Ptr{Cuchar},Cint),s,buf,size)
end
function put_le64(_s::Ptr,val::Uint64)
    s = convert(Ptr{AVIOContext},_s)
    ccall((:put_le64,libavformat),Void,(Ptr{AVIOContext},Uint64),s,val)
end
function put_be64(_s::Ptr,val::Uint64)
    s = convert(Ptr{AVIOContext},_s)
    ccall((:put_be64,libavformat),Void,(Ptr{AVIOContext},Uint64),s,val)
end
function put_le32(_s::Ptr,_val::Integer)
    s = convert(Ptr{AVIOContext},_s)
    val = uint32(_val)
    ccall((:put_le32,libavformat),Void,(Ptr{AVIOContext},Uint32),s,val)
end
function put_be32(_s::Ptr,_val::Integer)
    s = convert(Ptr{AVIOContext},_s)
    val = uint32(_val)
    ccall((:put_be32,libavformat),Void,(Ptr{AVIOContext},Uint32),s,val)
end
function put_le24(_s::Ptr,_val::Integer)
    s = convert(Ptr{AVIOContext},_s)
    val = uint32(_val)
    ccall((:put_le24,libavformat),Void,(Ptr{AVIOContext},Uint32),s,val)
end
function put_be24(_s::Ptr,_val::Integer)
    s = convert(Ptr{AVIOContext},_s)
    val = uint32(_val)
    ccall((:put_be24,libavformat),Void,(Ptr{AVIOContext},Uint32),s,val)
end
function put_le16(_s::Ptr,_val::Integer)
    s = convert(Ptr{AVIOContext},_s)
    val = uint32(_val)
    ccall((:put_le16,libavformat),Void,(Ptr{AVIOContext},Uint32),s,val)
end
function put_be16(_s::Ptr,_val::Integer)
    s = convert(Ptr{AVIOContext},_s)
    val = uint32(_val)
    ccall((:put_be16,libavformat),Void,(Ptr{AVIOContext},Uint32),s,val)
end
function put_tag(_s::Ptr,_tag::Union(Ptr,ByteString))
    s = convert(Ptr{AVIOContext},_s)
    tag = convert(Ptr{Uint8},_tag)
    ccall((:put_tag,libavformat),Void,(Ptr{AVIOContext},Ptr{Uint8}),s,tag)
end
function av_url_read_fpause(_h::Ptr,_pause::Integer)
    h = convert(Ptr{AVIOContext},_h)
    pause = int32(_pause)
    ccall((:av_url_read_fpause,libavformat),Cint,(Ptr{AVIOContext},Cint),h,pause)
end
function av_url_read_fseek(_h::Ptr,_stream_index::Integer,timestamp::Int64,_flags::Integer)
    h = convert(Ptr{AVIOContext},_h)
    stream_index = int32(_stream_index)
    flags = int32(_flags)
    ccall((:av_url_read_fseek,libavformat),Int64,(Ptr{AVIOContext},Cint,Int64,Cint),h,stream_index,timestamp,flags)
end
function url_fopen(_s::Ptr,_url::Union(Ptr,ByteString),_flags::Integer)
    s = convert(Ptr{Ptr{AVIOContext}},_s)
    url = convert(Ptr{Uint8},_url)
    flags = int32(_flags)
    ccall((:url_fopen,libavformat),Cint,(Ptr{Ptr{AVIOContext}},Ptr{Uint8},Cint),s,url,flags)
end
function url_fclose(_s::Ptr)
    s = convert(Ptr{AVIOContext},_s)
    ccall((:url_fclose,libavformat),Cint,(Ptr{AVIOContext},),s)
end
function url_fseek(_s::Ptr,offset::Int64,_whence::Integer)
    s = convert(Ptr{AVIOContext},_s)
    whence = int32(_whence)
    ccall((:url_fseek,libavformat),Int64,(Ptr{AVIOContext},Int64,Cint),s,offset,whence)
end
function url_fskip(_s::Ptr,offset::Int64)
    s = convert(Ptr{AVIOContext},_s)
    ccall((:url_fskip,libavformat),Cint,(Ptr{AVIOContext},Int64),s,offset)
end
function url_ftell(_s::Ptr)
    s = convert(Ptr{AVIOContext},_s)
    ccall((:url_ftell,libavformat),Int64,(Ptr{AVIOContext},),s)
end
function url_fsize(_s::Ptr)
    s = convert(Ptr{AVIOContext},_s)
    ccall((:url_fsize,libavformat),Int64,(Ptr{AVIOContext},),s)
end
function url_fgetc(_s::Ptr)
    s = convert(Ptr{AVIOContext},_s)
    ccall((:url_fgetc,libavformat),Cint,(Ptr{AVIOContext},),s)
end
function url_setbufsize(_s::Ptr,_buf_size::Integer)
    s = convert(Ptr{AVIOContext},_s)
    buf_size = int32(_buf_size)
    ccall((:url_setbufsize,libavformat),Cint,(Ptr{AVIOContext},Cint),s,buf_size)
end
function put_flush_packet(_s::Ptr)
    s = convert(Ptr{AVIOContext},_s)
    ccall((:put_flush_packet,libavformat),Void,(Ptr{AVIOContext},),s)
end
function url_open_dyn_buf(_s::Ptr)
    s = convert(Ptr{Ptr{AVIOContext}},_s)
    ccall((:url_open_dyn_buf,libavformat),Cint,(Ptr{Ptr{AVIOContext}},),s)
end
function url_open_dyn_packet_buf(_s::Ptr,_max_packet_size::Integer)
    s = convert(Ptr{Ptr{AVIOContext}},_s)
    max_packet_size = int32(_max_packet_size)
    ccall((:url_open_dyn_packet_buf,libavformat),Cint,(Ptr{Ptr{AVIOContext}},Cint),s,max_packet_size)
end
function url_close_dyn_buf(_s::Ptr,_pbuffer::Ptr)
    s = convert(Ptr{AVIOContext},_s)
    pbuffer = convert(Ptr{Ptr{Uint8}},_pbuffer)
    ccall((:url_close_dyn_buf,libavformat),Cint,(Ptr{AVIOContext},Ptr{Ptr{Uint8}}),s,pbuffer)
end
function url_fdopen(_s::Ptr,_h::Ptr)
    s = convert(Ptr{Ptr{AVIOContext}},_s)
    h = convert(Ptr{URLContext},_h)
    ccall((:url_fdopen,libavformat),Cint,(Ptr{Ptr{AVIOContext}},Ptr{URLContext}),s,h)
end
function url_feof(_s::Ptr)
    s = convert(Ptr{AVIOContext},_s)
    ccall((:url_feof,libavformat),Cint,(Ptr{AVIOContext},),s)
end
function url_ferror(_s::Ptr)
    s = convert(Ptr{AVIOContext},_s)
    ccall((:url_ferror,libavformat),Cint,(Ptr{AVIOContext},),s)
end
function udp_set_remote_url(_h::Ptr,_uri::Union(Ptr,ByteString))
    h = convert(Ptr{URLContext},_h)
    uri = convert(Ptr{Uint8},_uri)
    ccall((:udp_set_remote_url,libavformat),Cint,(Ptr{URLContext},Ptr{Uint8}),h,uri)
end
function udp_get_local_port(_h::Ptr)
    h = convert(Ptr{URLContext},_h)
    ccall((:udp_get_local_port,libavformat),Cint,(Ptr{URLContext},),h)
end
function init_checksum(_s::Ptr,_update_checksum::Ptr,checksum::Culong)
    s = convert(Ptr{AVIOContext},_s)
    update_checksum = convert(Ptr{Void},_update_checksum)
    ccall((:init_checksum,libavformat),Void,(Ptr{AVIOContext},Ptr{Void},Culong),s,update_checksum,checksum)
end
function get_checksum(_s::Ptr)
    s = convert(Ptr{AVIOContext},_s)
    ccall((:get_checksum,libavformat),Culong,(Ptr{AVIOContext},),s)
end
function put_strz(_s::Ptr,_buf::Union(Ptr,ByteString))
    s = convert(Ptr{AVIOContext},_s)
    buf = convert(Ptr{Uint8},_buf)
    ccall((:put_strz,libavformat),Void,(Ptr{AVIOContext},Ptr{Uint8}),s,buf)
end
function url_fgets(_s::Ptr,_buf::Union(Ptr,ByteString),_buf_size::Integer)
    s = convert(Ptr{AVIOContext},_s)
    buf = convert(Ptr{Uint8},_buf)
    buf_size = int32(_buf_size)
    ccall((:url_fgets,libavformat),Ptr{Uint8},(Ptr{AVIOContext},Ptr{Uint8},Cint),s,buf,buf_size)
end
function get_strz(_s::Ptr,_buf::Union(Ptr,ByteString),_maxlen::Integer)
    s = convert(Ptr{AVIOContext},_s)
    buf = convert(Ptr{Uint8},_buf)
    maxlen = int32(_maxlen)
    ccall((:get_strz,libavformat),Ptr{Uint8},(Ptr{AVIOContext},Ptr{Uint8},Cint),s,buf,maxlen)
end
function url_is_streamed(_s::Ptr)
    s = convert(Ptr{AVIOContext},_s)
    ccall((:url_is_streamed,libavformat),Cint,(Ptr{AVIOContext},),s)
end
function url_fileno(_s::Ptr)
    s = convert(Ptr{AVIOContext},_s)
    ccall((:url_fileno,libavformat),Ptr{URLContext},(Ptr{AVIOContext},),s)
end
function url_fget_max_packet_size(_s::Ptr)
    s = convert(Ptr{AVIOContext},_s)
    ccall((:url_fget_max_packet_size,libavformat),Cint,(Ptr{AVIOContext},),s)
end
function url_open_buf(_s::Ptr,_buf::Union(Ptr,ByteString),_buf_size::Integer,_flags::Integer)
    s = convert(Ptr{Ptr{AVIOContext}},_s)
    buf = convert(Ptr{Uint8},_buf)
    buf_size = int32(_buf_size)
    flags = int32(_flags)
    ccall((:url_open_buf,libavformat),Cint,(Ptr{Ptr{AVIOContext}},Ptr{Uint8},Cint,Cint),s,buf,buf_size,flags)
end
function url_close_buf(_s::Ptr)
    s = convert(Ptr{AVIOContext},_s)
    ccall((:url_close_buf,libavformat),Cint,(Ptr{AVIOContext},),s)
end
function url_exist(_url::Union(Ptr,ByteString))
    url = convert(Ptr{Uint8},_url)
    ccall((:url_exist,libavformat),Cint,(Ptr{Uint8},),url)
end
function avio_check(_url::Union(Ptr,ByteString),_flags::Integer)
    url = convert(Ptr{Uint8},_url)
    flags = int32(_flags)
    ccall((:avio_check,libavformat),Cint,(Ptr{Uint8},Cint),url,flags)
end
function avio_set_interrupt_cb(_interrupt_cb::Ptr)
    interrupt_cb = convert(Ptr{Void},_interrupt_cb)
    ccall((:avio_set_interrupt_cb,libavformat),Void,(Ptr{Void},),interrupt_cb)
end
function avio_alloc_context(_buffer::Ptr,_buffer_size::Integer,_write_flag::Integer,_opaque::Ptr,_read_packet::Ptr,_write_packet::Ptr,_seek::Ptr)
    buffer = convert(Ptr{Cuchar},_buffer)
    buffer_size = int32(_buffer_size)
    write_flag = int32(_write_flag)
    opaque = convert(Ptr{Void},_opaque)
    read_packet = convert(Ptr{Void},_read_packet)
    write_packet = convert(Ptr{Void},_write_packet)
    seek = convert(Ptr{Void},_seek)
    ccall((:avio_alloc_context,libavformat),Ptr{AVIOContext},(Ptr{Cuchar},Cint,Cint,Ptr{Void},Ptr{Void},Ptr{Void},Ptr{Void}),buffer,buffer_size,write_flag,opaque,read_packet,write_packet,seek)
end
function avio_w8(_s::Ptr,_b::Integer)
    s = convert(Ptr{AVIOContext},_s)
    b = int32(_b)
    ccall((:avio_w8,libavformat),Void,(Ptr{AVIOContext},Cint),s,b)
end
function avio_write(_s::Ptr,_buf::Ptr,_size::Integer)
    s = convert(Ptr{AVIOContext},_s)
    buf = convert(Ptr{Cuchar},_buf)
    size = int32(_size)
    ccall((:avio_write,libavformat),Void,(Ptr{AVIOContext},Ptr{Cuchar},Cint),s,buf,size)
end
function avio_wl64(_s::Ptr,val::Uint64)
    s = convert(Ptr{AVIOContext},_s)
    ccall((:avio_wl64,libavformat),Void,(Ptr{AVIOContext},Uint64),s,val)
end
function avio_wb64(_s::Ptr,val::Uint64)
    s = convert(Ptr{AVIOContext},_s)
    ccall((:avio_wb64,libavformat),Void,(Ptr{AVIOContext},Uint64),s,val)
end
function avio_wl32(_s::Ptr,_val::Integer)
    s = convert(Ptr{AVIOContext},_s)
    val = uint32(_val)
    ccall((:avio_wl32,libavformat),Void,(Ptr{AVIOContext},Uint32),s,val)
end
function avio_wb32(_s::Ptr,_val::Integer)
    s = convert(Ptr{AVIOContext},_s)
    val = uint32(_val)
    ccall((:avio_wb32,libavformat),Void,(Ptr{AVIOContext},Uint32),s,val)
end
function avio_wl24(_s::Ptr,_val::Integer)
    s = convert(Ptr{AVIOContext},_s)
    val = uint32(_val)
    ccall((:avio_wl24,libavformat),Void,(Ptr{AVIOContext},Uint32),s,val)
end
function avio_wb24(_s::Ptr,_val::Integer)
    s = convert(Ptr{AVIOContext},_s)
    val = uint32(_val)
    ccall((:avio_wb24,libavformat),Void,(Ptr{AVIOContext},Uint32),s,val)
end
function avio_wl16(_s::Ptr,_val::Integer)
    s = convert(Ptr{AVIOContext},_s)
    val = uint32(_val)
    ccall((:avio_wl16,libavformat),Void,(Ptr{AVIOContext},Uint32),s,val)
end
function avio_wb16(_s::Ptr,_val::Integer)
    s = convert(Ptr{AVIOContext},_s)
    val = uint32(_val)
    ccall((:avio_wb16,libavformat),Void,(Ptr{AVIOContext},Uint32),s,val)
end
function avio_put_str(_s::Ptr,_str::Union(Ptr,ByteString))
    s = convert(Ptr{AVIOContext},_s)
    str = convert(Ptr{Uint8},_str)
    ccall((:avio_put_str,libavformat),Cint,(Ptr{AVIOContext},Ptr{Uint8}),s,str)
end
function avio_put_str16le(_s::Ptr,_str::Union(Ptr,ByteString))
    s = convert(Ptr{AVIOContext},_s)
    str = convert(Ptr{Uint8},_str)
    ccall((:avio_put_str16le,libavformat),Cint,(Ptr{AVIOContext},Ptr{Uint8}),s,str)
end
function avio_seek(_s::Ptr,offset::Int64,_whence::Integer)
    s = convert(Ptr{AVIOContext},_s)
    whence = int32(_whence)
    ccall((:avio_seek,libavformat),Int64,(Ptr{AVIOContext},Int64,Cint),s,offset,whence)
end
function avio_skip(_s::Ptr,offset::Int64)
    s = convert(Ptr{AVIOContext},_s)
    ccall((:avio_skip,libavformat),Int64,(Ptr{AVIOContext},Int64),s,offset)
end
function avio_tell(_s::Ptr)
    s = convert(Ptr{AVIOContext},_s)
    ccall((:avio_tell,libavformat),Int64,(Ptr{AVIOContext},),s)
end
function avio_size(_s::Ptr)
    s = convert(Ptr{AVIOContext},_s)
    ccall((:avio_size,libavformat),Int64,(Ptr{AVIOContext},),s)
end
function avio_flush(_s::Ptr)
    s = convert(Ptr{AVIOContext},_s)
    ccall((:avio_flush,libavformat),Void,(Ptr{AVIOContext},),s)
end
function avio_read(_s::Ptr,_buf::Ptr,_size::Integer)
    s = convert(Ptr{AVIOContext},_s)
    buf = convert(Ptr{Cuchar},_buf)
    size = int32(_size)
    ccall((:avio_read,libavformat),Cint,(Ptr{AVIOContext},Ptr{Cuchar},Cint),s,buf,size)
end
function avio_r8(_s::Ptr)
    s = convert(Ptr{AVIOContext},_s)
    ccall((:avio_r8,libavformat),Cint,(Ptr{AVIOContext},),s)
end
function avio_rl16(_s::Ptr)
    s = convert(Ptr{AVIOContext},_s)
    ccall((:avio_rl16,libavformat),Uint32,(Ptr{AVIOContext},),s)
end
function avio_rl24(_s::Ptr)
    s = convert(Ptr{AVIOContext},_s)
    ccall((:avio_rl24,libavformat),Uint32,(Ptr{AVIOContext},),s)
end
function avio_rl32(_s::Ptr)
    s = convert(Ptr{AVIOContext},_s)
    ccall((:avio_rl32,libavformat),Uint32,(Ptr{AVIOContext},),s)
end
function avio_rl64(_s::Ptr)
    s = convert(Ptr{AVIOContext},_s)
    ccall((:avio_rl64,libavformat),Uint64,(Ptr{AVIOContext},),s)
end
function avio_rb16(_s::Ptr)
    s = convert(Ptr{AVIOContext},_s)
    ccall((:avio_rb16,libavformat),Uint32,(Ptr{AVIOContext},),s)
end
function avio_rb24(_s::Ptr)
    s = convert(Ptr{AVIOContext},_s)
    ccall((:avio_rb24,libavformat),Uint32,(Ptr{AVIOContext},),s)
end
function avio_rb32(_s::Ptr)
    s = convert(Ptr{AVIOContext},_s)
    ccall((:avio_rb32,libavformat),Uint32,(Ptr{AVIOContext},),s)
end
function avio_rb64(_s::Ptr)
    s = convert(Ptr{AVIOContext},_s)
    ccall((:avio_rb64,libavformat),Uint64,(Ptr{AVIOContext},),s)
end
function avio_get_str(_pb::Ptr,_maxlen::Integer,_buf::Union(Ptr,ByteString),_buflen::Integer)
    pb = convert(Ptr{AVIOContext},_pb)
    maxlen = int32(_maxlen)
    buf = convert(Ptr{Uint8},_buf)
    buflen = int32(_buflen)
    ccall((:avio_get_str,libavformat),Cint,(Ptr{AVIOContext},Cint,Ptr{Uint8},Cint),pb,maxlen,buf,buflen)
end
function avio_get_str16le(_pb::Ptr,_maxlen::Integer,_buf::Union(Ptr,ByteString),_buflen::Integer)
    pb = convert(Ptr{AVIOContext},_pb)
    maxlen = int32(_maxlen)
    buf = convert(Ptr{Uint8},_buf)
    buflen = int32(_buflen)
    ccall((:avio_get_str16le,libavformat),Cint,(Ptr{AVIOContext},Cint,Ptr{Uint8},Cint),pb,maxlen,buf,buflen)
end
function avio_get_str16be(_pb::Ptr,_maxlen::Integer,_buf::Union(Ptr,ByteString),_buflen::Integer)
    pb = convert(Ptr{AVIOContext},_pb)
    maxlen = int32(_maxlen)
    buf = convert(Ptr{Uint8},_buf)
    buflen = int32(_buflen)
    ccall((:avio_get_str16be,libavformat),Cint,(Ptr{AVIOContext},Cint,Ptr{Uint8},Cint),pb,maxlen,buf,buflen)
end
function avio_open(_s::Ptr,_url::Union(Ptr,ByteString),_flags::Integer)
    s = convert(Ptr{Ptr{AVIOContext}},_s)
    url = convert(Ptr{Uint8},_url)
    flags = int32(_flags)
    ccall((:avio_open,libavformat),Cint,(Ptr{Ptr{AVIOContext}},Ptr{Uint8},Cint),s,url,flags)
end
function avio_open2(_s::Ptr,_url::Union(Ptr,ByteString),_flags::Integer,_int_cb::Ptr,_options::Ptr)
    s = convert(Ptr{Ptr{AVIOContext}},_s)
    url = convert(Ptr{Uint8},_url)
    flags = int32(_flags)
    int_cb = convert(Ptr{AVIOInterruptCB},_int_cb)
    options = convert(Ptr{Ptr{AVDictionary}},_options)
    ccall((:avio_open2,libavformat),Cint,(Ptr{Ptr{AVIOContext}},Ptr{Uint8},Cint,Ptr{AVIOInterruptCB},Ptr{Ptr{AVDictionary}}),s,url,flags,int_cb,options)
end
function avio_close(_s::Ptr)
    s = convert(Ptr{AVIOContext},_s)
    ccall((:avio_close,libavformat),Cint,(Ptr{AVIOContext},),s)
end
function avio_open_dyn_buf(_s::Ptr)
    s = convert(Ptr{Ptr{AVIOContext}},_s)
    ccall((:avio_open_dyn_buf,libavformat),Cint,(Ptr{Ptr{AVIOContext}},),s)
end
function avio_close_dyn_buf(_s::Ptr,_pbuffer::Ptr)
    s = convert(Ptr{AVIOContext},_s)
    pbuffer = convert(Ptr{Ptr{Uint8}},_pbuffer)
    ccall((:avio_close_dyn_buf,libavformat),Cint,(Ptr{AVIOContext},Ptr{Ptr{Uint8}}),s,pbuffer)
end
function avio_enum_protocols(_opaque::Ptr,_output::Integer)
    opaque = convert(Ptr{Ptr{Void}},_opaque)
    output = int32(_output)
    ccall((:avio_enum_protocols,libavformat),Ptr{Uint8},(Ptr{Ptr{Void}},Cint),opaque,output)
end
function avio_pause(_h::Ptr,_pause::Integer)
    h = convert(Ptr{AVIOContext},_h)
    pause = int32(_pause)
    ccall((:avio_pause,libavformat),Cint,(Ptr{AVIOContext},Cint),h,pause)
end
function avio_seek_time(_h::Ptr,_stream_index::Integer,timestamp::Int64,_flags::Integer)
    h = convert(Ptr{AVIOContext},_h)
    stream_index = int32(_stream_index)
    flags = int32(_flags)
    ccall((:avio_seek_time,libavformat),Int64,(Ptr{AVIOContext},Cint,Int64,Cint),h,stream_index,timestamp,flags)
end
