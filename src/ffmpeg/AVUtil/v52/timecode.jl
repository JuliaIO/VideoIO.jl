# Julia wrapper for header: /opt/ffmpeg/include/libavutil/timecode.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


export
    av_timecode_adjust_ntsc_framenum2,
    av_timecode_get_smpte_from_framenum,
    av_timecode_make_string,
    av_timecode_make_smpte_tc_string,
    av_timecode_make_mpeg_tc_string,
    av_timecode_init,
    av_timecode_init_from_string,
    av_timecode_check_frame_rate


function av_timecode_adjust_ntsc_framenum2(framenum::Integer,fps::Integer)
    ccall((:av_timecode_adjust_ntsc_framenum2,libavutil),Cint,(Cint,Cint),framenum,fps)
end

function av_timecode_get_smpte_from_framenum(tc,framenum::Integer)
    ccall((:av_timecode_get_smpte_from_framenum,libavutil),UInt32,(Ptr{AVTimecode},Cint),tc,framenum)
end

function av_timecode_make_string(tc,buf,framenum::Integer)
    ccall((:av_timecode_make_string,libavutil),Ptr{UInt8},(Ptr{AVTimecode},Ptr{UInt8},Cint),tc,buf,framenum)
end

function av_timecode_make_smpte_tc_string(buf,tcsmpte::Integer,prevent_df::Integer)
    ccall((:av_timecode_make_smpte_tc_string,libavutil),Ptr{UInt8},(Ptr{UInt8},UInt32,Cint),buf,tcsmpte,prevent_df)
end

function av_timecode_make_mpeg_tc_string(buf,tc25bit::Integer)
    ccall((:av_timecode_make_mpeg_tc_string,libavutil),Ptr{UInt8},(Ptr{UInt8},UInt32),buf,tc25bit)
end

function av_timecode_init(tc,rate::AVRational,flags::Integer,frame_start::Integer,log_ctx)
    ccall((:av_timecode_init,libavutil),Cint,(Ptr{AVTimecode},AVRational,Cint,Cint,Ptr{Void}),tc,rate,flags,frame_start,log_ctx)
end

function av_timecode_init_from_string(tc,rate::AVRational,str,log_ctx)
    ccall((:av_timecode_init_from_string,libavutil),Cint,(Ptr{AVTimecode},AVRational,Ptr{UInt8},Ptr{Void}),tc,rate,str,log_ctx)
end

function av_timecode_check_frame_rate(rate::AVRational)
    ccall((:av_timecode_check_frame_rate,libavutil),Cint,(AVRational,),rate)
end
