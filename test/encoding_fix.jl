@testset "Encoding with colorspace and framerate fixes" begin
    # Create a temporary output file
    temp_output = tempname() * ".mp4"

    try
        # Test 1: Basic encoding with valid framerate
        @testset "Valid framerate encoding" begin
            width, height = 64, 48
            framerate = 24
            nframes = 10

            # Create and encode a simple synthetic video
            VideoIO.open_video_out(temp_output, RGB{N0f8}, (height, width);
                                   framerate=framerate,
                                   encoder_options=(crf=23, preset="ultrafast")) do writer
                for i in 1:nframes
                    # Create a simple gradient frame
                    frame = [RGB{N0f8}((i/nframes), (x/width), (y/height))
                            for y in 1:height, x in 1:width]
                    write(writer, frame)
                end
            end

            # Verify the file was created
            @test isfile(temp_output)
            @test filesize(temp_output) > 0

            # Verify we can read it back and get correct framerate
            VideoIO.openvideo(temp_output) do reader
                fps = VideoIO.framerate(reader)
                @test isfinite(fps)
                @test fps > 0
                @test fps ≈ framerate rtol=0.1

                # Verify dimensions
                @test VideoIO.width(reader) == width
                @test VideoIO.height(reader) == height

                # Read at least one frame to verify decoding works
                frame = read(reader)
                @test size(frame) == (height, width)
            end
        end

        # Test 2: Invalid framerate should throw error
        @testset "Invalid framerate validation" begin
            width, height = 64, 48

            # Test infinity - should throw ArgumentError from our new validation
            @test_throws ArgumentError VideoIO.open_video_out(
                temp_output, RGB{N0f8}, (height, width);
                framerate=Inf
            )

            # Test zero - should throw ErrorException from existing check
            @test_throws Exception VideoIO.open_video_out(
                temp_output, RGB{N0f8}, (height, width);
                framerate=0
            )

            # Test negative - should throw ErrorException from existing check
            @test_throws Exception VideoIO.open_video_out(
                temp_output, RGB{N0f8}, (height, width);
                framerate=-24
            )
        end

        # Test 3: Colorspace handling for YUV encoding
        @testset "RGB to YUV encoding" begin
            width, height = 64, 48
            nframes = 5

            # This will encode RGB input to YUV420P (default for H.264)
            # The colorspace fix ensures proper colorspace metadata
            VideoIO.open_video_out(temp_output, RGB{N0f8}, (height, width);
                                   framerate=30,
                                   encoder_options=(crf=23, preset="ultrafast")) do writer
                for i in 1:nframes
                    # Create a colorful test pattern
                    frame = [RGB{N0f8}((i*x)/(nframes*width), (y/height), 0.5)
                            for y in 1:height, x in 1:width]
                    write(writer, frame)
                end
            end

            @test isfile(temp_output)
            @test filesize(temp_output) > 0
        end

        # Test 4: Framerate fallback mechanism
        @testset "Framerate reading with fallbacks" begin
            width, height = 64, 48

            # Create a video with known framerate
            VideoIO.open_video_out(temp_output, RGB{N0f8}, (height, width);
                                   framerate=25,
                                   encoder_options=(crf=23, preset="ultrafast")) do writer
                for i in 1:3
                    frame = fill(RGB{N0f8}(i/3, i/3, i/3), height, width)
                    write(writer, frame)
                end
            end

            # Read back and verify framerate fallback works
            VideoIO.openvideo(temp_output) do reader
                fps = VideoIO.framerate(reader)
                @test isfinite(fps)
                @test fps > 0
                # The framerate should be close to what we set
                # (may not be exact due to codec internals)
                @test fps ≈ 25 rtol=0.2
            end
        end

    finally
        # Cleanup
        if isfile(temp_output)
            rm(temp_output)
        end
    end
end
