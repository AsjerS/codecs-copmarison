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
    (10, '3D Model'),
    (11, 'Audio // Home Theater');


CREATE TABLE licenses (
    license_id      INTEGER PRIMARY KEY,
    license_name    TEXT NOT NULL UNIQUE,
    hex_colour      TEXT,
    emoji           TEXT
);
INSERT INTO licenses (license_id, license_name, hex_colour, emoji) VALUES
    (1, 'Free (Public Domain)', '#63be7b', '🟢'),
    (2, 'Free (Permissive)', '#b1d47f', '🟢'),
    (3, 'Royalty-Bearing (Simple)', '#ffeb84', '🟡'),
    (4, 'Royalty-Bearing', '#fbaa77', '🟠'),
    (5, 'Royalty-Bearing (Complex)', '#f8696b', '🔴'),
    (6, 'Proprietary', '#fbaa77', '🟠'),
    (7, 'Free (Source Available)', '#ffeb84', '🟡');

CREATE TABLE qualitative_ratings (
    rating_id       INTEGER PRIMARY KEY,
    rating_name     TEXT NOT NULL UNIQUE,
    hex_colour      TEXT,
    emoji           TEXT,
    sort_order      INTEGER
);
INSERT INTO qualitative_ratings (rating_id, rating_name, hex_colour, emoji, sort_order) VALUES
    (1, 'Excellent', '#63be7b', '🟢', 1),
    (2, 'Good', '#cbdc81', '🟡', 2),
    (3, 'Normal', '#fdc07c', '🟠', 3),
    (4, 'Poor', '#f8696b', '🔴', 4);

CREATE TABLE level_ratings (
    level_id        INTEGER PRIMARY KEY,
    level_name      TEXT NOT NULL,
    interpretation  TEXT,
    hex_colour      TEXT,
    emoji           TEXT,
    sort_order      INTEGER
);
INSERT INTO level_ratings (level_id, level_name, interpretation, hex_colour, emoji, sort_order) VALUES
    (1, 'Very Low', 'DESC', '#63BE7B', '🟢', 1),
    (2, 'Low', 'DESC', '#cbdc81', '🟡', 2),
    (3, 'Medium', 'DESC', '#fdc07c', '🟠', 3),
    (4, 'High', 'DESC', '#f8696b', '🔴', 4),
    (5, 'Very Low', 'ASC', '#f8696b', '🔴', 1),
    (6, 'Low', 'ASC', '#fdc07c', '🟠', 2),
    (7, 'Medium', 'ASC', '#cbdc81', '🟡', 3),
    (8, 'High', 'ASC', '#63BE7B', '🟢', 4);

CREATE TABLE color_models (
    color_model_id      INTEGER PRIMARY KEY,
    color_model_name    TEXT NOT NULL UNIQUE
);
INSERT INTO color_models (color_model_id, color_model_name) VALUES
    (1, 'YUV 4:2:0'),
    (2, 'YUV 4:2:2'),
    (3, 'YUV 4:4:4'),
    (4, 'RGB'),
    (5, 'Indexed'),
    (6, 'YCbCr'),
    (7, 'XYB'),
    (8, 'Vector'),
    (9, 'CMYK');

CREATE TABLE makers (
    maker_id        INTEGER PRIMARY KEY,
    maker_name      TEXT NOT NULL UNIQUE
);
INSERT INTO makers (maker_id, maker_name) VALUES
    (1, 'Google'),
    (2, 'Apple'),
    (3, 'Microsoft'),
    (4, 'Xiph.Org Foundation'),
    (5, 'Alliance for Open Media'),
    (6, 'Dolby Laboratories'),
    (7, 'DTS (Xperi)'),
    (8, 'Fraunhofer IIS'),
    (9, 'MPEG'),
    (10, 'ITU-T'),
    (11, 'ISO/IEC'),
    (12, 'Adobe'),
    (13, 'Avid'),
    (14, 'GoPro'),
    (15, 'FFmpeg Team'),
    (16, 'W3C'),
    (17, '3D Systems'),
    (18, 'Wavefront Technologies'),
    (19, '3MF Consortium'),
    (20, 'Khronos Group'),
    (21, 'Autodesk'),
    (22, 'Pixar'),
    (23, 'CompuServe'),
    (24, 'DivX, Inc.'),
    (25, 'Matthew T. Ashland'),
    (26, 'IBM'),
    (27, 'The Community'),
    (28, 'RealNetworks'),
    (29, 'SoftSound'),
    (30, 'Sorenson Media'),
    (31, 'Sony');

CREATE TABLE standard_makers (
    standard_id     INTEGER NOT NULL,
    maker_id        INTEGER NOT NULL,
    PRIMARY KEY (standard_id, maker_id),
    FOREIGN KEY (standard_id) REFERENCES standards (standard_id),
    FOREIGN KEY (maker_id) REFERENCES makers (maker_id)
);

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
    file_size_lossy         INTEGER,
    file_size_lossless      INTEGER,
    ecosystem_support       INTEGER,
    encoding_speed          INTEGER,
    decoding_speed          INTEGER,
    has_alpha_channel       INTEGER CHECK (has_alpha_channel IN (0,1)),
    color_bit_depth         INTEGER,
    audio_bit_depth         INTEGER,
    color_model_id          INTEGER,            -- enum
    latency_level_id        INTEGER,            -- enum
    editing_performance_id  INTEGER,            -- enum
    max_audio_channels      TEXT,
    subtitle_is_image       INTEGER CHECK (subtitle_is_image IN (0,1)),
    has_texture_support     INTEGER CHECK (has_texture_support IN (0,1)),
    has_animation_support   INTEGER CHECK (has_animation_support IN (0,1)),
    relevance               INTEGER, CHECK (relevance IN (1,2,3)),
                                                --^-- 1 = essential, 2 = common, 3 = all

    FOREIGN KEY (standard_id) REFERENCES standards (standard_id),
    FOREIGN KEY (category_id) REFERENCES categories (category_id)
    FOREIGN KEY (color_model_id) REFERENCES color_models (color_model_id),
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
INSERT INTO standards (standard_id, license_id, release_year) VALUES (0100, 2, 2001);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (0100, 'MP4', 1), (0100, 'M4A', 0);
INSERT INTO standard_makers (standard_id, maker_id) VALUES (0100, 11);
INSERT INTO profiles (standard_id, profile_name, category_id, notes, ecosystem_support, relevance)
    VALUES (0100, 'Default', 1, 'The most compatible and widely used container format for digital video.', 99, 1);

