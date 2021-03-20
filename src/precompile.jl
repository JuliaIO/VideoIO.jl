function _precompile()
    mktempdir() do dir
        for e in [UInt8, Gray{N0f8}, RGB{N0f8}]
            filename = joinpath(dir, "vid.mp4")
            framestack = [rand(e, 10, 10) for _ in 1:10]
            VideoIO.save(filename, framestack)
            VideoIO.load(filename)
            rm(filename)
        end
    end
end
