# Julia wrapper for header: /usr/include/libavutil/cpu.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


function av_get_cpu_flags()
    ccall((:av_get_cpu_flags,libavutil),Cint,())
end
function ff_get_cpu_flags_arm()
    ccall((:ff_get_cpu_flags_arm,libavutil),Cint,())
end
function ff_get_cpu_flags_ppc()
    ccall((:ff_get_cpu_flags_ppc,libavutil),Cint,())
end
function ff_get_cpu_flags_x86()
    ccall((:ff_get_cpu_flags_x86,libavutil),Cint,())
end
