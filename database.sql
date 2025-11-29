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
    (7, 'Free (Source Available)', '#ffeb84', '🟡'),
    (8, 'Open Specification', '#b1d47f', '🟢');

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
    (31, 'Sony'),
    (32, '3GPP'),
    (33, '3GPP2'),
    (34, 'Matroska project'),
    (35, 'Intel'),
    (36, 'SuperMac Technologies'),
    (37, 'Skype'),
    (38, 'Interactive Multimedia Association');

CREATE TABLE standard_makers (
    standard_id     INTEGER NOT NULL,
    maker_id        INTEGER NOT NULL,
    PRIMARY KEY (standard_id, maker_id),
    FOREIGN KEY (standard_id) REFERENCES standards (standard_id),
    FOREIGN KEY (maker_id) REFERENCES makers (maker_id)
);

CREATE TABLE pairing_support_levels (
    level_id        INTEGER PRIMARY KEY,
    level_name      TEXT NOT NULL UNIQUE
);
INSERT INTO pairing_support_levels (level_id, level_name) VALUES
    (1, 'Official'),
    (2, 'Common'),
    (3, 'Non-Standard');



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
    FOREIGN KEY (category_id) REFERENCES categories (category_id),
    FOREIGN KEY (color_model_id) REFERENCES color_models (color_model_id),
    FOREIGN KEY (latency_level_id) REFERENCES level_ratings (level_id),
    FOREIGN KEY (editing_performance_id) REFERENCES qualitative_ratings (rating_id)
);

CREATE TABLE container_codec_support (
    container_id        INTEGER NOT NULL,
    codec_id            INTEGER NOT NULL,
    support_level_id    INTEGER NOT NULL,
    PRIMARY KEY (container_id, codec_id),
    FOREIGN KEY (container_id) REFERENCES standards (standard_id),
    FOREIGN KEY (codec_id) REFERENCES standards (standard_id),
    FOREIGN KEY (support_level_id) REFERENCES pairing_support_levels (level_id)
);



-- =============================================================================
-- DATA POPULATION
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Category: Container (ID: 1)
-- -----------------------------------------------------------------------------

--- Standard: MP4 ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (0100, 3, 2001);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (0100, 'MP4', 1), (0100, 'M4A', 0), (0100, 'M4P', 0), (0100, 'MP4P', 0);
INSERT INTO standard_makers (standard_id, maker_id) VALUES (0100, 11);
INSERT INTO profiles (standard_id, profile_name, category_id, notes, ecosystem_support, relevance)
    VALUES (0100, 'Default', 1, 'The most compatible and widely used container format for digital video. Often uses .M4A for audio-only, usually containing AAC.', 99, 1);

--- Standard: MKV ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (0101, 2, 2002);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (0101, 'MKV', 1), (0101, 'MKA', 0), (0101, 'Matroska', 0);
INSERT INTO standard_makers (standard_id, maker_id) VALUES (0101, 34);
INSERT INTO profiles (standard_id, profile_name, category_id, notes, ecosystem_support, relevance)
    VALUES (0101, 'Default', 1, 'A flexible container that can hold virtually any track type, prized by enthusiasts.', 75, 1);

--- Standard: WebM ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (0102, 2, 2010);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (0102, 'WebM', 1), (0102, 'WebA', 0);
INSERT INTO standard_makers (standard_id, maker_id) VALUES (0102, 1);
INSERT INTO profiles (standard_id, profile_name, category_id, notes, ecosystem_support, relevance)
    VALUES (0102, 'Default', 1, 'A container specifically designed for royalty-free web codecs like VP9 and AV1.', 90, 1);

--- Standard: MOV ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (0103, 6, 1991);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (0103, 'MOV', 1), (0103, 'QuickTime', 0), (0103, 'qt', 0);
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
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (0105, 'Ogg', 1), (0105, 'ogv', 0), (0105, 'oga', 0), (0105, 'ogx', 0), (0105, 'ogm', 0), (0105, 'spx', 0);
INSERT INTO standard_makers (standard_id, maker_id) VALUES (0105, 4);
INSERT INTO profiles (standard_id, profile_name, category_id, notes, ecosystem_support, relevance)
    VALUES (0105, 'Default', 1, 'The container format for the Xiph.Org Foundation''s family of open-source codecs like Vorbis, Opus, and Theora.', 70, 1);

