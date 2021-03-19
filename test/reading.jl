@testset "Reading of various example file formats" begin
    swscale_options = (sws_flags = "accurate_rnd+full_chroma_inp+full_chroma_int",)
    for testvid in values(VideoIO.TestVideos.videofiles)
        name = testvid.name
        test_frameno = testvid.testframe
        @testset "Reading $(testvid.name)" begin
            testvid_path = joinpath(@__DIR__, "../videos", name)
            comparison_frame = make_comparison_frame_png(load, testvid_path, test_frameno)
            f = VideoIO.testvideo(testvid_path)
            v = VideoIO.openvideo(f; swscale_options = swscale_options)
            try
                time_seconds = VideoIO.gettime(v)
                @test time_seconds == 0
                width, height = VideoIO.out_frame_size(v)
                @test VideoIO.out_frame_eltype(v) == RGB{N0f8}
                if size(comparison_frame, 1) > height
                    trimmed_comparison_frame =
                        comparison_frame[1+size(comparison_frame,1)-height:end,:]
                else
                    trimmed_comparison_frame = comparison_frame
                end

                # Find the first non-trivial image
                first_img = read(v)
                first_time = VideoIO.gettime(v)
                seekstart(v)
                img = read(v)
                @test VideoIO.gettime(v) == first_time
                @test img == first_img
                @test size(img) == VideoIO.out_frame_size(v)[[2, 1]]
                # no scaling currently
                @test VideoIO.out_frame_size(v) == VideoIO.raw_frame_size(v)
                @test VideoIO.raw_pixel_format(v) == 0 # true for current test videos
                i=1
                while i < test_frameno
                    read!(v, img)
                    i += 1
                end
                test_compare_frames(img, trimmed_comparison_frame, required_accuracy)
                test_time = VideoIO.gettime(v)
                seek(v, test_time)
                raw_img = parent(img)
                read!(v, raw_img) # VideoReader should accept scanline-major images
                test_compare_frames(img, trimmed_comparison_frame, required_accuracy)
                @test VideoIO.gettime(v) == test_time
                if size(img, 1) != size(img, 2)
                    # Passing an arrray that is not scanline-major does not work
                    @test_throws ArgumentError read!(v, similar(img))
                    @test VideoIO.gettime(v) == test_time
                end
                @test_throws(ArgumentError,
                             read!(v, similar(raw_img, size(raw_img) .- 1)))
                @test_throws MethodError read!(v, similar(raw_img, Rational{Int}))
                @test_throws ArgumentError read!(v, similar(raw_img, Gray{N0f8}))
                @test VideoIO.gettime(v) == test_time

                seekstart(v)
                for i in 1:50
                    read!(v,img)
                end
                fiftieth_frame = copy(img)
                fiftytime = VideoIO.gettime(v)

                while !eof(v)
                    read!(v, img)
                end

                seek(v,fiftytime)
                read!(v,img)

                @test img == fiftieth_frame

                seekstart(v)
                start_t = VideoIO.gettime(v)
                @test start_t <= 0
                buff, align = VideoIO.read_raw(v, 1)
                @test VideoIO.out_bytes_size(v) == length(buff)
                @test align == 1
                buff_bak = copy(buff)
                seekstart(v)
                VideoIO.read_raw!(v, buff, 1)
                last_time = VideoIO.gettime(v)
                @test buff == buff_bak
                @test_throws(ArgumentError,
                             VideoIO.read_raw!(v, similar(buff, size(buff) .- 1)))
                @test_throws MethodError VideoIO.read_raw!(v, similar(buff, Int))
                @test VideoIO.gettime(v) == last_time
                notranscode_buff = VideoIO.openvideo(read, testvid_path,
                                                     transcode = false)
                @test notranscode_buff == buff_bak

                # read first frames again, and compare
                read_frameno!(img, v, test_frameno)
                test_compare_frames(img, trimmed_comparison_frame, required_accuracy)

                # make sure read! works with both PermutedDimsArray and Array
                # The above tests already use read! for PermutedDimsArray,
                # so just test the type of img
                @test typeof(img) <: PermutedDimsArray

                img_p = parent(img)
                @assert typeof(img_p) <: Array
                # img is a view of img_p, so calling read! on img_p should alter img
                #
                # first, zero img out to be sure we get the desired result from
                # calls to read on img_p!
                fill!(img, zero(eltype(img)))
                # Then get the first frame, which uses read!
                read_frameno!(img_p, v, test_frameno)
                # Finally compare the result to make sure it's right
                test_compare_frames(img, trimmed_comparison_frame, required_accuracy)

                # Skipping & frame counting
                VideoIO.seekstart(v)
                VideoIO.skipframe(v)
                VideoIO.skipframes(v, 10)
                @test VideoIO.counttotalframes(v) ==
                    VideoIO.TestVideos.videofiles[name].numframes
            finally
                close(f)
            end

            v = VideoIO.load(testvid_path)
            @test length(v) == VideoIO.TestVideos.videofiles[name].numframes
        end
    end
