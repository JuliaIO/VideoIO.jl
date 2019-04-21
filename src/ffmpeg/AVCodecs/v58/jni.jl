# Julia wrapper for header: /usr/include/libavcodec/jni.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


export
    av_jni_set_java_vm,
    av_jni_get_java_vm


function av_jni_set_java_vm(vm, log_ctx)
    ccall((:av_jni_set_java_vm, libavcodec), Cint, (Ptr{Cvoid}, Ptr{Cvoid}), vm, log_ctx)
end

function av_jni_get_java_vm(log_ctx)
    ccall((:av_jni_get_java_vm, libavcodec), Ptr{Cvoid}, (Ptr{Cvoid},), log_ctx)
end
