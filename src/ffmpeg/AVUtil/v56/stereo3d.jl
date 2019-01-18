# Julia wrapper for header: /usr/include/libavutil/stereo3d.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


export
    av_stereo3d_alloc,
    av_stereo3d_create_side_data,
    av_stereo3d_type_name,
    av_stereo3d_from_name


function av_stereo3d_alloc()
    ccall((:av_stereo3d_alloc, libavutil), Ptr{AVStereo3D}, ())
end

function av_stereo3d_create_side_data(frame)
    ccall((:av_stereo3d_create_side_data, libavutil), Ptr{AVStereo3D}, (Ptr{AVFrame},), frame)
end

function av_stereo3d_type_name(_type::Integer)
    ccall((:av_stereo3d_type_name, libavutil), Cstring, (UInt32,), _type)
end

function av_stereo3d_from_name(name)
    ccall((:av_stereo3d_from_name, libavutil), Cint, (Cstring,), name)
end