--- Standard: 3GP ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (0106, 2, 2001);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (0106, '3GP', 1);
INSERT INTO standard_makers (standard_id, maker_id) VALUES (0106, 32);
INSERT INTO profiles (standard_id, profile_name, category_id, notes, ecosystem_support, relevance)
    VALUES (0106, 'Default', 1, 'A simplified version of the MP4 container, designed for early 3G mobile phones and MMS messaging.', 50, 3);

--- Standard: 3G2 ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (0107, 2, 2002);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (0107, '3G2', 1);
INSERT INTO standard_makers (standard_id, maker_id) VALUES (0107, 33);
INSERT INTO profiles (standard_id, profile_name, category_id, notes, ecosystem_support, relevance)
    VALUES ( 0107, 'Default', 1, 'A container format for CDMA2000 mobile networks, a sibling to the more common 3GP format.', 40, 3);

--- Standard: IAMF (Immersive Audio Model and Format) ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (0108, 2, 2023);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (0108, 'IAMF', 1), (0108, 'Immersive Audio Model and Format', 0);
INSERT INTO standard_makers (standard_id, maker_id) VALUES (0108, 5);
INSERT INTO profiles (standard_id, profile_name, category_id, notes, ecosystem_support, relevance)
    VALUES (0108, 'Default', 1, 'A specialized open container format for delivering immersive and object-based audio.', 20, 3);

--- Standard: FLV (Flash Video) ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (0109, 6, 2002);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (0109, 'FLV', 1), (0109, 'Flash Video', 0);
INSERT INTO standard_makers (standard_id, maker_id) VALUES (0109, 12);
INSERT INTO profiles (standard_id, profile_name, category_id, notes, ecosystem_support, relevance)
    VALUES (0109, 'Default', 1, 'The container format for Adobe Flash Player, which powered most web video in the mid-2000s.', 40, 3);

--- Standard: WAV ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (0110, 1, 1991);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (0110, 'WAV', 1), (0110, 'WAVE', 0);
INSERT INTO standard_makers (standard_id, maker_id) VALUES (0110, 3), (0110, 26);
INSERT INTO profiles (standard_id, profile_name, category_id, notes, ecosystem_support, relevance)
    VALUES (0110, 'Default', 1, 'An audio container format most commonly used to store uncompressed PCM audio.', 99, 1);

--- Standard: AIFF ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (0111, 2, 1988);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (0111, 'AIFF', 1), (0111, 'Audio Interchange File Format', 0);
INSERT INTO standard_makers (standard_id, maker_id) VALUES (0111, 2);
INSERT INTO profiles (standard_id, profile_name, category_id, notes, ecosystem_support, relevance)
    VALUES (0111, 'Default', 1, 'Apple''s standard uncompressed audio container, functionally similar to WAV. Widely used in professional audio on macOS.', 90, 2);

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
    0, 10, 3, 4, 1
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
    0, 12, 3, 4, 1
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
    70, 15, 60, 40,
    1, 12, 3, 4, 1
);

--- Standard: AV2 ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (0204, 2, 2025);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (0204, 'AV2', 1);
INSERT INTO standard_makers (standard_id, maker_id) VALUES (0204, 5);
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, encoding_speed, decoding_speed, file_size_lossy,
    has_alpha_channel, color_bit_depth, color_model_id, editing_performance_id, relevance
) VALUES (
    0204, 'Default', 2, 'An in-development successor to AV1. Performance numbers are preliminary and based on early, unoptimized reference software.',
    0, 1, 10, 30,
    1, 12, 3, 4, 3
);

