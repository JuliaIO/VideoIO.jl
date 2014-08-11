using Images
using ImageView
import VideoIO

function playvid(video_file)
    f = VideoIO.openvideo(video_file)
    img = read(f, Image)
    canvas, _ = ImageView.view(img)
    
    while !eof(f)
        read!(f, img)
        ImageView.view(canvas, img)
        sleep(1/f.framerate)
    end
end

function main(args)
    for arg in args
        playvid(arg)
    end
end

if !isinteractive()
    main(ARGS)
end

