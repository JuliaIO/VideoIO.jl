# Julia wrapper for header: /usr/include/libavcodec/avfft.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0

@c Ptr{FFTContext} av_fft_init (Int32, Int32) libavcodec
@c None av_fft_permute (Ptr{FFTContext}, Ptr{FFTComplex}) libavcodec
@c None av_fft_calc (Ptr{FFTContext}, Ptr{FFTComplex}) libavcodec
@c None av_fft_end (Ptr{FFTContext},) libavcodec
@c Ptr{FFTContext} av_mdct_init (Int32, Int32, Float64) libavcodec
@c None av_imdct_calc (Ptr{FFTContext}, Ptr{FFTSample}, Ptr{FFTSample}) libavcodec
@c None av_imdct_half (Ptr{FFTContext}, Ptr{FFTSample}, Ptr{FFTSample}) libavcodec
@c None av_mdct_calc (Ptr{FFTContext}, Ptr{FFTSample}, Ptr{FFTSample}) libavcodec
@c None av_mdct_end (Ptr{FFTContext},) libavcodec
@c Ptr{RDFTContext} av_rdft_init (Int32, Void) libavcodec
@c None av_rdft_calc (Ptr{RDFTContext}, Ptr{FFTSample}) libavcodec
@c None av_rdft_end (Ptr{RDFTContext},) libavcodec
@c Ptr{DCTContext} av_dct_init (Int32, Void) libavcodec
@c None av_dct_calc (Ptr{DCTContext}, Ptr{FFTSample}) libavcodec
@c None av_dct_end (Ptr{DCTContext},) libavcodec

