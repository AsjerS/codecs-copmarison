### Container

| Name | Maker(s) | Description | Support (%) | License | Year |
|:---|:---|:---|:---|:---|:---|
| MP4 | ISO/IEC | The most compatible and widely used container format for digital video. Often uses .M4A for audio-only, usually containing AAC. | 🟢 99 | 🟢 Free (Permissive) | 2001 |
| MKV | Xiph.Org Foundation | A flexible container that can hold virtually any track type, prized by enthusiasts. | 🟡 75 | 🟢 Free (Permissive) | 2002 |
| WebM | Google | A container specifically designed for royalty-free web codecs like VP9 and AV1. | 🟢 90 | 🟢 Free (Permissive) | 2010 |
| MOV | Apple | Apple's container format, a standard in professional video production. | 🟡 80 | 🟠 Proprietary | 1991 |
| AVI | Microsoft | A legacy container, now outdated but still found in older archives. | 🟡 65 | 🟢 Free (Public Domain) | 1992 |
| Ogg | Xiph.Org Foundation | The container format for the Xiph.Org Foundation's family of open-source codecs like Vorbis, Opus, and Theora. | 🟡 70 | 🟢 Free (Permissive) | 2002 |
| 3GP | 3GPP | A simplified version of the MP4 container, designed for early 3G mobile phones and MMS messaging. | 🟠 50 | 🟢 Free (Permissive) | 2001 |
| 3G2 | 3GPP2 | A container format for CDMA2000 mobile networks, a sibling to the more common 3GP format. | 🔴 40 | 🟢 Free (Permissive) | 2002 |
| IAMF | Alliance for Open Media | A specialized open container format for delivering immersive and object-based audio. | 🔴 20 | 🟢 Free (Permissive) | 2023 |

### Video // Delivery

