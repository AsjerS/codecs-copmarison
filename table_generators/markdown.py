import sqlite3
import os

# --- Configuration ---
DB_FILE = '../codecs.db'
OUTPUT_FILE = 'output.md'
TITLE = "# Codecs Comparison - Markdown"

# ==============================================================================
# VIEW CONFIGURATION
# For each category, define the list of columns you want to display, in order.
# An empty list [] or a missing category will hide that table from the output.
# ==============================================================================

VIEW_CONFIG = {
    'Container': [
        'display_name', 'notes', 'license_name', 'ecosystem_support'
    ],
    'Video // Delivery': [
        'display_name', 'license_name', 'ecosystem_support', 'encoding_speed', 'decoding_speed', 'file_size_lossy',
    ],
    'Subtitle': [
        'display_name', 'notes', 'subtitle_is_image', 'license_name', 'ecosystem_support'
    ],
    'Audio // Lossy': [
        'display_name', 'license_name', 'ecosystem_support', 'decoding_speed', 'latency', 'file_size_lossy', 'max_audio_channels'
    ],
    'Audio // Lossless': [
        'display_name', 'license_name', 'ecosystem_support', 'decoding_speed', 'file_size_lossless', 'audio_bit_depth', 'max_audio_channels'
    ],
    'Image': [
        'display_name', 'license_name', 'ecosystem_support', 'encoding_speed', 'decoding_speed', 'has_alpha_channel', 'file_size_lossy', 'file_size_lossless'
    ],
    'Animated Image': [
        'display_name', 'license_name', 'ecosystem_support', 'decoding_speed', 'color_bit_depth', 'file_size_lossy', 'file_size_lossless'
    ],
    '3D Model': [
        'display_name', 'notes', 'license_name', 'release_year', 'ecosystem_support'
    ]
}

""" FULL CONFIG TEMPLATE
VIEW_CONFIG = {
    'Container': [
        'display_name', 'notes', 'license_name', 'release_year', 'ecosystem_support'
    ],
    'Video // Delivery': [
        'display_name', 'notes', 'license_name', 'release_year', 'ecosystem_support',
        'encoding_speed', 'decoding_speed', 'has_alpha_channel', 'color_bit_depth',
        'chroma_name', 'file_size_lossy', 'file_size_lossless', 'editing_performance'
    ],
    'Video // Intermediate': [
        'display_name', 'notes', 'license_name', 'release_year', 'ecosystem_support',
        'editing_performance', 'has_alpha_channel', 'color_bit_depth', 'chroma_name',
        'file_size_lossless'
    ],
    'Video // Archival': [
        'display_name', 'notes', 'license_name', 'editing_performance', 'has_alpha_channel',
        'color_bit_depth', 'chroma_name', 'file_size_lossless'
    ],
    'Subtitle': [
        'display_name', 'notes', 'subtitle_is_image', 'license_name', 'release_year',
        'ecosystem_support'
    ],
    'Audio // Lossy': [
        'display_name', 'notes', 'license_name', 'release_year', 'ecosystem_support',
        'decoding_speed', 'latency', 'file_size_lossy', 'audio_bit_depth', 'max_audio_channels'
    ],
    'Audio // Lossless': [
        'display_name', 'notes', 'license_name', 'release_year', 'ecosystem_support',
        'decoding_speed', 'file_size_lossless', 'audio_bit_depth', 'max_audio_channels'
    ],
    'Image': [
        'display_name', 'notes', 'license_name', 'release_year', 'ecosystem_support',
        'encoding_speed', 'decoding_speed', 'has_alpha_channel', 'color_bit_depth',
        'file_size_lossy', 'file_size_lossless', 'chroma_subsampling_id'
    ],
    'Animated Image': [
        'display_name', 'notes', 'license_name', 'release_year', 'ecosystem_support',
        'decoding_speed', 'has_alpha_channel', 'color_bit_depth', 'file_size_lossy',
        'file_size_lossless'
    ],
    '3D Model': [
        'display_name', 'notes', 'license_name', 'release_year', 'ecosystem_support'
    ]
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
    'audio_bit_depth': 'Audio Depth (bits)', 'chroma_name': 'Chroma',
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

    full_markdown = f"{TITLE}"

    # Iterate through the categories defined in the config to control table order
    for category_name, active_columns in VIEW_CONFIG.items():
        if not active_columns: continue # Skip if the column list is empty

        full_markdown += f"## {category_name}\n\n"
        
        query = """
            SELECT
                s.release_year,
                (SELECT GROUP_CONCAT(name, ' / ') FROM format_aliases fa WHERE fa.standard_id = s.standard_id AND fa.is_primary = 1) AS primary_aliases,
                p.*,
                l.license_name, l.emoji AS license_emoji,
                cs.chroma_name,
                lr.level_name AS latency, lr.emoji AS latency_emoji,
                qr.rating_name AS editing_performance, qr.emoji AS editing_performance_emoji
            FROM profiles p
            JOIN standards s ON p.standard_id = s.standard_id
            JOIN categories c ON p.category_id = c.category_id
            LEFT JOIN licenses l ON s.license_id = l.license_id
            LEFT JOIN qualitative_ratings qr ON p.editing_performance_id = qr.rating_id
            LEFT JOIN level_ratings lr ON p.latency_level_id = lr.level_id
            LEFT JOIN chroma_subsampling cs ON p.chroma_subsampling_id = cs.chroma_id
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

            for key in ['latency', 'editing_performance']:
                if row.get(key) and '(' in row[key]:
                    row[key] = row[key].split(' (')[0]

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