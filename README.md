# Codecs Comparison

A detailed comparison of most major codecs for video, audio, image, and more. Some data, like file size, are estimates, not actual values, since those depend on how something is decoded. It's made to be as consistent as I could make it, while still being easy to read. For example, JPEG lossless compression has a value going over 100%, because it's almost never used and makes the other values clearer.

## File Explanation

- **`database.sql`**: The script used to generate the database in SQLite, where all the data is stored initially.
- **`table_generators/markdown.py`**: The script that generates a customizable Markdown version of the comparison from `codecs.db`.

## Build Your Own

To make your own version of the table, follow these steps:

1. Install SQLite and Python on your system.
2. Copy this repository: `git clone https://github.com/AsjerS/codecs-copmarison.git`.
3. CD into the repository, and generate `codecs.db` with `sqlite3 codecs.db < databse.sql`.
4. CD into `table_generators/`, and edit the `markdown.py` configuration to your liking.
5. Run `markdown.py`.

There is a ton of data in the database that's unused in the version on this page, so you could make your own table however you'd like. When I find the time for it I might also make a GUI application for generating these tables.

## Markdown Version

Note: this is a heavily stripped down version of the comparison, only containing the codecs you're most likely to find on the web.

There is a version with all codecs existing in the database named `full_version.md`, though this is mostly just for easily previewing what data there is in the database without installing anything.

### Container

| Name | Description | Support (%) | License | Year |
|:---|:---|:---|:---|:---|
| MP4 | The most compatible and widely used container format for digital video. | 🟢 99 | 🟢 Free (Permissive) | 2001 |
| MKV | A flexible container that can hold virtually any track type, prized by enthusiasts. | 🟡 75 | 🟢 Free (Permissive) | 2002 |
| WebM | A container specifically designed for royalty-free web codecs like VP9 and AV1. | 🟢 90 | 🟢 Free (Permissive) | 2010 |
| MOV | Apple's container format, a standard in professional video production. | 🟡 80 | 🟠 Proprietary | 1991 |
| AVI | A legacy container from Microsoft, now outdated but still found in older archives. | 🟡 65 | 🟢 Free (Public Domain) | 1992 |

### Video // Delivery

| Name | Lossy Size (%) | Support (%) | Decode Speed (%) | Encode Speed (%) | License |
|:---|:---|:---|:---|:---|:---|
| H.264 / AVC | 🔴 100 | 🟢 99 | 🟢 100 | 🟢 100 | 🟡 Royalty-Bearing (Simple) |
| H.265 / HEVC | 🟡 50 | 🟡 75 | 🟡 80 | 🔴 20 | 🔴 Royalty-Bearing (Complex) |
| VP9 | 🟡 55 | 🟢 85 | 🟡 80 | 🔴 25 | 🟢 Free (Permissive) |
| AV1 | 🟢 40 | 🟡 70 | 🟠 60 | 🔴 5 | 🟢 Free (Permissive) |
| H.266 / VVC | 🟢 35 | 🔴 5 | 🔴 40 | 🔴 2 | 🟠 Royalty-Bearing |
| MPEG-2 | ⚫ 180 | 🟡 70 | 🔵 150 | 🔵 150 | 🟢 Free (Public Domain) |
| VP8 | ⚫ 115 | 🟡 70 | 🔵 130 | 🔵 120 | 🟢 Free (Permissive) |

### Audio // Lossy

| Name | Lossy Size (%) | Support (%) | Decode Speed (%) | License | Max Channels | Latency |
|:---|:---|:---|:---|:---|:---|:---|
| Opus | 🟡 50 | 🟢 90 | 🟢 100 | 🟢 Free (Permissive) | 255 | 🟢 Very Low |
| MP3 | 🔴 100 | 🟢 99 | 🟢 100 | 🟢 Free (Public Domain) | 2 | 🔴 High |
| AAC | 🟠 65 | 🟢 95 | 🟢 100 | 🟡 Royalty-Bearing (Simple) | 48 | 🟠 Medium |
| Vorbis | 🟠 80 | 🟡 75 | 🟢 100 | 🟢 Free (Permissive) | 255 | 🔴 High |

### Audio // Lossless

| Name | Lossless Size (%) | Support (%) | Decode Speed (%) | License | Max Channels | Audio Depth (bits) |
|:---|:---|:---|:---|:---|:---|:---|
| WAV (Uncompressed) | 🔴 100 | 🟢 99 | 🟢 100 | 🟢 Free (Public Domain) | 65536 | 32 |
| FLAC | 🟡 60 | 🟢 90 | 🟢 95 | 🟢 Free (Permissive) | 8 | 32 |
| ALAC | 🟠 65 | 🟠 60 | 🟢 95 | 🟢 Free (Permissive) | 8 | 32 |
| Monkey's Audio | 🟡 55 | 🔴 30 | 🟡 70 | 🟡 Free (Source Available) | 32 | 24 |

### Image

| Name | Lossy Size (%) | Lossless Size (%) | Support (%) | Decode Speed (%) | Encode Speed (%) | License | Alpha? |
|:---|:---|:---|:---|:---|:---|:---|:---|
| JPEG | 🔴 100 | ⚫ 200 | 🟢 99 | 🟢 100 | 🟢 100 | 🟢 Free (Public Domain) | No |
| PNG | N/A | 🔴 100 | 🟢 99 | 🟡 80 | 🔴 30 | 🟢 Free (Permissive) | Yes |
| WebP | 🟠 70 | 🟠 75 | 🟢 97 | 🟢 100 | 🟢 90 | 🟢 Free (Permissive) | Yes |
| AVIF | 🟡 50 | 🟠 70 | 🟢 85 | 🟡 70 | 🔴 10 | 🟢 Free (Permissive) | Yes |
| JPEG XL | 🟢 40 | 🟠 65 | 🔴 10 | 🟢 100 | 🟢 90 | 🟢 Free (Permissive) | Yes |
| HEIF | 🟡 50 | 🟠 70 | 🟡 65 | 🟢 90 | 🔴 30 | 🔴 Royalty-Bearing (Complex) | Yes |
| SVG | N/A | N/A | 🟢 98 | N/A | N/A | 🟢 Free (Permissive) | Yes |
| TIFF | N/A | ⚫ 110 | 🟠 60 | 🟡 70 | 🔴 20 | 🟠 Proprietary | Yes |

