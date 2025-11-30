# Codecs Comparison

A detailed comparison of most major codecs for video, audio, image, and more. Some data, like file size, are estimates, not actual values, since those depend on how something is decoded. It's made to be as consistent as I could make it, while still being easy to read. For example, JPEG lossless compression has a value going over 100%, because it's almost never used and makes the other values clearer.

## File Explanation

- **`database.sql`**: The script used to generate the database in SQLite, where all the data is stored initially.
- **`tablegen.py`**: The script that generates a customizable version of the comparison with the data from `codecs.db`.

## `database.sql` Formatting Explanation

Sections:

- **Enumilations**: contains tables acting as enumerations to use in the main data tables, to improve consistency and move logic away from table generator scripts.
- **Core data tables**: where the tables are defined, which will later be populated with the actual codec data.
    - If a column in a table has `--enum` after it, that column has a foreign key to one of the tables defined under Enumilations.
- **Data population**: the place where all the data is inserted in the tables, grouped by category and codec.
    - Most entries are formatted in a certain way:
        - everything until `notes` is on the first row (has what every entry should have);
        - everything until `file_size_*` is on the second row (has what almost every entry should have);
        - everything until `relevance` is on the third row (mostly has category-specific data).
    - There are exceptions made for very simple categories (at this point only `Container`), that are still readable without many line breaks. Those have (almost) everything on the same row.


## Build Your Own

To make your own version of the table, follow these steps:

1. Install SQLite and Python on your system.
2. Copy this repository: `git clone https://github.com/AsjerS/codecs-copmarison.git`.
3. CD into the repository, and generate `codecs.db` with `sqlite3 codecs.db < databse.sql`.
4. Edit the `tablegen.py` configuration to your liking.
5. Run `tablegen.py` with your flags of choice, explained by running `python tablegen.py -h`.

As an example, to generate the full version of the table, this command was used: `python tablegen.py --relevance 3 --show-aliases --full --container-mode combined-tagged --container-threshold 3`

There is a ton of data in the database that's unused in the version on this page, so you could make your own table however you'd like. When I find the time for it I might also make a GUI application for generating these tables.

## Markdown Version

Note: this is a heavily stripped down version of the comparison, only containing the codecs you're most likely to find on the web.

There is a version with all codecs existing in the database named `full_version.md`, though this is mostly just for easily previewing what data there is in the database without installing anything.

(you can hover over most of the codec names to get a small description about them)

### Container

| Name | Description | Support (%) | License | Year | Supported Codecs |
|:---|:---|:---|:---|:---|:---|
| MP4 | The most compatible and widely used container format for digital video. Often uses .M4A for audio-only, usually containing AAC. | 🟢 99 | 🟡 Royalty-Bearing (Simple) | 2001 | H.264, AVC, H.265, HEVC, AV1, MPEG-2, WebVTT, Opus, MP3, AAC, FLAC, ALAC, Dolby Digital, Dolby TrueHD, DTS, DTS-HD Master Audio, AC-4 |
| MKV | A flexible container that can hold virtually any track type, prized by enthusiasts. | 🟡 75 | 🟢 Free (Permissive) | 2002 | H.264, AVC, H.265, HEVC, VP9, AV1, MPEG-2, VP8, Apple ProRes, Avid DNxHR, FFV1, SRT, ASS, WebVTT, VobSub, PGS, Opus, MP3, AAC, Vorbis, FLAC, ALAC, Uncompressed PCM, Dolby Digital, Dolby TrueHD, DTS, DTS-HD Master Audio |
| WebM | A container specifically designed for royalty-free web codecs like VP9 and AV1. | 🟢 90 | 🟢 Free (Permissive) | 2010 | VP9, AV1, VP8, WebVTT, Opus, Vorbis |
| MOV | Apple's container format, a standard in professional video production. | 🟡 80 | 🟠 Proprietary | 1991 | H.264, AVC, H.265, HEVC, MPEG-2, Apple ProRes, Avid DNxHR, GoPro CineForm, MP3, AAC, ALAC, Uncompressed PCM |
| Ogg | The container format for the Xiph.Org Foundation's family of open-source codecs like Vorbis, Opus, and Theora. | 🟡 70 | 🟢 Free (Permissive) | 2002 | Opus, Vorbis, FLAC, Uncompressed PCM |
| WAV | An audio container format most commonly used to store uncompressed PCM audio. | 🟢 99 | 🟢 Free (Public Domain) | 1991 | Uncompressed PCM |
| AIFF | Apple's standard uncompressed audio container, functionally similar to WAV. Widely used in professional audio on macOS. | 🟢 90 | 🟢 Free (Permissive) | 1988 | Uncompressed PCM |