--- Standard: H.266 ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (0205, 4, 2020);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (0205, 'H.266', 1), (0205, 'VVC', 1);
INSERT INTO standard_makers (standard_id, maker_id) VALUES (0205, 10), (0205, 11);
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, encoding_speed, decoding_speed, file_size_lossy,
    has_alpha_channel, color_bit_depth, color_model_id, editing_performance_id, relevance
) VALUES (
    0205, 'Default', 2, 'A successor to HEVC, its adoption is limited by licensing and the rise of AV1.',
    5, 2, 40, 35,
    0, 10, 3, 4, 3
);

--- Standard: MPEG-2 ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (0206, 1, 1995);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (0206, 'MPEG-2', 1), (0206, 'H.262', 0);
INSERT INTO standard_makers (standard_id, maker_id) VALUES (0206, 9);
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, encoding_speed, decoding_speed, file_size_lossy,
    has_alpha_channel, color_bit_depth, color_model_id, editing_performance_id, relevance
) VALUES (
    0206, 'Default', 2, 'The workhorse of standard-definition digital video (DVDs, DVB).',
    70, 150, 150, 180,
    0, 8, 2, 4, 2
);

--- Standard: VP8 ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (0207, 2, 2008);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (0207, 'VP8', 1);
INSERT INTO standard_makers (standard_id, maker_id) VALUES (0207, 1);
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, encoding_speed, decoding_speed, file_size_lossy,
    has_alpha_channel, color_bit_depth, color_model_id, editing_performance_id, relevance
) VALUES (
    0207, 'Default', 2, 'The original royalty-free codec for WebM, now primarily used as a baseline for WebRTC.',
    70, 120, 130, 115,
    1, 8, 1, 4, 2
);

--- Standard: Theora ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (0208, 2, 2004);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (0208, 'Theora', 1);
INSERT INTO standard_makers (standard_id, maker_id) VALUES (0208, 4);
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, encoding_speed, decoding_speed, file_size_lossy,
    has_alpha_channel, color_bit_depth, color_model_id, editing_performance_id, relevance
) VALUES (
    0208, 'Default', 2, 'The original open-source video codec. Now a legacy format, superseded by VP8/VP9.',
    20, 110, 120, 130,
    0, 8, 1, 4, 3
);

--- Standard: MPEG-1 ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (0209, 1, 1993);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (0209, 'MPEG-1', 1);
INSERT INTO standard_makers (standard_id, maker_id) VALUES (0209, 9);
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, encoding_speed, decoding_speed, file_size_lossy,
    has_alpha_channel, color_bit_depth, color_model_id, editing_performance_id, relevance
) VALUES (
    0209, 'Default', 2, 'The original standard for digital video, famous for Video CDs (VCDs). Now completely obsolete due to its very poor compression.',
    40, 200, 200, 300,
    0, 8, 1, 4, 3
);

--- Standard: VC-1 ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (0210, 3, 2006);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (0210, 'VC-1', 1), (0210, 'WMV9', 0);
INSERT INTO standard_makers (standard_id, maker_id) VALUES (0210, 3);
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, encoding_speed, decoding_speed, file_size_lossy,
    has_alpha_channel, color_bit_depth, color_model_id, editing_performance_id, relevance
) VALUES (
    0210, 'Default', 2, 'Standardized for Blu-ray. A direct competitor to H.264, but saw less adoption and is now a legacy format.',
    50, 110, 100, 105,
    0, 8, 1, 4, 3
);

--- Standard: DivX (MPEG-4 Part 2) ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (0211, 6, 1999);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (0211, 'DivX', 1);
INSERT INTO standard_makers (standard_id, maker_id) VALUES (0211, 24);
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, encoding_speed, decoding_speed, file_size_lossy,
    has_alpha_channel, color_bit_depth, color_model_id, editing_performance_id, relevance
) VALUES (
    0211, 'Default', 2, 'A popular proprietary codec based on MPEG-4 Part 2. Common in older hardware players from the 2000s.',
    40, 115, 110, 120,
    0, 8, 1, 4, 3
);

--- Standard: Xvid (MPEG-4 Part 2) ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (0212, 2, 2001);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (0212, 'Xvid', 1);
INSERT INTO standard_makers (standard_id, maker_id) VALUES (0212, 27);
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, encoding_speed, decoding_speed, file_size_lossy,
    has_alpha_channel, color_bit_depth, color_model_id, editing_performance_id, relevance
) VALUES (
    0212, 'Default', 2, 'The open-source equivalent of DivX. Was the dominant format for video sharing online before the rise of H.264.',
    40, 115, 110, 115,
    0, 8, 1, 4, 3
);

