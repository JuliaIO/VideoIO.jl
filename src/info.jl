# For reading information & metadata about the file

function _get_fc(file::String) # convenience function for `get_duration` and `get_start_time`
    v = open(file)
    return v.format_context, v
end
get_duration(fc::AVFormatContextPtr) = fc.duration / AV_TIME_BASE

"""
    get_duration(file::String) -> Float64

Return the duration of the video `file` in seconds (float).
"""
function get_duration(file::String)
    fc, v = _get_fc(file)
    duration = get_duration(fc)
    close(v)
    return duration
end

get_start_time(fc::AVFormatContextPtr) = Dates.unix2datetime(fc.start_time_realtime)

"""
    get_start_time(file::String) -> DateTime

Return the starting date & time of the video `file`. Note that if the starting date & time are missing, this function will return the Unix epoch (00:00 1st January 1970).
"""
function get_start_time(file::String)
    fc, v = _get_fc(file)
    starttime = get_start_time(fc)
    close(v)
    return starttime
end

get_time_duration(fc::AVFormatContextPtr) = (get_start_time(fc), get_duration(fc))

"""
    get_time_duration(file::String) -> (DateTime, Microsecond)

Return the starting date & time as well as the duration of the video `file`. Note that if the starting date & time are missing, this function will return the Unix epoch (00:00 1st January 1970).
"""
function get_time_duration(file::String)
    fc, v = _get_fc(file)
    starttime, duration = get_time_duration(fc)
    close(v)
    return starttime, duration
end

"""
    get_number_frames(file [, streamno])

Query the the container `file` for the number of frames in video stream
`streamno` if applicable, instead returning `nothing` if the container does not
report the number of frames. Will not decode the video to count the number of
frames in a video.
"""
function get_number_frames(file::AbstractString, streamno::Integer = 0)
    streamno >= 0 || throw(ArgumentError("streamno must be non-negative"))
    frame_strs = FFMPEG.exe(
        `-v error -select_streams v:$(streamno) -show_entries
        stream=nb_frames -of
        default=nokey=1:noprint_wrappers=1 $file`,
        command = FFMPEG.ffprobe,
        collect = true,
    )
    frame_str = frame_strs[1]
    if occursin("No such file or directory", frame_str)
        error("Could not find file $file")
    elseif occursin("N/A", frame_str)
        return nothing
    end
    return parse(Int, frame_str)
end
