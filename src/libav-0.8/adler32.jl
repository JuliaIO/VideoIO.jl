# Julia wrapper for header: /usr/include/libavutil/adler32.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


function av_adler32_update(adler::Culong,_buf::Union(Ptr,ByteString),_len::Integer)
    buf = convert(Ptr{Uint8},_buf)
    len = uint32(_len)
    ccall((:av_adler32_update,libavutil),Culong,(Culong,Ptr{Uint8},Uint32),adler,buf,len)
end
