import sqlite3
import os
import argparse

# --- Configuration ---
DB_FILE = '../codecs.db'
MD_OUTPUT_FILE = 'output.md'
HTML_OUTPUT_FILE = 'output.html'

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

HEADER_MAPPING = { 'display_name': 'Name', 'notes': 'Description', 'license_name': 'License', 'release_year': 'Year', 'ecosystem_support': 'Support (%)', 'encoding_speed': 'Encode Speed (%)', 'decoding_speed': 'Decode Speed (%)', 'has_alpha_channel': 'Alpha?', 'color_bit_depth': 'Color Depth (bits)', 'audio_bit_depth': 'Audio Depth (bits)', 'color_model_name': 'Color Model', 'file_size_lossy': 'Lossy Size (%)', 'file_size_lossless': 'Lossless Size (%)', 'latency': 'Latency', 'editing_performance': 'Editing Performance', 'max_audio_channels': 'Max Channels', 'subtitle_is_image': 'Type' }
EMOJI_MAP = {'license_name': 'license_emoji', 'editing_performance': 'editing_performance_emoji', 'latency': 'latency_emoji'}
PERCENTAGE_COLUMNS = {'ecosystem_support': 'higher_is_better', 'encoding_speed': 'higher_is_better', 'decoding_speed': 'higher_is_better', 'file_size_lossy': 'lower_is_better', 'file_size_lossless': 'lower_is_better'}

def get_emoji_for_percentage(value, interpretation='higher_is_better'):
    if not isinstance(value, (int, float)): return ""
    if interpretation == 'higher_is_better':
        if value > 100: return "🔵 ";
        if value > 80: return "🟢 ";
        if value > 60: return "🟡 ";
        if value > 40: return "🟠 ";
        return "🔴 "
    elif interpretation == 'lower_is_better':
        if value <= 40: return "🟢 ";
        if value <= 60: return "🟡 ";
        if value <= 80: return "🟠 ";
        if value <= 100: return "🔴 ";
        return "⚫ "
    return ""

# ==============================================================================
# DATA FETCHING
# ==============================================================================

def get_data_for_categories():
    """Connects to the DB, fetches and processes all data, and returns it."""
    if not os.path.exists(DB_FILE):
        raise FileNotFoundError(f"Error: Database file '{DB_FILE}' not found.")

    conn = sqlite3.connect(DB_FILE)
    conn.row_factory = sqlite3.Row
    cursor = conn.cursor()
    processed_data = {}

    for category_name, active_columns in VIEW_CONFIG.items():
        if not active_columns: continue
        
        query = """
            SELECT s.release_year, (SELECT GROUP_CONCAT(name, ' / ') FROM format_aliases fa WHERE fa.standard_id = s.standard_id AND fa.is_primary = 1) AS primary_aliases, p.*, l.license_name, l.emoji AS license_emoji, cm.color_model_name, lr.level_name AS latency, lr.emoji AS latency_emoji, qr.rating_name AS editing_performance, qr.emoji AS editing_performance_emoji
            FROM profiles p JOIN standards s ON p.standard_id = s.standard_id JOIN categories c ON p.category_id = c.category_id LEFT JOIN licenses l ON s.license_id = l.license_id LEFT JOIN qualitative_ratings qr ON p.editing_performance_id = qr.rating_id LEFT JOIN level_ratings lr ON p.latency_level_id = lr.level_id LEFT JOIN color_models cm ON p.color_model_id = cm.color_model_id
            WHERE c.category_name = ? ORDER BY s.standard_id, p.profile_id
        """
        
        cursor.execute(query, (category_name,))
        rows = [dict(row) for row in cursor.fetchall()]
        
        for row in rows:
            display_name = row['primary_aliases']
            profile_name = row['profile_name']
            if profile_name and profile_name.lower() != 'default':
                display_name += f" ({profile_name})"
            row['display_name'] = display_name
        
        processed_data[category_name] = rows
    
    conn.close()
    return processed_data

# ==============================================================================
# RENDERING
# ==============================================================================

def render_as_markdown(all_data, use_tooltips=False):
    """Takes the processed data and returns a single Markdown string."""
    full_markdown = ""
    for category_name, rows in all_data.items():
        active_columns = VIEW_CONFIG[category_name]
        full_markdown += f"### {category_name}\n\n"
        if not rows:
            full_markdown += "_No data available for this category._\n\n"
            continue

        headers = [HEADER_MAPPING.get(col, col) for col in active_columns]
        full_markdown += "| " + " | ".join(headers) + " |\n"
        full_markdown += "|:---" * len(headers) + "|\n"
        
        for row in rows:
            row_data = []
            for col_name in active_columns:
                cell_value = row.get(col_name)
                emoji_prefix = ""
                if col_name in EMOJI_MAP and row.get(EMOJI_MAP[col_name]): emoji_prefix = f"{row[EMOJI_MAP[col_name]]} "
                elif col_name in PERCENTAGE_COLUMNS: emoji_prefix = get_emoji_for_percentage(cell_value, PERCENTAGE_COLUMNS[col_name])
                
                if col_name == 'has_alpha_channel' or col_name == 'subtitle_is_image':
                    if col_name == 'subtitle_is_image': cell_value = 'Image' if cell_value == 1 else 'Text'
                    else: cell_value = 'Yes' if cell_value == 1 else ('No' if cell_value == 0 else 'N/A')

                processed_cell = str(cell_value) if cell_value is not None else 'N/A'

                if col_name == 'display_name' and use_tooltips and 'notes' not in active_columns and row.get('notes'):
                    safe_notes = row['notes'].replace('"', '&quot;')
                    processed_cell = f'<abbr title="{safe_notes}">{processed_cell}</abbr>'
                
                row_data.append(f"{emoji_prefix}{processed_cell}")
            full_markdown += "| " + " | ".join(row_data) + " |\n"
        full_markdown += "\n"
    return full_markdown

