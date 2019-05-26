
using VideoIO, ColorTypes, FixedPointNumbers, DataFrames

function createtestvideo(;filename::String="$(tempname()).mp4",duration::Real=5,
    width::Int64=1280,height::Int64=720,framerate::Real=30,testtype::String="testsrc2",
    encoder::String="libx264rgb")
    withenv("PATH" => VideoIO.libpath, "LD_LIBRARY_PATH" => VideoIO.libpath, "DYLD_LIBRARY_PATH" => VideoIO.libpath) do
        VideoIO.collectexecoutput(`$(VideoIO.ffmpeg) -y -f lavfi -i
            $testtype=duration=$duration:size=$(width)x$(height):rate=$framerate
            -c:v $encoder -preset slow -crf 0 -c:a copy $filename`)
    end
    return filename
end

function testvideocomp!(df,preset,imgstack_gray)
    t = @elapsed encodevideo("video.mp4",imgstack_gray,framerate=30,codec_name = "libx264",
        AVCodecContextProperties=[:color_range => 2, :priv_data => ("crf"=>"0","preset"=>preset)])
    fs = filesize("video.mp4")
    f = openvideo("video.mp4",target_format=VideoIO.AV_PIX_FMT_GRAY8)
    imgstack_gray_copy = []
    while !eof(f)
        push!(imgstack_gray_copy,read(f))
    end
    identical = !any(.!(imgstack_gray .== imgstack_gray_copy))
    push!(df,[preset,fs,t,identical])
end

imgstack_gray_noise = map(x->rand(Gray{N0f8},1280,720),1:1000)
f = openvideo(createtestvideo())
imgstack = []
while !eof(f)
    push!(imgstack,read(f))
end
imgstack_gray_testvid = map(x->convert.(Gray{N0f8},x),imgstack)
f = openvideo("videos/ladybird.mp4")
imgstack = []
while !eof(f)
    push!(imgstack,read(f))
end
imgstack_gray_ladybird = map(x->convert.(Gray{N0f8},x),imgstack)

df_noise = DataFrame(preset=[],filesize=[],time=[],identical=[])
df_testvid = DataFrame(preset=[],filesize=[],time=[],identical=[])
df_ladybird = DataFrame(preset=[],filesize=[],time=[],identical=[])
for preset in ["ultrafast","superfast","veryfast","faster","fast","medium","slow",
"slower","veryslow"]
    @show preset
    for rep in 1:3
        @show rep
        testvideocomp!(df_noise,preset,imgstack_gray_noise)
        testvideocomp!(df_testvid,preset,imgstack_gray_testvid)
        testvideocomp!(df_ladybird,preset,imgstack_gray_ladybird)
    end
end
df_noise[:filesize_perc] = 100*(df_noise[:filesize]./df_noise[:filesize][1])
df_testvid[:filesize_perc] = 100*(df_testvid[:filesize]./df_testvid[:filesize][1])
df_ladybird[:filesize_perc] = 100*(df_ladybird[:filesize]./df_ladybird[:filesize][1])
df_noise[:fps] = length(imgstack_gray_noise)./df_noise[:time]
df_testvid[:fps] = length(imgstack_gray_testvid)./df_testvid[:time]
df_ladybird[:fps] = length(imgstack_gray_ladybird)./df_ladybird[:time]

using Statistics
df_noise_summary = by(df_noise, :preset, identical = :identical => minimum, fps_mean = :fps => mean, fps_std = :fps => std, filesize_perc_mean = :filesize_perc => mean,filesize_perc_std = :filesize_perc => std)
df_testvid_summary = by(df_testvid, :preset, identical = :identical => minimum, fps_mean = :fps => mean, fps_std = :fps => std, filesize_perc_mean = :filesize_perc => mean,filesize_perc_std = :filesize_perc => std)
df_ladybird_summary = by(df_ladybird, :preset, identical = :identical => minimum, fps_mean = :fps => mean, fps_std = :fps => std, filesize_perc_mean = :filesize_perc => mean,filesize_perc_std = :filesize_perc => std)

@show df_noise_summary
@show df_testvid_summary
@show df_ladybird_summary
# HISTOGRAM COMPARISON
# using PyPlot, ImageCore
# figure()
# hist(rawview(channelview(imgstack_gray_copy[1]))[:],0:256,label="copy")
# hist(rawview(channelview(imgstack_gray[1]))[:],0:256,label="original")
# legend()
