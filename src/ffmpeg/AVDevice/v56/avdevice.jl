# Julia wrapper for header: /usr/local/ffmpeg/2.4/include/libavdevice/avdevice.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


export
    #avdevice_version,
    avdevice_configuration,
    avdevice_license,
    avdevice_register_all,
    av_input_audio_device_next,
    av_input_video_device_next,
    av_output_audio_device_next,
    av_output_video_device_next,
    avdevice_app_to_dev_control_message,
    avdevice_dev_to_app_control_message,
    avdevice_capabilities_create,
    avdevice_capabilities_free,
    avdevice_list_devices,
    avdevice_free_list_devices


function avdevice_version()
    ccall((:avdevice_version,libavdevice),Uint32,())
end

function avdevice_configuration()
    ccall((:avdevice_configuration,libavdevice),Ptr{Uint8},())
end

function avdevice_license()
    ccall((:avdevice_license,libavdevice),Ptr{Uint8},())
end

function avdevice_register_all()
    ccall((:avdevice_register_all,libavdevice),Void,())
end

function av_input_audio_device_next(d)
    ccall((:av_input_audio_device_next,libavdevice),Ptr{AVInputFormat},(Ptr{AVInputFormat},),d)
end

function av_input_video_device_next(d)
    ccall((:av_input_video_device_next,libavdevice),Ptr{AVInputFormat},(Ptr{AVInputFormat},),d)
end

function av_output_audio_device_next(d)
    ccall((:av_output_audio_device_next,libavdevice),Ptr{AVOutputFormat},(Ptr{AVOutputFormat},),d)
end

function av_output_video_device_next(d)
    ccall((:av_output_video_device_next,libavdevice),Ptr{AVOutputFormat},(Ptr{AVOutputFormat},),d)
end

function avdevice_app_to_dev_control_message(s,_type::AVAppToDevMessageType,data,data_size::Csize_t)
    ccall((:avdevice_app_to_dev_control_message,libavdevice),Cint,(Ptr{AVFormatContext},AVAppToDevMessageType,Ptr{Void},Csize_t),s,_type,data,data_size)
end

function avdevice_dev_to_app_control_message(s,_type::AVDevToAppMessageType,data,data_size::Csize_t)
    ccall((:avdevice_dev_to_app_control_message,libavdevice),Cint,(Ptr{AVFormatContext},AVDevToAppMessageType,Ptr{Void},Csize_t),s,_type,data,data_size)
end

function avdevice_capabilities_create(caps,s,device_options)
    #ccall((:avdevice_capabilities_create,libavdevice),Cint,(Ptr{Ptr{AVDeviceCapabilitiesQuery}},Ptr{AVFormatContext},Ptr{Ptr{AVDictionary}}),caps,s,device_options)
    ccall((:avdevice_capabilities_create,libavdevice),Cint,(Ptr{Ptr{Void}},Ptr{AVFormatContext},Ptr{Ptr{AVDictionary}}),caps,s,device_options)
end

function avdevice_capabilities_free(caps,s)
    ccall((:avdevice_capabilities_free,libavdevice),Void,(Ptr{Ptr{AVDeviceCapabilitiesQuery}},Ptr{AVFormatContext}),caps,s)
end

function avdevice_list_devices(s,device_list)
    ccall((:avdevice_list_devices,libavdevice),Cint,(Ptr{AVFormatContext},Ptr{Ptr{AVDeviceInfoList}}),s,device_list)
end

function avdevice_free_list_devices(device_list)
    ccall((:avdevice_free_list_devices,libavdevice),Void,(Ptr{Ptr{AVDeviceInfoList}},),device_list)
end
