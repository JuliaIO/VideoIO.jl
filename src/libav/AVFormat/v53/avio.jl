# Julia wrapper for header: /usr/local/include/libavformat/avio.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


export
    url_poll,
    url_open_protocol,
    url_alloc,
    url_connect,
    url_open,
    url_read,
    url_read_complete,
    url_write,
    url_seek,
    url_close,
    url_filesize,
    url_get_file_handle,
    url_get_max_packet_size,
    url_get_filename,
    av_url_read_pause,
    av_url_read_seek,
    url_set_interrupt_cb,
    av_protocol_next,
    av_register_protocol2,
    init_put_byte,
    av_alloc_put_byte,
    get_buffer,
    get_partial_buffer,
    get_byte,
    get_le16,
    get_le24,
    get_le32,
    get_le64,
    get_be16,
    get_be24,
    get_be32,
    get_be64,
    put_byte,
    put_nbyte,
    put_buffer,
    put_le64,
    put_be64,
    put_le32,
    put_be32,
    put_le24,
    put_be24,
    put_le16,
    put_be16,
    put_tag,
    av_url_read_fpause,
    av_url_read_fseek,
    url_fopen,
    url_fclose,
    url_fseek,
    url_fskip,
    url_ftell,
    url_fsize,
    url_fgetc,
    url_setbufsize,
    put_flush_packet,
    url_open_dyn_buf,
    url_open_dyn_packet_buf,
    url_close_dyn_buf,
    url_fdopen,
    url_feof,
    url_ferror,
    udp_set_remote_url,
    udp_get_local_port,
    init_checksum,
    get_checksum,
    put_strz,
    url_fgets,
    get_strz,
    url_is_streamed,
    url_fileno,
    url_fget_max_packet_size,
    url_open_buf,
    url_close_buf,
    url_exist,
    avio_check,
    avio_set_interrupt_cb,
    avio_alloc_context,
    avio_w8,
    avio_write,
    avio_wl64,
    avio_wb64,
    avio_wl32,
    avio_wb32,
    avio_wl24,
    avio_wb24,
    avio_wl16,
    avio_wb16,
    avio_put_str,
    avio_put_str16le,
    avio_seek,
    avio_skip,
    avio_tell,
    avio_size,
    avio_flush,
    avio_read,
    avio_r8,
    avio_rl16,
    avio_rl24,
    avio_rl32,
    avio_rl64,
    avio_rb16,
    avio_rb24,
    avio_rb32,
    avio_rb64,
    avio_get_str,
    avio_get_str16le,
    avio_get_str16be,
    avio_open,
    avio_open2,
    avio_close,
    avio_open_dyn_buf,
    avio_close_dyn_buf,
    avio_enum_protocols,
    avio_pause,
    avio_seek_time


function url_poll(poll_table,n::Integer,timeout::Integer)
    ccall((:url_poll,libavformat),Cint,(Ptr{URLPollEntry},Cint,Cint),poll_table,n,timeout)
end

function url_open_protocol(puc,up,url,flags::Integer)
    ccall((:url_open_protocol,libavformat),Cint,(Ptr{Ptr{URLContext}},Ptr{URLProtocol},Ptr{UInt8},Cint),puc,up,url,flags)
end

function url_alloc(h,url,flags::Integer)
    ccall((:url_alloc,libavformat),Cint,(Ptr{Ptr{URLContext}},Ptr{UInt8},Cint),h,url,flags)
end

function url_connect(h)
    ccall((:url_connect,libavformat),Cint,(Ptr{URLContext},),h)
end

function url_open(h,url,flags::Integer)
    ccall((:url_open,libavformat),Cint,(Ptr{Ptr{URLContext}},Ptr{UInt8},Cint),h,url,flags)
end

function url_read(h,buf,size::Integer)
    ccall((:url_read,libavformat),Cint,(Ptr{URLContext},Ptr{Cuchar},Cint),h,buf,size)
end

function url_read_complete(h,buf,size::Integer)
    ccall((:url_read_complete,libavformat),Cint,(Ptr{URLContext},Ptr{Cuchar},Cint),h,buf,size)
end

function url_write(h,buf,size::Integer)
    ccall((:url_write,libavformat),Cint,(Ptr{URLContext},Ptr{Cuchar},Cint),h,buf,size)
end

function url_seek(h,pos::Int64,whence::Integer)
    ccall((:url_seek,libavformat),Int64,(Ptr{URLContext},Int64,Cint),h,pos,whence)
end

function url_close(h)
    ccall((:url_close,libavformat),Cint,(Ptr{URLContext},),h)