--- Standard: MKV ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (0101, 2, 2002);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (0101, 'MKV', 1), (0101, 'MKA', 0), (0101, 'Matroska', 0);
INSERT INTO standard_makers (standard_id, maker_id) VALUES (0101, 4);
INSERT INTO profiles (standard_id, profile_name, category_id, notes, ecosystem_support, relevance)
    VALUES (0101, 'Default', 1, 'A flexible container that can hold virtually any track type, prized by enthusiasts.', 75, 1);

--- Standard: WebM ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (0102, 2, 2010);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (0102, 'WebM', 1);
INSERT INTO standard_makers (standard_id, maker_id) VALUES (0102, 1);
INSERT INTO profiles (standard_id, profile_name, category_id, notes, ecosystem_support, relevance)
    VALUES (0102, 'Default', 1, 'A container specifically designed for royalty-free web codecs like VP9 and AV1.', 90, 1);

--- Standard: MOV ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (0103, 6, 1991);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (0103, 'MOV', 1), (0103, 'QuickTime', 0);
INSERT INTO standard_makers (standard_id, maker_id) VALUES (0103, 2);
INSERT INTO profiles (standard_id, profile_name, category_id, notes, ecosystem_support, relevance)
    VALUES (0103, 'Default', 1, 'Apple''s container format, a standard in professional video production.', 80, 1);

--- Standard: AVI ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (0104, 1, 1992);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (0104, 'AVI', 1);
INSERT INTO standard_makers (standard_id, maker_id) VALUES (0104, 3);
INSERT INTO profiles (standard_id, profile_name, category_id, notes, ecosystem_support, relevance)
    VALUES (0104, 'Default', 1, 'A legacy container, now outdated but still found in older archives.', 65, 3);

--- Standard: Ogg ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (0105, 2, 2002);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (0105, 'Ogg', 1);
INSERT INTO standard_makers (standard_id, maker_id) VALUES (0105, 4);
INSERT INTO profiles (standard_id, profile_name, category_id, notes, ecosystem_support, relevance)
    VALUES (0105, 'Default', 1, 'The container format for the Xiph.Org Foundation''s family of open-source codecs like Vorbis, Opus, and Theora.', 70, 1);

-- -----------------------------------------------------------------------------
-- Category: Video // Delivery (ID: 2)
-- -----------------------------------------------------------------------------

--- Standard: H.264 ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (0200, 3, 2003);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (0200, 'H.264', 1), (0200, 'AVC', 1);
INSERT INTO standard_makers (standard_id, maker_id) VALUES (0200, 10), (0200, 11);
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, encoding_speed, decoding_speed, file_size_lossy,
    has_alpha_channel, color_bit_depth, color_model_id, editing_performance_id, relevance
) VALUES (
    0200, 'Default', 2, 'The universal compatibility king for over a decade.',
    99, 100, 100, 100,
    0, 10, 1, 4, 1
);

--- Standard: H.265 ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (0201, 5, 2013);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (0201, 'H.265', 1), (0201, 'HEVC', 1);
INSERT INTO standard_makers (standard_id, maker_id) VALUES (0201, 10), (0201, 11);
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, encoding_speed, decoding_speed, file_size_lossy,
    has_alpha_channel, color_bit_depth, color_model_id, editing_performance_id, relevance
) VALUES (
    0201, 'Default', 2, 'Dominant in premium 4K media, but with complex licensing.',
    75, 20, 80, 50,
    0, 10, 3, 4, 1
);

--- Standard: VP9 ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (0202, 2, 2013);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (0202, 'VP9', 1);
INSERT INTO standard_makers (standard_id, maker_id) VALUES (0202, 1);
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, encoding_speed, decoding_speed, file_size_lossy,
    has_alpha_channel, color_bit_depth, color_model_id, editing_performance_id, relevance
) VALUES (
    0202, 'Default', 2, 'Google''s successful open alternative to HEVC, the backbone of YouTube.',
    85, 25, 80, 55,
    1, 12, 3, 4, 1
);

--- Standard: AV1 ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (0203, 2, 2018);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (0203, 'AV1', 1);
INSERT INTO standard_makers (standard_id, maker_id) VALUES (0203, 5);
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, encoding_speed, decoding_speed, file_size_lossy,
    has_alpha_channel, color_bit_depth, color_model_id, editing_performance_id, relevance
) VALUES (
    0203, 'Default', 2, 'The royalty-free future of web video, backed by major tech companies.',
    70, 5, 60, 40,
    1, 12, 3, 4, 1
);

--- Standard: H.266 ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (0204, 4, 2020);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (0204, 'H.266', 1), (0204, 'VVC', 1);
INSERT INTO standard_makers (standard_id, maker_id) VALUES (0204, 10), (0204, 11);
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, encoding_speed, decoding_speed, file_size_lossy,
    has_alpha_channel, color_bit_depth, color_model_id, editing_performance_id, relevance
) VALUES (
    0204, 'Default', 2, 'A successor to HEVC, its adoption is limited by licensing and the rise of AV1.',
    5, 2, 40, 35,
    0, 10, 3, 4, 3
);

