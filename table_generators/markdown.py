import sqlite3
import os

# --- Configuration ---
DB_FILE = '../codecs.db'
OUTPUT_FILE = 'output.md'
TITLE = "# Codecs Comparison - Markdown"

# ==============================================================================
# VIEW CONFIGURATION
# This dictionary controls which columns are displayed for each category and in
# what order. Simply reorder the column names to change the table layout.
# Below that is a comment with all configuration options for reference.
# ==============================================================================

VIEW_CONFIG = {
    'Container': [
        'display_name',
        'notes',
        'ecosystem_support',
        'license_name',
        'release_year',
    ],
    'Video // Delivery': [
        'display_name',
        'file_size_lossy',
        'ecosystem_support',
        'decoding_speed',
        'encoding_speed',
        'license_name',
    ],
    'Audio // Lossy': [
        'display_name',
        'file_size_lossy',
        'ecosystem_support',
        'decoding_speed',
        'license_name',
        'max_audio_channels',
        'latency',
    ],
    'Audio // Lossless': [
        'display_name',
        'file_size_lossless',
        'ecosystem_support',
        'decoding_speed',
        'license_name',
        'max_audio_channels',
        'audio_bit_depth',
    ],
    'Image': [
        'display_name',
        'file_size_lossy',
        'file_size_lossless',
        'ecosystem_support',
        'decoding_speed',
        'encoding_speed',
        'license_name',
        'has_alpha_channel',
    ],
}

""" THEORETICAL FULL VIEW_CONFIG
This commented-out block contains all possible columns for each category.
You can copy and paste from here into the active VIEW_CONFIG above to customize
the generated tables.

VIEW_CONFIG = {
    'Container': [
        'display_name',
        'notes',
        'ecosystem_support',
        'license_name',
        'release_year',
    ],
    'Video // Delivery': [
        'display_name',
        'notes',
        'file_size_lossy',
        'file_size_lossless',
        'ecosystem_support',
        'decoding_speed',
        'encoding_speed',
        'license_name',
        'release_year',
        'editing_performance',
        'has_alpha_channel',
        'color_model_name',
        'color_bit_depth',
    ],
    'Video // Intermediate': [
        'display_name',
        'notes',
        'file_size_lossless',
        'ecosystem_support',
        'decoding_speed',
        'encoding_speed',
        'license_name',
        'release_year',
        'editing_performance',
        'has_alpha_channel',
        'color_model_name',
        'color_bit_depth',
    ],
    'Video // Archival': [
        'display_name',
        'notes',
        'file_size_lossless',
        'ecosystem_support',
        'decoding_speed',
        'encoding_speed',
        'license_name',
        'release_year',
        'editing_performance',
        'has_alpha_channel',
        'color_model_name',
        'color_bit_depth',
    ],
    'Subtitle': [
        'display_name',
        'notes',
        'ecosystem_support',
        'license_name',
        'release_year',
        'subtitle_is_image',
    ],
    'Audio // Lossy': [
        'display_name',
        'notes',
        'file_size_lossy',
        'ecosystem_support',
        'decoding_speed',
        'license_name',
        'release_year',
        'max_audio_channels',
        'audio_bit_depth',
        'latency',
    ],
    'Audio // Lossless': [
        'display_name',
        'notes',
        'file_size_lossless',
        'ecosystem_support',
        'decoding_speed',
        'license_name',
        'release_year',
        'max_audio_channels',
        'audio_bit_depth',
        'latency',
    ],
    'Image': [
        'display_name',
        'notes',
        'file_size_lossy',
        'file_size_lossless',
        'ecosystem_support',
        'decoding_speed',
        'encoding_speed',
        'license_name',
        'release_year',
        'has_alpha_channel',
        'color_model_name',
        'color_bit_depth',
    ],
    'Animated Image': [
        'display_name',
        'notes',
        'file_size_lossy',
        'file_size_lossless',
        'ecosystem_support',
        'decoding_speed',
        'encoding_speed',
        'license_name',
        'release_year',
        'has_alpha_channel',
        'color_model_name',
        'color_bit_depth',
    ],
    '3D Model': [
        'display_name',
        'notes',
        'file_size_lossless',
        'ecosystem_support',
        'license_name',
        'release_year',
    ],
    'Audio // Home Theater': [
        'display_name',
        'notes',
        'file_size_lossy',
        'file_size_lossless',
        'ecosystem_support',
        'decoding_speed',
        'license_name',
        'release_year',
        'max_audio_channels',
        'audio_bit_depth',
        'latency',
    ],
}
"""

