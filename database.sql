PRAGMA foreign_keys = ON;
BEGIN TRANSACTION;

-- =============================================================================
-- ENUMILATIONS
-- =============================================================================

CREATE TABLE categories (
    category_id     INTEGER PRIMARY KEY,
    category_name   TEXT NOT NULL UNIQUE,
    description     TEXT
);
INSERT INTO categories (category_id, category_name) VALUES
    (1, 'Container'),
    (2, 'Video // Delivery'),
    (3, 'Video // Intermediate'),
    (4, 'Video // Archival'),
    (5, 'Subtitle'),
    (6, 'Audio // Lossy'),
    (7, 'Audio // Lossless'),
    (8, 'Image'),
    (9, 'Animated Image'),
    (10, '3D Model');


CREATE TABLE licenses (
    license_id      INTEGER PRIMARY KEY,
    license_name    TEXT NOT NULL UNIQUE,
    hex_colour      TEXT,
    emoji           TEXT
);
INSERT INTO licenses (license_id, license_name, hex_colour, emoji) VALUES
    (1, 'Free (Public Domain)', '#63BE7B', '🟢'),
    (2, 'Free (Permissive)', '#70AD47', '🟢'),
    (3, 'Royalty-Bearing (Simple)', '#FFC000', '🟡'),
    (4, 'Royalty-Bearing', '#ED7D31', '🟠'),
    (5, 'Royalty-Bearing (Complex)', '#C00000', '🔴'),
    (6, 'Proprietary', '#ED7D31', '🟠');

CREATE TABLE qualitative_ratings (
    rating_id       INTEGER PRIMARY KEY,
    rating_name     TEXT NOT NULL UNIQUE,
    hex_colour      TEXT,
    emoji           TEXT,
    sort_order      INTEGER
);
INSERT INTO qualitative_ratings (rating_id, rating_name, hex_colour, emoji, sort_order) VALUES
    (1, 'Excellent', '#63BE7B', '🟢', 1),
    (2, 'Good', '#CBDC81', '🟡', 2),
    (3, 'Normal', '#FDC07C', '🟠', 3),
    (4, 'Poor', '#F8696B', '🔴', 4);

CREATE TABLE level_ratings (
    level_id        INTEGER PRIMARY KEY,
    level_name      TEXT NOT NULL UNIQUE,
    interpretation  TEXT,
    hex_colour      TEXT,
    emoji           TEXT,
    sort_order      INTEGER
);
INSERT INTO level_ratings (level_id, level_name, interpretation, hex_colour, emoji, sort_order) VALUES
    (1, 'Very Low', 'DESC', '#63BE7B', '🟢', 1),
    (2, 'Low', 'DESC', '#CBDC81', '🟡', 2),
    (3, 'Medium', 'DESC', '#FDC07C', '🟠', 3),
    (4, 'High', 'DESC', '#F8696B', '🔴', 4),
    (5, 'Very Low', 'ASC', '#F8696B', '🔴', 1),
    (6, 'Low', 'ASC', '#FDC07C', '🟠', 2),
    (7, 'Medium', 'ASC', '#CBDC81', '🟡', 3),
    (8, 'High', 'ASC', '#63BE7B', '🟢', 4);

CREATE TABLE chroma_subsampling (
    chroma_id       INTEGER PRIMARY KEY,
    chroma_name     TEXT NOT NULL UNIQUE
);
INSERT INTO chroma_subsampling (chroma_id, chroma_name) VALUES
    (1, '4:2:0'),
    (2, '4:2:2'),
    (3, '4:4:4');

-- =============================================================================
-- CORE DATA TABLES
-- =============================================================================

CREATE TABLE standards (
    standard_id     INTEGER PRIMARY KEY,
    license_id      INTEGER,
    release_year    INTEGER,

    FOREIGN KEY (license_id) REFERENCES licenses (license_id)
);