--- Standard: MPEG-2 ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (0205, 1, 1995);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (0205, 'MPEG-2', 1), (0205, 'H.262', 0);
INSERT INTO standard_makers (standard_id, maker_id) VALUES (0205, 9);
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, encoding_speed, decoding_speed, file_size_lossy,
    has_alpha_channel, color_bit_depth, color_model_id, editing_performance_id, relevance
) VALUES (
    0205, 'Default', 2, 'The workhorse of standard-definition digital video (DVDs, DVB).',
    70, 150, 150, 180,
    0, 8, 2, 4, 2
);

--- Standard: VP8 ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (0206, 2, 2008);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (0206, 'VP8', 1);
INSERT INTO standard_makers (standard_id, maker_id) VALUES (0206, 1);
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, encoding_speed, decoding_speed, file_size_lossy,
    has_alpha_channel, color_bit_depth, color_model_id, editing_performance_id, relevance
) VALUES (
    0206, 'Default', 2, 'The original royalty-free codec for WebM, now primarily used as a baseline for WebRTC.',
    70, 120, 130, 115,
    1, 8, 1, 4, 2
);

--- Standard: Theora ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (0207, 2, 2004);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (0207, 'Theora', 1);
INSERT INTO standard_makers (standard_id, maker_id) VALUES (0207, 4);
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, encoding_speed, decoding_speed, file_size_lossy,
    has_alpha_channel, color_bit_depth, color_model_id, editing_performance_id, relevance
) VALUES (
    0207, 'Default', 2, 'The original open-source video codec. Now a legacy format, superseded by VP8/VP9.',
    40, 110, 120, 130,
    0, 8, 1, 4, 3
);

--- Standard: MPEG-1 ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (0208, 1, 1993);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (0208, 'MPEG-1', 1);
INSERT INTO standard_makers (standard_id, maker_id) VALUES (0208, 9);
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, encoding_speed, decoding_speed, file_size_lossy,
    has_alpha_channel, color_bit_depth, color_model_id, editing_performance_id, relevance
) VALUES (
    0208, 'Default', 2, 'The original standard for digital video, famous for Video CDs (VCDs). Now completely obsolete due to its very poor compression.',
    60, 200, 200, 300,
    0, 8, 1, 4, 3
);

--- Standard: VC-1 ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (0209, 3, 2006);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (0209, 'VC-1', 1), (0209, 'WMV9', 0);
INSERT INTO standard_makers (standard_id, maker_id) VALUES (0209, 3);
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, encoding_speed, decoding_speed, file_size_lossy,
    has_alpha_channel, color_bit_depth, color_model_id, editing_performance_id, relevance
) VALUES (
    0209, 'Default', 2, 'Standardized for Blu-ray. A direct competitor to H.264, but saw less adoption and is now a legacy format.',
    65, 110, 100, 105,
    0, 8, 1, 4, 3
);

--- Standard: DivX (MPEG-4 Part 2) ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (0210, 6, 1999);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (0210, 'DivX', 1);
INSERT INTO standard_makers (standard_id, maker_id) VALUES (0210, 24);
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, encoding_speed, decoding_speed, file_size_lossy,
    has_alpha_channel, color_bit_depth, color_model_id, editing_performance_id, relevance
) VALUES (
    0210, 'Default', 2, 'A popular proprietary codec based on MPEG-4 Part 2. Common in older hardware players from the 2000s.',
    70, 115, 110, 120,
    0, 8, 1, 4, 3
);

--- Standard: Xvid (MPEG-4 Part 2) ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (0211, 2, 2001);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (0211, 'Xvid', 1);
INSERT INTO standard_makers (standard_id, maker_id) VALUES (0211, 27);
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, encoding_speed, decoding_speed, file_size_lossy,
    has_alpha_channel, color_bit_depth, color_model_id, editing_performance_id, relevance
) VALUES (
    0211, 'Default', 2, 'The open-source equivalent of DivX. Was the dominant format for video sharing online before the rise of H.264.',
    70, 115, 110, 115,
    0, 8, 1, 4, 3
);

--- Standard: RealVideo ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (0212, 6, 1997);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (0212, 'RealVideo', 1);
INSERT INTO standard_makers (standard_id, maker_id) VALUES (0212, 28);
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, encoding_speed, decoding_speed, file_size_lossy,
    has_alpha_channel, color_bit_depth, color_model_id, editing_performance_id, relevance
) VALUES (
    0212, 'Default', 2, 'A dominant streaming video format in the late 90s/early 2000s, optimized for very low bitrates.',
    40, 90, 90, 130,
    0, 8, 1, 4, 3
);

--- Standard: H.263 ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (0213, 3, 1996);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (0213, 'H.263', 1);
INSERT INTO standard_makers (standard_id, maker_id) VALUES (0213, 10);
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, encoding_speed, decoding_speed, file_size_lossy,
    has_alpha_channel, color_bit_depth, color_model_id, editing_performance_id, relevance
) VALUES (
    0213, 'Default', 2, 'The predecessor to H.264 for video conferencing and mobile video. Optimized for low bitrates.',
    50, 140, 140, 150,
    0, 8, 1, 4, 3
);

--- Standard: Sorenson Spark ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (0214, 6, 1998);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (0214, 'Sorenson Spark', 1), (0214, 'Sorenson Video 3', 0), (0214, 'SVQ3', 0);
INSERT INTO standard_makers (standard_id, maker_id) VALUES (0214, 30);
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, encoding_speed, decoding_speed, file_size_lossy,
    has_alpha_channel, color_bit_depth, color_model_id, editing_performance_id, relevance
) VALUES (
    0214, 'Default', 2, 'The dominant video codec of the early web, used in Adobe Flash Player and early versions of YouTube.',
    45, 120, 115, 125,
    0, 8, 1, 4, 3
);

-- -----------------------------------------------------------------------------
-- Category: Video // Intermediate (ID: 3)
-- -----------------------------------------------------------------------------

