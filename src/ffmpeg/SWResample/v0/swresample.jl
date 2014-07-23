# Julia wrapper for header: /opt/ffmpeg/include/libswresample/swresample.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


export
    swr_get_class,
    swr_alloc,
    swr_init,
    swr_is_initialized,
    swr_alloc_set_opts,
    swr_free,
    swr_close,
    swr_convert,
    swr_next_pts,
    swr_set_compensation,
    swr_set_channel_mapping,
    swr_set_matrix,
    swr_drop_output,
    swr_inject_silence,
    swr_get_delay,
    #swresample_version,
    swresample_configuration,
    swresample_license


function swr_get_class()
    ccall((:swr_get_class,libswresample),Ptr{AVClass},())
end

function swr_alloc()
    ccall((:swr_alloc,libswresample),Ptr{SwrContext},())
end

function swr_init(s)
    ccall((:swr_init,libswresample),Cint,(Ptr{SwrContext},),s)
end

function swr_is_initialized(s)
    ccall((:swr_is_initialized,libswresample),Cint,(Ptr{SwrContext},),s)
end

function swr_alloc_set_opts(s,out_ch_layout::Int64,out_sample_fmt::AVSampleFormat,out_sample_rate::Integer,in_ch_layout::Int64,in_sample_fmt::AVSampleFormat,in_sample_rate::Integer,log_offset::Integer,log_ctx)
    ccall((:swr_alloc_set_opts,libswresample),Ptr{SwrContext},(Ptr{SwrContext},Int64,AVSampleFormat,Cint,Int64,AVSampleFormat,Cint,Cint,Ptr{Void}),s,out_ch_layout,out_sample_fmt,out_sample_rate,in_ch_layout,in_sample_fmt,in_sample_rate,log_offset,log_ctx)
end

function swr_free(s)
    ccall((:swr_free,libswresample),Void,(Ptr{Ptr{SwrContext}},),s)
end

function swr_close(s)
    ccall((:swr_close,libswresample),Void,(Ptr{SwrContext},),s)
end

function swr_convert(s,out,out_count::Integer,_in,in_count::Integer)
    ccall((:swr_convert,libswresample),Cint,(Ptr{SwrContext},Ptr{Ptr{Uint8}},Cint,Ptr{Ptr{Uint8}},Cint),s,out,out_count,_in,in_count)
end

function swr_next_pts(s,pts::Int64)
    ccall((:swr_next_pts,libswresample),Int64,(Ptr{SwrContext},Int64),s,pts)
end

function swr_set_compensation(s,sample_delta::Integer,compensation_distance::Integer)
    ccall((:swr_set_compensation,libswresample),Cint,(Ptr{SwrContext},Cint,Cint),s,sample_delta,compensation_distance)
end

function swr_set_channel_mapping(s,channel_map)
    ccall((:swr_set_channel_mapping,libswresample),Cint,(Ptr{SwrContext},Ptr{Cint}),s,channel_map)
end

function swr_set_matrix(s,matrix,stride::Integer)
    ccall((:swr_set_matrix,libswresample),Cint,(Ptr{SwrContext},Ptr{Cdouble},Cint),s,matrix,stride)
end

function swr_drop_output(s,count::Integer)
    ccall((:swr_drop_output,libswresample),Cint,(Ptr{SwrContext},Cint),s,count)
end

function swr_inject_silence(s,count::Integer)
    ccall((:swr_inject_silence,libswresample),Cint,(Ptr{SwrContext},Cint),s,count)
end

function swr_get_delay(s,base::Int64)
    ccall((:swr_get_delay,libswresample),Int64,(Ptr{SwrContext},Int64),s,base)
end

function swresample_version()
    ccall((:swresample_version,libswresample),Uint32,())
end

function swresample_configuration()
    ccall((:swresample_configuration,libswresample),Ptr{Uint8},())
end

function swresample_license()
    ccall((:swresample_license,libswresample),Ptr{Uint8},())
end
