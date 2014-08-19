using Images
using ImageView
import VideoIO

function playvid(f::VideoIO.VideoReader; flip=false)
    img = read(f, Image)
    flip && (img = fliplr(img))
    canvas, _ = ImageView.view(img)
    
    while !eof(f)
        read!(f, img)
        flip && (img=fliplr(img))
        ImageView.view(canvas, img)
        sleep(1/f.framerate)
    end
end

playvid(video_file) = playvid(VideoIO.openvideo(video_file))
playcam(args...) = playvid(VideoIO.opencamera(args...), flip=true)

function main(args)
    for i = 1:length(args)
        arg = args[i]
        if arg == "-c" || endswith(arg, "-camera")
            if i+1 <= length(args)
                i += 1
                playcam(args[i])
            else
                playcam()
            end
        else
            playvid(arg)
        end
    end
end

if !isinteractive()
    main(ARGS)
end

