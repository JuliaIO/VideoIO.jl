

[Build error master - VideoIO with AVOptions API with tests](https://travis-ci.org/kmsquire/VideoIO.jl/jobs/39122213)

    ERROR: AVDeviceCapabilitiesQuery not defined
     in include at ./boot.jl:242
     in include_from_node1 at ./loading.jl:128
     in include at ./boot.jl:242
     in include_from_node1 at ./loading.jl:128
     in reload_path at ./loading.jl:152
     in _require at ./loading.jl:67
     in require at ./loading.jl:52
     in require_3B_3925 at /usr/bin/../lib/x86_64-linux-gnu/julia/
     sys.so
     in include at ./boot.jl:242
     in include_from_node1 at ./loading.jl:128
     in include at ./boot.jl:242
     in include_from_node1 at loading.jl:128
     in process_options at ./client.jl:293
     in _start at ./client.jl:362
     in _start_3B_3753 at /usr/bin/../lib/x86_64-linux-gnu/julia/
     sys.so
     while loading /home/travis/.julia/v0.4/VideoIO/src/avoptions.jl,
     in expression starting on line 691
     while loading /home/travis/.julia/v0.4/VideoIO/src/VideoIO.jl,
     in expression starting on line 13
     while loading /home/travis/.julia/v0.4/VideoIO/test/
     avoptions_tests.jl, in expression starting on line 3
     while loading /home/travis/.julia/v0.4/VideoIO/test/runtests.jl,
     in expression starting on line 2