CREATE TABLE format_aliases (
    alias_id    INTEGER PRIMARY KEY AUTOINCREMENT,
    standard_id INTEGER NOT NULL,
    name        TEXT NOT NULL,
    is_primary  INTEGER NOT NULL CHECK (is_primary IN (0,1)),

    FOREIGN KEY (standard_id) REFERENCES standards (standard_id)
);

CREATE TABLE profiles (
    profile_id              INTEGER PRIMARY KEY,
    standard_id             INTEGER NOT NULL,
    profile_name            TEXT,
    category_id             INTEGER NOT NULL,   -- enum
    notes                   TEXT,
    ecosystem_support       INTEGER,
    encoding_speed          INTEGER,
    decoding_speed          INTEGER,
    has_alpha_channel       INTEGER CHECK (has_alpha_channel IN (0,1)),
    color_bit_depth         INTEGER,
    audio_bit_depth         INTEGER,
    chroma_subsampling_id   INTEGER,            -- enum
    latency_level_id        INTEGER,            -- enum
    editing_performance_id  INTEGER,            -- enum
    file_size_lossy         INTEGER,
    file_size_lossless      INTEGER,
    max_audio_channels      TEXT,
    subtitle_is_image       INTEGER CHECK (subtitle_is_image IN (0,1)),

    FOREIGN KEY (standard_id) REFERENCES standards (standard_id),
    FOREIGN KEY (category_id) REFERENCES categories (category_id)
    FOREIGN KEY (chroma_subsampling_id) REFERENCES chroma_subsampling (chroma_id),
    FOREIGN KEY (latency_level_id) REFERENCES level_ratings (level_id),
    FOREIGN KEY (editing_performance_id) REFERENCES qualitative_ratings (rating_id)
);



-- =============================================================================
-- DATA POPULATION
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Category: Container (ID: 1)
-- -----------------------------------------------------------------------------

--- Standard: MP4 ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (10, 2, 2001);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (10, 'MP4', 1);
INSERT INTO profiles (standard_id, profile_name, category_id, notes, ecosystem_support)
    VALUES (10, 'Default', 1, 'The most compatible and widely used container format for digital video.', 99);

--- Standard: MKV ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (11, 2, 2002);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (11, 'MKV', 1), (11, 'Matroska', 1);
INSERT INTO profiles (standard_id, profile_name, category_id, notes, ecosystem_support)
    VALUES (11, 'Default', 1, 'A flexible container that can hold virtually any track type, prized by enthusiasts.', 75);

--- Standard: WebM ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (12, 2, 2010);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (12, 'WebM', 1);
INSERT INTO profiles (standard_id, profile_name, category_id, notes, ecosystem_support)
    VALUES (12, 'Default', 1, 'A container specifically designed for royalty-free web codecs like VP9 and AV1.', 90);

--- Standard: MOV ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (13, 6, 1991);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (13, 'MOV', 1), (13, 'QuickTime', 1);
INSERT INTO profiles (standard_id, profile_name, category_id, notes, ecosystem_support)
    VALUES (13, 'Default', 1, 'Apple''s container format, a standard in professional video production.', 80);

--- Standard: AVI ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (14, 1, 1992);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (14, 'AVI', 1);
INSERT INTO profiles (standard_id, profile_name, category_id, notes, ecosystem_support)
    VALUES (14, 'Default', 1, 'A legacy container from Microsoft, now outdated but still found in older archives.', 65);

-- -----------------------------------------------------------------------------
-- Category: Video // Delivery (ID: 2)
-- -----------------------------------------------------------------------------

--- Standard: H.264 ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (20, 3, 2003);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (20, 'H.264', 1), (20, 'AVC', 1);
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, encoding_speed, decoding_speed, file_size_lossy,
    has_alpha_channel, color_bit_depth, chroma_subsampling_id, editing_performance_id
) VALUES (
    20, 'Default', 2, 'The universal compatibility king for over a decade.',
    99, 100, 100, 100,
    0, 10, 1, 4
);

