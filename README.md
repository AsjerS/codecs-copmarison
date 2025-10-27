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
5. Run `tablegen.py` with your flags of choice, explained here:
- Controlling types of tables:
    - for a simple Markdown table: `--format simple-md` (or `-f simple-md`)
    - for a Markdown version with HTML tooltips: `--format tooltip-md`
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

(you can hover over most of the codec names to get a small description about them)

### Container

| Name | Description | Support (%) | License | Year |
|:---|:---|:---|:---|:---|
| MP4 | The most compatible and widely used container format for digital video. | 🟢 99 | 🟢 Free (Permissive) | 2001 |
| MKV | A flexible container that can hold virtually any track type, prized by enthusiasts. | 🟡 75 | 🟢 Free (Permissive) | 2002 |
| WebM | A container specifically designed for royalty-free web codecs like VP9 and AV1. | 🟢 90 | 🟢 Free (Permissive) | 2010 |
| MOV | Apple's container format, a standard in professional video production. | 🟡 80 | 🟠 Proprietary | 1991 |
| Ogg | The container format for the Xiph.Org Foundation's family of open-source codecs like Vorbis, Opus, and Theora. | 🟡 70 | 🟢 Free (Permissive) | 2002 |

### Video // Delivery

| Name | Lossy Size (%) | Support (%) | Decode Speed (%) | Encode Speed (%) | License |
|:---|:---|:---|:---|:---|:---|
| <span title="The universal compatibility king for over a decade.">H.264 / AVC</span> | 🔴 100 | 🟢 99 | 🟢 100 | 🟢 100 | 🟡 Royalty-Bearing (Simple) |
| <span title="Dominant in premium 4K media, but with complex licensing.">H.265 / HEVC</span> | 🟡 50 | 🟡 75 | 🟡 80 | 🔴 20 | 🔴 Royalty-Bearing (Complex) |
| <span title="Google's successful open alternative to HEVC, the backbone of YouTube.">VP9</span> | 🟡 55 | 🟢 85 | 🟡 80 | 🔴 25 | 🟢 Free (Permissive) |
| <span title="The royalty-free future of web video, backed by major tech companies.">AV1</span> | 🟢 40 | 🟡 70 | 🟠 60 | 🔴 5 | 🟢 Free (Permissive) |
| <span title="The workhorse of standard-definition digital video (DVDs, DVB).">MPEG-2</span> | ⚫ 180 | 🟡 70 | 🔵 150 | 🔵 150 | 🟢 Free (Public Domain) |
| <span title="The original royalty-free codec for WebM, now primarily used as a baseline for WebRTC.">VP8</span> | ⚫ 115 | 🟡 70 | 🔵 130 | 🔵 120 | 🟢 Free (Permissive) |

### Audio // Lossy

| Name | Lossy Size (%) | Support (%) | Decode Speed (%) | License | Max Channels | Latency |
|:---|:---|:---|:---|:---|:---|:---|
| <span title="State-of-the-art codec for WebRTC, VoIP, and modern streaming.">Opus</span> | 🟡 50 | 🟢 90 | 🟢 100 | 🟢 Free (Permissive) | 255 | 🟢 Very Low |
| <span title="The legacy audio king, universal but inefficient.">MP3</span> | 🔴 100 | 🟢 99 | 🟢 100 | 🟢 Free (Public Domain) | 2 | 🔴 High |
| <span title="The standard for Apple devices and most modern streaming services.">AAC</span> | 🟠 65 | 🟢 95 | 🟢 100 | 🟡 Royalty-Bearing (Simple) | 48 | 🟠 Medium |
| <span title="The original open-source alternative to MP3, used heavily by Spotify and game developers.">Vorbis</span> | 🟠 80 | 🟡 75 | 🟢 90 | 🟢 Free (Permissive) | 255 | 🔴 High |

### Audio // Lossless

| Name | Lossless Size (%) | Support (%) | Decode Speed (%) | License | Max Channels |
|:---|:---|:---|:---|:---|:---|
| <span title="The universal standard for uncompressed, raw PCM audio data.">WAV (Uncompressed)</span> | 🔴 100 | 🟢 99 | 🔵 200 | 🟢 Free (Public Domain) | 6505036 |
| <span title="The de facto open standard for compressed lossless audio. Note: most existing decoders only support up to 24-bit decoding">FLAC</span> | 🟡 60 | 🟢 90 | 🟢 95 | 🟢 Free (Permissive) | 8 |
| <span title="Apple's native lossless format, open-sourced in 2011.">ALAC</span> | 🟠 65 | 🟠 60 | 🟢 95 | 🟢 Free (Permissive) | 8 |

### Image

| Name | Lossy Size (%) | Lossless Size (%) | Support (%) | Decode Speed (%) | Encode Speed (%) | License | Alpha? |
|:---|:---|:---|:---|:---|:---|:---|:---|
| <span title="The universal standard for photographic images on the web.">JPEG</span> | 🔴 100 | ⚫ 200 | 🟢 99 | 🟢 100 | 🟢 100 | 🟢 Free (Public Domain) | No |
| <span title="The standard for lossless web graphics and transparency.">PNG</span> | N/A | 🔴 100 | 🟢 99 | 🟡 80 | 🔴 30 | 🟢 Free (Permissive) | Yes |
| <span title="Google's versatile format to replace JPEG and PNG, offering better compression.">WebP</span> | 🟠 70 | 🟠 75 | 🟢 97 | 🟢 100 | 🟢 90 | 🟢 Free (Permissive) | Yes |
| <span title="State-of-the-art compression based on AV1, offering superior quality and features.">AVIF</span> | 🟡 50 | 🟠 70 | 🟢 85 | 🟡 70 | 🔴 10 | 🟢 Free (Permissive) | Yes |
| <span title="The container format used by most modern smartphones, typically with an HEVC-encoded image.">HEIF</span> | 🟡 50 | 🟠 70 | 🟡 65 | 🟢 90 | 🔴 30 | 🔴 Royalty-Bearing (Complex) | Yes |
| <span title="An XML-based vector format. Performance and file size are not directly comparable to raster formats.">SVG</span> | N/A | N/A | 🟢 98 | N/A | N/A | 🟢 Free (Permissive) | Yes |
| <span title="A &quot;digital negative&quot; containing unprocessed 12-16 bit data from a camera sensor. Offers maximum editing flexibility.">DNG</span> | N/A | ⚫ 250 | 🟠 50 | N/A | N/A | 🟠 Proprietary | No |