| Name | Maker(s) | Description | Lossy Size (%) | Support (%) | Decode Speed (%) | Encode Speed (%) | License | Year | Editing Performance | Alpha? | Color Model | Color Depth (bits) |
|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|
| H.264 / AVC | ITU-T, ISO/IEC | The universal compatibility king for over a decade. | 🔴 100 | 🟢 99 | 🟢 100 | 🟢 100 | 🟡 Royalty-Bearing (Simple) | 2003 | 🔴 Poor | No | YUV 4:2:0 | 10 |
| H.265 / HEVC | ITU-T, ISO/IEC | Dominant in premium 4K media, but with complex licensing. | 🟡 50 | 🟡 75 | 🟡 80 | 🔴 20 | 🔴 Royalty-Bearing (Complex) | 2013 | 🔴 Poor | No | YUV 4:4:4 | 10 |
| VP9 | Google | Google's successful open alternative to HEVC, the backbone of YouTube. | 🟡 55 | 🟢 85 | 🟡 80 | 🔴 25 | 🟢 Free (Permissive) | 2013 | 🔴 Poor | Yes | YUV 4:4:4 | 12 |
| AV1 | Alliance for Open Media | The royalty-free future of web video, backed by major tech companies. | 🟢 40 | 🟡 70 | 🟠 60 | 🔴 5 | 🟢 Free (Permissive) | 2018 | 🔴 Poor | Yes | YUV 4:4:4 | 12 |
| AV2 | Alliance for Open Media | An in-development successor to AV1. Performance numbers are preliminary and based on early, unoptimized reference software. | 🟢 30 | 🔴 0 | 🔴 10 | 🔴 1 | 🟢 Free (Permissive) | 2024 | 🔴 Poor | Yes | YUV 4:4:4 | 12 |
| H.266 / VVC | ITU-T, ISO/IEC | A successor to HEVC, its adoption is limited by licensing and the rise of AV1. | 🟢 35 | 🔴 5 | 🔴 40 | 🔴 2 | 🟠 Royalty-Bearing | 2020 | 🔴 Poor | No | YUV 4:4:4 | 10 |
| MPEG-2 | MPEG | The workhorse of standard-definition digital video (DVDs, DVB). | ⚫ 180 | 🟡 70 | 🔵 150 | 🔵 150 | 🟢 Free (Public Domain) | 1995 | 🔴 Poor | No | YUV 4:2:2 | 8 |
| VP8 | Google | The original royalty-free codec for WebM, now primarily used as a baseline for WebRTC. | ⚫ 115 | 🟡 70 | 🔵 130 | 🔵 120 | 🟢 Free (Permissive) | 2008 | 🔴 Poor | Yes | YUV 4:2:0 | 8 |
| Theora | Xiph.Org Foundation | The original open-source video codec. Now a legacy format, superseded by VP8/VP9. | ⚫ 130 | 🔴 40 | 🔵 120 | 🔵 110 | 🟢 Free (Permissive) | 2004 | 🔴 Poor | No | YUV 4:2:0 | 8 |
| MPEG-1 | MPEG | The original standard for digital video, famous for Video CDs (VCDs). Now completely obsolete due to its very poor compression. | ⚫ 300 | 🟠 60 | 🔵 200 | 🔵 200 | 🟢 Free (Public Domain) | 1993 | 🔴 Poor | No | YUV 4:2:0 | 8 |
| VC-1 | Microsoft | Standardized for Blu-ray. A direct competitor to H.264, but saw less adoption and is now a legacy format. | ⚫ 105 | 🟡 65 | 🟢 100 | 🔵 110 | 🟡 Royalty-Bearing (Simple) | 2006 | 🔴 Poor | No | YUV 4:2:0 | 8 |
| DivX | DivX, Inc. | A popular proprietary codec based on MPEG-4 Part 2. Common in older hardware players from the 2000s. | ⚫ 120 | 🟡 70 | 🔵 110 | 🔵 115 | 🟠 Proprietary | 1999 | 🔴 Poor | No | YUV 4:2:0 | 8 |
| Xvid | The Community | The open-source equivalent of DivX. Was the dominant format for video sharing online before the rise of H.264. | ⚫ 115 | 🟡 70 | 🔵 110 | 🔵 115 | 🟢 Free (Permissive) | 2001 | 🔴 Poor | No | YUV 4:2:0 | 8 |
| RealVideo | RealNetworks | A dominant streaming video format in the late 90s/early 2000s, optimized for very low bitrates. | ⚫ 130 | 🔴 40 | 🟢 90 | 🟢 90 | 🟠 Proprietary | 1997 | 🔴 Poor | No | YUV 4:2:0 | 8 |
| H.263 | ITU-T | The predecessor to H.264 for video conferencing and mobile video. Optimized for low bitrates. | ⚫ 150 | 🟠 50 | 🔵 140 | 🔵 140 | 🟡 Royalty-Bearing (Simple) | 1996 | 🔴 Poor | No | YUV 4:2:0 | 8 |
| Sorenson Spark | Sorenson Media | The dominant video codec of the early web, used in Adobe Flash Player and early versions of YouTube. | ⚫ 125 | 🟠 45 | 🔵 115 | 🔵 120 | 🟠 Proprietary | 1998 | 🔴 Poor | No | YUV 4:2:0 | 8 |

### Audio // Lossy