--- Standard: Apple ProRes ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (0300, 6, 2007);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (0300, 'Apple ProRes', 1);
INSERT INTO standard_makers (standard_id, maker_id) VALUES (0300, 2);
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, file_size_lossless,
    has_alpha_channel, color_bit_depth, color_model_id, editing_performance_id, relevance
) VALUES (
    0300, '422 HQ', 3, 'The dominant intermediate codec in Mac-centric professional workflows.',
    70, 25,
    0, 10, 2, 1, 1
);
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, file_size_lossless,
    has_alpha_channel, color_bit_depth, color_model_id, editing_performance_id, relevance
) VALUES (
    0300, '4444 XQ', 3, 'The highest-quality version of ProRes, supporting an alpha channel.',
    60, 55,
    1, 12, 3, 1, 1
);

--- Standard: Avid DNxHR ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (0301, 3, 2014);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (0301, 'Avid DNxHR', 1);
INSERT INTO standard_makers (standard_id, maker_id) VALUES (0301, 13);
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, file_size_lossless,
    has_alpha_channel, color_bit_depth, color_model_id, editing_performance_id, relevance
) VALUES (
    0301, 'HQX', 3, 'The cross-platform industry standard for professional editing, especially in broadcast.',
    70, 25,
    1, 12, 3, 1, 1
);
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, file_size_lossless,
    has_alpha_channel, color_bit_depth, color_model_id, editing_performance_id, relevance
) VALUES (
    0301, 'LB', 3, 'A low-bandwidth version of DNxHR for offline editing and proxies.',
    70, 8,
    1, 8, 1, 1, 1
);

--- Standard: GoPro CineForm ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (0302, 6, 2004);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (0302, 'GoPro CineForm', 1);
INSERT INTO standard_makers (standard_id, maker_id) VALUES (0302, 14);
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, file_size_lossless,
    has_alpha_channel, color_bit_depth, color_model_id, editing_performance_id, relevance
) VALUES (
    0302, 'Default', 3, 'A high-quality intermediate codec, popular in GoPro and VFX workflows.',
    50, 20,
    1, 12, 3, 1, 1
);

--- Standard: Motion JPEG ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (0303, 1, 1995);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (0303, 'Motion JPEG', 1), (0303, 'MJPEG', 0);
INSERT INTO standard_makers (standard_id, maker_id) VALUES (0303, 11);
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, file_size_lossless,
    has_alpha_channel, color_bit_depth, color_model_id, editing_performance_id, relevance
) VALUES (
    0303, 'Default', 3, 'A video format consisting of a sequence of individual JPEG images. Mostly used by cinemas and older cameras.',
    60, 40,
    0, 8, 6, 1, 2
);

-- -----------------------------------------------------------------------------
-- Category: Video // Archival (ID: 4)
-- -----------------------------------------------------------------------------

--- Standard: Uncompressed Video ---
INSERT INTO standards (standard_id) VALUES (0400);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (0400, 'Uncompressed Video', 1);
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, encoding_speed, decoding_speed, file_size_lossless,
    has_alpha_channel, color_bit_depth, color_model_id, editing_performance_id, relevance
) VALUES (
    0400, '10-bit 4:4:4', 4, 'A raw, uncompressed video stream. Offers perfect quality and editing speed but with massive file sizes.',
    80, 500, 500, 100,
    1, 10, 3, 1, 1
);

--- Standard: FFV1 ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (0401, 2, 2003);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (0401, 'FFV1', 1);
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, encoding_speed, decoding_speed, file_size_lossless,
    has_alpha_channel, color_bit_depth, color_model_id, editing_performance_id, relevance
) VALUES (
    0401, 'Default', 4, 'The open standard for video archiving, prized for its data integrity features like checksums.',
    40, 150, 150, 45,
    1, 16, 3, 4, 1
);

--- Profile: H.264 Lossless ---
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, encoding_speed, decoding_speed, file_size_lossless,
    has_alpha_channel, color_bit_depth, color_model_id, editing_performance_id, relevance
) VALUES (
    0200, 'Lossless', 4, 'Lossless profile of H.264. Support for this specific profile is mostly software-based.',
    60, 120, 80, 42,
    0, 10, 2, 4, 1
);

--- Profile: H.265 Lossless ---
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, encoding_speed, decoding_speed, file_size_lossless,
    has_alpha_channel, color_bit_depth, color_model_id, editing_performance_id, relevance
) VALUES (
    0201, 'Lossless', 4, 'Lossless profile of H.265. Offers good compression with mostly software-based decoding.',
    50, 50, 60, 40,
    0, 10, 3, 4, 1
);

--- Profile: VP9 Lossless ---
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, encoding_speed, decoding_speed, file_size_lossless,
    has_alpha_channel, color_bit_depth, color_model_id, editing_performance_id, relevance
) VALUES (
    0202, 'Lossless', 4, 'Lossless profile of VP9. A good open-source alternative for archival.',
    55, 40, 70, 38,
    1, 12, 3, 4, 1
);

--- Profile: AV1 Lossless ---
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, encoding_speed, decoding_speed, file_size_lossless,
    has_alpha_channel, color_bit_depth, color_model_id, editing_performance_id, relevance
) VALUES (
    0203, 'Lossless', 4, 'Lossless profile of AV1. Offers the best compression ratio for archival video but is very slow.',
    50, 15, 50, 35,
    1, 12, 3, 4, 1
);

-- -----------------------------------------------------------------------------
-- Category: Subtitle (ID: 5)
-- -----------------------------------------------------------------------------

--- Standard: SRT ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (0500, 1, 1999);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (0500, 'SRT', 1);
INSERT INTO standard_makers (standard_id, maker_id) VALUES (0500, 27);
INSERT INTO profiles (standard_id, profile_name, category_id, notes, ecosystem_support, subtitle_is_image, relevance)
    VALUES (0500, 'Default', 5, 'The most universal and basic text-based subtitle format.', 99, 0, 1);

