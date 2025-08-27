# Codecs Comparison

A detailed comparison of most major codecs for video, audio, image, and more. Some data, like file size, are estimates, not actual values, since those depend on how something is decoded. It's made to be as consistent as I could make it, while still being easy to read. For example, JPEG lossless compression has a value going over 100%, because it's almost never used and makes the other values clearer.

## File Explanation

- **`database.sql`**: The script used to generate the database in SQLite, where all the data is stored initially.
- **`codecs.db`**: The actual database, generated with `sqlite3 codecs.db < database.sql`.
- **`table_generators/markdown.py`**: The script that generates a customizable Markdown version of the comparison from `codecs.db`.

## Simplified Markdown version

### Container

| Name | Description | License | Support (%) |
|:---|:---|:---|:---|
| MP4 | The most compatible and widely used container format for digital video. | 🟢 Free (Permissive) | 🟢 99 |
| MKV | A flexible container that can hold virtually any track type, prized by enthusiasts. | 🟢 Free (Permissive) | 🟡 75 |
| WebM | A container specifically designed for royalty-free web codecs like VP9 and AV1. | 🟢 Free (Permissive) | 🟢 90 |
| MOV | Apple's container format, a standard in professional video production. | 🟠 Proprietary | 🟡 80 |
| AVI | A legacy container from Microsoft, now outdated but still found in older archives. | 🟢 Free (Public Domain) | 🟡 65 |

### Video // Delivery

| Name | License | Support (%) | Encode Speed (%) | Decode Speed (%) | Lossy Size (%) |
|:---|:---|:---|:---|:---|:---|
| H.264 / AVC | 🟡 Royalty-Bearing (Simple) | 🟢 99 | 🟢 100 | 🟢 100 | 🔴 100 |
| H.265 / HEVC | 🔴 Royalty-Bearing (Complex) | 🟡 75 | 🔴 20 | 🟡 80 | 🟡 50 |
| VP9 | 🟢 Free (Permissive) | 🟢 85 | 🔴 25 | 🟡 80 | 🟡 55 |
| AV1 | 🟢 Free (Permissive) | 🟡 65 | 🔴 5 | 🟠 60 | 🟢 40 |
| H.266 / VVC | 🟠 Royalty-Bearing | 🔴 5 | 🔴 2 | 🔴 40 | 🟢 35 |
| MPEG-2 | 🟢 Free (Public Domain) | 🟡 70 | 🔵 150 | 🔵 150 | ⚫ 180 |

### Subtitle

| Name | Description | Type | License | Support (%) |
|:---|:---|:---|:---|:---|
| SRT | The most universal and basic text-based subtitle format. | Text | 🟢 Free (Public Domain) | 🟢 99 |
| ASS | A powerful text format offering advanced styling, positioning, and effects. | Text | 🟢 Free (Permissive) | 🟡 70 |
| WebVTT | The modern standard for subtitles on the web, designed for HTML5 video. | Text | 🟢 Free (Permissive) | 🟢 95 |
| VobSub | Image-based subtitle format used on DVDs. Cannot be scaled or edited like text. | Image | 🟠 Proprietary | 🟡 70 |
| PGS | High-resolution image-based subtitle format used on Blu-ray Discs. | Image | 🟠 Proprietary | 🟡 65 |

### Audio // Lossy

| Name | License | Support (%) | Decode Speed (%) | Latency | Lossy Size (%) | Max Channels |
|:---|:---|:---|:---|:---|:---|:---|
| Opus | 🟢 Free (Permissive) | 🟢 90 | 🟢 100 | 🟢 Very Low | 🟡 50 | 255 |
| MP3 | 🟢 Free (Public Domain) | 🟢 99 | 🟢 100 | 🔴 High | 🔴 100 | 2 |
| AAC | 🟡 Royalty-Bearing (Simple) | 🟢 95 | 🟢 100 | 🟠 Medium | 🟠 65 | 48 |
| Vorbis | 🟢 Free (Permissive) | 🟡 75 | 🟢 100 | 🔴 High | 🟠 80 | 255 |
| Dolby Digital | 🟠 Proprietary | 🟡 80 | 🟢 90 | 🔴 High | 🔴 90 | 5.1 |
| Dolby Digital (Plus) | 🟠 Proprietary | 🟡 70 | 🟢 95 | 🔴 High | 🟠 80 | 15.1 |