--- Standard: H.265 ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (21, 5, 2013);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (21, 'H.265', 1), (21, 'HEVC', 1);
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, encoding_speed, decoding_speed, file_size_lossy,
    has_alpha_channel, color_bit_depth, chroma_subsampling_id, editing_performance_id
) VALUES (
    21, 'Default', 2, 'Dominant in premium 4K media, but with complex licensing.',
    75, 20, 80, 50,
    0, 10, 3, 4
);

--- Standard: VP9 ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (22, 2, 2013);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (22, 'VP9', 1);
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, encoding_speed, decoding_speed, file_size_lossy,
    has_alpha_channel, color_bit_depth, chroma_subsampling_id, editing_performance_id
) VALUES (
    22, 'Default', 2, 'Google''s successful open alternative to HEVC, the backbone of YouTube.',
    85, 25, 80, 55,
    1, 12, 3, 4
);

--- Standard: AV1 ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (23, 2, 2018);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (23, 'AV1', 1);
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, encoding_speed, decoding_speed, file_size_lossy,
    has_alpha_channel, color_bit_depth, chroma_subsampling_id, editing_performance_id
) VALUES (
    23, 'Default', 2, 'The royalty-free future of web video, backed by major tech companies.',
    65, 5, 60, 40,
    1, 12, 3, 4
);

--- Standard: H.266 ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (24, 4, 2020);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (24, 'H.266', 1), (24, 'VVC', 1);
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, encoding_speed, decoding_speed, file_size_lossy,
    has_alpha_channel, color_bit_depth, chroma_subsampling_id, editing_performance_id
) VALUES (
    24, 'Default', 2, 'A successor to HEVC, its adoption is limited by licensing and the rise of AV1.',
    5, 2, 40, 35,
    0, 10, 3, 4
);

--- Standard: MPEG-2 ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (25, 1, 1995);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (25, 'MPEG-2', 1), (25, 'H.262', 0);
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, encoding_speed, decoding_speed, file_size_lossy,
    has_alpha_channel, color_bit_depth, chroma_subsampling_id, editing_performance_id
) VALUES (
    25, 'Default', 2, 'The workhorse of standard-definition digital video (DVDs, DVB).',
    70, 150, 150, 180,
    0, 8, 2, 4
);

-- -----------------------------------------------------------------------------
-- Category: Video // Intermediate (ID: 3)
-- -----------------------------------------------------------------------------

--- Standard: Apple ProRes ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (30, 6, 2007);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (30, 'Apple ProRes', 1);
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, file_size_lossless,
    has_alpha_channel, color_bit_depth, chroma_subsampling_id, editing_performance_id
) VALUES (
    30, '422 HQ', 3, 'The dominant intermediate codec in Mac-centric professional workflows.',
    70, 25,
    0, 10, 2, 1
);
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, file_size_lossless,
    has_alpha_channel, color_bit_depth, chroma_subsampling_id, editing_performance_id
) VALUES (
    30, '4444 XQ', 3, 'The highest-quality version of ProRes, supporting an alpha channel.',
    60, 55,
    1, 12, 3, 1
);

--- Standard: Avid DNxHR ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (31, 3, 2014);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (31, 'Avid DNxHR', 1);
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, file_size_lossless,
    has_alpha_channel, color_bit_depth, chroma_subsampling_id, editing_performance_id
) VALUES (
    31, 'HQX', 3, 'The cross-platform industry standard for professional editing, especially in broadcast.',
    70, 25,
    1, 12, 3, 1
);
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, file_size_lossless,
    has_alpha_channel, color_bit_depth, chroma_subsampling_id, editing_performance_id
) VALUES (
    31, 'LB', 3, 'A low-bandwidth version of DNxHR for offline editing and proxies.',
    70, 8,
    1, 8, 1, 1
);