end

function url_filesize(h)
    ccall((:url_filesize,libavformat),Int64,(Ptr{URLContext},),h)
end

function url_get_file_handle(h)
    ccall((:url_get_file_handle,libavformat),Cint,(Ptr{URLContext},),h)
end

function url_get_max_packet_size(h)
    ccall((:url_get_max_packet_size,libavformat),Cint,(Ptr{URLContext},),h)
end

function url_get_filename(h,buf,buf_size::Integer)
    ccall((:url_get_filename,libavformat),Void,(Ptr{URLContext},Ptr{UInt8},Cint),h,buf,buf_size)
end

function av_url_read_pause(h,pause::Integer)
    ccall((:av_url_read_pause,libavformat),Cint,(Ptr{URLContext},Cint),h,pause)
end

function av_url_read_seek(h,stream_index::Integer,timestamp::Int64,flags::Integer)
    ccall((:av_url_read_seek,libavformat),Int64,(Ptr{URLContext},Cint,Int64,Cint),h,stream_index,timestamp,flags)
end

function url_set_interrupt_cb(interrupt_cb)
    ccall((:url_set_interrupt_cb,libavformat),Void,(Ptr{Void},),interrupt_cb)
end

function av_protocol_next(p)
    ccall((:av_protocol_next,libavformat),Ptr{URLProtocol},(Ptr{URLProtocol},),p)
end

function av_register_protocol2(protocol,size::Integer)
    ccall((:av_register_protocol2,libavformat),Cint,(Ptr{URLProtocol},Cint),protocol,size)
end

function init_put_byte(s,buffer,buffer_size::Integer,write_flag::Integer,opaque,read_packet,write_packet,seek)
    ccall((:init_put_byte,libavformat),Cint,(Ptr{AVIOContext},Ptr{Cuchar},Cint,Cint,Ptr{Void},Ptr{Void},Ptr{Void},Ptr{Void}),s,buffer,buffer_size,write_flag,opaque,read_packet,write_packet,seek)
end

function av_alloc_put_byte(buffer,buffer_size::Integer,write_flag::Integer,opaque,read_packet,write_packet,seek)
    ccall((:av_alloc_put_byte,libavformat),Ptr{AVIOContext},(Ptr{Cuchar},Cint,Cint,Ptr{Void},Ptr{Void},Ptr{Void},Ptr{Void}),buffer,buffer_size,write_flag,opaque,read_packet,write_packet,seek)
end

function get_buffer(s,buf,size::Integer)
    ccall((:get_buffer,libavformat),Cint,(Ptr{AVIOContext},Ptr{Cuchar},Cint),s,buf,size)
end

function get_partial_buffer(s,buf,size::Integer)
    ccall((:get_partial_buffer,libavformat),Cint,(Ptr{AVIOContext},Ptr{Cuchar},Cint),s,buf,size)
end

function get_byte(s)
    ccall((:get_byte,libavformat),Cint,(Ptr{AVIOContext},),s)
end

function get_le16(s)
    ccall((:get_le16,libavformat),UInt32,(Ptr{AVIOContext},),s)
end

function get_le24(s)
    ccall((:get_le24,libavformat),UInt32,(Ptr{AVIOContext},),s)
end

function get_le32(s)
    ccall((:get_le32,libavformat),UInt32,(Ptr{AVIOContext},),s)
end

function get_le64(s)
    ccall((:get_le64,libavformat),UInt64,(Ptr{AVIOContext},),s)
end

function get_be16(s)
    ccall((:get_be16,libavformat),UInt32,(Ptr{AVIOContext},),s)
end

function get_be24(s)
    ccall((:get_be24,libavformat),UInt32,(Ptr{AVIOContext},),s)
end

function get_be32(s)
    ccall((:get_be32,libavformat),UInt32,(Ptr{AVIOContext},),s)
end

function get_be64(s)
    ccall((:get_be64,libavformat),UInt64,(Ptr{AVIOContext},),s)
end

function put_byte(s,b::Integer)
    ccall((:put_byte,libavformat),Void,(Ptr{AVIOContext},Cint),s,b)
end

function put_nbyte(s,b::Integer,count::Integer)
    ccall((:put_nbyte,libavformat),Void,(Ptr{AVIOContext},Cint,Cint),s,b,count)
end

function put_buffer(s,buf,size::Integer)
    ccall((:put_buffer,libavformat),Void,(Ptr{AVIOContext},Ptr{Cuchar},Cint),s,buf,size)
end