--- Standard: ASS ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (0501, 2, 2002);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (0501, 'ASS', 1), (0501, 'SSA', 0);
INSERT INTO standard_makers (standard_id, maker_id) VALUES (0501, 4);
INSERT INTO profiles (standard_id, profile_name, category_id, notes, ecosystem_support, subtitle_is_image, relevance)
    VALUES (0501, 'Default', 5, 'A powerful text format offering advanced styling, positioning, and effects.', 70, 0, 1);

--- Standard: WebVTT ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (0502, 2, 2010);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (0502, 'WebVTT', 1);
INSERT INTO standard_makers (standard_id, maker_id) VALUES (0502, 16);
INSERT INTO profiles (standard_id, profile_name, category_id, notes, ecosystem_support, subtitle_is_image, relevance)
    VALUES (0502, 'Default', 5, 'The modern standard for subtitles on the web, designed for HTML5 video.', 95, 0, 1);

--- Standard: VobSub ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (0503, 6, 1997);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (0503, 'VobSub', 1);
INSERT INTO profiles (standard_id, profile_name, category_id, notes, ecosystem_support, subtitle_is_image, file_size_lossless, relevance)
    VALUES (0503, 'Default', 5, 'Image-based subtitle format used on DVDs. Cannot be scaled or edited like text.', 70, 1, 5, 1);

--- Standard: PGS ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (0504, 6, 2006);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (0504, 'PGS', 1);
INSERT INTO profiles (standard_id, profile_name, category_id, notes, ecosystem_support, subtitle_is_image, file_size_lossless, relevance)
    VALUES (0504, 'Default', 5, 'High-resolution image-based subtitle format used on Blu-ray Discs.', 65, 1, 10, 1);

-- -----------------------------------------------------------------------------
-- Category: Audio // Lossy (ID: 6)
-- -----------------------------------------------------------------------------

--- Standard: Opus ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (0600, 2, 2012);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (0600, 'Opus', 1);
INSERT INTO standard_makers (standard_id, maker_id) VALUES (0600, 4);
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, encoding_speed, decoding_speed, file_size_lossy,
    latency_level_id, audio_bit_depth, max_audio_channels, relevance
) VALUES (
    0600, 'Default', 6, 'State-of-the-art codec for WebRTC, VoIP, and modern streaming.',
    90, 150, 100, 50,
    1, 32, '255', 1
);

--- Standard: MP3 ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (0601, 1, 1993);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (0601, 'MP3', 1);
INSERT INTO standard_makers (standard_id, maker_id) VALUES (0601, 9), (0601, 8);
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, encoding_speed, decoding_speed, file_size_lossy,
    latency_level_id, audio_bit_depth, max_audio_channels, relevance
) VALUES (
    0601, 'Default', 6, 'The legacy audio king, universal but inefficient.',
    99, 100, 100, 100,
    4, 16, '2', 1
);

--- Standard: AAC ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (0602, 3, 1997);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (0602, 'AAC', 1);
INSERT INTO standard_makers (standard_id, maker_id) VALUES (0602, 9);
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, encoding_speed, decoding_speed, file_size_lossy,
    latency_level_id, audio_bit_depth, max_audio_channels, relevance
) VALUES (
    0602, 'Default', 6, 'The standard for Apple devices and most modern streaming services.',
    95, 85, 100, 65,
    3, 24, '48', 1
);

--- Standard: Vorbis ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (0603, 2, 2000);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (0603, 'Vorbis', 1);
INSERT INTO standard_makers (standard_id, maker_id) VALUES (0603, 4);
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, encoding_speed, decoding_speed, file_size_lossy,
    latency_level_id, audio_bit_depth, max_audio_channels, relevance
) VALUES (
    0603, 'Default', 6, 'The original open-source alternative to MP3, used heavily by Spotify and game developers.',
    75, 70, 90, 80,
    4, 16, '255', 2
);

--- Standard: MP2 ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (0604, 1, 1993);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (0604, 'MP2', 1), (0604, 'MPEG-1 Audio Layer II', 0);
INSERT INTO standard_makers (standard_id, maker_id) VALUES (0604, 9), (0604, 8);
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, encoding_speed, decoding_speed, file_size_lossy,
    latency_level_id, audio_bit_depth, max_audio_channels, relevance
) VALUES (
    0604, 'Default', 6, 'The predecessor to MP3, used for Video CDs (VCDs) and digital broadcasting.',
    60, 110, 105, 140,
    4, 16, '2', 3
);

--- Standard: RealAudio ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (0605, 6, 1995);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (0605, 'RealAudio', 1);
INSERT INTO standard_makers (standard_id, maker_id) VALUES (0605, 28);
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, encoding_speed, decoding_speed, file_size_lossy,
    latency_level_id, audio_bit_depth, max_audio_channels, relevance
) VALUES (
    0605, 'Default', 6, 'A pioneering streaming audio format from the dial-up era, known for its high compression at low bitrates.',
    40, 90, 95, 110,
    4, 16, '2', 3
);

--- Standard: Windows Media Audio ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (0606, 6, 1999);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (0606, 'WMA', 1), (0606, 'Windows Media Audio', 0);
INSERT INTO standard_makers (standard_id, maker_id) VALUES (0606, 3);
--- Profile: WMA Standard ---
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, encoding_speed, decoding_speed, file_size_lossy,
    latency_level_id, audio_bit_depth, max_audio_channels, relevance
) VALUES (
    0606, 'Standard', 6, 'Microsoft''s proprietary competitor to MP3 and AAC, widely used in the Windows ecosystem.',
    65, 90, 95, 85,
    4, 16, '2', 2
);

--- Standard: ATRAC ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (0607, 6, 1992);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (0607, 'ATRAC', 1);
INSERT INTO standard_makers (standard_id, maker_id) VALUES (0607, 31);
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, encoding_speed, decoding_speed, file_size_lossy,
    latency_level_id, audio_bit_depth, max_audio_channels, relevance
) VALUES (
    0607, 'Default', 6, 'Sony''s proprietary audio codec, famous for the MiniDisc format. A major competitor to MP3 in its era.',
    30, 95, 95, 90,
    4, 16, '2', 3
);

