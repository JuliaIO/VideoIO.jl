@testset "Video encode/decode accuracy (read, encode, read, compare)" begin
    file = joinpath(videodir, "annie_oakley.ogg")
    imgstack_rgb = VideoIO.openvideo(collect, file)
    imgstack_gray = convert.(Array{Gray{N0f8}}, imgstack_rgb)
    @testset "Lossless Grayscale encoding" begin
        encoder_settings = (color_range=2,)
        encoder_private_settings = (crf="0", preset="medium")
        codec_name="libx264"
        VideoIO.encode_mux_video(tempvidpath, imgstack_gray,
                    codec_name = codec_name,
                    encoder_settings = encoder_settings,
                    encoder_private_settings = encoder_private_settings)
        imgstack_gray_copy = VideoIO.openvideo(collect, tempvidpath, target_format = VideoIO.AV_PIX_FMT_GRAY8)
        @test eltype(eltype(imgstack_gray)) == eltype(eltype(imgstack_gray_copy))
        @test length(imgstack_gray) == length(imgstack_gray_copy)
        @test size(imgstack_gray[1]) == size(imgstack_gray_copy[1])
        @test !any(.!(imgstack_gray .== imgstack_gray_copy))
    end

    @testset "Lossless RGB encoding" begin
        encoder_private_settings = (crf="0", preset="medium")
        codec_name="libx264rgb"
        VideoIO.encode_mux_video(tempvidpath, imgstack_rgb,
                            codec_name = codec_name,
                            encoder_private_settings = encoder_private_settings)
        imgstack_rgb_copy = VideoIO.openvideo(collect, tempvidpath)
        @test eltype(imgstack_rgb) == eltype(imgstack_rgb_copy)
        @test length(imgstack_rgb) == length(imgstack_rgb_copy)
        @test size(imgstack_rgb[1]) == size(imgstack_rgb_copy[1])
        @test !any(.!(imgstack_rgb .== imgstack_rgb_copy))
    end

    @testset "UInt8 accuracy during read & lossless encode" begin
        # Test that reading truth video has one of each UInt8 value pixels (16x16 frames = 256 pixels)
        raw_img = VideoIO.openvideo(read,
                                    joinpath(testdir, "references", "precisiontest_gray_truth.mp4"),
                                    target_format = VideoIO.AV_PIX_FMT_GRAY8)
        frame_truth = collect(rawview(channelview(raw_img)))
        h_truth = fit(Histogram, frame_truth[:], 0:256)
        @test h_truth.weights == fill(1,256) #Test that reading is precise

        # Test that encoding new test video has one of each UInt8 value pixels (16x16 frames = 256 pixels)
        img = Array{UInt8}(undef,16,16)
        for i in 1:256
            img[i] = UInt8(i-1)
        end
        imgstack = []
        for i=1:24
            push!(imgstack,img)
        end
        encoder_settings = (color_range=2,)
        encoder_private_settings = (crf="0", preset="medium")
        VideoIO.encode_mux_video(tempvidpath, imgstack, encoder_settings = encoder_settings,
                                    encoder_private_settings = encoder_private_settings)
        f = VideoIO.openvideo(tempvidpath, target_format = VideoIO.AV_PIX_FMT_GRAY8)
        try
            frame_test = collect(rawview(channelview(read(f))))
            h_test = fit(Histogram, frame_test[:], 0:256)
            @test h_test.weights == fill(1,256) #Test that encoding is precise (if above passes)
            @test VideoIO.counttotalframes(f) == 24
        finally
            close(f)
        end
    end

    @testset "Correct frame order when reading & encoding" begin
        @testset "Frame order when reading ground truth video" begin
            # Test that reading a video with frame-incremental pixel values is read in in-order
            f = VideoIO.openvideo(joinpath(testdir,"references","ordertest_gray_truth.mp4"),target_format=VideoIO.AV_PIX_FMT_GRAY8)
            frame_ids_truth = []
            while !eof(f)
                img = collect(rawview(channelview(read(f))))
                push!(frame_ids_truth,img[1,1])
            end
            @test frame_ids_truth == collect(0:255) #Test that reading is in correct frame order
            @test VideoIO.counttotalframes(f) == 256
        end
        @testset "Frame order when encoding, then reading video" begin
            # Test that writing and reading a video with frame-incremental pixel values is read in in-order
            imgstack = []
            img = Array{UInt8}(undef,16,16)
            for i in 0:255
                push!(imgstack,fill(UInt8(i),(16,16)))
            end
            encoder_settings = (color_range=2,)
            encoder_private_settings = (crf="0", preset="medium")
            VideoIO.encode_mux_video(tempvidpath, imgstack,
                                    encoder_settings = encoder_settings,
                                    encoder_private_settings = encoder_private_settings)
            f = VideoIO.openvideo(tempvidpath, target_format = VideoIO.AV_PIX_FMT_GRAY8)
            try
                frame_ids_test = []
                while !eof(f)
                    img = collect(rawview(channelview(read(f))))
                    push!(frame_ids_test,img[1,1])
                end
                @test frame_ids_test == collect(0:255) #Test that reading is in correct frame order
                @test VideoIO.counttotalframes(f) == 256
            finally
                close(f)
            end
        end
    end
end