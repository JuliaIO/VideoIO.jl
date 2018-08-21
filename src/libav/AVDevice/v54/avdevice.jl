# Julia wrapper for header: /usr/local/include/libavdevice/avdevice.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


export
    #avdevice_version,
    avdevice_configuration,
    avdevice_license,
    avdevice_register_all


function avdevice_version()
    ccall((:avdevice_version,libavdevice),UInt32,())
end

function avdevice_configuration()
    ccall((:avdevice_configuration,libavdevice),Ptr{UInt8},())
end

function avdevice_license()
    ccall((:avdevice_license,libavdevice),Ptr{UInt8},())
end

function avdevice_register_all()
    ccall((:avdevice_register_all,libavdevice),Cvoid,())
end