-- -----------------------------------------------------------------------------
-- Category: Audio // Lossless (ID: 7)
-- -----------------------------------------------------------------------------

--- Standard: WAV ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (0700, 1, 1991);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (0700, 'WAV', 1), (0700, 'PCM', 0);
INSERT INTO standard_makers (standard_id, maker_id) VALUES (0700, 3), (0700, 26);
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, encoding_speed, decoding_speed, file_size_lossless, audio_bit_depth, max_audio_channels, latency_level_id, relevance
) VALUES (
    0700, 'Uncompressed', 7, 'The universal standard for uncompressed, raw PCM audio data.',
    99, 500, 200, 100, 32, '6505036', 4, 1
);

--- Standard: FLAC ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (0701, 2, 2001);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (0701, 'FLAC', 1);
INSERT INTO standard_makers (standard_id, maker_id) VALUES (0701, 4);
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, encoding_speed, decoding_speed, file_size_lossless, audio_bit_depth, max_audio_channels, latency_level_id, relevance
) VALUES (
    0701, 'Default', 7, 'The de facto open standard for compressed lossless audio. Note: most existing decoders only support up to 24-bit decoding',
    90, 90, 95, 60, 32, '8', 4, 1
);

--- Standard: ALAC ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (0702, 2, 2004);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (0702, 'ALAC', 1);
INSERT INTO standard_makers (standard_id, maker_id) VALUES (0702, 2);
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, encoding_speed, decoding_speed, file_size_lossless, audio_bit_depth, max_audio_channels, latency_level_id, relevance
) VALUES (
    0702, 'Default', 7, 'Apple''s native lossless format, open-sourced in 2011.',
    60, 120, 95, 65, 32, '8', 4, 2
);

--- Standard: Monkey's Audio ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (0703, 7, 2001);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (0703, 'Monkey''s Audio', 1), (0703, 'APE', 0);
INSERT INTO standard_makers (standard_id, maker_id) VALUES (0703, 25);
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, encoding_speed, decoding_speed, file_size_lossless, audio_bit_depth, max_audio_channels, latency_level_id, relevance
) VALUES (
    0703, 'Default', 7, 'A proprietary codec known for its very high compression ratios, popular in niche audiophile circles.',
    30, 30, 80, 55, 24, '32', 4, 3
);

--- Profile: WMA Lossless ---
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, encoding_speed, decoding_speed, file_size_lossless, audio_bit_depth, max_audio_channels, latency_level_id, relevance
) VALUES (
    0606, 'Lossless', 7, 'The lossless version of WMA, Microsoft''s proprietary codec, widely used in the Windows ecosystem.',
    50, 80, 90, 62, 24, '8', 4, 3
);

--- Standard: Shorten ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (0704, 7, 1992);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (0704, 'Shorten', 1), (0704, 'SHN', 0);
INSERT INTO standard_makers (standard_id, maker_id) VALUES (0704, 29);
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, encoding_speed, decoding_speed, file_size_lossless, audio_bit_depth, max_audio_channels, latency_level_id, relevance
) VALUES (
    0704, 'Default', 7, 'An early lossless audio codec, popular in music trading communities before being superseded by FLAC.',
    20, 70, 85, 70, 16, '2', 4, 3
);

-- -----------------------------------------------------------------------------
-- Category: Image (ID: 8)
-- -----------------------------------------------------------------------------

--- Standard: JPEG ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (0800, 1, 1992);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (0800, 'JPEG', 1), (0800, 'JPG', 0);
INSERT INTO standard_makers (standard_id, maker_id) VALUES (0800, 11);
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, encoding_speed, decoding_speed, file_size_lossy, file_size_lossless,
    has_alpha_channel, color_bit_depth, color_model_id, relevance
) VALUES (
    0800, 'Default', 8, 'The universal standard for photographic images on the web.',
    99, 100, 100, 100, 200,
    0, 8, 6, 1
);

--- Standard: PNG ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (0801, 2, 1996);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (0801, 'PNG', 1);
INSERT INTO standard_makers (standard_id, maker_id) VALUES (0801, 16);
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, encoding_speed, decoding_speed, file_size_lossless,
    has_alpha_channel, color_bit_depth, color_model_id, relevance
) VALUES (
    0801, 'Default', 8, 'The standard for lossless web graphics and transparency.',
    99, 30, 80, 100,
    1, 8, 4, 1
);

--- Standard: WebP ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (0802, 2, 2010);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (0802, 'WebP', 1);
INSERT INTO standard_makers (standard_id, maker_id) VALUES (0802, 1);
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, encoding_speed, decoding_speed, file_size_lossy, file_size_lossless,
    has_alpha_channel, color_bit_depth, color_model_id, relevance
) VALUES (
    0802, 'Default', 8, 'Google''s versatile format to replace JPEG and PNG, offering better compression.',
    97, 90, 100, 70, 75,
    1, 8, 1, 2
);

--- Standard: AVIF ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (0803, 2, 2019);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (0803, 'AVIF', 1);
INSERT INTO standard_makers (standard_id, maker_id) VALUES (0803, 5);
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, encoding_speed, decoding_speed, file_size_lossy, file_size_lossless,
    has_alpha_channel, color_bit_depth, color_model_id, relevance
) VALUES (
    0803, 'Default', 8, 'State-of-the-art compression based on AV1, offering superior quality and features.',
    85, 10, 70, 50, 70,
    1, 12, 3, 2
);

--- Standard: JPEG XL ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (0804, 2, 2020);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (0804, 'JPEG XL', 1), (0804, 'JXL', 0);
INSERT INTO standard_makers (standard_id, maker_id) VALUES (0804, 11);
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, encoding_speed, decoding_speed, file_size_lossy, file_size_lossless,
    has_alpha_channel, color_bit_depth, color_model_id, relevance
) VALUES (
    0804, 'Default', 8, 'A technically superior next-gen format, but its adoption was stalled by browser politics.',
    10, 90, 100, 40, 65,
    1, 16, 7, 3
);