### Audio // Lossless

| Name | License | Support (%) | Decode Speed (%) | Lossless Size (%) | Audio Depth (bits) | Max Channels |
|:---|:---|:---|:---|:---|:---|:---|
| WAV (Uncompressed) | 🟢 Free (Public Domain) | 🟢 99 | 🟢 100 | 🔴 100 | 32 | 65536 |
| FLAC | 🟢 Free (Permissive) | 🟢 90 | 🟢 95 | 🟡 60 | 24 | 8 |
| ALAC | 🟢 Free (Permissive) | 🟠 60 | 🟢 95 | 🟠 65 | 32 | 8 |
| Monkey's Audio | 🟠 Proprietary | 🔴 30 | 🟡 70 | 🟡 55 | 24 | 32 |

### Image

| Name | License | Support (%) | Encode Speed (%) | Decode Speed (%) | Alpha? | Lossy Size (%) | Lossless Size (%) |
|:---|:---|:---|:---|:---|:---|:---|:---|
| JPEG | 🟢 Free (Public Domain) | 🟢 99 | 🟢 100 | 🟢 100 | No | 🔴 100 | ⚫ 200 |
| PNG | 🟢 Free (Permissive) | 🟢 99 | 🔴 30 | 🟡 80 | Yes | N/A | 🔴 100 |
| WebP | 🟢 Free (Permissive) | 🟢 97 | 🟢 90 | 🟢 100 | Yes | 🟠 70 | 🟠 75 |
| AVIF | 🟢 Free (Permissive) | 🟢 85 | 🔴 10 | 🟡 70 | Yes | 🟡 50 | 🟠 70 |
| JPEG XL | 🟢 Free (Permissive) | 🔴 10 | 🟢 90 | 🟢 100 | Yes | 🟢 40 | 🟠 65 |
| HEIF | 🟠 Proprietary | 🟡 65 | 🔴 30 | 🟢 90 | Yes | 🟡 50 | 🟠 70 |
| SVG | 🟢 Free (Permissive) | 🟢 98 | N/A | N/A | Yes | N/A | N/A |
| TIFF | 🟠 Proprietary | 🟠 60 | 🔴 20 | 🟡 70 | Yes | N/A | ⚫ 110 |

### Animated Image

| Name | License | Support (%) | Decode Speed (%) | Color Depth (bits) | Lossy Size (%) | Lossless Size (%) |
|:---|:---|:---|:---|:---|:---|:---|
| WebP (Animated) | 🟢 Free (Permissive) | 🟢 97 | 🟢 90 | 8 | 🟢 25 | 🟡 45 |
| AVIF (Animated) | 🟢 Free (Permissive) | 🟢 85 | 🟡 70 | 12 | 🟢 15 | 🟢 40 |
| GIF | 🟢 Free (Public Domain) | 🟢 99 | 🟢 100 | 2 | N/A | 🔴 100 |
| APNG | 🟢 Free (Permissive) | 🟢 95 | 🟡 80 | 16 | N/A | 🟠 65 |

### 3D Model

| Name | Description | License | Year | Support (%) |
|:---|:---|:---|:---|:---|
| glTF | "The JPEG of 3D," the modern standard for web and AR/VR. | 🟢 Free (Permissive) | 2015 | 🟢 85 |
| FBX | The de facto industry standard for exchanging animated 3D assets between applications. | 🟠 Proprietary | 2006 | 🟢 95 |
| OBJ | A simple, text-based format for static 3D models, universally supported. | 🟢 Free (Permissive) | 1990 | 🟢 98 |
| USD | "The HTML of the Metaverse," a framework for composing and collaborating on complex 3D scenes. | 🟢 Free (Permissive) | 2016 | 🟠 50 |
| STL | The universal, though inefficient, standard for 3D printing geometry. | 🟢 Free (Public Domain) | 1987 | 🟢 99 |
| 3MF | An open standard designed as a modern, feature-rich replacement for STL in 3D printing. | 🟢 Free (Permissive) | 2015 | 🟠 60 |