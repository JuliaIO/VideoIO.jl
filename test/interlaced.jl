@testset "Interlaced video codec properties" begin
    # Test with an interlaced H.264 video
    interlaced_path = joinpath(testdir, "references", "interlaced_h264.mp4")
    
    if !isfile(interlaced_path)
        @test_skip "Interlaced test video not found at $interlaced_path"
        return
    end
    
    VideoIO.openvideo(interlaced_path) do reader
        # Verify codec_descriptor is not null
        @test reader.codec_context.codec_descriptor != C_NULL
        
        # Check if it's a field-based codec (should be for interlaced H.264)
        is_field_based = (reader.codec_context.codec_descriptor.props & VideoIO.AV_CODEC_PROP_FIELDS) != 0
        @test is_field_based
        
        # For interlaced video, framerate calculation should account for fields
        # The video was created at 30fps but with interlacing, so the field rate is 60
        fps = VideoIO.framerate(reader)
        @test fps > 0
        @test isfinite(fps)
        
        # The framerate should be 60 (field rate) for interlaced content
        @test fps == 60 // 1
        
        # Verify we can read frames without error
        frame = read(reader)
        @test !isnothing(frame)
        @test size(frame) == (240, 320)  # height, width (permuted)
    end
end

@testset "Progressive video codec properties" begin
    # Test with a progressive video for comparison
    testvid_path = joinpath(VideoIO.TestVideos.videodir, "ladybird.mp4")
    
    VideoIO.openvideo(testvid_path) do reader
        # Verify codec_descriptor is not null
        @test reader.codec_context.codec_descriptor != C_NULL
        
        # Check if it's a field-based codec (should NOT be for progressive)
        is_field_based = (reader.codec_context.codec_descriptor.props & VideoIO.AV_CODEC_PROP_FIELDS) != 0
        @test !is_field_based
        
        # Get framerate
        fps = VideoIO.framerate(reader)
        @test fps > 0
        @test isfinite(fps)
    end
end