function put_le64(s,val::UInt64)
    ccall((:put_le64,libavformat),Void,(Ptr{AVIOContext},UInt64),s,val)
end

function put_be64(s,val::UInt64)
    ccall((:put_be64,libavformat),Void,(Ptr{AVIOContext},UInt64),s,val)
end

function put_le32(s,val::Integer)
    ccall((:put_le32,libavformat),Void,(Ptr{AVIOContext},UInt32),s,val)
end

function put_be32(s,val::Integer)
    ccall((:put_be32,libavformat),Void,(Ptr{AVIOContext},UInt32),s,val)
end

function put_le24(s,val::Integer)
    ccall((:put_le24,libavformat),Void,(Ptr{AVIOContext},UInt32),s,val)
end

function put_be24(s,val::Integer)
    ccall((:put_be24,libavformat),Void,(Ptr{AVIOContext},UInt32),s,val)
end

function put_le16(s,val::Integer)
    ccall((:put_le16,libavformat),Void,(Ptr{AVIOContext},UInt32),s,val)
end

function put_be16(s,val::Integer)
    ccall((:put_be16,libavformat),Void,(Ptr{AVIOContext},UInt32),s,val)
end

function put_tag(s,tag)
    ccall((:put_tag,libavformat),Void,(Ptr{AVIOContext},Ptr{UInt8}),s,tag)
end

function av_url_read_fpause(h,pause::Integer)
    ccall((:av_url_read_fpause,libavformat),Cint,(Ptr{AVIOContext},Cint),h,pause)
end

function av_url_read_fseek(h,stream_index::Integer,timestamp::Int64,flags::Integer)
    ccall((:av_url_read_fseek,libavformat),Int64,(Ptr{AVIOContext},Cint,Int64,Cint),h,stream_index,timestamp,flags)
end

function url_fopen(s,url,flags::Integer)
    ccall((:url_fopen,libavformat),Cint,(Ptr{Ptr{AVIOContext}},Ptr{UInt8},Cint),s,url,flags)
end

function url_fclose(s)
    ccall((:url_fclose,libavformat),Cint,(Ptr{AVIOContext},),s)
end

function url_fseek(s,offset::Int64,whence::Integer)
    ccall((:url_fseek,libavformat),Int64,(Ptr{AVIOContext},Int64,Cint),s,offset,whence)
end

function url_fskip(s,offset::Int64)
    ccall((:url_fskip,libavformat),Cint,(Ptr{AVIOContext},Int64),s,offset)
end

function url_ftell(s)
    ccall((:url_ftell,libavformat),Int64,(Ptr{AVIOContext},),s)
end

function url_fsize(s)
    ccall((:url_fsize,libavformat),Int64,(Ptr{AVIOContext},),s)
end

function url_fgetc(s)
    ccall((:url_fgetc,libavformat),Cint,(Ptr{AVIOContext},),s)
end

function url_setbufsize(s,buf_size::Integer)
    ccall((:url_setbufsize,libavformat),Cint,(Ptr{AVIOContext},Cint),s,buf_size)
end

function put_flush_packet(s)
    ccall((:put_flush_packet,libavformat),Void,(Ptr{AVIOContext},),s)
end

function url_open_dyn_buf(s)
    ccall((:url_open_dyn_buf,libavformat),Cint,(Ptr{Ptr{AVIOContext}},),s)
end

function url_open_dyn_packet_buf(s,max_packet_size::Integer)
    ccall((:url_open_dyn_packet_buf,libavformat),Cint,(Ptr{Ptr{AVIOContext}},Cint),s,max_packet_size)
end

function url_close_dyn_buf(s,pbuffer)
    ccall((:url_close_dyn_buf,libavformat),Cint,(Ptr{AVIOContext},Ptr{Ptr{UInt8}}),s,pbuffer)
end

function url_fdopen(s,h)
    ccall((:url_fdopen,libavformat),Cint,(Ptr{Ptr{AVIOContext}},Ptr{URLContext}),s,h)
end

function url_feof(s)
    ccall((:url_feof,libavformat),Cint,(Ptr{AVIOContext},),s)
end

function url_ferror(s)
    ccall((:url_ferror,libavformat),Cint,(Ptr{AVIOContext},),s)
end

function udp_set_remote_url(h,uri)
    ccall((:udp_set_remote_url,libavformat),Cint,(Ptr{URLContext},Ptr{UInt8}),h,uri)
end

function udp_get_local_port(h)
    ccall((:udp_get_local_port,libavformat),Cint,(Ptr{URLContext},),h)
end

