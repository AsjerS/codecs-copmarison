# Codecs Comparison - Markdown

### Container

| Name | Description | Support (%) | License | Year |
|:---|:---|:---|:---|:---|
| MP4 | The most compatible and widely used container format for digital video. | 🟢 99 | 🟢 Free (Permissive) | 2001 |
| MKV | A flexible container that can hold virtually any track type, prized by enthusiasts. | 🟡 75 | 🟢 Free (Permissive) | 2002 |
| WebM | A container specifically designed for royalty-free web codecs like VP9 and AV1. | 🟢 90 | 🟢 Free (Permissive) | 2010 |
| MOV | Apple's container format, a standard in professional video production. | 🟡 80 | 🟠 Proprietary | 1991 |
| AVI | A legacy container from Microsoft, now outdated but still found in older archives. | 🟡 65 | 🟢 Free (Public Domain) | 1992 |

### Video // Delivery

| Name | Description | Lossy Size (%) | Lossless Size (%) | Support (%) | Decode Speed (%) | Encode Speed (%) | License | Year | Editing Performance | Alpha? | Color Model | Color Depth (bits) |
|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|
| H.264 / AVC | The universal compatibility king for over a decade. | 🔴 100 | N/A | 🟢 99 | 🟢 100 | 🟢 100 | 🟡 Royalty-Bearing (Simple) | 2003 | 🔴 Poor | No | YUV 4:2:0 | 10 |
| H.265 / HEVC | Dominant in premium 4K media, but with complex licensing. | 🟡 50 | N/A | 🟡 75 | 🟡 80 | 🔴 20 | 🔴 Royalty-Bearing (Complex) | 2013 | 🔴 Poor | No | YUV 4:4:4 | 10 |
| VP9 | Google's successful open alternative to HEVC, the backbone of YouTube. | 🟡 55 | N/A | 🟢 85 | 🟡 80 | 🔴 25 | 🟢 Free (Permissive) | 2013 | 🔴 Poor | Yes | YUV 4:4:4 | 12 |
| AV1 | The royalty-free future of web video, backed by major tech companies. | 🟢 40 | N/A | 🟡 70 | 🟠 60 | 🔴 5 | 🟢 Free (Permissive) | 2018 | 🔴 Poor | Yes | YUV 4:4:4 | 12 |
| H.266 / VVC | A successor to HEVC, its adoption is limited by licensing and the rise of AV1. | 🟢 35 | N/A | 🔴 5 | 🔴 40 | 🔴 2 | 🟠 Royalty-Bearing | 2020 | 🔴 Poor | No | YUV 4:4:4 | 10 |
| MPEG-2 | The workhorse of standard-definition digital video (DVDs, DVB). | ⚫ 180 | N/A | 🟡 70 | 🔵 150 | 🔵 150 | 🟢 Free (Public Domain) | 1995 | 🔴 Poor | No | YUV 4:2:2 | 8 |
| VP8 | The original royalty-free codec for WebM, now primarily used as a baseline for WebRTC. | ⚫ 115 | N/A | 🟡 70 | 🔵 130 | 🔵 120 | 🟢 Free (Permissive) | 2008 | 🔴 Poor | Yes | YUV 4:2:0 | 8 |

### Video // Intermediate

| Name | Description | Lossless Size (%) | Support (%) | Decode Speed (%) | Encode Speed (%) | License | Year | Editing Performance | Alpha? | Color Model | Color Depth (bits) |
|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|
| Apple ProRes (422 HQ) | The dominant intermediate codec in Mac-centric professional workflows. | 🟢 25 | 🟡 70 | N/A | N/A | 🟠 Proprietary | 2007 | 🟢 Excellent | No | YUV 4:2:2 | 10 |
| Apple ProRes (4444 XQ) | The highest-quality version of ProRes, supporting an alpha channel. | 🟡 55 | 🟠 60 | N/A | N/A | 🟠 Proprietary | 2007 | 🟢 Excellent | Yes | YUV 4:4:4 | 12 |
| Avid DNxHR (HQX) | The cross-platform industry standard for professional editing, especially in broadcast. | 🟢 25 | 🟡 70 | N/A | N/A | 🟡 Royalty-Bearing (Simple) | 2014 | 🟢 Excellent | Yes | YUV 4:4:4 | 12 |
| Avid DNxHR (LB) | A low-bandwidth version of DNxHR for offline editing and proxies. | 🟢 8 | 🟡 70 | N/A | N/A | 🟡 Royalty-Bearing (Simple) | 2014 | 🟢 Excellent | Yes | YUV 4:2:0 | 8 |
| GoPro CineForm | A high-quality intermediate codec, popular in GoPro and VFX workflows. | 🟢 20 | 🟠 50 | N/A | N/A | 🟠 Proprietary | 2004 | 🟢 Excellent | Yes | YUV 4:4:4 | 12 |