--- Standard: GoPro CineForm ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (32, 6, 2004);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (32, 'GoPro CineForm', 1);
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, file_size_lossless,
    has_alpha_channel, color_bit_depth, chroma_subsampling_id, editing_performance_id
) VALUES (
    32, 'Default', 3, 'A high-quality intermediate codec, popular in GoPro and VFX workflows.',
    50, 20,
    1, 12, 3, 1
);

-- -----------------------------------------------------------------------------
-- Category: Video // Archival (ID: 4)
-- -----------------------------------------------------------------------------

--- Standard: Uncompressed Video ---
INSERT INTO standards (standard_id) VALUES (40);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (40, 'Uncompressed Video', 1);
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    file_size_lossless,
    has_alpha_channel, color_bit_depth, chroma_subsampling_id, editing_performance_id
) VALUES (
    40, '10-bit 4:4:4', 4, 'A raw, uncompressed video stream, used as a baseline for archival codecs.',
    100,
    1, 10, 3, 2
);

--- Standard: FFV1 ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (41, 2, 2003);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (41, 'FFV1', 1);
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, file_size_lossless,
    has_alpha_channel, color_bit_depth, chroma_subsampling_id, editing_performance_id
) VALUES (
    41, 'Default', 4, 'The open standard for video archiving, prized for its data integrity features like checksums.',
    40, 45,
    1, 16, 3, 4
);

--- Profile: H.264 Lossless ---
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    file_size_lossless,
    has_alpha_channel, color_bit_depth, chroma_subsampling_id, editing_performance_id
) VALUES (
    20, 'Lossless', 4, 'Lossless profile of H.264, offering poor compression but using ubiquitous hardware.',
    42,
    0, 10, 2, 4
);

--- Profile: H.265 Lossless ---
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    file_size_lossless,
    has_alpha_channel, color_bit_depth, chroma_subsampling_id, editing_performance_id
) VALUES (
    21, 'Lossless', 4, 'Lossless profile of H.265, offering good compression with potential for hardware support.',
    40,
    0, 10, 3, 4
);

--- Profile: VP9 Lossless ---
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    file_size_lossless,
    has_alpha_channel, color_bit_depth, chroma_subsampling_id, editing_performance_id
) VALUES (
    22, 'Lossless', 4, 'Lossless profile of VP9, offering a good open-source alternative for archival.',
    38,
    1, 12, 3, 4
);

--- Profile: AV1 Lossless ---
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    file_size_lossless,
    has_alpha_channel, color_bit_depth, chroma_subsampling_id, editing_performance_id
) VALUES (
    23, 'Lossless', 4, 'Lossless profile of AV1, offering the best compression ratio for archival video.',
    35,
    1, 12, 3, 4
);

-- -----------------------------------------------------------------------------
-- Category: Subtitle (ID: 5)
-- -----------------------------------------------------------------------------

--- Standard: SRT ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (50, 1, 1999);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (50, 'SRT', 1);
INSERT INTO profiles (standard_id, profile_name, category_id, notes, ecosystem_support, subtitle_is_image)
    VALUES (50, 'Default', 5, 'The most universal and basic text-based subtitle format.', 99, 0);

--- Standard: ASS ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (51, 2, 2002);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (51, 'ASS', 1), (51, 'SSA', 0);
INSERT INTO profiles (standard_id, profile_name, category_id, notes, ecosystem_support, subtitle_is_image)
    VALUES (51, 'Default', 5, 'A powerful text format offering advanced styling, positioning, and effects.', 70, 0);

--- Standard: WebVTT ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (52, 2, 2010);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (52, 'WebVTT', 1);
INSERT INTO profiles (standard_id, profile_name, category_id, notes, ecosystem_support, subtitle_is_image)
    VALUES (52, 'Default', 5, 'The modern standard for subtitles on the web, designed for HTML5 video.', 95, 0);

