# Tools for downloading test videos

module TestVideos

using VideoIO: VideoIO
import Base: show
import Downloads: download
export testvideo

videodir = joinpath(dirname(@__FILE__), "..", "videos")

mutable struct VideoFile{compression}
    name::AbstractString
    description::AbstractString
    license::AbstractString
    credit::AbstractString
    source::AbstractString
    download_url::AbstractString
    numframes::Int
    testframe::Int
    summarysize::Int
end

show(io::IO, v::VideoFile) = print(
    io,
    """
VideoFile:
   name:         $(v.name)  $(isfile(joinpath(videodir, v.name)) ? "(Downloaded)" : "")
   description:  $(v.description)
   license:      $(v.license)
   credit:       $(v.credit)
   source:       $(v.source)
   download_url: $(v.download_url)
   numframes:    $(v.numframes)
   summarysize:  $(v.summarysize)
 """,
)

VideoFile(name, description, license, credit, source, download_url, numframes, testframe, summarysize) =
    VideoFile{:raw}(name, description, license, credit, source, download_url, numframes, testframe, summarysize)

# Standard test videos
const videofiles = Dict(
    "ladybird.mp4" => VideoFile(
        "ladybird.mp4",
        "Ladybird opening wings (slow motion)",
        "Creative Commons: By Attribution 3.0 Unported (http://creativecommons.org/licenses/by/3.0/deed)",
        "CC-BY NatureClip (http://youtube.com/natureclip)",
        "https://downloadnatureclip.blogspot.com/p/download-links.html",
        "https://archive.org/download/LadybirdOpeningWingsCCBYNatureClip/Ladybird%20opening%20wings%20CC-BY%20NatureClip.mp4",
        397,
        13,
        3216,
    ),
    "annie_oakley.ogg" => VideoFile(
        "annie_oakley.ogg",
        "The \"Little Sure Shot\" of the \"Wild West,\" exhibition of rifle shooting at glass balls.",
        "pubic_domain (US)",
        "",
        "https://commons.wikimedia.org/wiki/File:Annie_Oakley_shooting_glass_balls,_1894.ogg",
        "https://upload.wikimedia.org/wikipedia/commons/8/87/Annie_Oakley_shooting_glass_balls%2C_1894.ogv",
        726,
        2,
        167311096,
    ),
    "crescent-moon.ogv" => VideoFile(
        "crescent-moon.ogv",
        "Moonset (time-lapse).",
        "Creative Commons Attribution 2.0 Generic (http://creativecommons.org/licenses/by/2.0/deed)",
        "Photo : Thomas Bresson",
        "https://commons.wikimedia.org/wiki/File:2010-10-10-Lune.ogv",
        "https://upload.wikimedia.org/wikipedia/commons/e/ef/2010-10-10-Lune.ogv",
        1213,
        1,
        9744,
    ),
    "black_hole.webm" => VideoFile(
        "black_hole.webm",
        "Artist’s impression of the black hole inside NGC 300 X-1 (ESO 1004c)",
        "Creative Commons Attribution 3.0 Unported (http://creativecommons.org/licenses/by/3.0/deed)",
        "Credit: ESO/L. Calçada",
        "https://www.eso.org/public/videos/eso1004a/",
        "https://upload.wikimedia.org/wikipedia/commons/1/13/Artist%E2%80%99s_impression_of_the_black_hole_inside_NGC_300_X-1_%28ESO_1004c%29.webm",
        597,
        1,
        4816,
    ),
)

"""
    testvideo(name, ops...)

Returns an `AVInput` object for the given video name. The video will be downloaded if it isn't available.
"""
function testvideo(name, ops...)
    videofile = joinpath(videodir, name)
    if !isfile(videofile)
        files = collect(keys(videofiles))
        # Bool is needed here for Julia v0.3
        ind = Bool[startswith(x, name) for x in files]
        count = sum(ind)

        if count == 1
            name = files[ind][1]
            videofile = joinpath(videodir, name)
            !isfile(videofile) && download(videofiles[name])
            !isfile(videofile) && throw(ErrorException("Error downloading test videofile \"$name\""))
        elseif count == 0
            throw(ErrorException("$name is not a known test videofile"))
        else
            throw(ErrorException("$name matches more than one test videofile"))
        end
    end
    return VideoIO.open(videofile, ops...) # Returns an AVInput, which in turn must be opened with openvideo, openaudio, etc.
end

function write_info(v::VideoFile)
    credit_file = joinpath(videodir, "$(v.name).txt")
    Base.open(credit_file, "w") do f
        return println(f, v)
    end
end

function download(v::VideoFile)
    write_info(v)
    println(stderr, "Downloading $(v.name) to $videodir")
    return download(v.download_url, joinpath(videodir, v.name))
end
"""
    available()

Print a list of all available test videos.
"""
function available()
    for v in values(videofiles)
        println(v)
    end
end

names() = collect(keys(videofiles))

"""
    download_all()

Downloads all test videos.
"""
function download_all()
    for (filename, v) in videofiles
        videofile = joinpath(videodir, filename)

        !isfile(videofile) && download(v)

        infofile = joinpath(videodir, "$(v.name).txt")
        !isfile(infofile) && write_info(v)
    end
end

"""
    remove_all()

Remove all test videos.
"""
function remove_all()
    for filename in keys(videofiles)
        videofile = joinpath(videodir, filename)
        isfile(videofile) && rm(videofile)
    end
end

end