### Video // Delivery

| Name | Lossy Size (%) | Support (%) | Decode Speed (%) | Encode Speed (%) | License |
|:---|:---|:---|:---|:---|:---|
| H.264 / AVC | 🔴 100 | 🟢 99 | 🟢 100 | 🟢 100 | 🟡 Royalty-Bearing (Simple) |
| H.265 / HEVC | 🟡 50 | 🟡 75 | 🟡 80 | 🔴 20 | 🔴 Royalty-Bearing (Complex) |
| VP9 | 🟡 55 | 🟢 85 | 🟡 80 | 🔴 25 | 🟢 Free (Permissive) |
| AV1 | 🟢 40 | 🟡 70 | 🟠 60 | 🔴 15 | 🟢 Free (Permissive) |
| MPEG-2 | ⚫ 180 | 🟡 70 | 🔵 150 | 🔵 150 | 🟢 Free (Public Domain) |
| VP8 | ⚫ 115 | 🟡 70 | 🔵 130 | 🔵 120 | 🟢 Free (Permissive) |

### Audio // Lossy

| Name | Lossy Size (%) | Support (%) | Decode Speed (%) | License | Max Channels | Latency |
|:---|:---|:---|:---|:---|:---|:---|
| Opus | 🟡 50 | 🟢 90 | 🟢 100 | 🟢 Free (Permissive) | 255 | 🟢 Very Low |
| MP3 | 🔴 100 | 🟢 99 | 🟢 100 | 🟢 Free (Public Domain) | 2 | 🔴 High |
| AAC | 🟠 65 | 🟢 95 | 🟢 100 | 🟡 Royalty-Bearing (Simple) | 48 | 🟠 Medium |
| Vorbis | 🟠 80 | 🟡 75 | 🟢 90 | 🟢 Free (Permissive) | 255 | 🔴 High |

### Audio // Lossless

| Name | Lossless Size (%) | Support (%) | Decode Speed (%) | License | Max Channels |
|:---|:---|:---|:---|:---|:---|
| FLAC | 🟡 60 | 🟢 90 | 🟢 95 | 🟢 Free (Permissive) | 8 |
| ALAC | 🟠 65 | 🟠 60 | 🟢 95 | 🟢 Free (Permissive) | 8 |
| Uncompressed PCM | 🔴 100 | 🟢 99 | 🔵 1000 | N/A | 65536 |

### Image

| Name | Lossy Size (%) | Lossless Size (%) | Support (%) | Decode Speed (%) | Encode Speed (%) | License | Alpha? |
|:---|:---|:---|:---|:---|:---|:---|:---|
| JPEG | 🔴 100 | ⚫ 200 | 🟢 99 | 🟢 100 | 🟢 100 | 🟢 Free (Public Domain) | No |
| PNG | N/A | 🔴 100 | 🟢 99 | 🟡 80 | 🔴 30 | 🟢 Free (Permissive) | Yes |
| WebP | 🟠 70 | 🟠 75 | 🟢 97 | 🟢 100 | 🟢 90 | 🟢 Free (Permissive) | Yes |
| AVIF | 🟡 50 | 🟠 70 | 🟢 85 | 🟡 70 | 🔴 10 | 🟢 Free (Permissive) | Yes |
| HEIF | 🟡 50 | 🟠 70 | 🟡 65 | 🟢 90 | 🔴 30 | 🔴 Royalty-Bearing (Complex) | Yes |
| SVG | N/A | N/A | 🟢 98 | N/A | N/A | 🟢 Free (Permissive) | Yes |
| DNG | N/A | ⚫ 250 | 🟠 50 | N/A | N/A | 🟢 Open Specification | No |