--- Standard: RealVideo ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (0213, 6, 1997);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (0213, 'RealVideo', 1);
INSERT INTO standard_makers (standard_id, maker_id) VALUES (0213, 28);
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, encoding_speed, decoding_speed, file_size_lossy,
    has_alpha_channel, color_bit_depth, color_model_id, editing_performance_id, relevance
) VALUES (
    0213, 'Default', 2, 'A dominant streaming video format in the late 90s/early 2000s, optimized for very low bitrates.',
    20, 90, 90, 130,
    0, 8, 1, 4, 3
);

--- Standard: H.263 ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (0214, 3, 1996);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (0214, 'H.263', 1);
INSERT INTO standard_makers (standard_id, maker_id) VALUES (0214, 10);
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, encoding_speed, decoding_speed, file_size_lossy,
    has_alpha_channel, color_bit_depth, color_model_id, editing_performance_id, relevance
) VALUES (
    0214, 'Default', 2, 'The predecessor to H.264 for video conferencing and mobile video. Optimized for low bitrates.',
    30, 140, 140, 150,
    0, 8, 1, 4, 3
);

--- Standard: Sorenson Spark ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (0215, 6, 1998);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (0215, 'Sorenson Spark', 1), (0214, 'Sorenson Video 3', 0), (0214, 'SVQ3', 0);
INSERT INTO standard_makers (standard_id, maker_id) VALUES (0215, 30);
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, encoding_speed, decoding_speed, file_size_lossy,
    has_alpha_channel, color_bit_depth, color_model_id, editing_performance_id, relevance
) VALUES (
    0215, 'Default', 2, 'The dominant video codec of the early web, used in Adobe Flash Player and early versions of YouTube.',
    25, 120, 115, 125,
    0, 8, 1, 4, 3
);

--- Standard: VP6 ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (0216, 6, 2003);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (0216, 'VP6', 1);
INSERT INTO standard_makers (standard_id, maker_id) VALUES (0216, 1);
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, encoding_speed, decoding_speed, file_size_lossy,
    has_alpha_channel, color_bit_depth, color_model_id, editing_performance_id, relevance
) VALUES (
    0216, 'Default', 2, 'A highly efficient codec for its time, used in Flash Player 8 and later. It was the successor to Sorenson Spark for web video.',
    30, 110, 115, 110,
    1, 8, 1, 4, 3
);

--- Standard: Indeo ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (0217, 6, 1992);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (0217, 'Indeo', 1);
INSERT INTO standard_makers (standard_id, maker_id) VALUES (0217, 35);
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, encoding_speed, decoding_speed, file_size_lossy,
    has_alpha_channel, color_bit_depth, color_model_id, editing_performance_id, relevance
) VALUES (
    0217, 'Default', 2, 'One of the first mainstream video codecs for PCs, bundled with Windows. Widely used in 90s CD-ROM games.',
    20, 150, 150, 180,
    0, 8, 1, 4, 3
);

--- Standard: Cinepak ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (0218, 6, 1991);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (0218, 'Cinepak', 1);
INSERT INTO standard_makers (standard_id, maker_id) VALUES (0218, 36);
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, encoding_speed, decoding_speed, file_size_lossy,
    has_alpha_channel, color_bit_depth, color_model_id, editing_performance_id, relevance
) VALUES (
    0218, 'Default', 2, 'A dominant video codec of the early 90s, standard in early QuickTime and Windows. Famous for its very fast playback on slow CPUs.',
    20, 50, 200, 200,
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
    ecosystem_support, file_size_lossy,
    has_alpha_channel, color_bit_depth, color_model_id, editing_performance_id, relevance
) VALUES (
    0300, '422 HQ', 3, 'A dominant visually lossless codec in Mac-centric professional workflows. Directly competes with DNxHR HQX.',
    70, 100,
    0, 10, 2, 1, 1
);
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, file_size_lossy,
    has_alpha_channel, color_bit_depth, color_model_id, editing_performance_id, relevance
) VALUES (
    0300, '4444 XQ', 3, 'The highest-quality version of ProRes, supporting 12-bit color and an alpha channel.',
    60, 220,
    1, 12, 3, 1, 1
);

