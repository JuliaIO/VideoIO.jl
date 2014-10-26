###############################################################################################################
# Webcam aquisition example with VideoIO-GLPlot
# Credits: Simon Danisch
###############################################################################################################
using Dates
using Tk
using Color, FixedPointNumbers
using Images
using ImageView
using VideoIO


using GLPlot, Reactive, GLAbstraction


# Open input  and stream
f = opencamera(VideoIO.DEFAULT_CAMERA_DEVICE, VideoIO.DEFAULT_CAMERA_FORMAT)
# Read a frame
img = read(f, Image)
# View the frame
view(img)

# Create a window to display
# use ;async=true in REPL, no need for renderloop(window)
window 	= createdisplay(;async =false, w=500, h=500)

# Live image processing
# Filters (matrix convolution)
laplace	   = [-3  -3  -3;
              -1   8  -1;
              -1  -1  -1]
edge    	 = [-1  -1  -1;
               -1  8  -1;
              - 1 -1  -1]
sharp      =  [0  -1   0;
              -1   5  -1;
               0  -1   0]
gaussian   =  [1   2   1;
               2   4   2;
               1   2   1]

img =  glplot(Texture(img,3), kernel=edge, filternorm=0.05f0)       #error
# img =  glplot(Texture(img, 3), kernel=sobel2, filternorm=0.1f0)
# img =  sqrt(img1.*img1 + img2.*img2)

#img = glplot(Texture(img, 3)) #Texture(img, 3), kernel=kernel, filternorm=0.1f0)

#Get Gpu memory object
glimg = img.uniforms[:image]

# Notes:
# Reactive doesn't export Timing - Timing.fpswhen is deprecated!
# createdisplay => window  => window.input[:open] = boolean (true/false)
# update!  < function GLTexture.jl in GLAbstraction
# mapslices  => (function, image {Uint8} 3D array, dims)
# reverse   => (array)

## transform the old image in the window to a new one with lift (old image -> new image)
lift(fpswhen(window.inputs[:open], 30.0)) do x
        newframe = VideoIO.read(f)
        update!(glimg,  mapslices(reverse, newframe, 3)) # needs to be mirrored :(
end

## loop again back to window
renderloop(window)
############################################################################################################
