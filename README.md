# Codecs Comparison

A detailed comparison of most major video, audio and image codecs. Some data like file size are estimates, not actual values, since those depend on what you're trying to encode. It's made to be as consistent as possible, while still being easy to read; for example, JPEG lossless compression has a value going over 100%, because it's almost never used and makes the other values clearer.

There are three versions of this document: two markdown versions (as can be seen below), and one original Xlsx version which has fancy features like conditional formatting (which can be downloaded a bit above this text, named `codecs-comparison.xslx`). The Xlsx version will usually be the most up-to-date.

## Markdown version - without colours

| **_VIDEO CODECS_** | **H.264 / AVC** | **H.265 / HEVC** | **VP9** | **AV1** | **H.266 / VVC** |
|---|:---:|:---:|:---:|:---:|:---:|
| _License_ | Royalty-Bearing (Simple) | Royalty-Bearing (Complex) | Free | Free | Royalty-Bearing (Standard) |
| _File Size_ | 100% | 50% | 55% | 40% | 35% |
| _Device Support_ | 99% | 75% | 85% | 60% | 5% |
| _Encoding Speed_ | 100% | 20% | 25% | 5% | 2% |
| _Decoding Speed_ | 100% | 80% | 80% | 60% | 40% |
|  |  |  |  |  |  |
| **_AUDIO CODECS<br>// LOSSY_** | **MP3** | **AAC** | **Opus** | **Dolby Digital Plus** | **Vorbis** |
| _License_ | Free | Royalty-Bearing (Simple) | Free | Proprietary | Free |
| _File Size_ | 100% | 65% | 50% | 80% | 80% |
| _Device Support_ | 99% | 95% | 90% | 70% | 75% |
| _Latency_ | 100% | 90% | 20% | 100% | 95% |
|  |  |  |  |  |  |
| **_AUDIO CODECS<br>// LOSSLESS_** | **None (WAV/PCM)** | **FLAC** | **ALAC** |  |  |
| _License_ | N/A | Free | Free |  |  |
| _File Size_ | 100% | 60% | 65% |  |  |
| _Device Support_ | 99% | 90% | 60% |  |  |
|  |  |  |  |  |  |
| **_IMAGE CODECS_** | **JPEG / JPG** | **PNG** | **WebP** | **AVIF** | **JPEG XL / JXL** |
| _License_ | Free | Free | Free | Free | Free |
| _File Size<br>// Lossy_ | 100% | N/A | 70% | 50% | 40% |
| _File Size<br>// Lossless_ | 200% | 100% | 75% | 70% | 65% |
| _Device Support_ | 99% | 99% | 97% | 80% | 10% |
| _Encoding Speed_ | 100% | 30% | 90% | 10% | 90% |
| _Decoding Speed_ | 100% | 80% | 100% | 70% | 100% |

## Mardown version - with colours

Note: the colours here don't really follow any formatting rule (apart from red generally being worst and green best), though there was an attempt to format them in a way that's easily readable.

For a version with actual colours representing the values better, see the .xlsx edition of this document.

| **_VIDEO CODECS_** | **H.264 / AVC** | **H.265 / HEVC** | **VP9** | **AV1** | **H.266 / VVC** |
|---|:---:|:---:|:---:|:---:|:---:|
| _License_ | 🟡Royalty-Bearing (Simple) | 🔴Royalty-Bearing (Complex) | 🟢Free | 🟢Free | 🟠Royalty-Bearing (Standard) |
| _File Size_ | 🔴100% | 🟠50% | 🟠55% | 🟡40% | 🟢35% |
| _Device Support_ | 🟢99% | 🟡75% | 🟢85% | 🟡60% | 🔴5% |
| _Encoding Speed_ | 🟢100% | 🔴20% | 🔴25% | 🔴5% | 🔴2% |
| _Decoding Speed_ | 🟢100% | 🟢80% | 🟢80% | 🟡60% | 🟠40% |
|  |  |  |  |  |  |
| **_AUDIO CODECS<br>// LOSSY_** | **MP3** | **AAC** | **Opus** | **Dolby Digital Plus** | **Vorbis** |
| _License_ | 🟢Free | 🟡Royalty-Bearing (Simple) | 🟢Free | 🟠Proprietary | 🟢Free |
| _File Size_ | 🔴100% | 🟡65% | 🟢50% | 🟠80% | 🟠80% |
| _Device Support_ | 🟢99% | 🟢95% | 🟢90% | 🟡70% | 🟡75% |
| _Latency_ | 🔴100% | 🔴90% | 🟢20% | 🔴100% | 🔴95% |
|  |  |  |  |  |  |
| **_AUDIO CODECS<br>// LOSSLESS_** | **None (WAV/PCM)** | **FLAC** | **ALAC** |  |  |
| _License_ | ⚪N/A | 🟢Free | 🟢Free |  |  |
| _File Size_ | 🔴100% | 🟡60% | 🟡65% |  |  |
| _Device Support_ | 🟢99% | 🟢90% | 🟡60% |  |  |
|  |  |  |  |  |  |
| **_IMAGE CODECS_** | **JPEG / JPG** | **PNG** | **WebP** | **AVIF** | **JPEG XL / JXL** |
| _License_ | 🟢Free | 🟢Free | 🟢Free | 🟢Free | 🟢Free |
| _File Size<br>// Lossy_ | 🔴100% | ⚪N/A | 🟠70% | 🟢50% | 🟢40% |
| _File Size<br>// Lossless_ | ⚫200% | 🔴100% | 🟠75% | 🟡70% | 🟢65% |
| _Device Support_ | 🟢99% | 🟢99% | 🟢97% | 🟢80% | 🔴10% |
| _Encoding Speed_ | 🟢100% | 🟠30% | 🟢90% | 🔴10% | 🟢90% |
| _Decoding Speed_ | 🟢100% | 🟢80% | 🟢100% | 🟡70% | 🟢100% |