--- Standard: Avid DNxHR ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (0301, 3, 2014);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (0301, 'Avid DNxHR', 1);
INSERT INTO standard_makers (standard_id, maker_id) VALUES (0301, 13);
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, file_size_lossy,
    has_alpha_channel, color_bit_depth, color_model_id, editing_performance_id, relevance
) VALUES (
    0301, 'HQX', 3, 'The cross-platform industry standard for high-quality online editing.',
    70, 100,
    1, 12, 3, 1, 1
);
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, file_size_lossy,
    has_alpha_channel, color_bit_depth, color_model_id, editing_performance_id, relevance
) VALUES (
    0301, 'LB', 3, 'A low-bandwidth "offline" proxy version of DNxHR, designed for fast performance on lower-spec systems.',
    70, 20,
    1, 8, 1, 1, 1
);

--- Standard: GoPro CineForm ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (0302, 6, 2004);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (0302, 'GoPro CineForm', 1);
INSERT INTO standard_makers (standard_id, maker_id) VALUES (0302, 14);
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, file_size_lossy,
    has_alpha_channel, color_bit_depth, color_model_id, editing_performance_id, relevance
) VALUES (
    0302, 'Default', 3, 'A high-quality intermediate codec, popular in GoPro and VFX workflows.',
    50, 90,
    1, 12, 3, 1, 2
);

--- Standard: Motion JPEG ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (0303, 1, 1995);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (0303, 'Motion JPEG', 1), (0303, 'MJPEG', 0);
INSERT INTO standard_makers (standard_id, maker_id) VALUES (0303, 11);
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, file_size_lossy,
    has_alpha_channel, color_bit_depth, color_model_id, editing_performance_id, relevance
) VALUES (
    0303, 'Default', 3, 'A video format consisting of individual JPEG images. Very inefficient but extremely easy to edit.',
    60, 250,
    0, 8, 6, 1, 3
);

--- Standard: Avid DNxHD ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (0304, 3, 2004);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (0304, 'Avid DNxHD', 1);
INSERT INTO standard_makers (standard_id, maker_id) VALUES (0304, 13);
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, file_size_lossy,
    has_alpha_channel, color_bit_depth, color_model_id, editing_performance_id, relevance
) VALUES (
    0304, '175x', 3, 'The predecessor to DNxHR, limited to HD resolutions.',
    65, 100,
    0, 10, 2, 1, 1
);
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, file_size_lossy,
    has_alpha_channel, color_bit_depth, color_model_id, editing_performance_id, relevance
) VALUES (
    0304, '36', 3, 'A very low-bitrate 8-bit proxy version of DNxHD.',
    65, 20,
    0, 8, 1, 1, 1
);

--- Standard: Advanced Professional Video (APV) ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (0305, 2, 2024);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (0305, 'APV', 1), (0305, 'Advanced Professional Video', 0);
INSERT INTO standard_makers (standard_id, maker_id) VALUES (0305, 32);
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, file_size_lossy,
    has_alpha_channel, color_bit_depth, color_model_id, editing_performance_id, relevance
) VALUES (
    0305, 'Default', 3, 'An ASWF open standard from Samsung. Designed to replace both DNxHR and ProRes as a more efficient and open codec.',
    40, 80,
    1, 16, 3, 1, 2
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
    0, 10, 3, 4, 1
);

--- Profile: H.265 Lossless ---
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, encoding_speed, decoding_speed, file_size_lossless,
    has_alpha_channel, color_bit_depth, color_model_id, editing_performance_id, relevance
) VALUES (
    0201, 'Lossless', 4, 'Lossless profile of H.265. Offers good compression with mostly software-based decoding.',
    50, 50, 60, 40,
    0, 12, 3, 4, 1
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
INSERT INTO standard_makers (standard_id, maker_id) VALUES (0501, 27);
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
    20, 90, 95, 110,
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
    4, 16, '2', 3
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
    15, 95, 95, 90,
    4, 16, '2', 3
);