--- Standard: VobSub ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (53, 6, 1997);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (53, 'VobSub', 1);
INSERT INTO profiles (standard_id, profile_name, category_id, notes, ecosystem_support, subtitle_is_image, file_size_lossless)
    VALUES (53, 'Default', 5, 'Image-based subtitle format used on DVDs. Cannot be scaled or edited like text.', 70, 1, 5);

--- Standard: PGS ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (54, 6, 2006);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (54, 'PGS', 1);
INSERT INTO profiles (standard_id, profile_name, category_id, notes, ecosystem_support, subtitle_is_image, file_size_lossless)
    VALUES (54, 'Default', 5, 'High-resolution image-based subtitle format used on Blu-ray Discs.', 65, 1, 10);

-- -----------------------------------------------------------------------------
-- Category: Audio // Lossy (ID: 6)
-- -----------------------------------------------------------------------------

--- Standard: Opus ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (60, 2, 2012);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (60, 'Opus', 1);
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, decoding_speed, file_size_lossy,
    latency_level_id, audio_bit_depth, max_audio_channels
) VALUES (
    60, 'Default', 6, 'State-of-the-art codec for WebRTC, VoIP, and modern streaming.',
    90, 100, 50,
    1, 32, '255'
);

--- Standard: MP3 ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (61, 1, 1993);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (61, 'MP3', 1);
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, decoding_speed, file_size_lossy,
    latency_level_id, audio_bit_depth, max_audio_channels
) VALUES (
    61, 'Default', 6, 'The legacy audio king, universal but inefficient.',
    99, 100, 100,
    4, 16, '2'
);

--- Standard: AAC ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (62, 3, 1997);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (62, 'AAC', 1);
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, decoding_speed, file_size_lossy,
    latency_level_id, audio_bit_depth, max_audio_channels
) VALUES (
    62, 'Default', 6, 'The standard for Apple devices, YouTube, and most modern streaming services.',
    95, 100, 65,
    3, 24, '48'
);

--- Standard: Vorbis ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (63, 2, 2000);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (63, 'Vorbis', 1);
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, decoding_speed, file_size_lossy,
    latency_level_id, audio_bit_depth, max_audio_channels
) VALUES (
    63, 'Default', 6, 'The original open-source alternative to MP3, used heavily by Spotify and game developers.',
    75, 100, 80,
    4, 16, '255'
);

--- Standard: Dolby Digital ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (64, 6, 1992);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (64, 'Dolby Digital', 1), (64, 'AC-3', 0);
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, decoding_speed, file_size_lossy,
    latency_level_id, audio_bit_depth, max_audio_channels
) VALUES (
    64, 'Default', 6, 'The standard for surround sound on DVDs and broadcast television.',
    80, 90, 90,
    4, 16, '5.1'
);
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, decoding_speed, file_size_lossy,
    latency_level_id, audio_bit_depth, max_audio_channels
) VALUES (
    64, 'Plus', 6, 'An enhanced version of AC-3 used by most modern streaming services.',
    70, 95, 80,
    4, 24, '15.1'
);

-- -----------------------------------------------------------------------------
-- Category: Audio // Lossless (ID: 7)
-- -----------------------------------------------------------------------------

--- Standard: WAV ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (70, 1, 1991);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (70, 'WAV', 1), (70, 'PCM', 0);
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, decoding_speed, file_size_lossless, audio_bit_depth, max_audio_channels
) VALUES (
    70, 'Uncompressed', 7, 'The universal standard for uncompressed, raw PCM audio data, used as a baseline.',
    99, 100, 100, 32, '65536'
);

--- Standard: FLAC ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (71, 2, 2001);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (71, 'FLAC', 1);
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, decoding_speed, file_size_lossless, audio_bit_depth, max_audio_channels
) VALUES (
    71, 'Default', 7, 'The de facto open standard for lossless audio archiving and audiophile listening.',
    90, 95, 60, 24, '8'
);

