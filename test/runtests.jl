include("avio.jl")

@osx_only begin
    include("avoptions_tests.jl")
end

@windows_only begin
    include("avoptions_tests.jl")
end