--- Standard: Adaptive Multi-Rate (AMR) ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (0608, 3, 1999);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (0608, 'AMR', 1);
INSERT INTO standard_makers (standard_id, maker_id) VALUES (0608, 32);
--- Profile: AMR Narrowband ---
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, encoding_speed, decoding_speed, file_size_lossy,
    latency_level_id, audio_bit_depth, max_audio_channels, relevance
) VALUES (
    0608, 'Narrowband (AMR-NB)', 6, 'The standard speech codec for 2G/3G mobile networks. Optimized for voice intelligibility at extremely low bitrates.',
    80, 300, 300, 15,
    1, 16, '1', 3
);
--- Profile: AMR Wideband ---
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, encoding_speed, decoding_speed, file_size_lossy,
    latency_level_id, audio_bit_depth, max_audio_channels, relevance
) VALUES (
    0608, 'Wideband (AMR-WB)', 6, 'The "HD Voice" codec used in modern mobile networks (VoLTE). Offers significantly better speech quality than AMR-NB.',
    75, 250, 250, 25,
    1, 16, '1', 3
);

--- Standard: Speex ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (0609, 2, 2002);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (0609, 'Speex', 1);
INSERT INTO standard_makers (standard_id, maker_id) VALUES (0609, 4);
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, encoding_speed, decoding_speed, file_size_lossy,
    latency_level_id, audio_bit_depth, max_audio_channels, relevance
) VALUES (
    0609, 'Default', 6, 'The predecessor to Opus from the Xiph.Org Foundation. Was the standard open-source speech codec for VoIP for many years.',
    40, 200, 200, 20,
    1, 16, '1', 3
);

--- Standard: SILK ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (0610, 2, 2009);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (0610, 'SILK', 1);
INSERT INTO standard_makers (standard_id, maker_id) VALUES (0610, 37);
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, encoding_speed, decoding_speed, file_size_lossy,
    latency_level_id, audio_bit_depth, max_audio_channels, relevance
) VALUES (
    0610, 'Default', 6, 'The speech codec developed for Skype, designed for voice clarity on unstable networks. Later merged with CELT to create Opus.',
    40, 300, 300, 10,
    1, 16, '1', 3
);

--- Standard: ADPCM ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (0611, 1, 1992);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (0611, 'ADPCM', 1), (0611, 'IMA ADPCM', 0);
INSERT INTO standard_makers (standard_id, maker_id) VALUES (0611, 38);
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, encoding_speed, decoding_speed, file_size_lossy,
    latency_level_id, audio_bit_depth, max_audio_channels, relevance
) VALUES (
    0611, 'Default', 6, 'A simple, very fast form of lossy compression. Widely used in 90s/2000s game consoles and as a compressed format within .wav files.',
    50, 400, 400, 110,
    1, 16, '2', 3
);

-- -----------------------------------------------------------------------------
-- Category: Audio // Lossless (ID: 7)
-- -----------------------------------------------------------------------------

--- Standard: Uncompressed PCM ---
INSERT INTO standards (standard_id, release_year) VALUES (0705, 1952);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (0705, 'Uncompressed PCM', 1), (0705, 'LPCM', 0), (0705, 'PCM', 0);
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, encoding_speed, decoding_speed, file_size_lossless, audio_bit_depth, max_audio_channels, latency_level_id, relevance
) VALUES (
    0705, 'Default', 7, 'The raw, uncompressed representation of digital audio. Commonly stored in WAV or AIFF containers.',
    99, 1000, 1000, 100, 32, '65536', 4, 1
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
    has_alpha_channel, color_model_id, relevance
) VALUES (
    0806, 'Default', 8, 'An XML-based vector format. Performance and file size are not directly comparable to raster formats.',
    98,
    1, 8, 2
);