HEADER_MAPPING = {
    'display_name': 'Name',
    'notes': 'Description',
    'license_name': 'License',
    'release_year': 'Year',
    'ecosystem_support': 'Support (%)',
    'encoding_speed': 'Encode Speed (%)', 'decoding_speed': 'Decode Speed (%)',
    'has_alpha_channel': 'Alpha?', 'color_bit_depth': 'Color Depth (bits)',
    'audio_bit_depth': 'Audio Depth (bits)', 'color_model_name': 'Color Model',
    'file_size_lossy': 'Lossy Size (%)', 'file_size_lossless': 'Lossless Size (%)',
    'latency': 'Latency', 'editing_performance': 'Editing Performance',
    'max_audio_channels': 'Max Channels', 'subtitle_is_image': 'Type'
}
EMOJI_MAP = {'license_name': 'license_emoji', 'editing_performance': 'editing_performance_emoji', 'latency': 'latency_emoji'}
PERCENTAGE_COLUMNS = {'ecosystem_support': 'higher_is_better', 'encoding_speed': 'higher_is_better', 'decoding_speed': 'higher_is_better', 'file_size_lossy': 'lower_is_better', 'file_size_lossless': 'lower_is_better'}

def get_emoji_for_percentage(value, interpretation='higher_is_better'):
    if not isinstance(value, (int, float)): return ""
    if interpretation == 'higher_is_better':
        if value > 100: return "🔵 "
        if value > 80: return "🟢 "
        if value > 60: return "🟡 "
        if value > 40: return "🟠 "
        return "🔴 "
    elif interpretation == 'lower_is_better':
        if value <= 40: return "🟢 "
        if value <= 60: return "🟡 "
        if value <= 80: return "🟠 "
        if value <= 100: return "🔴 "
        return "⚫ "
    return ""

def generate_markdown_guide():
    if not os.path.exists(DB_FILE):
        print(f"Error: Database file '{DB_FILE}' not found.")
        return

    conn = sqlite3.connect(DB_FILE)
    conn.row_factory = sqlite3.Row
    cursor = conn.cursor()

    full_markdown = f"{TITLE}\n\n"

    for category_name, active_columns in VIEW_CONFIG.items():
        if not active_columns: continue

        full_markdown += f"### {category_name}\n\n"
        
        query = """
            SELECT
                s.release_year,
                (SELECT GROUP_CONCAT(name, ' / ') FROM format_aliases fa WHERE fa.standard_id = s.standard_id AND fa.is_primary = 1) AS primary_aliases,
                p.*,
                l.license_name, l.emoji AS license_emoji,
                cm.color_model_name,
                lr.level_name AS latency, lr.emoji AS latency_emoji,
                qr.rating_name AS editing_performance, qr.emoji AS editing_performance_emoji
            FROM profiles p
            JOIN standards s ON p.standard_id = s.standard_id
            JOIN categories c ON p.category_id = c.category_id
            LEFT JOIN licenses l ON s.license_id = l.license_id
            LEFT JOIN qualitative_ratings qr ON p.editing_performance_id = qr.rating_id
            LEFT JOIN level_ratings lr ON p.latency_level_id = lr.level_id
            LEFT JOIN color_models cm ON p.color_model_id = cm.color_model_id
            WHERE c.category_name = ?
            ORDER BY s.standard_id, p.profile_id
        """
        
        cursor.execute(query, (category_name,))
        rows = [dict(row) for row in cursor.fetchall()]
        
        if not rows:
            full_markdown += "_No data available for this category._\n\n"
            continue

        for row in rows:
            display_name = row['primary_aliases']
            profile_name = row['profile_name']
            if profile_name and profile_name.lower() != 'default':
                display_name += f" ({profile_name})"
            row['display_name'] = display_name

        headers = [HEADER_MAPPING.get(col, col) for col in active_columns]
        
        full_markdown += "| " + " | ".join(headers) + " |\n"
        full_markdown += "|:---" * len(headers) + "|\n"
        
        for row in rows:
            row_data = []
            for col_name in active_columns:
                cell_value = row.get(col_name)
                emoji_prefix = ""
                if col_name in EMOJI_MAP:
                    emoji_col_name = EMOJI_MAP[col_name]
                    if row.get(emoji_col_name):
                        emoji_prefix = f"{row[emoji_col_name]} "
                elif col_name in PERCENTAGE_COLUMNS:
                    interpretation = PERCENTAGE_COLUMNS[col_name]
                    emoji_prefix = get_emoji_for_percentage(cell_value, interpretation)
                
                if col_name == 'has_alpha_channel' or col_name == 'subtitle_is_image':
                    if col_name == 'subtitle_is_image' and cell_value == 1: cell_value = 'Image'
                    elif col_name == 'subtitle_is_image' and cell_value == 0: cell_value = 'Text'
                    else: cell_value = 'Yes' if cell_value == 1 else ('No' if cell_value == 0 else 'N/A')

                processed_cell = str(cell_value) if cell_value is not None else 'N/A'
                row_data.append(f"{emoji_prefix}{processed_cell}")
            
            full_markdown += "| " + " | ".join(row_data) + " |\n"
        
        full_markdown += "\n"

    conn.close()
    
    try:
        with open(OUTPUT_FILE, 'w', encoding='utf-8') as f:
            f.write(full_markdown)
        print(f"Success! Guide has been written to '{OUTPUT_FILE}'.")
    except Exception as e:
        print(f"Error writing to file: {e}")

if __name__ == "__main__":
    generate_markdown_guide()