function init_checksum(s,update_checksum,checksum::Culong)
    ccall((:init_checksum,libavformat),Void,(Ptr{AVIOContext},Ptr{Void},Culong),s,update_checksum,checksum)
end

function get_checksum(s)
    ccall((:get_checksum,libavformat),Culong,(Ptr{AVIOContext},),s)
end

function put_strz(s,buf)
    ccall((:put_strz,libavformat),Void,(Ptr{AVIOContext},Ptr{UInt8}),s,buf)
end

function url_fgets(s,buf,buf_size::Integer)
    ccall((:url_fgets,libavformat),Ptr{UInt8},(Ptr{AVIOContext},Ptr{UInt8},Cint),s,buf,buf_size)
end

function get_strz(s,buf,maxlen::Integer)
    ccall((:get_strz,libavformat),Ptr{UInt8},(Ptr{AVIOContext},Ptr{UInt8},Cint),s,buf,maxlen)
end

function url_is_streamed(s)
    ccall((:url_is_streamed,libavformat),Cint,(Ptr{AVIOContext},),s)
end

function url_fileno(s)
    ccall((:url_fileno,libavformat),Ptr{URLContext},(Ptr{AVIOContext},),s)
end

function url_fget_max_packet_size(s)
    ccall((:url_fget_max_packet_size,libavformat),Cint,(Ptr{AVIOContext},),s)
end

function url_open_buf(s,buf,buf_size::Integer,flags::Integer)
    ccall((:url_open_buf,libavformat),Cint,(Ptr{Ptr{AVIOContext}},Ptr{UInt8},Cint,Cint),s,buf,buf_size,flags)
end

function url_close_buf(s)
    ccall((:url_close_buf,libavformat),Cint,(Ptr{AVIOContext},),s)
end

function url_exist(url)
    ccall((:url_exist,libavformat),Cint,(Ptr{UInt8},),url)
end

function avio_check(url,flags::Integer)
    ccall((:avio_check,libavformat),Cint,(Ptr{UInt8},Cint),url,flags)
end

function avio_set_interrupt_cb(interrupt_cb)
    ccall((:avio_set_interrupt_cb,libavformat),Void,(Ptr{Void},),interrupt_cb)
end

function avio_alloc_context(buffer,buffer_size::Integer,write_flag::Integer,opaque,read_packet,write_packet,seek)
    ccall((:avio_alloc_context,libavformat),Ptr{AVIOContext},(Ptr{Cuchar},Cint,Cint,Ptr{Void},Ptr{Void},Ptr{Void},Ptr{Void}),buffer,buffer_size,write_flag,opaque,read_packet,write_packet,seek)
end

function avio_w8(s,b::Integer)
    ccall((:avio_w8,libavformat),Void,(Ptr{AVIOContext},Cint),s,b)
end

function avio_write(s,buf,size::Integer)
    ccall((:avio_write,libavformat),Void,(Ptr{AVIOContext},Ptr{Cuchar},Cint),s,buf,size)
end

function avio_wl64(s,val::UInt64)
    ccall((:avio_wl64,libavformat),Void,(Ptr{AVIOContext},UInt64),s,val)
end

function avio_wb64(s,val::UInt64)
    ccall((:avio_wb64,libavformat),Void,(Ptr{AVIOContext},UInt64),s,val)
end

function avio_wl32(s,val::Integer)
    ccall((:avio_wl32,libavformat),Void,(Ptr{AVIOContext},UInt32),s,val)
end

function avio_wb32(s,val::Integer)
    ccall((:avio_wb32,libavformat),Void,(Ptr{AVIOContext},UInt32),s,val)
end

function avio_wl24(s,val::Integer)
    ccall((:avio_wl24,libavformat),Void,(Ptr{AVIOContext},UInt32),s,val)
end

function avio_wb24(s,val::Integer)
    ccall((:avio_wb24,libavformat),Void,(Ptr{AVIOContext},UInt32),s,val)
end

function avio_wl16(s,val::Integer)
    ccall((:avio_wl16,libavformat),Void,(Ptr{AVIOContext},UInt32),s,val)
end

function avio_wb16(s,val::Integer)
    ccall((:avio_wb16,libavformat),Void,(Ptr{AVIOContext},UInt32),s,val)
end

function avio_put_str(s,str)
    ccall((:avio_put_str,libavformat),Cint,(Ptr{AVIOContext},Ptr{UInt8}),s,str)
end

function avio_put_str16le(s,str)
    ccall((:avio_put_str16le,libavformat),Cint,(Ptr{AVIOContext},Ptr{UInt8}),s,str)
end

