
using VideoIO, ColorTypes, FixedPointNumbers, DataFrames

function createtestvideo(;filename::String="$(tempname()).mp4",duration::Real=5,
    width::Int64=1280,height::Int64=720,framerate::Real=30,testtype::String="testsrc2",
    encoder::String="libx264rgb")
    withenv("PATH" => string(VideoIO.libpath,":",Sys.BINDIR), "LD_LIBRARY_PATH" => VideoIO.libpath, "DYLD_LIBRARY_PATH" => VideoIO.libpath) do
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

noise_raw_size = size(imgstack_gray_noise[1],1) * size(imgstack_gray_noise[1],2) * length(imgstack_gray_noise)
testvid_raw_size = size(imgstack_gray_testvid[1],1) * size(imgstack_gray_testvid[1],2) * length(imgstack_gray_testvid)
ladybird_raw_size = size(imgstack_gray_ladybird[1],1) * size(imgstack_gray_ladybird[1],2) * length(imgstack_gray_ladybird)

df_noise[:filesize_perc] = 100*(df_noise[:filesize]./noise_raw_size)
df_testvid[:filesize_perc] = 100*(df_testvid[:filesize]./testvid_raw_size)
df_ladybird[:filesize_perc] = 100*(df_ladybird[:filesize]./ladybird_raw_size)
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

### Results (generated 2019-05-29 on a 2019 Macbook Pro)
#=
df_noise_summary = 9×6 DataFrame
│ Row │ preset    │ identical │ fps_mean │ fps_std │ filesize_perc_mean │ filesize_perc_std │
│     │ Any       │ Bool      │ Float64  │ Float64 │ Float64            │ Float64           │
├─────┼───────────┼───────────┼──────────┼─────────┼────────────────────┼───────────────────┤
│ 1   │ ultrafast │ true      │ 92.5769  │ 8.40224 │ 156.444            │ 0.0               │
│ 2   │ superfast │ true      │ 62.3509  │ 1.19652 │ 144.019            │ 0.0               │
│ 3   │ veryfast  │ true      │ 59.9182  │ 1.77294 │ 144.019            │ 0.0               │
│ 4   │ faster    │ true      │ 60.3482  │ 2.32679 │ 144.02             │ 0.0               │
│ 5   │ fast      │ true      │ 149.169  │ 1.56068 │ 100.784            │ 0.0               │
│ 6   │ medium    │ true      │ 146.141  │ 3.41282 │ 100.784            │ 0.0               │
│ 7   │ slow      │ true      │ 147.214  │ 1.23929 │ 100.784            │ 0.0               │
│ 8   │ slower    │ true      │ 138.808  │ 2.553   │ 100.784            │ 0.0               │
│ 9   │ veryslow  │ true      │ 132.505  │ 3.28558 │ 100.784            │ 0.0               │

df_testvid_summary = 9×6 DataFrame
│ Row │ preset    │ identical │ fps_mean │ fps_std │ filesize_perc_mean │ filesize_perc_std │
│     │ Any       │ Bool      │ Float64  │ Float64 │ Float64            │ Float64           │
├─────┼───────────┼───────────┼──────────┼─────────┼────────────────────┼───────────────────┤
│ 1   │ ultrafast │ true      │ 228.166  │ 75.1439 │ 4.80392            │ 0.0               │
│ 2   │ superfast │ true      │ 239.73   │ 54.2033 │ 3.62199            │ 0.0               │
│ 3   │ veryfast  │ true      │ 197.506  │ 13.1121 │ 3.59901            │ 0.0               │
│ 4   │ faster    │ true      │ 174.174  │ 18.0316 │ 3.60282            │ 0.0               │
│ 5   │ fast      │ true      │ 235.181  │ 7.40358 │ 3.44104            │ 0.0               │
│ 6   │ medium    │ true      │ 219.654  │ 3.27445 │ 3.40832            │ 0.0               │
│ 7   │ slow      │ true      │ 171.337  │ 3.92415 │ 3.33917            │ 0.0               │
│ 8   │ slower    │ true      │ 105.24   │ 6.59151 │ 3.25774            │ 5.43896e-16       │
│ 9   │ veryslow  │ true      │ 63.1136  │ 2.47291 │ 3.2219             │ 0.0               │

df_ladybird_summary = 9×6 DataFrame
│ Row │ preset    │ identical │ fps_mean │ fps_std  │ filesize_perc_mean │ filesize_perc_std │
│     │ Any       │ Bool      │ Float64  │ Float64  │ Float64            │ Float64           │
├─────┼───────────┼───────────┼──────────┼──────────┼────────────────────┼───────────────────┤
│ 1   │ ultrafast │ true      │ 176.787  │ 36.5227  │ 12.2293            │ 0.0               │
│ 2   │ superfast │ true      │ 135.925  │ 7.04431  │ 10.3532            │ 0.0               │
│ 3   │ veryfast  │ true      │ 117.115  │ 1.28102  │ 10.1954            │ 0.0               │
│ 4   │ faster    │ true      │ 94.39    │ 3.48494  │ 9.85604            │ 0.0               │
│ 5   │ fast      │ true      │ 69.657   │ 1.61004  │ 9.62724            │ 0.0               │
│ 6   │ medium    │ true      │ 54.9621  │ 0.568074 │ 9.51032            │ 0.0               │
│ 7   │ slow      │ true      │ 37.8888  │ 1.27484  │ 9.33622            │ 0.0               │
│ 8   │ slower    │ true      │ 20.1112  │ 1.04282  │ 9.25529            │ 0.0               │
│ 9   │ veryslow  │ true      │ 10.0016  │ 0.473213 │ 9.24999            │ 0.0               │
=#


# HISTOGRAM COMPARISON - useful for diagnosing range compression
# using PyPlot, ImageCore
# figure()
# hist(rawview(channelview(imgstack_gray_copy[1]))[:],0:256,label="copy")
# hist(rawview(channelview(imgstack_gray[1]))[:],0:256,label="original")
# legend()