### Video // Archival

| Name | Description | Lossless Size (%) | Support (%) | Decode Speed (%) | Encode Speed (%) | License | Year | Editing Performance | Alpha? | Color Model | Color Depth (bits) |
|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|
| H.264 / AVC (Lossless) | Lossless profile of H.264, offering poor compression but using ubiquitous hardware. | 🟡 42 | N/A | N/A | N/A | 🟡 Royalty-Bearing (Simple) | 2003 | 🔴 Poor | No | YUV 4:2:2 | 10 |
| H.265 / HEVC (Lossless) | Lossless profile of H.265, offering good compression with potential for hardware support. | 🟢 40 | N/A | N/A | N/A | 🔴 Royalty-Bearing (Complex) | 2013 | 🔴 Poor | No | YUV 4:4:4 | 10 |
| VP9 (Lossless) | Lossless profile of VP9, offering a good open-source alternative for archival. | 🟢 38 | N/A | N/A | N/A | 🟢 Free (Permissive) | 2013 | 🔴 Poor | Yes | YUV 4:4:4 | 12 |
| AV1 (Lossless) | Lossless profile of AV1, offering the best compression ratio for archival video. | 🟢 35 | N/A | N/A | N/A | 🟢 Free (Permissive) | 2018 | 🔴 Poor | Yes | YUV 4:4:4 | 12 |
| Uncompressed Video (10-bit 4:4:4) | A raw, uncompressed video stream, used as a baseline for archival codecs. | 🔴 100 | N/A | N/A | N/A | N/A | N/A | 🟡 Good | Yes | YUV 4:4:4 | 10 |
| FFV1 | The open standard for video archiving, prized for its data integrity features like checksums. | 🟡 45 | 🔴 40 | N/A | N/A | 🟢 Free (Permissive) | 2003 | 🔴 Poor | Yes | YUV 4:4:4 | 16 |

### Subtitle

| Name | Description | Support (%) | License | Year | Type |
|:---|:---|:---|:---|:---|:---|
| SRT | The most universal and basic text-based subtitle format. | 🟢 99 | 🟢 Free (Public Domain) | 1999 | Text |
| ASS | A powerful text format offering advanced styling, positioning, and effects. | 🟡 70 | 🟢 Free (Permissive) | 2002 | Text |
| WebVTT | The modern standard for subtitles on the web, designed for HTML5 video. | 🟢 95 | 🟢 Free (Permissive) | 2010 | Text |
| VobSub | Image-based subtitle format used on DVDs. Cannot be scaled or edited like text. | 🟡 70 | 🟠 Proprietary | 1997 | Image |
| PGS | High-resolution image-based subtitle format used on Blu-ray Discs. | 🟡 65 | 🟠 Proprietary | 2006 | Image |

### Audio // Lossy

| Name | Description | Lossy Size (%) | Support (%) | Decode Speed (%) | License | Year | Max Channels | Audio Depth (bits) | Latency |
|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|
| Opus | State-of-the-art codec for WebRTC, VoIP, and modern streaming. | 🟡 50 | 🟢 90 | 🟢 100 | 🟢 Free (Permissive) | 2012 | 255 | 32 | 🟢 Very Low |
| MP3 | The legacy audio king, universal but inefficient. | 🔴 100 | 🟢 99 | 🟢 100 | 🟢 Free (Public Domain) | 1993 | 2 | 16 | 🔴 High |
| AAC | The standard for Apple devices, YouTube, and most modern streaming services. | 🟠 65 | 🟢 95 | 🟢 100 | 🟡 Royalty-Bearing (Simple) | 1997 | 48 | 24 | 🟠 Medium |
| Vorbis | The original open-source alternative to MP3, used heavily by Spotify and game developers. | 🟠 80 | 🟡 75 | 🟢 100 | 🟢 Free (Permissive) | 2000 | 255 | 16 | 🔴 High |