function avio_seek(s,offset::Int64,whence::Integer)
    ccall((:avio_seek,libavformat),Int64,(Ptr{AVIOContext},Int64,Cint),s,offset,whence)
end

function avio_skip(s,offset::Int64)
    ccall((:avio_skip,libavformat),Int64,(Ptr{AVIOContext},Int64),s,offset)
end

function avio_tell(s)
    ccall((:avio_tell,libavformat),Int64,(Ptr{AVIOContext},),s)
end

function avio_size(s)
    ccall((:avio_size,libavformat),Int64,(Ptr{AVIOContext},),s)
end

function avio_flush(s)
    ccall((:avio_flush,libavformat),Void,(Ptr{AVIOContext},),s)
end

function avio_read(s,buf,size::Integer)
    ccall((:avio_read,libavformat),Cint,(Ptr{AVIOContext},Ptr{Cuchar},Cint),s,buf,size)
end

function avio_r8(s)
    ccall((:avio_r8,libavformat),Cint,(Ptr{AVIOContext},),s)
end

function avio_rl16(s)
    ccall((:avio_rl16,libavformat),UInt32,(Ptr{AVIOContext},),s)
end

function avio_rl24(s)
    ccall((:avio_rl24,libavformat),UInt32,(Ptr{AVIOContext},),s)
end

function avio_rl32(s)
    ccall((:avio_rl32,libavformat),UInt32,(Ptr{AVIOContext},),s)
end

function avio_rl64(s)
    ccall((:avio_rl64,libavformat),UInt64,(Ptr{AVIOContext},),s)
end

function avio_rb16(s)
    ccall((:avio_rb16,libavformat),UInt32,(Ptr{AVIOContext},),s)
end

function avio_rb24(s)
    ccall((:avio_rb24,libavformat),UInt32,(Ptr{AVIOContext},),s)
end

function avio_rb32(s)
    ccall((:avio_rb32,libavformat),UInt32,(Ptr{AVIOContext},),s)
end

function avio_rb64(s)
    ccall((:avio_rb64,libavformat),UInt64,(Ptr{AVIOContext},),s)
end

function avio_get_str(pb,maxlen::Integer,buf,buflen::Integer)
    ccall((:avio_get_str,libavformat),Cint,(Ptr{AVIOContext},Cint,Ptr{UInt8},Cint),pb,maxlen,buf,buflen)
end

function avio_get_str16le(pb,maxlen::Integer,buf,buflen::Integer)
    ccall((:avio_get_str16le,libavformat),Cint,(Ptr{AVIOContext},Cint,Ptr{UInt8},Cint),pb,maxlen,buf,buflen)
end

function avio_get_str16be(pb,maxlen::Integer,buf,buflen::Integer)
    ccall((:avio_get_str16be,libavformat),Cint,(Ptr{AVIOContext},Cint,Ptr{UInt8},Cint),pb,maxlen,buf,buflen)
end

function avio_open(s,url,flags::Integer)
    ccall((:avio_open,libavformat),Cint,(Ptr{Ptr{AVIOContext}},Ptr{UInt8},Cint),s,url,flags)
end

function avio_open2(s,url,flags::Integer,int_cb,options)
    ccall((:avio_open2,libavformat),Cint,(Ptr{Ptr{AVIOContext}},Ptr{UInt8},Cint,Ptr{AVIOInterruptCB},Ptr{Ptr{AVDictionary}}),s,url,flags,int_cb,options)
end

function avio_close(s)
    ccall((:avio_close,libavformat),Cint,(Ptr{AVIOContext},),s)
end

function avio_open_dyn_buf(s)
    ccall((:avio_open_dyn_buf,libavformat),Cint,(Ptr{Ptr{AVIOContext}},),s)
end

function avio_close_dyn_buf(s,pbuffer)
    ccall((:avio_close_dyn_buf,libavformat),Cint,(Ptr{AVIOContext},Ptr{Ptr{UInt8}}),s,pbuffer)
end

function avio_enum_protocols(opaque,output::Integer)
    ccall((:avio_enum_protocols,libavformat),Ptr{UInt8},(Ptr{Ptr{Void}},Cint),opaque,output)
end

function avio_pause(h,pause::Integer)
    ccall((:avio_pause,libavformat),Cint,(Ptr{AVIOContext},Cint),h,pause)
end

function avio_seek_time(h,stream_index::Integer,timestamp::Int64,flags::Integer)
    ccall((:avio_seek_time,libavformat),Int64,(Ptr{AVIOContext},Cint,Int64,Cint),h,stream_index,timestamp,flags)
end