--- Standard: ALAC ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (72, 2, 2004);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (72, 'ALAC', 1);
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, decoding_speed, file_size_lossless, audio_bit_depth, max_audio_channels
) VALUES (
    72, 'Default', 7, 'Apple''s native lossless format, open-sourced in 2011.',
    60, 95, 65, 32, '8'
);

--- Standard: Monkey's Audio ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (73, 6, 2001);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (73, 'Monkey''s Audio', 1), (73, 'APE', 0);
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, decoding_speed, file_size_lossless, audio_bit_depth, max_audio_channels
) VALUES (
    73, 'Default', 7, 'A proprietary codec known for its very high compression ratios, popular in niche audiophile circles.',
    30, 70, 55, 24, '32'
);

-- -----------------------------------------------------------------------------
-- Category: Image (ID: 8)
-- -----------------------------------------------------------------------------

--- Standard: JPEG ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (80, 1, 1992);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (80, 'JPEG', 1), (80, 'JPG', 0);
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, encoding_speed, decoding_speed, file_size_lossy, file_size_lossless,
    has_alpha_channel, color_bit_depth, chroma_subsampling_id
) VALUES (
    80, 'Default', 8, 'The universal standard for photographic images on the web.',
    99, 100, 100, 100, 200,
    0, 8, 1
);

--- Standard: PNG ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (81, 2, 1996);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (81, 'PNG', 1);
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, encoding_speed, decoding_speed, file_size_lossless,
    has_alpha_channel, color_bit_depth, chroma_subsampling_id
) VALUES (
    81, 'Default', 8, 'The standard for lossless web graphics and transparency, used as a baseline.',
    99, 30, 80, 100,
    1, 16, 3
);

--- Standard: WebP ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (82, 2, 2010);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (82, 'WebP', 1);
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, encoding_speed, decoding_speed, file_size_lossy, file_size_lossless,
    has_alpha_channel, color_bit_depth, chroma_subsampling_id
) VALUES (
    82, 'Default', 8, 'Google''s versatile format to replace JPEG and PNG, offering better compression.',
    97, 90, 100, 70, 75,
    1, 8, 3
);

--- Standard: AVIF ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (83, 2, 2019);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (83, 'AVIF', 1);
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, encoding_speed, decoding_speed, file_size_lossy, file_size_lossless,
    has_alpha_channel, color_bit_depth, chroma_subsampling_id
) VALUES (
    83, 'Default', 8, 'State-of-the-art compression based on AV1, offering superior quality and features.',
    85, 10, 70, 50, 70,
    1, 12, 3
);

--- Standard: JPEG XL ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (84, 2, 2020);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (84, 'JPEG XL', 1), (84, 'JXL', 0);
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, encoding_speed, decoding_speed, file_size_lossy, file_size_lossless,
    has_alpha_channel, color_bit_depth, chroma_subsampling_id
) VALUES (
    84, 'Default', 8, 'A technically superior next-gen format, but its adoption was stalled by browser politics.',
    10, 90, 100, 40, 65,
    1, 16, 3
);

--- Standard: HEIF ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (85, 6, 2015);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (85, 'HEIF', 1), (85, 'HEIC', 0);
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, encoding_speed, decoding_speed, file_size_lossy, file_size_lossless,
    has_alpha_channel, color_bit_depth, chroma_subsampling_id
) VALUES (
    85, 'Default', 8, 'The container format used by Apple devices, typically with an HEVC-encoded image.',
    65, 30, 90, 50, 70,
    1, 10, 2
);

--- Standard: SVG ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (86, 2, 2001);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (86, 'SVG', 1);
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support,
    has_alpha_channel, color_bit_depth, chroma_subsampling_id
) VALUES (
    86, 'Default', 8, 'An XML-based vector format. Performance and file size are not directly comparable to raster formats.',
    98,
    1, 8, 3
);

--- Standard: TIFF ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (87, 6, 1986);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (87, 'TIFF', 1);
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, encoding_speed, decoding_speed, file_size_lossless,
    has_alpha_channel, color_bit_depth, chroma_subsampling_id
) VALUES (
    87, 'Default', 8, 'The standard for high-quality print, archiving, and professional photography masters.',
    60, 20, 70, 110,
    1, 16, 3
);