### Audio // Lossless

| Name | Description | Lossless Size (%) | Support (%) | Decode Speed (%) | License | Year | Max Channels | Audio Depth (bits) | Latency |
|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|
| WAV (Uncompressed) | The universal standard for uncompressed, raw PCM audio data, used as a baseline. | 🔴 100 | 🟢 99 | 🟢 100 | 🟢 Free (Public Domain) | 1991 | 65536 | 32 | 🔴 High |
| FLAC | The de facto open standard for copmressed lossless audio. Note: most existing decoders only support up to 24-bit decoding | 🟡 60 | 🟢 90 | 🟢 95 | 🟢 Free (Permissive) | 2001 | 8 | 32 | 🔴 High |
| ALAC | Apple's native lossless format, open-sourced in 2011. | 🟠 65 | 🟠 60 | 🟢 95 | 🟢 Free (Permissive) | 2004 | 8 | 32 | 🔴 High |
| Monkey's Audio | A proprietary codec known for its very high compression ratios, popular in niche audiophile circles. | 🟡 55 | 🔴 30 | 🟡 70 | 🟡 Free (Source Available) | 2001 | 32 | 24 | 🔴 High |

### Image

| Name | Description | Lossy Size (%) | Lossless Size (%) | Support (%) | Decode Speed (%) | Encode Speed (%) | License | Year | Alpha? | Color Model | Color Depth (bits) |
|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|
| JPEG | The universal standard for photographic images on the web. | 🔴 100 | ⚫ 200 | 🟢 99 | 🟢 100 | 🟢 100 | 🟢 Free (Public Domain) | 1992 | No | YCbCr | 8 |
| PNG | The standard for lossless web graphics and transparency, used as a baseline. | N/A | 🔴 100 | 🟢 99 | 🟡 80 | 🔴 30 | 🟢 Free (Permissive) | 1996 | Yes | RGB | 8 |
| WebP | Google's versatile format to replace JPEG and PNG, offering better compression. | 🟠 70 | 🟠 75 | 🟢 97 | 🟢 100 | 🟢 90 | 🟢 Free (Permissive) | 2010 | Yes | YUV 4:2:0 | 8 |
| AVIF | State-of-the-art compression based on AV1, offering superior quality and features. | 🟡 50 | 🟠 70 | 🟢 85 | 🟡 70 | 🔴 10 | 🟢 Free (Permissive) | 2019 | Yes | YUV 4:4:4 | 12 |
| JPEG XL | A technically superior next-gen format, but its adoption was stalled by browser politics. | 🟢 40 | 🟠 65 | 🔴 10 | 🟢 100 | 🟢 90 | 🟢 Free (Permissive) | 2020 | Yes | XYB | 16 |
| HEIF | The container format used by Apple devices, typically with an HEVC-encoded image. | 🟡 50 | 🟠 70 | 🟡 65 | 🟢 90 | 🔴 30 | 🔴 Royalty-Bearing (Complex) | 2015 | Yes | YUV 4:2:2 | 10 |
| SVG | An XML-based vector format. Performance and file size are not directly comparable to raster formats. | N/A | N/A | 🟢 98 | N/A | N/A | 🟢 Free (Permissive) | 2001 | Yes | Vector | 8 |
| TIFF | The standard for high-quality print, archiving, and professional photography masters. | N/A | ⚫ 110 | 🟠 60 | 🟡 70 | 🔴 20 | 🟠 Proprietary | 1986 | Yes | RGB | 16 |

### Animated Image