--- Standard: HEIF ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (0805, 5, 2015);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (0805, 'HEIF', 1), (0805, 'HEIC', 0);
INSERT INTO standard_makers (standard_id, maker_id) VALUES (0805, 11);
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, encoding_speed, decoding_speed, file_size_lossy, file_size_lossless,
    has_alpha_channel, color_bit_depth, color_model_id, relevance
) VALUES (
    0805, 'Default', 8, 'The container format used by most modern smartphones, typically with an HEVC-encoded image.',
    65, 30, 90, 50, 70,
    1, 10, 2, 1
);

--- Standard: SVG ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (0806, 2, 2001);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (0806, 'SVG', 1);
INSERT INTO standard_makers (standard_id, maker_id) VALUES (0806, 16);
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support,
    has_alpha_channel, color_bit_depth, color_model_id, relevance
) VALUES (
    0806, 'Default', 8, 'An XML-based vector format. Performance and file size are not directly comparable to raster formats.',
    98,
    1, 8, 8, 2
);

--- Standard: TIFF ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (0807, 6, 1986);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (0807, 'TIFF', 1);
INSERT INTO standard_makers (standard_id, maker_id) VALUES (0807, 12);
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, encoding_speed, decoding_speed, file_size_lossless,
    has_alpha_channel, color_bit_depth, color_model_id, relevance
) VALUES (
    0807, 'Default', 8, 'The standard for high-quality print, archiving, and professional photography masters.',
    60, 20, 70, 110,
    1, 16, 4, 3
);

--- Standard: Camera RAW ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (0808, 6, 2004);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (0808, 'DNG', 1), (0808, 'Camera RAW', 0);
INSERT INTO standard_makers (standard_id, maker_id) VALUES (0808, 12);
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, file_size_lossless,
    has_alpha_channel, color_bit_depth, color_model_id, relevance
) VALUES (
    0808, 'Default', 8, 'A "digital negative" containing unprocessed 12-16 bit data from a camera sensor. Offers maximum editing flexibility.',
    50, 250,
    0, 16, 4, 2
);

--- Standard: BMP ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (0809, 6, 1990);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (0809, 'BMP', 1), (0809, 'Bitmap', 0);
INSERT INTO standard_makers (standard_id, maker_id) VALUES (0809, 3);
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, encoding_speed, decoding_speed, file_size_lossless,
    has_alpha_channel, color_bit_depth, color_model_id, relevance
) VALUES (
    0809, 'Default', 8, 'The uncompressed bitmap image format native to Windows. Files are large but simple and widely supported.',
    95, 200, 200, 130,
    0, 8, 4, 3
);

--- Standard: JPEG 2000 ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (0810, 4, 2000);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (0810, 'JPEG 2000', 1), (0810, 'JP2', 0);
INSERT INTO standard_makers (standard_id, maker_id) VALUES (0810, 11);
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, encoding_speed, decoding_speed, file_size_lossy, file_size_lossless,
    has_alpha_channel, color_bit_depth, color_model_id, relevance
) VALUES (
    0810, 'Default', 8, 'A technically superior successor to JPEG that failed to gain mainstream adoption. Now used in niche archival and medical imaging.',
    30, 40, 50, 75, 80,
    1, 16, 6, 3
);

-- -----------------------------------------------------------------------------
-- Category: Animated Image (ID: 9)
-- -----------------------------------------------------------------------------

--- Standard: GIF ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (0900, 1, 1989);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (0900, 'GIF', 1);
INSERT INTO standard_makers (standard_id, maker_id) VALUES (0900, 23);
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, decoding_speed, file_size_lossless,
    has_alpha_channel, color_bit_depth, color_model_id, relevance
) VALUES (
    0900, 'Default', 9, 'The universal standard for short animations, limited to a 256-color palette.',
    99, 100, 100,
    1, 8, 5, 1
);

--- Standard: APNG ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (0901, 2, 2004);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (0901, 'APNG', 1);
INSERT INTO standard_makers (standard_id, maker_id) VALUES (0901, 4);
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, decoding_speed, file_size_lossless,
    has_alpha_channel, color_bit_depth, color_model_id, relevance
) VALUES (
    0901, 'Default', 9, 'An extension of PNG for lossless animations with full color and alpha support.',
    95, 80, 65,
    1, 8, 4, 1
);

--- Profile: Animated WebP ---
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, decoding_speed, file_size_lossy, file_size_lossless,
    has_alpha_channel, color_bit_depth, color_model_id, relevance
) VALUES (
    0802, 'Animated', 9, 'Offers smaller file sizes than GIF with better color and alpha support.',
    97, 90, 25, 45,
    1, 8, 4, 1
);

--- Profile: Animated AVIF ---
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, decoding_speed, file_size_lossy, file_size_lossless,
    has_alpha_channel, color_bit_depth, color_model_id, relevance
) VALUES (
    0803, 'Animated', 9, 'State-of-the-art compression for animations, offering massive savings over GIF.',
    85, 70, 15, 40,
    1, 12, 3, 1
);

-- -----------------------------------------------------------------------------
-- Category: 3D Model (ID: 10)
-- -----------------------------------------------------------------------------

--- Standard: STL ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (1000, 1, 1987);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (1000, 'STL', 1);
INSERT INTO standard_makers (standard_id, maker_id) VALUES (1000, 17);
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, has_texture_support, has_animation_support, file_size_lossless, relevance
) VALUES (
    1000, 'Binary', 10, 'The most used, though inefficient, standard for 3D printing.',
    99, 0, 0, 100, 1
);
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, has_texture_support, has_animation_support, file_size_lossless, relevance
) VALUES (
    1000, 'ASCII', 10, 'A human-readable but inefficient text-based version of the STL format.',
    99, 0, 0, 400, 1
);

