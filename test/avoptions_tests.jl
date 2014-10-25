using Base.Test
using VideoIO

println("Now testing the AVOptions API")

# Test whether there are any FFmpeg-enabled input devices and formats
devices_list = discover_devices()
if isempty(devices_list)
    error("Cannot detect any FFmpeg-enabled input video devices!")
else
    println("Test#1: Detected input video devices... Passed")
end

# Test whether the default camera device is detectable
f = opencamera(VideoIO.DEFAULT_CAMERA_DEVICE, VideoIO.DEFAULT_CAMERA_FORMAT)
if isempty(f)
    error("Cannot detect a default video device/format, so you will have to set it manually!")
else
    println("Test#2: Detected default camera $(VideoIO.DEFAULT_CAMERA_DEVICE) and its format... Passed")
end

if !isempty(f)
   OptionsDictionary = document_all_options(f.avin, true)
   isempty(OptionsDictionary)? error("Cannot access the AVOptions API"):
    println("Test#3: Detected $(length(OptionsDictionary)) options in the AVOptions API... Passed")

end


# Close the camera input
close(f)