| Name | Maker(s) | Description | Lossy Size (%) | Support (%) | Decode Speed (%) | Encode Speed (%) | License | Year | Max Channels | Audio Depth (bits) | Latency |
|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|
| Opus | Xiph.Org Foundation | State-of-the-art codec for WebRTC, VoIP, and modern streaming. | 🟡 50 | 🟢 90 | 🟢 100 | 🔵 150 | 🟢 Free (Permissive) | 2012 | 255 | 32 | 🟢 Very Low |
| MP3 | Fraunhofer IIS, MPEG | The legacy audio king, universal but inefficient. | 🔴 100 | 🟢 99 | 🟢 100 | 🟢 100 | 🟢 Free (Public Domain) | 1993 | 2 | 16 | 🔴 High |
| AAC | MPEG | The standard for Apple devices and most modern streaming services. | 🟠 65 | 🟢 95 | 🟢 100 | 🟢 85 | 🟡 Royalty-Bearing (Simple) | 1997 | 48 | 24 | 🟠 Medium |
| Vorbis | Xiph.Org Foundation | The original open-source alternative to MP3, used heavily by Spotify and game developers. | 🟠 80 | 🟡 75 | 🟢 90 | 🟡 70 | 🟢 Free (Permissive) | 2000 | 255 | 16 | 🔴 High |
| MP2 | Fraunhofer IIS, MPEG | The predecessor to MP3, used for Video CDs (VCDs) and digital broadcasting. | ⚫ 140 | 🟠 60 | 🔵 105 | 🔵 110 | 🟢 Free (Public Domain) | 1993 | 2 | 16 | 🔴 High |
| RealAudio | RealNetworks | A pioneering streaming audio format from the dial-up era, known for its high compression at low bitrates. | ⚫ 110 | 🔴 40 | 🟢 95 | 🟢 90 | 🟠 Proprietary | 1995 | 2 | 16 | 🔴 High |
| WMA (Standard) | Microsoft | Microsoft's proprietary competitor to MP3 and AAC, widely used in the Windows ecosystem. | 🔴 85 | 🟡 65 | 🟢 95 | 🟢 90 | 🟠 Proprietary | 1999 | 2 | 16 | 🔴 High |
| ATRAC | Sony | Sony's proprietary audio codec, famous for the MiniDisc format. A major competitor to MP3 in its era. | 🔴 90 | 🔴 30 | 🟢 95 | 🟢 95 | 🟠 Proprietary | 1992 | 2 | 16 | 🔴 High |
| AMR (Narrowband (AMR-NB)) | 3GPP | The standard speech codec for 2G/3G mobile networks. Optimized for voice intelligibility at extremely low bitrates. | 🟢 15 | 🟡 80 | 🔵 300 | 🔵 300 | 🟡 Royalty-Bearing (Simple) | 1999 | 1 | 16 | 🟢 Very Low |
| AMR (Wideband (AMR-WB)) | 3GPP | The "HD Voice" codec used in modern mobile networks (VoLTE). Offers significantly better speech quality than AMR-NB. | 🟢 25 | 🟡 75 | 🔵 250 | 🔵 250 | 🟡 Royalty-Bearing (Simple) | 1999 | 1 | 16 | 🟢 Very Low |

### Audio // Lossless

| Name | Maker(s) | Description | Lossless Size (%) | Support (%) | Decode Speed (%) | Encode Speed (%) | License | Year | Max Channels | Audio Depth (bits) | Latency |
|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|
| WMA (Lossless) | Microsoft | The lossless version of WMA, Microsoft's proprietary codec, widely used in the Windows ecosystem. | 🟠 62 | 🟠 50 | 🟢 90 | 🟡 80 | 🟠 Proprietary | 1999 | 8 | 24 | 🔴 High |
| WAV (Uncompressed) | Microsoft, IBM | The universal standard for uncompressed, raw PCM audio data. | 🔴 100 | 🟢 99 | 🔵 1000 | 🔵 1000 | 🟢 Free (Public Domain) | 1991 | 65536 | 32 | 🔴 High |
| FLAC | Xiph.Org Foundation | The de facto open standard for compressed lossless audio. Note: most existing decoders only support up to 24-bit decoding | 🟡 60 | 🟢 90 | 🟢 95 | 🟢 90 | 🟢 Free (Permissive) | 2001 | 8 | 32 | 🔴 High |
| ALAC | Apple | Apple's native lossless format, open-sourced in 2011. | 🟠 65 | 🟠 60 | 🟢 95 | 🔵 120 | 🟢 Free (Permissive) | 2004 | 8 | 32 | 🔴 High |
| Monkey's Audio | Matthew T. Ashland | A proprietary codec known for its very high compression ratios, popular in niche audiophile circles. | 🟡 55 | 🔴 30 | 🟡 80 | 🔴 30 | 🟡 Free (Source Available) | 2001 | 32 | 24 | 🔴 High |
| Shorten | SoftSound | An early lossless audio codec, popular in music trading communities before being superseded by FLAC. | 🟠 70 | 🔴 20 | 🟢 85 | 🟡 70 | 🟡 Free (Source Available) | 1992 | 2 | 16 | 🔴 High |