--- Standard: OBJ ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (1001, 2, 1990);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (1001, 'OBJ', 1);
INSERT INTO standard_makers (standard_id, maker_id) VALUES (1001, 18);
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, has_texture_support, has_animation_support, file_size_lossless, relevance
) VALUES (
    1001, 'Default', 10, 'Text-based and verbose; files are significantly larger than binary equivalents for the same geometry.',
    98, 1, 0, 140, 1
);

--- Standard: 3MF ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (1002, 2, 2015);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (1002, '3MF', 1);
INSERT INTO standard_makers (standard_id, maker_id) VALUES (1002, 19);
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, has_texture_support, has_animation_support, file_size_lossless, relevance
) VALUES (
    1002, 'Default', 10, 'Uses ZIP compression, resulting in much smaller files than STL for the same model.',
    60, 1, 0, 40, 2
);

--- Standard: glTF ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (1003, 2, 2015);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (1003, 'glTF', 1), (1003, 'GLB', 0);
INSERT INTO standard_makers (standard_id, maker_id) VALUES (1003, 20);
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, has_texture_support, has_animation_support, file_size_lossless, relevance
) VALUES (
    1003, 'Default', 10, 'Highly optimized binary format (GLB) for web delivery; often the smallest for geometry.',
    85, 1, 1, 35, 2
);

--- Standard: FBX ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (1004, 6, 2006);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (1004, 'FBX', 1);
INSERT INTO standard_makers (standard_id, maker_id) VALUES (1004, 21);
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, has_texture_support, has_animation_support, file_size_lossless, relevance
) VALUES (
    1004, 'Default', 10, 'Binary format with scene overhead; efficient but not as compact as web-focused formats for pure geometry.',
    95, 1, 1, 60, 2
);

--- Standard: USD ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (1005, 2, 2016);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (1005, 'USD', 1), (1005, 'USDZ', 0);
INSERT INTO standard_makers (standard_id, maker_id) VALUES (1005, 22);
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, has_texture_support, has_animation_support, file_size_lossless, relevance
) VALUES (
    1005, 'Default', 10, '"The HTML of the Metaverse," a framework for composing and collaborating on complex 3D scenes.',
    50, 1, 1, 60, 2
);

-- -----------------------------------------------------------------------------
-- Category: Audio // Home Theater (ID: 11)
-- -----------------------------------------------------------------------------

--- Standard: Dolby Digital ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (1100, 6, 1992);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (1100, 'Dolby Digital', 1), (1100, 'AC-3', 0);
INSERT INTO standard_makers (standard_id, maker_id) VALUES (1100, 6);
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, encoding_speed, decoding_speed, file_size_lossy,
    latency_level_id, audio_bit_depth, max_audio_channels, relevance
) VALUES (
    1100, 'Default', 11, 'The standard for surround sound on DVDs and broadcast television.',
    80, 75, 90, 90,
    4, 16, '5.1', 1
);
--- Profile: Dolby Digital Plus ---
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, encoding_speed, decoding_speed, file_size_lossy,
    latency_level_id, audio_bit_depth, max_audio_channels, relevance
) VALUES (
    1100, 'Plus', 11, 'An enhanced version of AC-3 used by streaming services and as a core for TrueHD.',
    70, 70, 90, 80,
    4, 24, '15.1', 1
);

--- Standard: Dolby TrueHD ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (1101, 6, 2006);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (1101, 'Dolby TrueHD', 1);
INSERT INTO standard_makers (standard_id, maker_id) VALUES (1101, 6);
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, encoding_speed, decoding_speed, file_size_lossless,
    latency_level_id, audio_bit_depth, max_audio_channels, relevance
) VALUES (
    1101, 'Default', 11, 'A lossless audio codec that directly competes with DTS-HD MA on Blu-ray discs.',
    75, 60, 85, 55,
    4, 24, '8', 1
);
--- Profile: Dolby Atmos ---
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, encoding_speed, decoding_speed, file_size_lossless,
    latency_level_id, audio_bit_depth, max_audio_channels, relevance
) VALUES (
    1101, 'Atmos', 11, 'Object-based immersive audio, typically delivered within a Dolby TrueHD stream on Blu-ray.',
    65, 60, 75, 58,
    4, 24, '7.1 + Objects', 1
);

--- Standard: DTS ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (1102, 6, 1993);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (1102, 'DTS', 1);
INSERT INTO standard_makers (standard_id, maker_id) VALUES (1102, 7);
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, encoding_speed, decoding_speed, file_size_lossy,
    latency_level_id, audio_bit_depth, max_audio_channels, relevance
) VALUES (
    1102, 'Core', 11, 'The standard lossy surround format from DTS, competing with Dolby Digital. Often used as a fallback track.',
    75, 75, 90, 95,
    4, 24, '5.1', 1
);

--- Standard: DTS-HD Master Audio ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (1103, 6, 2004);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (1103, 'DTS-HD Master Audio', 1), (1103, 'DTS-HD MA', 0);
INSERT INTO standard_makers (standard_id, maker_id) VALUES (1103, 7);
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, encoding_speed, decoding_speed, file_size_lossless,
    latency_level_id, audio_bit_depth, max_audio_channels, relevance
) VALUES (
    1103, 'Default', 11, 'The primary lossless audio codec from DTS. The most common advanced format on Blu-ray.',
    80, 65, 85, 58,
    4, 24, '8', 1
);
--- Profile: DTS:X ---
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, encoding_speed, decoding_speed, file_size_lossless,
    latency_level_id, audio_bit_depth, max_audio_channels, relevance
) VALUES (
    1103, 'DTS:X', 11, 'DTS''s object-based immersive audio format, competing with Dolby Atmos.',
    60, 65, 75, 60,
    4, 24, '7.1 + Objects', 1
);


COMMIT;