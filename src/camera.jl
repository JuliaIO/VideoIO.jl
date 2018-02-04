### Camera Functions

function get_camera_devices(ffmpeg, idev, idev_name)
    CAMERA_DEVICES = String[]

    read_vid_devs = false
    out,err = readall_stdout_stderr(`$ffmpeg -list_devices true -f $idev -i $idev_name`)
    buf = length(out) > 0 ? out : err
    for line in eachline(IOBuffer(buf))
        if contains(line, "video devices")
            read_vid_devs = true
            continue
        elseif contains(line, "audio devices") || contains(line, "exit") || contains(line, "error")
            read_vid_devs = false
            continue
        end

        if read_vid_devs
            m = match(r"""\[.*"(.*)".?""", line)
            if m != nothing
                push!(CAMERA_DEVICES, m.captures[1])
            end

            # Alternative format (TODO: could be combined with the regex above)
            m = match(r"""\[.*\] \[[0-9]\] (.*)""", line)
            if m != nothing
                push!(CAMERA_DEVICES, m.captures[1])
            end
        end
    end

    return CAMERA_DEVICES
end

if is_windows()
    ffmpeg = joinpath(dirname(@__FILE__), "..", "deps", "ffmpeg-2.2.3-win$WORD_SIZE-shared", "bin", "ffmpeg.exe")

    DEFAULT_CAMERA_FORMAT = AVFormat.av_find_input_format("dshow")
    CAMERA_DEVICES = get_camera_devices(ffmpeg, "dshow", "dummy")
    DEFAULT_CAMERA_DEVICE = length(CAMERA_DEVICES) > 0 ? CAMERA_DEVICES[1] : "0"

end

if is_linux()
    import Glob
    DEFAULT_CAMERA_FORMAT = AVFormat.av_find_input_format("video4linux2")
    CAMERA_DEVICES = Glob.glob("video*", "/dev")
    DEFAULT_CAMERA_DEVICE = length(CAMERA_DEVICES) > 0 ? CAMERA_DEVICES[1] : ""
end

if is_apple()
    ffmpeg = joinpath(INSTALL_ROOT, "bin", "ffmpeg")

    DEFAULT_CAMERA_FORMAT = AVFormat.av_find_input_format("avfoundation")
    global CAMERA_DEVICES = String[]
    try
        CAMERA_DEVICES = get_camera_devices(ffmpeg, "avfoundation", "\"\"")
    catch
        try
            CAMERA_DEVICES = get_camera_devices(ffmpeg, "qtkit", "\"\"")
        end
    end

    DEFAULT_CAMERA_DEVICE = length(CAMERA_DEVICES) > 0 ? CAMERA_DEVICES[1] : "FaceTime"
    #DEFAULT_CAMERA_DEVICE = "Integrated"
end

function opencamera(device=DEFAULT_CAMERA_DEVICE, format=DEFAULT_CAMERA_FORMAT, args...; kwargs...)
    camera = AVInput(device, format)
    VideoReader(camera, args...; kwargs...)
end
