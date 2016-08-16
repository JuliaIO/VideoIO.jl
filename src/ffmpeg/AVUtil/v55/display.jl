# Julia wrapper for header: /usr/local/include/libavutil/display.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


export
    av_display_rotation_get,
    av_display_rotation_set,
    av_display_matrix_flip


function av_display_rotation_get(matrix::NTuple{9,Int32})
    ccall((:av_display_rotation_get,libavutil),Cdouble,(NTuple{9,Int32},),matrix)
end

function av_display_rotation_set(matrix::NTuple{9,Int32},angle::Cdouble)
    ccall((:av_display_rotation_set,libavutil),Void,(NTuple{9,Int32},Cdouble),matrix,angle)
end

function av_display_matrix_flip(matrix::NTuple{9,Int32},hflip::Integer,vflip::Integer)
    ccall((:av_display_matrix_flip,libavutil),Void,(NTuple{9,Int32},Cint,Cint),matrix,hflip,vflip)
end