| Name | Description | Lossy Size (%) | Lossless Size (%) | Support (%) | Decode Speed (%) | Encode Speed (%) | License | Year | Alpha? | Color Model | Color Depth (bits) |
|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|
| WebP (Animated) | Offers smaller file sizes than GIF with better color and alpha support. | 🟢 25 | 🟡 45 | 🟢 97 | 🟢 90 | N/A | 🟢 Free (Permissive) | 2010 | Yes | RGB | 8 |
| AVIF (Animated) | State-of-the-art compression for animations, offering massive savings over GIF. | 🟢 15 | 🟢 40 | 🟢 85 | 🟡 70 | N/A | 🟢 Free (Permissive) | 2019 | Yes | YUV 4:4:4 | 12 |
| GIF | The universal standard for short animations, limited to a 256-color palette. | N/A | 🔴 100 | 🟢 99 | 🟢 100 | N/A | 🟢 Free (Public Domain) | 1989 | Yes | Indexed | 8 |
| APNG | An extension of PNG for lossless animations with full color and alpha support, used as a baseline. | N/A | 🟠 65 | 🟢 95 | 🟡 80 | N/A | 🟢 Free (Permissive) | 2004 | Yes | RGB | 8 |

### 3D Model

| Name | Description | Lossless Size (%) | Support (%) | License | Year |
|:---|:---|:---|:---|:---|:---|
| glTF | Highly optimized binary format (GLB) for web delivery; often the smallest for geometry. | 🟢 35 | 🟢 85 | 🟢 Free (Permissive) | 2015 |
| FBX | Binary format with scene overhead; efficient but not as compact as web-focused formats for pure geometry. | 🟡 60 | 🟢 95 | 🟠 Proprietary | 2006 |
| OBJ | Text-based and verbose; files are significantly larger than binary equivalents for the same geometry. | ⚫ 140 | 🟢 98 | 🟢 Free (Permissive) | 1990 |
| USD | "The HTML of the Metaverse," a framework for composing and collaborating on complex 3D scenes. | 🟡 60 | 🟠 50 | 🟢 Free (Permissive) | 2016 |
| STL (Binary) | The most used, though inefficient, standard for 3D printing. | 🔴 100 | 🟢 99 | 🟢 Free (Public Domain) | 1987 |
| STL (ASCII) | A human-readable but inefficient text-based version of the STL format. | ⚫ 400 | 🟢 99 | 🟢 Free (Public Domain) | 1987 |
| 3MF | Uses ZIP compression, resulting in much smaller files than STL for the same model. | 🟢 40 | 🟠 60 | 🟢 Free (Permissive) | 2015 |

### Audio // Home Theater

| Name | Description | Lossy Size (%) | Lossless Size (%) | Support (%) | Decode Speed (%) | License | Year | Max Channels | Audio Depth (bits) | Latency |
|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|
| Dolby Digital | The standard for surround sound on DVDs and broadcast television. | 🔴 90 | N/A | 🟡 80 | 🟢 90 | 🟠 Proprietary | 1992 | 5.1 | 16 | 🔴 High |
| Dolby Digital (Plus) | An enhanced version of AC-3 used by streaming services and as a core for TrueHD. | 🟠 80 | N/A | 🟡 70 | 🟢 95 | 🟠 Proprietary | 1992 | 15.1 | 24 | 🔴 High |
| Dolby TrueHD | A lossless audio codec that directly competes with DTS-HD MA on Blu-ray discs. | N/A | 🟡 55 | 🟡 75 | 🟢 90 | 🟠 Proprietary | 2006 | 8 | 24 | 🔴 High |
| Dolby TrueHD (Atmos) | Object-based immersive audio, typically delivered within a Dolby TrueHD stream on Blu-ray. | N/A | 🟡 58 | 🟡 65 | 🟢 85 | 🟠 Proprietary | 2006 | 7.1 + Objects | 24 | 🔴 High |
| DTS (Core) | The standard lossy surround format from DTS, competing with Dolby Digital. Often used as a fallback track. | 🔴 95 | N/A | 🟡 75 | 🟢 90 | 🟠 Proprietary | 1993 | 5.1 | 24 | 🔴 High |
| DTS-HD Master Audio | The primary lossless audio codec from DTS. The most common advanced format on Blu-ray. | N/A | 🟡 58 | 🟡 80 | 🟢 90 | 🟠 Proprietary | 2004 | 8 | 24 | 🔴 High |
| DTS-HD Master Audio (DTS:X) | DTS's object-based immersive audio format, competing with Dolby Atmos. | N/A | 🟡 60 | 🟠 60 | 🟢 85 | 🟠 Proprietary | 2004 | 7.1 + Objects | 24 | 🔴 High |

