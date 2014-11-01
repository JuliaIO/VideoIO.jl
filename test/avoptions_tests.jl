using Base.Test
using VideoIO

println(STDERR, "Now testing the AVOptions API...")

println(STDERR, "Test#1: Detect AVOptions-enabled devices...")
devices_list = discover_devices()
if length(devices_list.idevice_name)<1
    error("Cannot detect any input video devices!")
else
    println("Detected $(length(devices_list.idevice_name)) input video devices... Passed \n")
end

println(STDERR, "Test#2: Open default camera device and format...")
f = opencamera()
if (f.avin==C_NULL)
    error("Device detection failed, test the API manually!")
else
    println("Detected default camera $(VideoIO.DEFAULT_CAMERA_DEVICE) and its format... Passed \n")
end

if (f.avin.isopen)
    println("-"^75)
    println(STDERR, "Test#3: Check whether API options are accessible...")
    fmt_options, codec_options = document_all_options(f, true)
    if isempty(fmt_options)
        error("Cannot access options")
    else
        options = collect(keys(fmt_options))
        println("Detected $(length(options)) options... \n")

        # Select 2 options, test get and set with strings
        println(STDERR, "Test#4: Now testing get options with strings...")
        !isempty(get_option(f, options[1]))? println("get ", options[1],"... passed"): error("get failed")
        !isempty(get_option(f, options[3]))? println("get ", options[3],"... passed"): error("get failed")

        # Select 2 options, set with AVDictionary API
        println(STDERR, "\nTest#5: Now testing AVDictionary API...")
        entries = Dict{String,String}()
        for i=1:4
            entries[options[i]] = string((fmt_options[options[i]][1]+fmt_options[options[i]][2])/2)
        end
        create_dictionary(entries) != C_NULL ? println("Built an AVDictionary... passed \n"): error("Failed")
    end
    # Close the camera input
    close(f)
end