-- -----------------------------------------------------------------------------
-- Category: Animated Image (ID: 9)
-- -----------------------------------------------------------------------------

--- Standard: GIF ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (90, 1, 1989);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (90, 'GIF', 1);
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, decoding_speed, file_size_lossless,
    has_alpha_channel, color_bit_depth
) VALUES (
    90, 'Default', 9, 'The universal standard for short animations, limited to a 256-color palette.',
    99, 100, 100,
    1, 2
);

--- Standard: APNG ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (91, 2, 2004);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (91, 'APNG', 1);
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, decoding_speed, file_size_lossless,
    has_alpha_channel, color_bit_depth
) VALUES (
    91, 'Default', 9, 'An extension of PNG for lossless animations with full color and alpha support, used as a baseline.',
    95, 80, 65,
    1, 16
);

--- Profile: Animated WebP ---
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, decoding_speed, file_size_lossy, file_size_lossless,
    has_alpha_channel, color_bit_depth
) VALUES (
    82, 'Animated', 9, 'Offers smaller file sizes than GIF with better color and alpha support.',
    97, 90, 25, 45,
    1, 8
);

--- Profile: Animated AVIF ---
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, decoding_speed, file_size_lossy, file_size_lossless,
    has_alpha_channel, color_bit_depth
) VALUES (
    83, 'Animated', 9, 'State-of-the-art compression for animations, offering massive savings over GIF.',
    85, 70, 15, 40,
    1, 12
);

-- -----------------------------------------------------------------------------
-- Category: 3D Model (ID: 10)
-- -----------------------------------------------------------------------------

--- Standard: STL ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (104, 1, 1987);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (104, 'STL', 1);
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, has_texture_support, has_animation_support, file_size_lossless
) VALUES (
    104, 'Binary', 10, 'The most used, though inefficient, standard for 3D printing.',
    99, 0, 0, 100
);
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, has_texture_support, has_animation_support, file_size_lossless
) VALUES (
    104, 'ASCII', 10, 'A human-readable but inefficient text-based version of the STL format.',
    99, 0, 0, 400
);

--- Standard: OBJ ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (102, 2, 1990);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (102, 'OBJ', 1);
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, has_texture_support, has_animation_support, file_size_lossless
) VALUES (
    102, 'Default', 10, 'Text-based and verbose; files are significantly larger than binary equivalents for the same geometry.',
    98, 1, 0, 140
);

--- Standard: 3MF ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (105, 2, 2015);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (105, '3MF', 1);
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, has_texture_support, has_animation_support, file_size_lossless
) VALUES (
    105, 'Default', 10, 'Uses ZIP compression, resulting in much smaller files than STL for the same model.',
    60, 1, 0, 40
);

--- Standard: glTF ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (100, 2, 2015);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (100, 'glTF', 1), (100, 'GLB', 0);
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, has_texture_support, has_animation_support, file_size_lossless
) VALUES (
    100, 'Default', 10, 'Highly optimized binary format (GLB) for web delivery; often the smallest for geometry.',
    85, 1, 1, 35
);

--- Standard: FBX ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (101, 6, 2006);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (101, 'FBX', 1);
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, has_texture_support, has_animation_support, file_size_lossless
) VALUES (
    101, 'Default', 10, 'Binary format with scene overhead; efficient but not as compact as web-focused formats for pure geometry.',
    95, 1, 1, 60
);

--- Standard: USD ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (103, 2, 2016);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (103, 'USD', 1), (103, 'USDZ', 0);
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, has_texture_support, has_animation_support, file_size_lossless
) VALUES (
    103, 'Default', 10, '"The HTML of the Metaverse," a framework for composing and collaborating on complex 3D scenes.',
    50, 1, 1, 60
);


COMMIT;