### Image

| Name | Maker(s) | Description | Lossy Size (%) | Lossless Size (%) | Support (%) | Decode Speed (%) | Encode Speed (%) | License | Year | Alpha? | Color Model | Color Depth (bits) |
|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|
| JPEG | ISO/IEC | The universal standard for photographic images on the web. | 🔴 100 | ⚫ 200 | 🟢 99 | 🟢 100 | 🟢 100 | 🟢 Free (Public Domain) | 1992 | No | YCbCr | 8 |
| PNG | W3C | The standard for lossless web graphics and transparency. | N/A | 🔴 100 | 🟢 99 | 🟡 80 | 🔴 30 | 🟢 Free (Permissive) | 1996 | Yes | RGB | 8 |
| WebP | Google | Google's versatile format to replace JPEG and PNG, offering better compression. | 🟠 70 | 🟠 75 | 🟢 97 | 🟢 100 | 🟢 90 | 🟢 Free (Permissive) | 2010 | Yes | YUV 4:2:0 | 8 |
| AVIF | Alliance for Open Media | State-of-the-art compression based on AV1, offering superior quality and features. | 🟡 50 | 🟠 70 | 🟢 85 | 🟡 70 | 🔴 10 | 🟢 Free (Permissive) | 2019 | Yes | YUV 4:4:4 | 12 |
| JPEG XL | ISO/IEC | A technically superior next-gen format, but its adoption was stalled by browser politics. | 🟢 40 | 🟠 65 | 🔴 10 | 🟢 100 | 🟢 90 | 🟢 Free (Permissive) | 2020 | Yes | XYB | 16 |
| HEIF | ISO/IEC | The container format used by most modern smartphones, typically with an HEVC-encoded image. | 🟡 50 | 🟠 70 | 🟡 65 | 🟢 90 | 🔴 30 | 🔴 Royalty-Bearing (Complex) | 2015 | Yes | YUV 4:2:2 | 10 |
| SVG | W3C | An XML-based vector format. Performance and file size are not directly comparable to raster formats. | N/A | N/A | 🟢 98 | N/A | N/A | 🟢 Free (Permissive) | 2001 | Yes | Vector | 8 |
| TIFF | Adobe | The standard for high-quality print, archiving, and professional photography masters. | N/A | ⚫ 110 | 🟠 60 | 🟡 70 | 🔴 20 | 🟠 Proprietary | 1986 | Yes | RGB | 16 |
| DNG | Adobe | A "digital negative" containing unprocessed 12-16 bit data from a camera sensor. Offers maximum editing flexibility. | N/A | ⚫ 250 | 🟠 50 | N/A | N/A | 🟠 Proprietary | 2004 | No | RGB | 16 |
| BMP | Microsoft | The uncompressed bitmap image format native to Windows. Files are large but simple and widely supported. | N/A | ⚫ 130 | 🟢 95 | 🔵 200 | 🔵 200 | 🟠 Proprietary | 1990 | No | RGB | 8 |
| JPEG 2000 | ISO/IEC | A technically superior successor to JPEG that failed to gain mainstream adoption. Now used in niche archival and medical imaging. | 🟠 75 | 🟠 80 | 🔴 30 | 🟠 50 | 🔴 40 | 🟠 Royalty-Bearing | 2000 | Yes | YCbCr | 16 |

