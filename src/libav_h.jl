
recurs_sym_type(ex::Any) = 
  (ex==None || typeof(ex)==Symbol || length(ex.args)==1) ? eval(ex) : Expr(ex.head, ex.args[1], recurs_sym_type(ex.args[2]))
macro c(ret_type, func, arg_types, lib)
  local _arg_types = Expr(:tuple, [recurs_sym_type(a) for a in arg_types.args]...)
  local _ret_type = recurs_sym_type(ret_type)
  local _args_in = Any[ symbol(string('a',x)) for x in 1:length(_arg_types.args) ]
  local _lib = eval(lib)
  quote
    $(esc(func))($(_args_in...)) = ccall( ($(string(func)), $(Expr(:quote, _lib)) ), $_ret_type, $_arg_types, $(_args_in...) )
  end
end

macro ctypedef(fake_t,real_t)
  real_t = recurs_sym_type(real_t)
  quote
    typealias $fake_t $real_t
  end
end

@ctypedef AVDictionary Void
@ctypedef AVDictionaryEntry Void
@ctypedef AVIOContext Void
# enum AVMediaType
const AVMEDIA_TYPE_UNKNOWN = -1
const AVMEDIA_TYPE_VIDEO = 0
const AVMEDIA_TYPE_AUDIO = 1
const AVMEDIA_TYPE_DATA = 2
const AVMEDIA_TYPE_SUBTITLE = 3
const AVMEDIA_TYPE_ATTACHMENT = 4
const AVMEDIA_TYPE_NB = 5
# end
# enum AVPictureType
const AV_PICTURE_TYPE_I = 1
const AV_PICTURE_TYPE_P = 2
const AV_PICTURE_TYPE_B = 3
const AV_PICTURE_TYPE_S = 4
const AV_PICTURE_TYPE_SI = 5
const AV_PICTURE_TYPE_SP = 6
const AV_PICTURE_TYPE_BI = 7
# end
# enum AVSampleFormat
const AV_SAMPLE_FMT_NONE = -1
const AV_SAMPLE_FMT_U8 = 0
const AV_SAMPLE_FMT_S16 = 1
const AV_SAMPLE_FMT_S32 = 2
const AV_SAMPLE_FMT_FLT = 3
const AV_SAMPLE_FMT_DBL = 4
const AV_SAMPLE_FMT_U8P = 5
const AV_SAMPLE_FMT_S16P = 6
const AV_SAMPLE_FMT_S32P = 7
const AV_SAMPLE_FMT_FLTP = 8
const AV_SAMPLE_FMT_DBLP = 9
const AV_SAMPLE_FMT_NB = 10
# end
@ctypedef AVDictionaryEntry Void
@ctypedef AVDictionary Void
@ctypedef AVClass Void
# enum PixelFormat
const PIX_FMT_NONE = -1
const PIX_FMT_YUV420P = 0
const PIX_FMT_YUYV422 = 1
const PIX_FMT_RGB24 = 2
const PIX_FMT_BGR24 = 3
const PIX_FMT_YUV422P = 4
const PIX_FMT_YUV444P = 5
const PIX_FMT_YUV410P = 6
const PIX_FMT_YUV411P = 7
const PIX_FMT_GRAY8 = 8
const PIX_FMT_MONOWHITE = 9
const PIX_FMT_MONOBLACK = 10
const PIX_FMT_PAL8 = 11
const PIX_FMT_YUVJ420P = 12
const PIX_FMT_YUVJ422P = 13
const PIX_FMT_YUVJ444P = 14
const PIX_FMT_XVMC_MPEG2_MC = 15
const PIX_FMT_XVMC_MPEG2_IDCT = 16
const PIX_FMT_UYVY422 = 17
const PIX_FMT_UYYVYY411 = 18
const PIX_FMT_BGR8 = 19
const PIX_FMT_BGR4 = 20
const PIX_FMT_BGR4_BYTE = 21
const PIX_FMT_RGB8 = 22
const PIX_FMT_RGB4 = 23
const PIX_FMT_RGB4_BYTE = 24
const PIX_FMT_NV12 = 25
const PIX_FMT_NV21 = 26
const PIX_FMT_ARGB = 27
const PIX_FMT_RGBA = 28
const PIX_FMT_ABGR = 29
const PIX_FMT_BGRA = 30
const PIX_FMT_GRAY16BE = 31
const PIX_FMT_GRAY16LE = 32
const PIX_FMT_YUV440P = 33
const PIX_FMT_YUVJ440P = 34
const PIX_FMT_YUVA420P = 35
const PIX_FMT_VDPAU_H264 = 36
const PIX_FMT_VDPAU_MPEG1 = 37
const PIX_FMT_VDPAU_MPEG2 = 38
const PIX_FMT_VDPAU_WMV3 = 39
const PIX_FMT_VDPAU_VC1 = 40
const PIX_FMT_RGB48BE = 41
const PIX_FMT_RGB48LE = 42
const PIX_FMT_RGB565BE = 43
const PIX_FMT_RGB565LE = 44
const PIX_FMT_RGB555BE = 45
const PIX_FMT_RGB555LE = 46
const PIX_FMT_BGR565BE = 47
const PIX_FMT_BGR565LE = 48
const PIX_FMT_BGR555BE = 49
const PIX_FMT_BGR555LE = 50
const PIX_FMT_VAAPI_MOCO = 51
const PIX_FMT_VAAPI_IDCT = 52
const PIX_FMT_VAAPI_VLD = 53
const PIX_FMT_YUV420P16LE = 54
const PIX_FMT_YUV420P16BE = 55
const PIX_FMT_YUV422P16LE = 56
const PIX_FMT_YUV422P16BE = 57
const PIX_FMT_YUV444P16LE = 58
const PIX_FMT_YUV444P16BE = 59
const PIX_FMT_VDPAU_MPEG4 = 60
const PIX_FMT_DXVA2_VLD = 61
const PIX_FMT_RGB444LE = 62
const PIX_FMT_RGB444BE = 63
const PIX_FMT_BGR444LE = 64
const PIX_FMT_BGR444BE = 65
const PIX_FMT_Y400A = 66
const PIX_FMT_BGR48BE = 67
const PIX_FMT_BGR48LE = 68
const PIX_FMT_YUV420P9BE = 69
const PIX_FMT_YUV420P9LE = 70
const PIX_FMT_YUV420P10BE = 71
const PIX_FMT_YUV420P10LE = 72
const PIX_FMT_YUV422P10BE = 73
const PIX_FMT_YUV422P10LE = 74
const PIX_FMT_YUV444P9BE = 75
const PIX_FMT_YUV444P9LE = 76
const PIX_FMT_YUV444P10BE = 77
const PIX_FMT_YUV444P10LE = 78
const PIX_FMT_YUV422P9BE = 79
const PIX_FMT_YUV422P9LE = 80
const PIX_FMT_VDA_VLD = 81
const PIX_FMT_GBRP = 82
const PIX_FMT_GBRP9BE = 83
const PIX_FMT_GBRP9LE = 84
const PIX_FMT_GBRP10BE = 85
const PIX_FMT_GBRP10LE = 86
const PIX_FMT_GBRP16BE = 87
const PIX_FMT_GBRP16LE = 88
const PIX_FMT_NB = 89
# end
@ctypedef AVRational Void
# enum CodecID
const CODEC_ID_NONE = 0
const CODEC_ID_MPEG1VIDEO = 1
const CODEC_ID_MPEG2VIDEO = 2
const CODEC_ID_MPEG2VIDEO_XVMC = 3
const CODEC_ID_H261 = 4
const CODEC_ID_H263 = 5
const CODEC_ID_RV10 = 6
const CODEC_ID_RV20 = 7
const CODEC_ID_MJPEG = 8
const CODEC_ID_MJPEGB = 9
const CODEC_ID_LJPEG = 10
const CODEC_ID_SP5X = 11
const CODEC_ID_JPEGLS = 12
const CODEC_ID_MPEG4 = 13
const CODEC_ID_RAWVIDEO = 14
const CODEC_ID_MSMPEG4V1 = 15
const CODEC_ID_MSMPEG4V2 = 16
const CODEC_ID_MSMPEG4V3 = 17
const CODEC_ID_WMV1 = 18
const CODEC_ID_WMV2 = 19
const CODEC_ID_H263P = 20
const CODEC_ID_H263I = 21
const CODEC_ID_FLV1 = 22
const CODEC_ID_SVQ1 = 23
const CODEC_ID_SVQ3 = 24
const CODEC_ID_DVVIDEO = 25
const CODEC_ID_HUFFYUV = 26
const CODEC_ID_CYUV = 27
const CODEC_ID_H264 = 28
const CODEC_ID_INDEO3 = 29
const CODEC_ID_VP3 = 30
const CODEC_ID_THEORA = 31
const CODEC_ID_ASV1 = 32
const CODEC_ID_ASV2 = 33
const CODEC_ID_FFV1 = 34
const CODEC_ID_4XM = 35
const CODEC_ID_VCR1 = 36
const CODEC_ID_CLJR = 37
const CODEC_ID_MDEC = 38
const CODEC_ID_ROQ = 39
const CODEC_ID_INTERPLAY_VIDEO = 40
const CODEC_ID_XAN_WC3 = 41
const CODEC_ID_XAN_WC4 = 42
const CODEC_ID_RPZA = 43
const CODEC_ID_CINEPAK = 44
const CODEC_ID_WS_VQA = 45
const CODEC_ID_MSRLE = 46
const CODEC_ID_MSVIDEO1 = 47
const CODEC_ID_IDCIN = 48
const CODEC_ID_8BPS = 49
const CODEC_ID_SMC = 50
const CODEC_ID_FLIC = 51
const CODEC_ID_TRUEMOTION1 = 52
const CODEC_ID_VMDVIDEO = 53
const CODEC_ID_MSZH = 54
const CODEC_ID_ZLIB = 55
const CODEC_ID_QTRLE = 56
const CODEC_ID_SNOW = 57
const CODEC_ID_TSCC = 58
const CODEC_ID_ULTI = 59
const CODEC_ID_QDRAW = 60
const CODEC_ID_VIXL = 61
const CODEC_ID_QPEG = 62
const CODEC_ID_PNG = 63
const CODEC_ID_PPM = 64
const CODEC_ID_PBM = 65
const CODEC_ID_PGM = 66
const CODEC_ID_PGMYUV = 67
const CODEC_ID_PAM = 68
const CODEC_ID_FFVHUFF = 69
const CODEC_ID_RV30 = 70
const CODEC_ID_RV40 = 71
const CODEC_ID_VC1 = 72
const CODEC_ID_WMV3 = 73
const CODEC_ID_LOCO = 74
const CODEC_ID_WNV1 = 75
const CODEC_ID_AASC = 76
const CODEC_ID_INDEO2 = 77
const CODEC_ID_FRAPS = 78
const CODEC_ID_TRUEMOTION2 = 79
const CODEC_ID_BMP = 80
const CODEC_ID_CSCD = 81
const CODEC_ID_MMVIDEO = 82
const CODEC_ID_ZMBV = 83
const CODEC_ID_AVS = 84
const CODEC_ID_SMACKVIDEO = 85
const CODEC_ID_NUV = 86
const CODEC_ID_KMVC = 87
const CODEC_ID_FLASHSV = 88
const CODEC_ID_CAVS = 89
const CODEC_ID_JPEG2000 = 90
const CODEC_ID_VMNC = 91
const CODEC_ID_VP5 = 92
const CODEC_ID_VP6 = 93
const CODEC_ID_VP6F = 94
const CODEC_ID_TARGA = 95
const CODEC_ID_DSICINVIDEO = 96
const CODEC_ID_TIERTEXSEQVIDEO = 97
const CODEC_ID_TIFF = 98
const CODEC_ID_GIF = 99
const CODEC_ID_FFH264 = 100
const CODEC_ID_DXA = 101
const CODEC_ID_DNXHD = 102
const CODEC_ID_THP = 103
const CODEC_ID_SGI = 104
const CODEC_ID_C93 = 105
const CODEC_ID_BETHSOFTVID = 106
const CODEC_ID_PTX = 107
const CODEC_ID_TXD = 108
const CODEC_ID_VP6A = 109
const CODEC_ID_AMV = 110
const CODEC_ID_VB = 111
const CODEC_ID_PCX = 112
const CODEC_ID_SUNRAST = 113
const CODEC_ID_INDEO4 = 114
const CODEC_ID_INDEO5 = 115
const CODEC_ID_MIMIC = 116
const CODEC_ID_RL2 = 117
const CODEC_ID_8SVX_EXP = 118
const CODEC_ID_8SVX_FIB = 119
const CODEC_ID_ESCAPE124 = 120
const CODEC_ID_DIRAC = 121
const CODEC_ID_BFI = 122
const CODEC_ID_CMV = 123
const CODEC_ID_MOTIONPIXELS = 124
const CODEC_ID_TGV = 125
const CODEC_ID_TGQ = 126
const CODEC_ID_TQI = 127
const CODEC_ID_AURA = 128
const CODEC_ID_AURA2 = 129
const CODEC_ID_V210X = 130
const CODEC_ID_TMV = 131
const CODEC_ID_V210 = 132
const CODEC_ID_DPX = 133
const CODEC_ID_MAD = 134
const CODEC_ID_FRWU = 135
const CODEC_ID_FLASHSV2 = 136
const CODEC_ID_CDGRAPHICS = 137
const CODEC_ID_R210 = 138
const CODEC_ID_ANM = 139
const CODEC_ID_BINKVIDEO = 140
const CODEC_ID_IFF_ILBM = 141
const CODEC_ID_IFF_BYTERUN1 = 142
const CODEC_ID_KGV1 = 143
const CODEC_ID_YOP = 144
const CODEC_ID_VP8 = 145
const CODEC_ID_PICTOR = 146
const CODEC_ID_ANSI = 147
const CODEC_ID_A64_MULTI = 148
const CODEC_ID_A64_MULTI5 = 149
const CODEC_ID_R10K = 150
const CODEC_ID_MXPEG = 151
const CODEC_ID_LAGARITH = 152
const CODEC_ID_PRORES = 153
const CODEC_ID_JV = 154
const CODEC_ID_DFA = 155
const CODEC_ID_WMV3IMAGE = 156
const CODEC_ID_VC1IMAGE = 157
const CODEC_ID_G723_1 = 158
const CODEC_ID_G729 = 159
const CODEC_ID_UTVIDEO = 160
const CODEC_ID_BMV_VIDEO = 161
const CODEC_ID_VBLE = 162
const CODEC_ID_DXTORY = 163
const CODEC_ID_V410 = 164
const CODEC_ID_FIRST_AUDIO = 65536
const CODEC_ID_PCM_S16LE = 65536
const CODEC_ID_PCM_S16BE = 65537
const CODEC_ID_PCM_U16LE = 65538
const CODEC_ID_PCM_U16BE = 65539
const CODEC_ID_PCM_S8 = 65540
const CODEC_ID_PCM_U8 = 65541
const CODEC_ID_PCM_MULAW = 65542
const CODEC_ID_PCM_ALAW = 65543
const CODEC_ID_PCM_S32LE = 65544
const CODEC_ID_PCM_S32BE = 65545
const CODEC_ID_PCM_U32LE = 65546
const CODEC_ID_PCM_U32BE = 65547
const CODEC_ID_PCM_S24LE = 65548
const CODEC_ID_PCM_S24BE = 65549
const CODEC_ID_PCM_U24LE = 65550
const CODEC_ID_PCM_U24BE = 65551
const CODEC_ID_PCM_S24DAUD = 65552
const CODEC_ID_PCM_ZORK = 65553
const CODEC_ID_PCM_S16LE_PLANAR = 65554
const CODEC_ID_PCM_DVD = 65555
const CODEC_ID_PCM_F32BE = 65556
const CODEC_ID_PCM_F32LE = 65557
const CODEC_ID_PCM_F64BE = 65558
const CODEC_ID_PCM_F64LE = 65559
const CODEC_ID_PCM_BLURAY = 65560
const CODEC_ID_PCM_LXF = 65561
const CODEC_ID_S302M = 65562
const CODEC_ID_PCM_S8_PLANAR = 65563
const CODEC_ID_ADPCM_IMA_QT = 69632
const CODEC_ID_ADPCM_IMA_WAV = 69633
const CODEC_ID_ADPCM_IMA_DK3 = 69634
const CODEC_ID_ADPCM_IMA_DK4 = 69635
const CODEC_ID_ADPCM_IMA_WS = 69636
const CODEC_ID_ADPCM_IMA_SMJPEG = 69637
const CODEC_ID_ADPCM_MS = 69638
const CODEC_ID_ADPCM_4XM = 69639
const CODEC_ID_ADPCM_XA = 69640
const CODEC_ID_ADPCM_ADX = 69641
const CODEC_ID_ADPCM_EA = 69642
const CODEC_ID_ADPCM_G726 = 69643
const CODEC_ID_ADPCM_CT = 69644
const CODEC_ID_ADPCM_SWF = 69645
const CODEC_ID_ADPCM_YAMAHA = 69646
const CODEC_ID_ADPCM_SBPRO_4 = 69647
const CODEC_ID_ADPCM_SBPRO_3 = 69648
const CODEC_ID_ADPCM_SBPRO_2 = 69649
const CODEC_ID_ADPCM_THP = 69650
const CODEC_ID_ADPCM_IMA_AMV = 69651
const CODEC_ID_ADPCM_EA_R1 = 69652
const CODEC_ID_ADPCM_EA_R3 = 69653
const CODEC_ID_ADPCM_EA_R2 = 69654
const CODEC_ID_ADPCM_IMA_EA_SEAD = 69655
const CODEC_ID_ADPCM_IMA_EA_EACS = 69656
const CODEC_ID_ADPCM_EA_XAS = 69657
const CODEC_ID_ADPCM_EA_MAXIS_XA = 69658
const CODEC_ID_ADPCM_IMA_ISS = 69659
const CODEC_ID_ADPCM_G722 = 69660
const CODEC_ID_AMR_NB = 73728
const CODEC_ID_AMR_WB = 73729
const CODEC_ID_RA_144 = 77824
const CODEC_ID_RA_288 = 77825
const CODEC_ID_ROQ_DPCM = 81920
const CODEC_ID_INTERPLAY_DPCM = 81921
const CODEC_ID_XAN_DPCM = 81922
const CODEC_ID_SOL_DPCM = 81923
const CODEC_ID_MP2 = 86016
const CODEC_ID_MP3 = 86017
const CODEC_ID_AAC = 86018
const CODEC_ID_AC3 = 86019
const CODEC_ID_DTS = 86020
const CODEC_ID_VORBIS = 86021
const CODEC_ID_DVAUDIO = 86022
const CODEC_ID_WMAV1 = 86023
const CODEC_ID_WMAV2 = 86024
const CODEC_ID_MACE3 = 86025
const CODEC_ID_MACE6 = 86026
const CODEC_ID_VMDAUDIO = 86027
const CODEC_ID_SONIC = 86028
const CODEC_ID_SONIC_LS = 86029
const CODEC_ID_FLAC = 86030
const CODEC_ID_MP3ADU = 86031
const CODEC_ID_MP3ON4 = 86032
const CODEC_ID_SHORTEN = 86033
const CODEC_ID_ALAC = 86034
const CODEC_ID_WESTWOOD_SND1 = 86035
const CODEC_ID_GSM = 86036
const CODEC_ID_QDM2 = 86037
const CODEC_ID_COOK = 86038
const CODEC_ID_TRUESPEECH = 86039
const CODEC_ID_TTA = 86040
const CODEC_ID_SMACKAUDIO = 86041
const CODEC_ID_QCELP = 86042
const CODEC_ID_WAVPACK = 86043
const CODEC_ID_DSICINAUDIO = 86044
const CODEC_ID_IMC = 86045
const CODEC_ID_MUSEPACK7 = 86046
const CODEC_ID_MLP = 86047
const CODEC_ID_GSM_MS = 86048
const CODEC_ID_ATRAC3 = 86049
const CODEC_ID_VOXWARE = 86050
const CODEC_ID_APE = 86051
const CODEC_ID_NELLYMOSER = 86052
const CODEC_ID_MUSEPACK8 = 86053
const CODEC_ID_SPEEX = 86054
const CODEC_ID_WMAVOICE = 86055
const CODEC_ID_WMAPRO = 86056
const CODEC_ID_WMALOSSLESS = 86057
const CODEC_ID_ATRAC3P = 86058
const CODEC_ID_EAC3 = 86059
const CODEC_ID_SIPR = 86060
const CODEC_ID_MP1 = 86061
const CODEC_ID_TWINVQ = 86062
const CODEC_ID_TRUEHD = 86063
const CODEC_ID_MP4ALS = 86064
const CODEC_ID_ATRAC1 = 86065
const CODEC_ID_BINKAUDIO_RDFT = 86066
const CODEC_ID_BINKAUDIO_DCT = 86067
const CODEC_ID_AAC_LATM = 86068
const CODEC_ID_QDMC = 86069
const CODEC_ID_CELT = 86070
const CODEC_ID_BMV_AUDIO = 86071
const CODEC_ID_FIRST_SUBTITLE = 94208
const CODEC_ID_DVD_SUBTITLE = 94208
const CODEC_ID_DVB_SUBTITLE = 94209
const CODEC_ID_TEXT = 94210
const CODEC_ID_XSUB = 94211
const CODEC_ID_SSA = 94212
const CODEC_ID_MOV_TEXT = 94213
const CODEC_ID_HDMV_PGS_SUBTITLE = 94214
const CODEC_ID_DVB_TELETEXT = 94215
const CODEC_ID_SRT = 94216
const CODEC_ID_FIRST_UNKNOWN = 98304
const CODEC_ID_TTF = 98304
const CODEC_ID_PROBE = 102400
const CODEC_ID_MPEG2TS = 131072
const CODEC_ID_MPEG4SYSTEMS = 131073
const CODEC_ID_FFMETADATA = 135168
# end
# enum Motion_Est_ID
const ME_ZERO = 1
const ME_FULL = 2
const ME_LOG = 3
const ME_PHODS = 4
const ME_EPZS = 5
const ME_X1 = 6
const ME_HEX = 7
const ME_UMH = 8
const ME_ITER = 9
const ME_TESA = 10
# end
# enum AVDiscard
const AVDISCARD_NONE = -16
const AVDISCARD_DEFAULT = 0
const AVDISCARD_NONREF = 8
const AVDISCARD_BIDIR = 16
const AVDISCARD_NONKEY = 32
const AVDISCARD_ALL = 48
# end
# enum AVColorPrimaries
const AVCOL_PRI_BT709 = 1
const AVCOL_PRI_UNSPECIFIED = 2
const AVCOL_PRI_BT470M = 4
const AVCOL_PRI_BT470BG = 5
const AVCOL_PRI_SMPTE170M = 6
const AVCOL_PRI_SMPTE240M = 7
const AVCOL_PRI_FILM = 8
const AVCOL_PRI_NB = 9
# end
# enum AVColorTransferCharacteristic
const AVCOL_TRC_BT709 = 1
const AVCOL_TRC_UNSPECIFIED = 2
const AVCOL_TRC_GAMMA22 = 4
const AVCOL_TRC_GAMMA28 = 5
const AVCOL_TRC_NB = 6
# end
# enum AVColorSpace
const AVCOL_SPC_RGB = 0
const AVCOL_SPC_BT709 = 1
const AVCOL_SPC_UNSPECIFIED = 2
const AVCOL_SPC_FCC = 4
const AVCOL_SPC_BT470BG = 5
const AVCOL_SPC_SMPTE170M = 6
const AVCOL_SPC_SMPTE240M = 7
const AVCOL_SPC_NB = 8
# end
# enum AVColorRange
const AVCOL_RANGE_UNSPECIFIED = 0
const AVCOL_RANGE_MPEG = 1
const AVCOL_RANGE_JPEG = 2
const AVCOL_RANGE_NB = 3
# end
# enum AVChromaLocation
const AVCHROMA_LOC_UNSPECIFIED = 0
const AVCHROMA_LOC_LEFT = 1
const AVCHROMA_LOC_CENTER = 2
const AVCHROMA_LOC_TOPLEFT = 3
const AVCHROMA_LOC_TOP = 4
const AVCHROMA_LOC_BOTTOMLEFT = 5
const AVCHROMA_LOC_BOTTOM = 6
const AVCHROMA_LOC_NB = 7
# end
# enum AVLPCType
const AV_LPC_TYPE_DEFAULT = -1
const AV_LPC_TYPE_NONE = 0
const AV_LPC_TYPE_FIXED = 1
const AV_LPC_TYPE_LEVINSON = 2
const AV_LPC_TYPE_CHOLESKY = 3
const AV_LPC_TYPE_NB = 4
# end
# enum AVAudioServiceType
const AV_AUDIO_SERVICE_TYPE_MAIN = 0
const AV_AUDIO_SERVICE_TYPE_EFFECTS = 1
const AV_AUDIO_SERVICE_TYPE_VISUALLY_IMPAIRED = 2
const AV_AUDIO_SERVICE_TYPE_HEARING_IMPAIRED = 3
const AV_AUDIO_SERVICE_TYPE_DIALOGUE = 4
const AV_AUDIO_SERVICE_TYPE_COMMENTARY = 5
const AV_AUDIO_SERVICE_TYPE_EMERGENCY = 6
const AV_AUDIO_SERVICE_TYPE_VOICE_OVER = 7
const AV_AUDIO_SERVICE_TYPE_KARAOKE = 8
const AV_AUDIO_SERVICE_TYPE_NB = 9
# end
@ctypedef RcOverride Void
@ctypedef AVPanScan Void
# enum AVPacketSideDataType
const AV_PKT_DATA_PALETTE = 0
const AV_PKT_DATA_NEW_EXTRADATA = 1
const AV_PKT_DATA_PARAM_CHANGE = 2
# end
@ctypedef AVPacket Void
# enum AVSideDataParamChangeFlags
const AV_SIDE_DATA_PARAM_CHANGE_CHANNEL_COUNT = 1
const AV_SIDE_DATA_PARAM_CHANGE_CHANNEL_LAYOUT = 2
const AV_SIDE_DATA_PARAM_CHANGE_SAMPLE_RATE = 4
const AV_SIDE_DATA_PARAM_CHANGE_DIMENSIONS = 8
# end
@ctypedef AVFrame Void
# enum AVFieldOrder
const AV_FIELD_UNKNOWN = 0
const AV_FIELD_PROGRESSIVE = 1
const AV_FIELD_TT = 2
const AV_FIELD_BB = 3
const AV_FIELD_TB = 4
const AV_FIELD_BT = 5
# end
@ctypedef AVCodecContext Void
@ctypedef AVProfile Void
@ctypedef AVCodecDefault Void
@ctypedef AVCodec Void
@ctypedef AVHWAccel Void
@ctypedef AVPicture Void
@ctypedef AVPaletteControl Void
# enum AVSubtitleType
const SUBTITLE_NONE = 0
const SUBTITLE_BITMAP = 1
const SUBTITLE_TEXT = 2
const SUBTITLE_ASS = 3
# end
@ctypedef AVSubtitleRect Void
@ctypedef AVSubtitle Void
@ctypedef ReSampleContext Void
@ctypedef AVCodecParserContext Void
@ctypedef AVCodecParser Void
@ctypedef AVBitStreamFilterContext Void
@ctypedef AVBitStreamFilter Void
# enum AVLockOp
const AV_LOCK_CREATE = 0
const AV_LOCK_OBTAIN = 1
const AV_LOCK_RELEASE = 2
const AV_LOCK_DESTROY = 3
# end
@ctypedef FFTSample Float32
@ctypedef FFTComplex Void
@ctypedef FFTContext Void
# enum RDFTransformType
const DFT_R2C = 0
const IDFT_C2R = 1
const IDFT_R2C = 2
const DFT_C2R = 3
# end
@ctypedef RDFTContext Void
@ctypedef DCTContext Void
# enum DCTTransformType
const DCT_II = 0
const DCT_III = 1
const DCT_I = 2
const DST_I = 3
# end
# enum AVOptionType
const AV_OPT_TYPE_FLAGS = 0
const AV_OPT_TYPE_INT = 1
const AV_OPT_TYPE_INT64 = 2
const AV_OPT_TYPE_DOUBLE = 3
const AV_OPT_TYPE_FLOAT = 4
const AV_OPT_TYPE_STRING = 5
const AV_OPT_TYPE_RATIONAL = 6
const AV_OPT_TYPE_BINARY = 7
const AV_OPT_TYPE_CONST = 128
const FF_OPT_TYPE_FLAGS = 0
const FF_OPT_TYPE_INT = 1
const FF_OPT_TYPE_INT64 = 2
const FF_OPT_TYPE_DOUBLE = 3
const FF_OPT_TYPE_FLOAT = 4
const FF_OPT_TYPE_STRING = 5
const FF_OPT_TYPE_RATIONAL = 6
const FF_OPT_TYPE_BINARY = 7
const FF_OPT_TYPE_CONST = 128
# end
@ctypedef AVOption Void
@ctypedef vda_frame Void
@ctypedef AVIOInterruptCB Void
@ctypedef AVIOContext Void
@ctypedef URLContext Void
@ctypedef URLProtocol Void
@ctypedef URLPollEntry Void
@ctypedef URLInterruptCB Void
@ctypedef ByteIOContext AVIOContext
@ctypedef AVMetadata AVDictionary
@ctypedef AVMetadataTag AVDictionaryEntry
@ctypedef AVMetadataConv Void
@ctypedef AVFrac Void
@ctypedef AVProbeData Void
@ctypedef AVFormatParameters Void
@ctypedef AVOutputFormat Void
@ctypedef AVInputFormat Void
# enum AVStreamParseType
const AVSTREAM_PARSE_NONE = 0
const AVSTREAM_PARSE_FULL = 1
const AVSTREAM_PARSE_HEADERS = 2
const AVSTREAM_PARSE_TIMESTAMPS = 3
const AVSTREAM_PARSE_FULL_ONCE = 4
# end
@ctypedef AVIndexEntry Void
@ctypedef AVStream Void
@ctypedef AVProgram Void
@ctypedef AVChapter Void
@ctypedef AVFormatContext Void
@ctypedef AVPacketList Void
@ctypedef AVIOInterruptCB Void
@ctypedef URLContext Void
@ctypedef URLProtocol Void
@ctypedef URLPollEntry Void
@ctypedef URLInterruptCB Void
@ctypedef ByteIOContext AVIOContext
@ctypedef SwsVector Void
@ctypedef SwsFilter Void
@ctypedef AVCRC uint32_t
# enum AVCRCId
const AV_CRC_8_ATM = 0
const AV_CRC_16_ANSI = 1
const AV_CRC_16_CCITT = 2
const AV_CRC_32_IEEE = 3
const AV_CRC_32_IEEE_LE = 4
const AV_CRC_MAX = 5
# end
@ctypedef AVCRCId Int32
@ctypedef AVExpr Void
@ctypedef AVFifoBuffer Void
@ctypedef AVComponentDescriptor Void
@ctypedef AVPixFmtDescriptor Void
@ctypedef AVExtFloat Void
@ctypedef av_alias64 Void
@ctypedef av_alias32 Void
@ctypedef av_alias16 Void
@ctypedef AVLFG Void
@ctypedef AVClass Void
# enum AVRounding
const AV_ROUND_ZERO = 0
const AV_ROUND_INF = 1
const AV_ROUND_DOWN = 2
const AV_ROUND_UP = 3
const AV_ROUND_NEAR_INF = 5
# end
@ctypedef AVOption Void
@ctypedef AVComponentDescriptor Void
@ctypedef AVPixFmtDescriptor Void
@ctypedef AVRational Void
