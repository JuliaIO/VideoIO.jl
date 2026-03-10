@testset "Friendly error messages (#360)" begin
    @test_throws ErrorException("Could not open nonexistent_file.mp4: No such file or directory") VideoIO.openvideo("nonexistent_file.mp4")
end

@testset "eof correctness for file streams (#320)" begin
    file = joinpath(videodir, "annie_oakley.ogg")
    f = VideoIO.openvideo(file)
    try
        @test !eof(f)
        n = 0
        while !eof(f)
            read(f)
            n += 1
        end
        @test n > 0
        @test eof(f)
    finally
        close(f)
    end
    # eof on closed reader should return true
    @test eof(f)
end

if (Sys.islinux())
    @testset "c api memory leak test" begin
        function get_memory_usage()
            open("/proc/$(getpid())/statm") do io
                return split(read(io, String))[1]
            end
        end

        file = joinpath(videodir, "annie_oakley.ogg")

        @testset "open file test" begin
            check_size = 10
            usage_vec = Vector{String}(undef, check_size)

            for i in 1:check_size
                f = VideoIO.openvideo(file)
                close(f)
                GC.gc()

                usage_vec[i] = get_memory_usage()
            end

            @debug "open file test" usage_vec
            @test usage_vec[end-1] == usage_vec[end]
            if usage_vec[end-1] != usage_vec[end]
                @error "open file test" usage_vec
            end
        end

        @testset "open and read file test" begin
            check_size = 10
            usage_vec = Vector{String}(undef, check_size)

            for i in 1:check_size
                f = VideoIO.openvideo(file)
                img = read(f)
                close(f)
                GC.gc()

                usage_vec[i] = get_memory_usage()
            end

            @test usage_vec[end-1] == usage_vec[end]
            if usage_vec[end-1] != usage_vec[end]
                @error "open and read file test" usage_vec
            end
        end
    end
end