end

@testset "Reading monochrome videos" begin
    testvid = first(values(VideoIO.TestVideos.videofiles))
    testvid_path = joinpath(@__DIR__, "../videos", testvid.name)
    # Test that limited range YCbCr values are translated to "full range"
    minp, maxp = VideoIO.openvideo(get_video_extrema, testvid_path,
                                   target_format = VideoIO.AV_PIX_FMT_GRAY8)
    @test typeof(minp) == Gray{N0f8}
    @test minp.val.i < 16
    @test maxp.val.i > 235
    # Disable automatic rescaling
    minp, maxp = VideoIO.openvideo(get_video_extrema, testvid_path,
                                   target_format = VideoIO.AV_PIX_FMT_GRAY8,
                                   target_colorspace_details =
                                   VideoIO.VioColorspaceDetails())
    @test minp.val.i >= 16
    @test maxp.val.i <= 235
end

@testset "IO reading of various example file formats" begin
    swscale_options = (sws_flags = "accurate_rnd+full_chroma_inp+full_chroma_int",)
    for testvid in values(VideoIO.TestVideos.videofiles)
        name = testvid.name
        test_frameno = testvid.testframe
        # TODO: fix me?
        (startswith(name, "ladybird") || startswith(name, "NPS")) && continue
        @testset "Testing $name" begin
            testvid_path = joinpath(@__DIR__, "../videos", name)
            comparison_frame = make_comparison_frame_png(load, testvid_path, test_frameno)
            filename = joinpath(videodir, name)
            v = VideoIO.openvideo(filename; swscale_options = swscale_options)
            try
                width, height = VideoIO.out_frame_size(v)
                if size(comparison_frame, 1) > height
                    trimmed_comparison_frame =
                        comparison_frame[1+size(comparison_frame,1)-height:end,:]
                else
                    trimmed_comparison_frame = comparison_frame
                end
                img = read(v)
                i=1
                while i < test_frameno
                    read!(v, img)
                    i += 1
                end
                test_compare_frames(img, trimmed_comparison_frame,
                                    required_accuracy)
                while !eof(v)
                    read!(v, img)
                end

                # Iterator interface
                VT = typeof(v)
                @test Base.IteratorSize(VT) === Base.SizeUnknown()
                @test Base.IteratorEltype(VT) === Base.EltypeUnknown()

                VideoIO.seekstart(v)
                i = 0
                local first_frame
                local last_frame
                for frame in v
                    i += 1
                    if i == 1
                        first_frame = frame
                    end
                    last_frame = frame
                end
                @test i == VideoIO.TestVideos.videofiles[name].numframes
                # test that the frames returned by the iterator have distinct storage
                if i > 1
                    @test first_frame !== last_frame
                end

                ## Test that iterator is mutable, and continues where iteration last
                ## stopped.
                @test iterate(v) === nothing
            finally
                close(v)
            end
        end
    end

    VideoIO.testvideo("ladybird") # coverage testing
    @test_throws ErrorException VideoIO.testvideo("rickroll")
    @test_throws ErrorException VideoIO.testvideo("")
end

@testset "Reading video metadata" begin
    @testset "Reading Storage Aspect Ratio: SAR" begin
        # currently, the SAR of all the test videos is 1, we should get another video with a valid SAR that is not equal to 1
        vids = Dict("ladybird.mp4" => 1, "black_hole.webm" => 1, "crescent-moon.ogv" => 1, "annie_oakley.ogg" => 1)
        @test all(VideoIO.aspect_ratio(VideoIO.openvideo(joinpath(videodir, k))) == v for (k,v) in vids)
    end
    @testset "Reading video duration, start date, and duration" begin
        # tesing the duration and date & time functions:
        file = joinpath(videodir, "annie_oakley.ogg")
        @test VideoIO.get_duration(file) == 24224200/1e6
        @test VideoIO.get_start_time(file) == DateTime(1970, 1, 1)
        @test VideoIO.get_time_duration(file) == (DateTime(1970, 1, 1), 24224200/1e6)
        @test VideoIO.get_number_frames(file) === nothing
    end
    @testset "Reading the number of frames from container" begin
        file = joinpath(videodir, "ladybird.mp4")
        @test VideoIO.get_number_frames(file) == 398
        @test VideoIO.get_number_frames(file, 0) == 398
        @test_throws ArgumentError VideoIO.get_number_frames(file, -1)
        @test_throws ErrorException VideoIO.get_number_frames("Not_a_file")
    end
end