def render_as_html(all_data):
    """Takes the processed data and returns a single HTML string."""
    html_parts = ["""<!DOCTYPE html><html lang="en"><head><meta charset="UTF-8"><title>Codec Comparison Guide</title><style>body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif; line-height: 1.6; padding: 2em; color: #333; } h1, h3 { color: #111; } table { border-collapse: collapse; width: 100%; margin-bottom: 2em; box-shadow: 0 2px 3px rgba(0,0,0,0.1); } th, td { border: 1px solid #ddd; padding: 10px 12px; text-align: left; vertical-align: top; } thead { background-color: #f2f2f2; font-weight: bold; } tbody tr:nth-child(even) { background-color: #f9f9f9; } abbr { text-decoration: underline dotted; cursor: help; }</style></head><body><h1>Codec Comparison Guide</h1>"""]

    for category_name, rows in all_data.items():
        active_columns = VIEW_CONFIG[category_name]
        html_parts.append(f"<h3>{category_name}</h3>")
        if not rows:
            html_parts.append("<p><em>No data available for this category.</em></p>")
            continue

        html_parts.append("<table><thead><tr>")
        for header in [HEADER_MAPPING.get(col, col) for col in active_columns]:
            html_parts.append(f"<th>{header}</th>")
        html_parts.append("</tr></thead><tbody>")

        for row in rows:
            html_parts.append("<tr>")
            for col_name in active_columns:
                cell_value = row.get(col_name)
                emoji_prefix = ""
                if col_name in EMOJI_MAP and row.get(EMOJI_MAP[col_name]): emoji_prefix = f"{row[EMOJI_MAP[col_name]]} "
                elif col_name in PERCENTAGE_COLUMNS: emoji_prefix = get_emoji_for_percentage(cell_value, PERCENTAGE_COLUMNS[col_name])
                
                if col_name == 'has_alpha_channel' or col_name == 'subtitle_is_image':
                    if col_name == 'subtitle_is_image': cell_value = 'Image' if cell_value == 1 else 'Text'
                    else: cell_value = 'Yes' if cell_value == 1 else ('No' if cell_value == 0 else 'N/A')
                
                processed_cell = str(cell_value) if cell_value is not None else 'N/A'
                if col_name == 'display_name' and 'notes' not in active_columns and row.get('notes'):
                    safe_notes = row['notes'].replace('"', '&quot;')
                    processed_cell = f'<abbr title="{safe_notes}">{processed_cell}</abbr>'
                html_parts.append(f"<td>{emoji_prefix}{processed_cell}</td>")
            html_parts.append("</tr>")
        html_parts.append("</tbody></table>")
    
    html_parts.append("</body></html>")
    return "\n".join(html_parts)

# ==============================================================================
# EXECUTION
# ==============================================================================

if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description="Generates comparison tables for codecs in various formats.",
        formatter_class=argparse.RawTextHelpFormatter
    )
    parser.add_argument(
        '-f', '--format',
        choices=['simple-md', 'github-md', 'html'],
        default='github-md',
        help="The output format to generate:\n"
             "  simple-md: Plain Markdown without HTML tooltips.\n"
             "  github-md: Markdown with HTML tooltips for GitHub (default).\n"
             "  html:      A full, standalone HTML page."
    )
    args = parser.parse_args()

    try:
        all_category_data = get_data_for_categories()

        if args.format == 'simple-md':
            print("Generating simple Markdown file...")
            output = render_as_markdown(all_category_data, use_tooltips=False)
            with open(MD_OUTPUT_FILE, 'w', encoding='utf-8') as f:
                f.write(output)
            print(f"Success! Markdown guide has been written to '{MD_OUTPUT_FILE}'.")

        elif args.format == 'github-md':
            print("Generating GitHub-flavored Markdown file with tooltips...")
            output = render_as_markdown(all_category_data, use_tooltips=True)
            with open(MD_OUTPUT_FILE, 'w', encoding='utf-8') as f:
                f.write(output)
            print(f"Success! Markdown guide has been written to '{MD_OUTPUT_FILE}'.")
            
        elif args.format == 'html':
            print("Generating HTML file...")
            output = render_as_html(all_category_data)
            with open(HTML_OUTPUT_FILE, 'w', encoding='utf-8') as f:
                f.write(output)
            print(f"Success! HTML guide has been written to '{HTML_OUTPUT_FILE}'.")

    except Exception as e:
        print(f"An error occurred: {e}")