--- Standard: TIFF ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (0807, 8, 1986);
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
INSERT INTO standards (standard_id, license_id, release_year) VALUES (0808, 8, 2004);
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
INSERT INTO standards (standard_id, license_id, release_year) VALUES (0809, 8, 1990);
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
    15, 40, 50, 75, 80,
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

--- Standard: DTS Express ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (1104, 6, 2006);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (1104, 'DTS Express', 1), (1104, 'DTSE', 0);
INSERT INTO standard_makers (standard_id, maker_id) VALUES (1104, 7);
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, encoding_speed, decoding_speed, file_size_lossy,
    latency_level_id, audio_bit_depth, max_audio_channels, relevance
) VALUES (
    1104, 'Default', 11, 'A low-bitrate DTS codec used for secondary audio (e.g., commentaries, menus) on Blu-ray discs.',
    70, 110, 100, 70,
    4, 16, '5.1', 2
);

--- Standard: AC-4 ---
INSERT INTO standards (standard_id, license_id, release_year) VALUES (1106, 6, 2014);
INSERT INTO format_aliases (standard_id, name, is_primary) VALUES (1106, 'AC-4', 1);
INSERT INTO standard_makers (standard_id, maker_id) VALUES (1106, 6);
INSERT INTO profiles (
    standard_id, profile_name, category_id, notes,
    ecosystem_support, encoding_speed, decoding_speed, file_size_lossy,
    latency_level_id, audio_bit_depth, max_audio_channels, relevance
) VALUES (
    1106, 'Default', 11, 'Dolby''s next-generation audio codec for broadcast and streaming, designed for efficiency and immersive audio features.',
    40, 60, 70, 65,
    4, 24, '7.1.4', 2
);

