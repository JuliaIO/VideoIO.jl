# For reading information & metadata about the file

function _get_fc(file::String) # convenience function for `get_duration` and `get_start_time`
    v = open(file)
    return unsafe_load(v.apFormatContext[1])
end
get_duration(fc::AVFormatContext) = fc.duration / 1e6

"""
    get_duration(file::String) -> Float64

Return the duration of the video `file` in seconds (float).
"""
get_duration(file::String) = get_duration(_get_fc(file))

get_start_time(fc::AVFormatContext) = Dates.unix2datetime(fc.start_time_realtime)

"""
    get_start_time(file::String) -> DateTime

Return the starting date & time of the video `file`. Note that if the starting date & time are missing, this function will return the Unix epoch (00:00 1st January 1970).
"""
get_start_time(file::String) = get_start_time(_get_fc(file))

get_time_duration(fc::AVFormatContext) = (get_start_time(fc), get_duration(fc))

"""
    get_time_duration(file::String) -> (DateTime, Microsecond)

Return the starting date & time as well as the duration of the video `file`. Note that if the starting date & time are missing, this function will return the Unix epoch (00:00 1st January 1970).
"""
get_time_duration(file::String) = get_time_duration(_get_fc(file))

"""
    get_number_frames(file [, streamno])

Query the the container `file` for the number of frames in video stream
`streamno` if applicable, instead returning `nothing` if the container does not
report the number of frames. Will not decode the video to count the number of
frames in a video.
"""
function get_number_frames(file::AbstractString, streamno::Integer = 0)
    streamno >= 0 || throw(ArgumentError("streamno must be non-negative"))
    frame_strs = FFMPEG.exe(`-v error -select_streams v:$(streamno) -show_entries
                            stream=nb_frames -of
                            default=nokey=1:noprint_wrappers=1 $file`,
                           command = FFMPEG.ffprobe, collect = true)
    frame_str = frame_strs[1]
    if occursin("No such file or directory", frame_str)
        error("Could not find file $file")
    elseif occursin("N/A", frame_str)
        return nothing
    end
    return parse(Int, frame_str)
end
