if Sys.islinux()
    include("init-linux.jl")
else
    include("init-notlinux.jl")
end