var documenterSearchIndex = {"docs":
[{"location":"functionindex/#Index","page":"Index","title":"Index","text":"","category":"section"},{"location":"functionindex/","page":"Index","title":"Index","text":"","category":"page"},{"location":"utilities/#Utilities","page":"Utilities","title":"Utilities","text":"","category":"section"},{"location":"utilities/#Test-Videos","page":"Utilities","title":"Test Videos","text":"","category":"section"},{"location":"utilities/","page":"Utilities","title":"Utilities","text":"A small number of test videos are available through VideoIO.TestVideos. These are short videos in a variety of formats with non-restrictive (public domain or Creative Commons) licenses.","category":"page"},{"location":"utilities/","page":"Utilities","title":"Utilities","text":"VideoIO.TestVideos.available","category":"page"},{"location":"utilities/#VideoIO.TestVideos.available","page":"Utilities","title":"VideoIO.TestVideos.available","text":"available()\n\nPrint a list of all available test videos.\n\n\n\n\n\n","category":"function"},{"location":"utilities/","page":"Utilities","title":"Utilities","text":"VideoIO.testvideo","category":"page"},{"location":"utilities/#VideoIO.TestVideos.testvideo","page":"Utilities","title":"VideoIO.TestVideos.testvideo","text":"testvideo(name, ops...)\n\nReturns an AVInput object for the given video name. The video will be downloaded if it isn't available.\n\n\n\n\n\n","category":"function"},{"location":"utilities/","page":"Utilities","title":"Utilities","text":"VideoIO.TestVideos.download_all","category":"page"},{"location":"utilities/#VideoIO.TestVideos.download_all","page":"Utilities","title":"VideoIO.TestVideos.download_all","text":"download_all()\n\nDownloads all test videos.\n\n\n\n\n\n","category":"function"},{"location":"utilities/","page":"Utilities","title":"Utilities","text":"VideoIO.TestVideos.remove_all","category":"page"},{"location":"utilities/#VideoIO.TestVideos.remove_all","page":"Utilities","title":"VideoIO.TestVideos.remove_all","text":"remove_all()\n\nRemove all test videos.\n\n\n\n\n\n","category":"function"},{"location":"lowlevel/#Low-level-functionality","page":"Low Level Functionality","title":"Low level functionality","text":"","category":"section"},{"location":"lowlevel/#FFMPEG-log-level","page":"Low Level Functionality","title":"FFMPEG log level","text":"","category":"section"},{"location":"lowlevel/","page":"Low Level Functionality","title":"Low Level Functionality","text":"FFMPEG's built-in logging and warning level can be read and set with","category":"page"},{"location":"lowlevel/","page":"Low Level Functionality","title":"Low Level Functionality","text":"VideoIO.loglevel!","category":"page"},{"location":"lowlevel/#VideoIO.loglevel!","page":"Low Level Functionality","title":"VideoIO.loglevel!","text":"loglevel!(loglevel::Integer)\n\nSet FFMPEG log level. Options are:\n\nVideoIO.AVUtil.AV_LOG_QUIET\nVideoIO.AVUtil.AV_LOG_PANIC\nVideoIO.AVUtil.AV_LOG_FATAL\nVideoIO.AVUtil.AV_LOG_ERROR\nVideoIO.AVUtil.AV_LOG_WARNING\nVideoIO.AVUtil.AV_LOG_INFO\nVideoIO.AVUtil.AV_LOG_VERBOSE\nVideoIO.AVUtil.AV_LOG_DEBUG\nVideoIO.AVUtil.AV_LOG_TRACE\n\n\n\n\n\n","category":"function"},{"location":"lowlevel/","page":"Low Level Functionality","title":"Low Level Functionality","text":"VideoIO.loglevel","category":"page"},{"location":"lowlevel/#VideoIO.loglevel","page":"Low Level Functionality","title":"VideoIO.loglevel","text":"loglevel() -> String\n\nGet FFMPEG log level as a variable name string.\n\n\n\n\n\n","category":"function"},{"location":"lowlevel/#FFMPEG-interface","page":"Low Level Functionality","title":"FFMPEG interface","text":"","category":"section"},{"location":"lowlevel/","page":"Low Level Functionality","title":"Low Level Functionality","text":"Each ffmpeg library has its own VideoIO subpackage:","category":"page"},{"location":"lowlevel/","page":"Low Level Functionality","title":"Low Level Functionality","text":"libavcodec    -> AVCodecs\nlibavdevice   -> AVDevice\nlibavfilter   -> AVFilters\nlibavformat   -> AVFormat\nlibavutil     -> AVUtil\nlibswscale    -> SWScale","category":"page"},{"location":"lowlevel/","page":"Low Level Functionality","title":"Low Level Functionality","text":"The following three files are related to ffmpeg, but currently not exposed:","category":"page"},{"location":"lowlevel/","page":"Low Level Functionality","title":"Low Level Functionality","text":"libswresample -> SWResample\nlibpostproc   -> PostProc   (not wrapped)","category":"page"},{"location":"lowlevel/","page":"Low Level Functionality","title":"Low Level Functionality","text":"After importing VideoIO, you can import and use any of the subpackages directly","category":"page"},{"location":"lowlevel/","page":"Low Level Functionality","title":"Low Level Functionality","text":"import VideoIO\nimport SWResample  # SWResample functions are now available","category":"page"},{"location":"lowlevel/","page":"Low Level Functionality","title":"Low Level Functionality","text":"Note that much of the functionality of these subpackages is not enabled by default, to avoid long compilation times as they load.  To control what is loaded, each library version has a file which imports that's modules files.  For example, ffmpeg's libswscale-v2 files are loaded by VideoIO_PKG_DIR/src/ffmpeg/SWScale/v2/LIBSWSCALE.jl.","category":"page"},{"location":"lowlevel/","page":"Low Level Functionality","title":"Low Level Functionality","text":"Check these files to enable any needed functionality that isn't already enabled. Note that you'll probably need to do this for each version of the package for ffmpeg, and that the interfaces do change some from version to version.","category":"page"},{"location":"lowlevel/","page":"Low Level Functionality","title":"Low Level Functionality","text":"Note that, in general, the low-level functions are not very fun to use, so it is good to focus initially on enabling a nice, higher-level function for these interfaces.","category":"page"},{"location":"#Introduction","page":"Introduction","title":"Introduction","text":"","category":"section"},{"location":"","page":"Introduction","title":"Introduction","text":"This library provides methods for reading and writing video files.","category":"page"},{"location":"","page":"Introduction","title":"Introduction","text":"Functionality is based on a dedicated build of ffmpeg, provided via JuliaPackaging/Yggdrasil","category":"page"},{"location":"","page":"Introduction","title":"Introduction","text":"Explore the source at github.com/JuliaIO/VideoIO.jl","category":"page"},{"location":"#Platform-Nodes:","page":"Introduction","title":"Platform Nodes:","text":"","category":"section"},{"location":"","page":"Introduction","title":"Introduction","text":"ARM: For truly lossless reading & writing, there is a known issue on ARM that results in small precision differences when reading/writing some video files. As such, tests for frame comparison are currently skipped on ARM. Issues/PRs welcome for helping to get this fixed.","category":"page"},{"location":"#Installation","page":"Introduction","title":"Installation","text":"","category":"section"},{"location":"","page":"Introduction","title":"Introduction","text":"The package can be installed with the Julia package manager. From the Julia REPL, type ] to enter the Pkg REPL mode and run:","category":"page"},{"location":"","page":"Introduction","title":"Introduction","text":"pkg> add VideoIO","category":"page"},{"location":"","page":"Introduction","title":"Introduction","text":"Or, equivalently, via the Pkg API:","category":"page"},{"location":"","page":"Introduction","title":"Introduction","text":"julia> import Pkg; Pkg.add(\"VideoIO\")","category":"page"},{"location":"reading/#Video-Reading","page":"Reading Videos","title":"Video Reading","text":"","category":"section"},{"location":"reading/","page":"Reading Videos","title":"Reading Videos","text":"Note: Reading of audio streams is not yet implemented","category":"page"},{"location":"reading/#Reading-Video-Files","page":"Reading Videos","title":"Reading Video Files","text":"","category":"section"},{"location":"reading/","page":"Reading Videos","title":"Reading Videos","text":"VideoIO contains a simple high-level interface which allows reading of video frames from a supported video file (or from a camera device, shown later).","category":"page"},{"location":"reading/","page":"Reading Videos","title":"Reading Videos","text":"The simplest form will load the entire video into memory as a vector of image arrays.","category":"page"},{"location":"reading/","page":"Reading Videos","title":"Reading Videos","text":"using VideoIO\nVideoIO.load(\"video.mp4\")","category":"page"},{"location":"reading/","page":"Reading Videos","title":"Reading Videos","text":"VideoIO.load","category":"page"},{"location":"reading/#VideoIO.load","page":"Reading Videos","title":"VideoIO.load","text":"load(filename::String, args...; kwargs...)\n\nLoad video file filename into memory as vector of image arrays, setting args and kwargs on the openvideo process.\n\n\n\n\n\n","category":"function"},{"location":"reading/","page":"Reading Videos","title":"Reading Videos","text":"Frames can be read sequentially until the end of the file:","category":"page"},{"location":"reading/","page":"Reading Videos","title":"Reading Videos","text":"using VideoIO\n\n# Construct a AVInput object to access the video and audio streams in a video container\n# io = VideoIO.open(video_file)\nio = VideoIO.testvideo(\"annie_oakley\") # for testing purposes\n\n# Access the video stream in an AVInput, and return a VideoReader object:\nf = VideoIO.openvideo(io) # you can also use a file name, instead of a AVInput\n\nimg = read(f)\n\nwhile !eof(f)\n    read!(f, img)\n    # Do something with frames\nend\nclose(f)","category":"page"},{"location":"reading/","page":"Reading Videos","title":"Reading Videos","text":"VideoIO.openvideo","category":"page"},{"location":"reading/#VideoIO.openvideo","page":"Reading Videos","title":"VideoIO.openvideo","text":"openvideo(file[, video_stream = 1]; <keyword arguments>) -> reader\nopenvideo(f, ...)\n\nOpen file and create an object to read and decode video stream number video_stream. file can either be a AVInput created by VideoIO.open, the name of a file as an AbstractString, or instead an IO object. However, support for IO objects is incomplete, and does not currently work with common video containers such as *.mp4 files.\n\nFrames can be read from the reader with read or read!, or alternatively by using the iterator interface provided for reader. To close the reader, simply use close. Seeking within the reader can be accomplished using seek, seekstart. Frames can be skipped with skipframe, or skipframes. The current time in the video stream can be accessed with gettime. Details about the frame dimension can be found with out_frame_size. The total number of frames can be found with counttotalframes.\n\nIf called with a single argument function as the first argument, the reader will be passed to the function, and will be closed once the call returns whether or not an error occurred.\n\nThe decoder options and conversion to Julia arrays is controlled by the keyword arguments listed below.\n\nKeyword arguments\n\ntranscode::Bool = true: Determines whether decoded frames are transferred   into a Julia matrix with easily interpretable element type, or instead   returned as raw byte buffers.\ntarget_format::Union{Nothing, Cint} = nothing: Determines the target pixel   format that decoded frames will be transformed into before being transferred   to an output array. This can either by a VideoIO.AV_PIX_FMT_* value   corresponding to a FFmpeg   AVPixelFormat,   and must then also be a format supported by the VideoIO, or instead   nothing, in which case the format will be automatically chosen by FFmpeg.   This list of currently supported pixel formats, and the matrix element type   that each pixel format corresponds with, are elements of   VideoIO.VIO_PIX_FMT_DEF_ELTYPE_LU.\npix_fmt_loss_flags = 0: Loss flags to control how transfer pixel format is   chosen. Only valid if target_format = nothing. Flags must correspond to   FFmpeg   loss flags.\ntarget_colorspace_details = nothing: Information about the color space   of output Julia arrays. If nothing, then this will correspond to a   best-effort interpretation of Colors.jl for the corresponding element   type. To override these defaults, create a VideoIO.VioColorspaceDetails   object using the appropriate AVCOL_ definitions from FFmpeg, or use   VideoIO.VioColorspaceDetails() to use the FFmpeg defaults. To avoid   rescaling limited color range data (mpeg) to full color range output (jpeg),   then set this to VideoIO.VioColorspaceDetails() to avoid additional   scaling by sws_scale.\nallow_vio_gray_transform = true: Instead of using sws_scale for gray data,   use a more accurate color space transformation implemented in VideoIO if   allow_vio_gray_gransform = true. Otherwise, use sws_scale.\nswscale_options::OptionsT = (;): A Namedtuple, or Dict{Symbol, Any} of   options for the swscale object used to perform color space scaling. Options   must correspond with options for FFmpeg's   scaler filter.\nsws_color_options::OptionsT = (;): Additional keyword arguments passed to   sws_setColorspaceDetails.\n\n\n\n\n\n","category":"function"},{"location":"reading/","page":"Reading Videos","title":"Reading Videos","text":"Alternatively, you can open the video stream in a file directly with VideoIO.openvideo(filename), without making an intermediate AVInput object, if you only need the video.","category":"page"},{"location":"reading/","page":"Reading Videos","title":"Reading Videos","text":"VideoIO also provides an iterator interface for VideoReader, which behaves like other mutable iterators in Julia (e.g. Channels). If iteration is stopped early, for example with a break statement, then it can be resumed in the same spot by iterating on the same VideoReader object. Consequently, if you have already iterated over all the frames of a VideoReader object, then it will be empty for further iteration unless its position in the video is changed with seek.","category":"page"},{"location":"reading/","page":"Reading Videos","title":"Reading Videos","text":"using VideoIO\n\nf = VideoIO.openvideo(\"video.mp4\")\nfor img in f\n    # Do something with img\nend\n# Alternatively use collect(f) to get all of the frames\n\n# Further iteration will show that f is now empty\n@assert isempty(f)\n\nclose(f)","category":"page"},{"location":"reading/","page":"Reading Videos","title":"Reading Videos","text":"Seeking through the video can be achieved via seek(f, seconds::Float64) and seekstart(f) to return to the start.","category":"page"},{"location":"reading/","page":"Reading Videos","title":"Reading Videos","text":"VideoIO.seek","category":"page"},{"location":"reading/#Base.seek","page":"Reading Videos","title":"Base.seek","text":"seek(reader::VideoReader, seconds)\n\nSeeks into the parent AVInput using this video stream's index. See [seek] for AVInput.\n\n\n\n\n\nseek(avin::AVInput, seconds::AbstractFloat, video_stream::Integer=1)\n\nSeek through the container format avin so that the next frame returned by the stream indicated by video_stream will have a timestamp greater than or equal to seconds.\n\n\n\n\n\n","category":"function"},{"location":"reading/","page":"Reading Videos","title":"Reading Videos","text":"VideoIO.seekstart","category":"page"},{"location":"reading/#Base.seekstart","page":"Reading Videos","title":"Base.seekstart","text":"seekstart(reader::VideoReader)\n\nSeek to time zero of the parent AVInput using reader's stream index. See seekstart for AVInput objects.\n\n\n\n\n\nseekstart(avin::AVInput{T}, video_stream_index=1) where T <: AbstractString\n\nSeek to time zero of AVInput object.\n\n\n\n\n\n","category":"function"},{"location":"reading/","page":"Reading Videos","title":"Reading Videos","text":"Frames can be skipped without reading frame content via skipframe(f) and skipframes(f, n)","category":"page"},{"location":"reading/","page":"Reading Videos","title":"Reading Videos","text":"VideoIO.skipframe","category":"page"},{"location":"reading/#VideoIO.skipframe","page":"Reading Videos","title":"VideoIO.skipframe","text":"skipframe(s::VideoReader; throwEOF=true)\n\nSkip the next frame. If End of File is reached, EOFError thrown if throwEOF=true. Otherwise returns true if EOF reached, false otherwise.\n\n\n\n\n\n","category":"function"},{"location":"reading/","page":"Reading Videos","title":"Reading Videos","text":"VideoIO.skipframes","category":"page"},{"location":"reading/#VideoIO.skipframes","page":"Reading Videos","title":"VideoIO.skipframes","text":"skipframes(s::VideoReader, n::Int; throwEOF=true) -> n\n\nSkip the next n frames. If End of File is reached and throwEOF=true, a EOFError will be thrown. Returns the number of frames that were skipped.\n\n\n\n\n\n","category":"function"},{"location":"reading/","page":"Reading Videos","title":"Reading Videos","text":"Total available frame count is available via counttotalframes(f)","category":"page"},{"location":"reading/","page":"Reading Videos","title":"Reading Videos","text":"VideoIO.counttotalframes","category":"page"},{"location":"reading/#VideoIO.counttotalframes","page":"Reading Videos","title":"VideoIO.counttotalframes","text":"counttotalframes(reader) -> n::Int\n\nCount the total number of frames in the video by seeking to start, skipping through each frame, and seeking back to the start.\n\nFor a faster alternative that relies on video container metadata, try get_number_frames.\n\n\n\n\n\n","category":"function"},{"location":"reading/","page":"Reading Videos","title":"Reading Videos","text":"!!! note H264 videos encoded with crf>0 have been observed to have 4-fewer frames available for reading.","category":"page"},{"location":"reading/#Changing-the-target-pixel-format-for-reading","page":"Reading Videos","title":"Changing the target pixel format for reading","text":"","category":"section"},{"location":"reading/","page":"Reading Videos","title":"Reading Videos","text":"It can be helpful to be explicit in which pixel format you wish to read frames as. Here a grayscale video is read and parsed into a Vector(Array{UInt8}}","category":"page"},{"location":"reading/","page":"Reading Videos","title":"Reading Videos","text":"f = VideoIO.openvideo(filename, target_format=VideoIO.AV_PIX_FMT_GRAY8)\n\nwhile !eof(f)\n    img = reinterpret(UInt8, read(f))\nend\nclose(f)","category":"page"},{"location":"reading/#Video-Playback","page":"Reading Videos","title":"Video Playback","text":"","category":"section"},{"location":"reading/","page":"Reading Videos","title":"Reading Videos","text":"A trivial video player interface exists (no audio) through GLMakie.jl. Note: GLMakie must be imported first to enable playback functionality.","category":"page"},{"location":"reading/","page":"Reading Videos","title":"Reading Videos","text":"using GLMakie\nusing VideoIO\n\nf = VideoIO.testvideo(\"annie_oakley\")  # downloaded if not available\nVideoIO.playvideo(f)  # no sound","category":"page"},{"location":"reading/","page":"Reading Videos","title":"Reading Videos","text":"Customization of playback can be achieved by looking at the basic expanded version of this function:","category":"page"},{"location":"reading/","page":"Reading Videos","title":"Reading Videos","text":"import GLMakie\nimport VideoIO\n\n#io = VideoIO.open(video_file)\nio = VideoIO.testvideo(\"annie_oakley\") # for testing purposes\nf = VideoIO.openvideo(io)\n\nimg = read(f)\nscene = GLMakie.Scene(resolution = reverse(size(img)))\nmakieimg = GLMakie.image!(scene, img, show_axis = false, scale_plot = true)\nGLMakie.rotate!(scene, -0.5pi)\ndisplay(scene)\n\nwhile !eof(f)\n    read!(f, img)\n    makieimg.image = img\n    sleep(1/VideoIO.framerate(f))\nend","category":"page"},{"location":"reading/","page":"Reading Videos","title":"Reading Videos","text":"This code is essentially the code in playvideo, and will read and (without the sleep) play a movie file as fast as possible.","category":"page"},{"location":"reading/#Reading-Camera-Output","page":"Reading Videos","title":"Reading Camera Output","text":"","category":"section"},{"location":"reading/","page":"Reading Videos","title":"Reading Videos","text":"Frames can be read iteratively","category":"page"},{"location":"reading/","page":"Reading Videos","title":"Reading Videos","text":"using VideoIO\ncam = VideoIO.opencamera()\nfor i in 1:100\n    img = read(cam)\n    sleep(1/VideoIO.framerate(cam))\nend","category":"page"},{"location":"reading/#Webcam-playback","page":"Reading Videos","title":"Webcam playback","text":"","category":"section"},{"location":"reading/","page":"Reading Videos","title":"Reading Videos","text":"The default system webcam can be viewed directly","category":"page"},{"location":"reading/","page":"Reading Videos","title":"Reading Videos","text":"using GLMakie\nusing VideoIO\nVideoIO.viewcam()","category":"page"},{"location":"reading/","page":"Reading Videos","title":"Reading Videos","text":"An expanded version of this approach:","category":"page"},{"location":"reading/","page":"Reading Videos","title":"Reading Videos","text":"import GLMakie, VideoIO\n\ncam = VideoIO.opencamera()\n\nimg = read(cam)\nscene = GLMakie.Scene(resolution = size(img'))\nmakieimg = GLMakie.image!(scene, img, show_axis = false, scale_plot = false)\nGLMakie.rotate!(scene, -0.5pi)\ndisplay(scene)\n\nwhile isopen(scene)\n    read!(cam, img)\n    makieimg.image = img\n    sleep(1/VideoIO.framerate(cam))\nend\n\nclose(cam)","category":"page"},{"location":"reading/#Video-Properties-and-Metadata","page":"Reading Videos","title":"Video Properties & Metadata","text":"","category":"section"},{"location":"reading/","page":"Reading Videos","title":"Reading Videos","text":"VideoIO.get_start_time","category":"page"},{"location":"reading/#VideoIO.get_start_time","page":"Reading Videos","title":"VideoIO.get_start_time","text":"get_start_time(file::String) -> DateTime\n\nReturn the starting date & time of the video file. Note that if the starting date & time are missing, this function will return the Unix epoch (00:00 1st January 1970).\n\n\n\n\n\n","category":"function"},{"location":"reading/","page":"Reading Videos","title":"Reading Videos","text":"VideoIO.get_time_duration","category":"page"},{"location":"reading/#VideoIO.get_time_duration","page":"Reading Videos","title":"VideoIO.get_time_duration","text":"get_time_duration(file::String) -> (DateTime, Microsecond)\n\nReturn the starting date & time as well as the duration of the video file. Note that if the starting date & time are missing, this function will return the Unix epoch (00:00 1st January 1970).\n\n\n\n\n\n","category":"function"},{"location":"reading/","page":"Reading Videos","title":"Reading Videos","text":"VideoIO.get_duration","category":"page"},{"location":"reading/#VideoIO.get_duration","page":"Reading Videos","title":"VideoIO.get_duration","text":"get_duration(file::String) -> Float64\n\nReturn the duration of the video file in seconds (float).\n\n\n\n\n\n","category":"function"},{"location":"reading/","page":"Reading Videos","title":"Reading Videos","text":"VideoIO.get_number_frames","category":"page"},{"location":"reading/#VideoIO.get_number_frames","page":"Reading Videos","title":"VideoIO.get_number_frames","text":"get_number_frames(file [, streamno])\n\nQuery the the container file for the number of frames in video stream streamno if applicable, instead returning nothing if the container does not report the number of frames. Will not decode the video to count the number of frames in a video.\n\n\n\n\n\n","category":"function"},{"location":"writing/#Writing-Videos","page":"Writing Videos","title":"Writing Videos","text":"","category":"section"},{"location":"writing/","page":"Writing Videos","title":"Writing Videos","text":"Note: Writing of audio streams is not yet implemented","category":"page"},{"location":"writing/#Single-step-Encoding","page":"Writing Videos","title":"Single-step Encoding","text":"","category":"section"},{"location":"writing/","page":"Writing Videos","title":"Writing Videos","text":"Videos can be encoded directly from image stack using VideoIO.save(filename::String, imgstack::Array) where imgstack is an array of image arrays with identical type and size.","category":"page"},{"location":"writing/","page":"Writing Videos","title":"Writing Videos","text":"The entire image stack can be encoded in a single step:","category":"page"},{"location":"writing/","page":"Writing Videos","title":"Writing Videos","text":"import VideoIO\nencoder_options = (crf=23, preset=\"medium\")\nVideoIO.save(\"video.mp4\", imgstack, framerate=30, encoder_options=encoder_options)","category":"page"},{"location":"writing/","page":"Writing Videos","title":"Writing Videos","text":"VideoIO.save","category":"page"},{"location":"writing/#VideoIO.save","page":"Writing Videos","title":"VideoIO.save","text":"save(filename::String, imgstack; ...)\n\nCreate a video container filename and encode the set of frames imgstack into it. imgstack must be an iterable of matrices and each frame must have the same dimensions and element type.\n\nEncoding options, restrictions on frame size and element type, and other details are described in open_video_out. All keyword arguments are passed to open_video_out.\n\nSee also: open_video_out, write, close_video_out!\n\n\n\n\n\n","category":"function"},{"location":"writing/#Iterative-Encoding","page":"Writing Videos","title":"Iterative Encoding","text":"","category":"section"},{"location":"writing/","page":"Writing Videos","title":"Writing Videos","text":"Alternatively, videos can be encoded iteratively within custom loops.","category":"page"},{"location":"writing/","page":"Writing Videos","title":"Writing Videos","text":"using VideoIO\nframestack = map(x->rand(UInt8, 100, 100), 1:100) #vector of 2D arrays\n\nencoder_options = (crf=23, preset=\"medium\")\nframerate=24\nopen_video_out(\"video.mp4\", framestack[1], framerate=framerate, encoder_options=encoder_options) do writer\n    for frame in framestack\n        write(writer, frame)\n    end\nend","category":"page"},{"location":"writing/","page":"Writing Videos","title":"Writing Videos","text":"An example saving a series of png files as a video:","category":"page"},{"location":"writing/","page":"Writing Videos","title":"Writing Videos","text":"using VideoIO, ProgressMeter\n\ndir = \"\" #path to directory holding images\nimgnames = filter(x->occursin(\".png\",x), readdir(dir)) # Populate list of all .pngs\nintstrings =  map(x->split(x,\".\")[1], imgnames) # Extract index from filenames\np = sortperm(parse.(Int, intstrings)) #sort files numerically\nimgnames = imgnames[p]\n\nencoder_options = (crf=23, preset=\"medium\")\n\nfirstimg = load(joinpath(dir, imgnames[1]))\nopen_video_out(\"video.mp4\", firstimg, framerate=24, encoder_options=encoder_options) do writer\n    @showprogress \"Encoding video frames..\" for i in eachindex(imgnames)\n        img = load(joinpath(dir, imgnames[i]))\n        write(writer, img)\n    end\nend","category":"page"},{"location":"writing/","page":"Writing Videos","title":"Writing Videos","text":"VideoIO.open_video_out","category":"page"},{"location":"writing/#VideoIO.open_video_out","page":"Writing Videos","title":"VideoIO.open_video_out","text":"open_video_out(filename, ::Type{T}, sz::NTuple{2, Integer};\n               <keyword arguments>) -> writer\nopen_video_out(filename, first_img::Matrix; ...)\nopen_video_out(f, ...; ...)\n\nOpen file filename and prepare to encode a video stream into it, returning object writer that can be used to encode frames. The size and element type of the video can either be specified by passing the first frame of the movie first_img, which will not be encoded, or instead the element type T and 2-tuple size sz. If the size is explicitly specified, the first element will be the height, and the second width, unless keyword argument scanline_major = true, in which case the order is reversed. Both height and width must be even. The element type T must be one of the supported element types, which is any key of VideoIO.VIO_DEF_ELTYPE_PIX_FMT_LU, or instead the Normed or Unsigned type for a corresponding Gray element type. The container type will be inferred from filename.\n\nFrames are encoded with write, which must use frames with the same size, element type, and obey the same value of scanline_major. The video must be closed once all frames are encoded with close_video_out!.\n\nIf called with a function as the first argument, f, then the function will be called with the writer object writer as its only argument. This writer object will be closed once the call is complete, regardless of whether or not an error occurred.\n\nKeyword arguments\n\ncodec_name::Union{AbstractString, Nothing} = nothing: Name of the codec to   use. Must be a name accepted by FFmpeg, and   compatible with the chosen container type, or nothing, in which case the   codec will be automatically selected by FFmpeg based on the container.\nframerate::Real = 24: Framerate of the resulting video.\nscanline_major::Bool = false: If false, then Julia arrays are assumed to   have frame height in the first dimension, and frame width on the second. If   true, then pixels that adjacent to eachother in the same scanline (i.e.   horizontal line of the video) are assumed to be adjacent to eachother in   memory. scanline_major = true videos must be StridedArrays with unit   stride in the first dimension. For normal arrays, this corresponds to a   matrix where frame width is in the first dimension, and frame height is in   the second.\ncontainer_options::OptionsT = (;): A NamedTuple or Dict{Symbol, Any}   of options for the container. Must correspond to option names and values   accepted by FFmpeg.\ncontainer_private_options::OptionsT = (;): A NamedTuple or   Dict{Symbol, Any} of private options for the container. Must correspond   to private options names and values accepted by   FFmpeg for the chosen container type.\nencoder_options::OptionsT = (;): A NamedTuple or Dict{Symbol, Any} of   options for the encoder context. Must correspond to option names and values   accepted by FFmpeg.\nencoder_private_options::OptionsT = (;): A NamedTuple or   Dict{Symbol, Any} of private options for the encoder context. Must   correspond to private option names and values accepted by   FFmpeg for the chosen codec specified by codec_name.\nswscale_options::OptionsT = (;): A Namedtuple, or Dict{Symbol, Any} of   options for the swscale object used to perform color space scaling. Options   must correspond with options for FFmpeg's   scaler filter.\ntarget_pix_fmt::Union{Nothing, Cint} = nothing: The pixel format that will   be used to input data into the encoder. This can either by a   VideoIO.AV_PIX_FMT_* value corresponding to a FFmpeg   AVPixelFormat,   and must then be a format supported by the encoder, or instead nothing,   in which case it will be chosen automatically by FFmpeg.\npix_fmt_loss_flags = 0: Loss flags to control how encoding pixel format is   chosen. Only valid if target_pix_fmt = nothing. Flags must correspond to   FFmpeg   loss flags.\ninput_colorspace_details = nothing: Information about the color space   of input Julia arrays. If nothing, then this will correspond to a   best-effort interpretation of Colors.jl for the corresponding element type.   To override these defaults, create a VideoIO.VioColorspaceDetails object   using the appropriate AVCOL_ definitions from FFmpeg, or use   VideoIO.VioColorspaceDetails() to use the FFmpeg defaults. If data in the   input Julia arrays is already in the mpeg color range, then set this to   VideoIO.VioColorspaceDetails() to avoid additional scaling by sws_scale.\nallow_vio_gray_transform = true: Instead of using sws_scale for gray data,   use a more accurate color space transformation implemented in VideoIO if   allow_vio_gray_transform = true. Otherwise, use sws_scale.\nsws_color_options::OptionsT = (;): Additional keyword arguments passed to   sws_setColorspaceDetails.\n\nSee also: write, close_video_out!\n\n\n\n\n\n","category":"function"},{"location":"writing/","page":"Writing Videos","title":"Writing Videos","text":"VideoIO.write","category":"page"},{"location":"writing/#Base.write","page":"Writing Videos","title":"Base.write","text":"write(writer::VideoWriter, img)\nwrite(writer::VideoWriter, img, index)\n\nPrepare frame img for encoding, encode it, mux it, and either cache it or write it to the file described by writer. img must be the same size and element type as the size and element type that was used to create writer. If index is provided, it must start at zero and increment monotonically.\n\n\n\n\n\n","category":"function"},{"location":"writing/","page":"Writing Videos","title":"Writing Videos","text":"VideoIO.close_video_out!","category":"page"},{"location":"writing/#VideoIO.close_video_out!","page":"Writing Videos","title":"VideoIO.close_video_out!","text":"close_video_out!(writer::VideoWriter)\n\nWrite all frames cached in writer to the video container that it describes, and then close the file. Once all frames in a video have been added to writer, then it must be closed with this function to flush any cached frames to the file, and then finally close the file and release resources associated with writer.\n\n\n\n\n\n","category":"function"},{"location":"writing/#Supported-Colortypes","page":"Writing Videos","title":"Supported Colortypes","text":"","category":"section"},{"location":"writing/","page":"Writing Videos","title":"Writing Videos","text":"Encoding of the following image element color types currently supported:","category":"page"},{"location":"writing/","page":"Writing Videos","title":"Writing Videos","text":"UInt8\nGray{N0f8}\nRGB{N0f8}","category":"page"},{"location":"writing/#Encoder-Options","page":"Writing Videos","title":"Encoder Options","text":"","category":"section"},{"location":"writing/","page":"Writing Videos","title":"Writing Videos","text":"The encoder_options keyword argument allows control over FFmpeg encoding options. Optional fields can be found here.","category":"page"},{"location":"writing/","page":"Writing Videos","title":"Writing Videos","text":"More details about options specific to h264 can be found here.","category":"page"},{"location":"writing/","page":"Writing Videos","title":"Writing Videos","text":"Some example values for the encoder_options keyword argument are:","category":"page"},{"location":"writing/","page":"Writing Videos","title":"Writing Videos","text":"Goal encoder_options value\nPerceptual compression, h264 default. Best for most cases (crf=23, preset=\"medium\")\nLossless compression. Fastest, largest file size (crf=0, preset=\"ultrafast\")\nLossless compression. Slowest, smallest file size (crf=0, preset=\"ultraslow\")\nDirect control of bitrate and frequency of intra frames (every 10) (bit_rate = 400000, gop_size = 10, max_b_frames = 1)","category":"page"},{"location":"writing/#Lossless-Encoding","page":"Writing Videos","title":"Lossless Encoding","text":"","category":"section"},{"location":"writing/#Lossless-RGB","page":"Writing Videos","title":"Lossless RGB","text":"","category":"section"},{"location":"writing/","page":"Writing Videos","title":"Writing Videos","text":"If lossless encoding of RGB{N0f8} is required, true lossless requires using codec_name = \"libx264rgb\", to avoid the lossy RGB->YUV420 conversion, and crf=0.","category":"page"},{"location":"writing/#Lossless-Grayscale","page":"Writing Videos","title":"Lossless Grayscale","text":"","category":"section"},{"location":"writing/","page":"Writing Videos","title":"Writing Videos","text":"If lossless encoding of Gray{N0f8} or UInt8 is required, crf=0 should be set, as well as color_range=2 to ensure full 8-bit pixel color representation. i.e. (color_range=2, crf=0, preset=\"medium\")","category":"page"},{"location":"writing/#Encoding-Performance","page":"Writing Videos","title":"Encoding Performance","text":"","category":"section"},{"location":"writing/","page":"Writing Videos","title":"Writing Videos","text":"See examples/lossless_video_encoding_testing.jl for testing of losslessness, speed, and compression as a function of h264 encoding preset, for 3 example videos.","category":"page"}]
}
