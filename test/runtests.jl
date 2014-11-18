include("avio.jl")

# Tests are performed on OSX and Windows
@osx? include("avoptions_tests.jl") : @windows? include("avoptions_tests.jl") : nothing

