using Images
using AV
using ImageView

function show_vid(video_file)
    f = AV.open(video_file)
    img = read(f, Image)
    canvas, _ = ImageView.view(img)
    
    while !eof(f)
        read!(f, img)
        ImageView.view(canvas, img)
        sleep(1/f.videoFramerate)
    end
end

function main(args)
    for arg in args
        show_vid(arg)
    end
end

if !isinteractive()
    main(ARGS)
end

