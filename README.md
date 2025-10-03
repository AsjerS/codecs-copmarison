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
4. Edit the `tablegen.py` configuration to your liking.
5. Run `tablegen.py` with your flags of choice, explained here:
- Controlling types of tables:
    - for a simple Markdown table: `--format simple-md` (or `-f simple-md`)
    - for a Markdown version with HTML tooltips: `--format tooltip-md`
    - for a Markdown table with tooltips for GitHub: `-format tooltip-github-md`
    - for an HTML table: `--format html`
- Selecting the amount of data:
    - for just the essential data: `--relevance 1` (or `-r 1`)
    - for all the data you're most likely to encounter: `--relevance 2`
    - for everything in the database, including extremely niche data: `--relevance 3`
- Choosing whether you want to show all aliases of codecs: `--show-aliases` (or `-a`)

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

### Video // Delivery

| Name | Lossy Size (%) | Support (%) | Decode Speed (%) | Encode Speed (%) | License |
|:---|:---|:---|:---|:---|:---|
| [H.264 / AVC](# "The universal compatibility king for over a decade.") | 🔴 100 | 🟢 99 | 🟢 100 | 🟢 100 | 🟡 Royalty-Bearing (Simple) |
| [H.265 / HEVC](# "Dominant in premium 4K media, but with complex licensing.") | 🟡 50 | 🟡 75 | 🟡 80 | 🔴 20 | 🔴 Royalty-Bearing (Complex) |
| [VP9](# "Google's successful open alternative to HEVC, the backbone of YouTube.") | 🟡 55 | 🟢 85 | 🟡 80 | 🔴 25 | 🟢 Free (Permissive) |
| [AV1](# "The royalty-free future of web video, backed by major tech companies.") | 🟢 40 | 🟡 70 | 🟠 60 | 🔴 5 | 🟢 Free (Permissive) |
| [MPEG-2](# "The workhorse of standard-definition digital video (DVDs, DVB).") | ⚫ 180 | 🟡 70 | 🔵 150 | 🔵 150 | 🟢 Free (Public Domain) |
| [VP8](# "The original royalty-free codec for WebM, now primarily used as a baseline for WebRTC.") | ⚫ 115 | 🟡 70 | 🔵 130 | 🔵 120 | 🟢 Free (Permissive) |

### Audio // Lossy

| Name | Lossy Size (%) | Support (%) | Decode Speed (%) | License | Max Channels | Latency |
|:---|:---|:---|:---|:---|:---|:---|
| [Opus](# "State-of-the-art codec for WebRTC, VoIP, and modern streaming.") | 🟡 50 | 🟢 90 | 🟢 100 | 🟢 Free (Permissive) | 255 | 🟢 Very Low |
| [MP3](# "The legacy audio king, universal but inefficient.") | 🔴 100 | 🟢 99 | 🟢 100 | 🟢 Free (Public Domain) | 2 | 🔴 High |
| [AAC](# "The standard for Apple devices and most modern streaming services.") | 🟠 65 | 🟢 95 | 🟢 100 | 🟡 Royalty-Bearing (Simple) | 48 | 🟠 Medium |
| [Vorbis](# "The original open-source alternative to MP3, used heavily by Spotify and game developers.") | 🟠 80 | 🟡 75 | 🟢 90 | 🟢 Free (Permissive) | 255 | 🔴 High |

### Audio // Lossless

| Name | Lossless Size (%) | Support (%) | Decode Speed (%) | License | Max Channels |
|:---|:---|:---|:---|:---|:---|
| [WAV (Uncompressed)](# "The universal standard for uncompressed, raw PCM audio data, used as a baseline.") | 🔴 100 | 🟢 99 | 🔵 200 | 🟢 Free (Public Domain) | 65536 |
| [FLAC](# "The de facto open standard for compressed lossless audio. Note: most existing decoders only support up to 24-bit decoding") | 🟡 60 | 🟢 90 | 🟢 95 | 🟢 Free (Permissive) | 8 |
| [ALAC](# "Apple's native lossless format, open-sourced in 2011.") | 🟠 65 | 🟠 60 | 🟢 95 | 🟢 Free (Permissive) | 8 |

### Image

| Name | Lossy Size (%) | Lossless Size (%) | Support (%) | Decode Speed (%) | Encode Speed (%) | License | Alpha? |
|:---|:---|:---|:---|:---|:---|:---|:---|
| [JPEG](# "The universal standard for photographic images on the web.") | 🔴 100 | ⚫ 200 | 🟢 99 | 🟢 100 | 🟢 100 | 🟢 Free (Public Domain) | No |
| [PNG](# "The standard for lossless web graphics and transparency, used as a baseline.") | N/A | 🔴 100 | 🟢 99 | 🟡 80 | 🔴 30 | 🟢 Free (Permissive) | Yes |
| [WebP](# "Google's versatile format to replace JPEG and PNG, offering better compression.") | 🟠 70 | 🟠 75 | 🟢 97 | 🟢 100 | 🟢 90 | 🟢 Free (Permissive) | Yes |
| [AVIF](# "State-of-the-art compression based on AV1, offering superior quality and features.") | 🟡 50 | 🟠 70 | 🟢 85 | 🟡 70 | 🔴 10 | 🟢 Free (Permissive) | Yes |
| [HEIF](# "The container format used by Apple devices, typically with an HEVC-encoded image.") | 🟡 50 | 🟠 70 | 🟡 65 | 🟢 90 | 🔴 30 | 🔴 Royalty-Bearing (Complex) | Yes |
| [SVG](# "An XML-based vector format. Performance and file size are not directly comparable to raster formats.") | N/A | N/A | 🟢 98 | N/A | N/A | 🟢 Free (Permissive) | Yes |