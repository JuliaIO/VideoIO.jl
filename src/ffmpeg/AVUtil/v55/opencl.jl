# Julia wrapper for header: /usr/local/include/libavutil/opencl.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


export
    av_opencl_get_device_list,
    av_opencl_free_device_list,
    av_opencl_set_option,
    av_opencl_get_option,
    av_opencl_free_option,
    av_opencl_alloc_external_env,
    av_opencl_free_external_env,
    av_opencl_errstr,
    av_opencl_register_kernel_code,
    av_opencl_init,
    av_opencl_compile,
    av_opencl_get_command_queue,
    av_opencl_buffer_create,
    av_opencl_buffer_write,
    av_opencl_buffer_read,
    av_opencl_buffer_write_image,
    av_opencl_buffer_read_image,
    av_opencl_buffer_release,
    av_opencl_uninit,
    av_opencl_benchmark


function av_opencl_get_device_list(device_list)
    ccall((:av_opencl_get_device_list,libavutil),Cint,(Ptr{Ptr{AVOpenCLDeviceList}},),device_list)
end

function av_opencl_free_device_list(device_list)
    ccall((:av_opencl_free_device_list,libavutil),Cvoid,(Ptr{Ptr{AVOpenCLDeviceList}},),device_list)
end

function av_opencl_set_option(key,val)
    ccall((:av_opencl_set_option,libavutil),Cint,(Cstring,Cstring),key,val)
end

function av_opencl_get_option(key,out_val)
    ccall((:av_opencl_get_option,libavutil),Cint,(Cstring,Ptr{Ptr{UInt8}}),key,out_val)
end

function av_opencl_free_option()
    ccall((:av_opencl_free_option,libavutil),Cvoid,())
end

function av_opencl_alloc_external_env()
    ccall((:av_opencl_alloc_external_env,libavutil),Ptr{AVOpenCLExternalEnv},())
end

function av_opencl_free_external_env(ext_opencl_env)
    ccall((:av_opencl_free_external_env,libavutil),Cvoid,(Ptr{Ptr{AVOpenCLExternalEnv}},),ext_opencl_env)
end

function av_opencl_errstr(status::cl_int)
    ccall((:av_opencl_errstr,libavutil),Cstring,(cl_int,),status)
end

function av_opencl_register_kernel_code(kernel_code)
    ccall((:av_opencl_register_kernel_code,libavutil),Cint,(Cstring,),kernel_code)
end

function av_opencl_init(ext_opencl_env)
    ccall((:av_opencl_init,libavutil),Cint,(Ptr{AVOpenCLExternalEnv},),ext_opencl_env)
end

function av_opencl_compile(program_name,build_opts)
    ccall((:av_opencl_compile,libavutil),cl_program,(Cstring,Cstring),program_name,build_opts)
end

function av_opencl_get_command_queue()
    ccall((:av_opencl_get_command_queue,libavutil),cl_command_queue,())
end

function av_opencl_buffer_create(cl_buf,cl_buf_size::Csize_t,flags::Integer,host_ptr)
    ccall((:av_opencl_buffer_create,libavutil),Cint,(Ptr{cl_mem},Csize_t,Cint,Ptr{Cvoid}),cl_buf,cl_buf_size,flags,host_ptr)
end

function av_opencl_buffer_write(dst_cl_buf::cl_mem,src_buf,buf_size::Csize_t)
    ccall((:av_opencl_buffer_write,libavutil),Cint,(cl_mem,Ptr{UInt8},Csize_t),dst_cl_buf,src_buf,buf_size)
end

function av_opencl_buffer_read(dst_buf,src_cl_buf::cl_mem,buf_size::Csize_t)
    ccall((:av_opencl_buffer_read,libavutil),Cint,(Ptr{UInt8},cl_mem,Csize_t),dst_buf,src_cl_buf,buf_size)
end

function av_opencl_buffer_write_image(dst_cl_buf::cl_mem,cl_buffer_size::Csize_t,dst_cl_offset::Integer,src_data,plane_size,plane_num::Integer)
    ccall((:av_opencl_buffer_write_image,libavutil),Cint,(cl_mem,Csize_t,Cint,Ptr{Ptr{UInt8}},Ptr{Cint},Cint),dst_cl_buf,cl_buffer_size,dst_cl_offset,src_data,plane_size,plane_num)
end

function av_opencl_buffer_read_image(dst_data,plane_size,plane_num::Integer,src_cl_buf::cl_mem,cl_buffer_size::Csize_t)
    ccall((:av_opencl_buffer_read_image,libavutil),Cint,(Ptr{Ptr{UInt8}},Ptr{Cint},Cint,cl_mem,Csize_t),dst_data,plane_size,plane_num,src_cl_buf,cl_buffer_size)
end

function av_opencl_buffer_release(cl_buf)
    ccall((:av_opencl_buffer_release,libavutil),Cvoid,(Ptr{cl_mem},),cl_buf)
end

function av_opencl_uninit()
    ccall((:av_opencl_uninit,libavutil),Cvoid,())
end

function av_opencl_benchmark(device,platform::cl_platform_id,benchmark)
    ccall((:av_opencl_benchmark,libavutil),Int64,(Ptr{AVOpenCLDeviceNode},cl_platform_id,Ptr{Cvoid}),device,platform,benchmark)
end