--- !!!!!!!!!!!! WARNING: STILL INCOMPLETE, SHOULD NOT BE USED IN FINAL TABLE YET !!!!!!!!!!!! ---
INSERT INTO container_codec_support (container_id, codec_id, support_level_id) VALUES
    -- MP4 (0100)
    (0100, 0200, 1), -- H.264
    (0100, 0201, 1), -- H.265
    (0100, 0203, 1), -- AV1
    (0100, 0206, 1), -- MPEG-2
    (0100, 0211, 1), -- DivX (MPEG-4 Part 2)
    (0100, 0212, 1), -- Xvid (MPEG-4 Part 2)
    (0100, 0209, 1), -- MPEG-1
    (0100, 0210, 1), -- VC-1
    (0100, 0303, 1), -- MJPEG
    (0100, 0602, 1), -- AAC
    (0100, 0702, 1), -- ALAC
    (0100, 0701, 1), -- FLAC
    (0100, 0600, 1), -- Opus
    (0100, 1100, 1), -- Dolby Digital
    (0100, 1101, 1), -- Dolby TrueHD
    (0100, 1102, 1), -- DTS
    (0100, 1103, 1), -- DTS-HD MA
    (0100, 1106, 1), -- AC-4
    (0100, 0601, 1), -- MP3
    (0100, 0502, 1), -- WebVTT
    (0100, 0202, 3), -- VP9
    (0100, 0207, 3), -- VP8
    (0100, 0603, 3), -- Vorbis

    -- MKV (0101)
    (0101, 0200, 2), -- H.264
    (0101, 0201, 2), -- H.265
    (0101, 0202, 2), -- VP9
    (0101, 0203, 2), -- AV1
    (0101, 0207, 2), -- VP8
    (0101, 0208, 2), -- Theora
    (0101, 0206, 2), -- MPEG-2
    (0101, 0209, 2), -- MPEG-1
    (0101, 0210, 2), -- VC-1
    (0101, 0211, 2), -- DivX
    (0101, 0212, 2), -- Xvid
    (0101, 0213, 3), -- RealVideo
    (0101, 0300, 2), -- ProRes
    (0101, 0301, 2), -- DNxHR
    (0101, 0401, 2), -- FFV1
    (0101, 0600, 2), -- Opus
    (0101, 0603, 2), -- Vorbis
    (0101, 0701, 2), -- FLAC
    (0101, 0601, 2), -- MP3
    (0101, 0602, 2), -- AAC
    (0101, 0702, 2), -- ALAC
    (0101, 0705, 2), -- PCM
    (0101, 1100, 2), -- Dolby Digital
    (0101, 1101, 2), -- Dolby TrueHD
    (0101, 1102, 2), -- DTS
    (0101, 1103, 2), -- DTS-HD MA
    (0101, 0606, 2), -- WMA
    (0101, 0500, 2), -- SRT
    (0101, 0501, 2), -- ASS
    (0101, 0503, 2), -- VobSub
    (0101, 0504, 2), -- PGS
    (0101, 0502, 2), -- WebVTT

    -- WebM (0102)
    (0102, 0207, 1), -- VP8
    (0102, 0202, 1), -- VP9
    (0102, 0203, 1), -- AV1
    (0102, 0603, 1), -- Vorbis
    (0102, 0600, 1), -- Opus
    (0102, 0502, 1), -- WebVTT

    -- MOV (0103)
    (0103, 0300, 1), -- ProRes
    (0103, 0301, 1), -- DNxHR
    (0103, 0302, 1), -- CineForm
    (0103, 0200, 1), -- H.264
    (0103, 0201, 1), -- H.265
    (0103, 0206, 1), -- MPEG-2
    (0103, 0218, 1), -- Cinepak
    (0103, 0303, 1), -- MJPEG
    (0103, 0705, 1), -- PCM
    (0103, 0602, 1), -- AAC
    (0103, 0702, 1), -- ALAC
    (0103, 0601, 1), -- MP3
    (0103, 0202, 3), -- VP9

    -- AVI (0104)
    (0104, 0211, 1), -- DivX
    (0104, 0212, 1), -- Xvid
    (0104, 0217, 1), -- Indeo
    (0104, 0218, 1), -- Cinepak
    (0104, 0303, 1), -- MJPEG
    (0104, 0304, 1), -- DNxHD
    (0104, 0401, 2), -- FFV1
    (0104, 0400, 1), -- Uncompressed Video
    (0104, 0601, 1), -- MP3
    (0104, 0705, 1), -- PCM
    (0104, 0611, 1), -- ADPCM
    (0104, 0606, 3), -- WMA
    (0104, 0200, 3), -- H.264

    -- Ogg (0105)
    (0105, 0208, 1), -- Theora
    (0105, 0603, 1), -- Vorbis
    (0105, 0600, 1), -- Opus
    (0105, 0701, 1), -- FLAC
    (0105, 0609, 1), -- Speex
    (0105, 0705, 1), -- PCM
    (0105, 0203, 3), -- AV1

    -- 3GP (0106)
    (0106, 0214, 1), -- H.263
    (0106, 0211, 1), -- DivX
    (0106, 0200, 1), -- H.264
    (0106, 0608, 1), -- AMR
    (0106, 0602, 1), -- AAC

    -- 3G2 (0107)
    (0107, 0214, 1), -- H.263
    (0107, 0211, 1), -- DivX
    (0107, 0200, 1), -- H.264
    (0107, 0608, 1), -- AMR
    (0107, 0602, 1), -- AAC
    (0107, 0606, 3), -- WMA

    -- IAMF (0108)
    (0108, 0602, 1), -- AAC
    (0108, 0600, 1), -- Opus
    (0108, 0701, 1), -- FLAC
    (0108, 0705, 1), -- PCM

    -- FLV (0109)
    (0109, 0215, 1), -- Sorenson Spark
    (0109, 0216, 1), -- VP6
    (0109, 0200, 1), -- H.264
    (0109, 0601, 1), -- MP3
    (0109, 0602, 1), -- AAC
    (0109, 0705, 1), -- PCM
    (0109, 0611, 1), -- ADPCM

    -- WAV (0110)
    (0110, 0705, 1), -- PCM
    (0110, 0611, 1), -- ADPCM
    (0110, 0601, 3), -- MP3
    (0110, 0606, 3), -- WMA

    -- AIFF (0111)
    (0111, 0705, 1), -- PCM
    (0111, 0705, 1); -- ADPCM

COMMIT;
