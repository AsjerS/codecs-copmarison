import sqlite3
import os
import argparse
import csv
import io

# --- Configuration ---
DB_FILE = 'codecs.db'
MD_OUTPUT_FILE = 'output.md'
HTML_OUTPUT_FILE = 'output.html'
CSV_OUTPUT_DIR = 'output'

# ==============================================================================
# VIEW CONFIGURATION
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

VIEW_CONFIG_FULL = {
    "Container": [
        "display_name",
        "maker_names",
        "notes",
        "ecosystem_support",
        "license_name",
        "release_year",
    ],
    "Video // Delivery": [
        "display_name",
        "maker_names",
        "notes",
        "file_size_lossy",
        "ecosystem_support",
        "decoding_speed",
        "encoding_speed",
        "license_name",
        "release_year",
        "editing_performance",
        "has_alpha_channel",
        "color_model_name",
        "color_bit_depth",
    ],
    "Video // Intermediate": [
        "display_name",
        "maker_names",
        "notes",
        "file_size_lossy",
        "ecosystem_support",
        "license_name",
        "release_year",
        "editing_performance",
        "has_alpha_channel",
        "color_model_name",
        "color_bit_depth",
    ],
    "Video // Archival": [
        "display_name",
        "maker_names",
        "notes",
        "file_size_lossless",
        "ecosystem_support",
        "decoding_speed",
        "encoding_speed",
        "license_name",
        "release_year",
        "editing_performance",
        "has_alpha_channel",
        "color_model_name",
        "color_bit_depth",
    ],
    "Subtitle": [
        "display_name",
        "maker_names",
        "notes",
        "ecosystem_support",
        "license_name",
        "release_year",
        "subtitle_is_image",
    ],
    "Audio // Lossy": [
        "display_name",
        "maker_names",
        "notes",
        "file_size_lossy",
        "ecosystem_support",
        "decoding_speed",
        "encoding_speed",
        "license_name",
        "release_year",
        "max_audio_channels",
        "audio_bit_depth",
        "latency",
    ],
    "Audio // Lossless": [
        "display_name",
        "maker_names",
        "notes",
        "file_size_lossless",
        "ecosystem_support",
        "decoding_speed",
        "encoding_speed",
        "license_name",
        "release_year",
        "max_audio_channels",
        "audio_bit_depth",
        "latency",
    ],
    "Image": [
        "display_name",
        "maker_names",
        "notes",
        "file_size_lossy",
        "file_size_lossless",
        "ecosystem_support",
        "decoding_speed",
        "encoding_speed",
        "license_name",
        "release_year",
        "has_alpha_channel",
        "color_model_name",
        "color_bit_depth",
    ],
    "Animated Image": [
        "display_name",
        "maker_names",
        "notes",
        "file_size_lossy",
        "file_size_lossless",
        "ecosystem_support",
        "decoding_speed",
        "license_name",
        "release_year",
        "has_alpha_channel",
        "color_model_name",
        "color_bit_depth",
    ],
    "3D Model": [
        "display_name",
        "maker_names",
        "notes",
        "file_size_lossless",
        "ecosystem_support",
        "license_name",
        "release_year",
    ],
    "Audio // Home Theater": [
        "display_name",
        "maker_names",
        "notes",
        "file_size_lossy",
        "file_size_lossless",
        "ecosystem_support",
        "decoding_speed",
        "encoding_speed",
        "license_name",
        "release_year",
        "max_audio_channels",
        "audio_bit_depth",
        "latency",
    ],
}

HEADER_MAPPING = {
    "display_name": "Name",
    "maker_names": "Maker(s)",
    "notes": "Description",
    "license_name": "License",
    "release_year": "Year",
    "ecosystem_support": "Support (%)",
    "encoding_speed": "Encode Speed (%)",
    "decoding_speed": "Decode Speed (%)",
    "has_alpha_channel": "Alpha?",
    "color_bit_depth": "Color Depth (bits)",
    "audio_bit_depth": "Audio Depth (bits)",
    "color_model_name": "Color Model",
    "file_size_lossy": "Lossy Size (%)",
    "file_size_lossless": "Lossless Size (%)",
    "latency": "Latency",
    "editing_performance": "Editing Performance",
    "max_audio_channels": "Max Channels",
    "subtitle_is_image": "Type",
    "supported_combined": "Supported Codecs",
    "supported_combined_tagged": "Supported Codecs",
    "supported_official": "Official Codecs",
    "supported_common": "Common Codecs",
    "supported_nonstandard": "Non-Standard Codecs",
}
EMOJI_MAP = {
    "license_name": "license_emoji",
    "editing_performance": "editing_performance_emoji",
    "latency": "latency_emoji",
}
COLOR_MAP = {
    "license_name": "license_hex",
    "editing_performance": "editing_performance_hex",
    "latency": "latency_hex",
}
PERCENTAGE_COLUMNS = {
    "ecosystem_support": "higher_is_better",
    "encoding_speed": "higher_is_better",
    "decoding_speed": "higher_is_better",
    "file_size_lossy": "lower_is_better",
    "file_size_lossless": "lower_is_better",
}

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

def get_color_for_percentage(value, interpretation='higher_is_better'):
    if not isinstance(value, (int, float)): return None
    RED = (248, 105, 107); YELLOW = (255, 235, 132); GREEN = (99, 190, 123)
    if interpretation == 'higher_is_better':
        if value > 100: return "#63a0be"
        value_norm = value / 100.0
    else:
        if value > 100: return "#666666"
        value_norm = (100.0 - max(0, value)) / 100.0
    value_norm = min(1.0, max(0.0, value_norm))
    if value_norm <= 0.5:
        start_color, end_color = RED, YELLOW
        t = value_norm * 2
    else:
        start_color, end_color = YELLOW, GREEN
        t = (value_norm - 0.5) * 2
    r = int(start_color[0] * (1 - t) + end_color[0] * t)
    g = int(start_color[1] * (1 - t) + end_color[1] * t)
    b = int(start_color[2] * (1 - t) + end_color[2] * t)
    return f'#{r:02x}{g:02x}{b:02x}'

def get_text_color_for_bg(hex_color):
    if not hex_color or len(hex_color) < 7: return "#000000"
    try:
        hex_color = hex_color.lstrip('#')
        rgb = tuple(int(hex_color[i:i+2], 16) for i in (0, 2, 4))
        brightness = (rgb[0] * 299 + rgb[1] * 587 + rgb[2] * 114) / 1000
        return "#FFFFFF" if brightness < 128 else "#000000"
    except (ValueError, IndexError): return "#000000"

# ==============================================================================
# DATA FETCHING
# ==============================================================================

def get_data_for_categories(view_config, relevance_threshold=3, show_all_aliases=False, container_mode='combined', container_threshold=2):
    if not os.path.exists(DB_FILE): raise FileNotFoundError(f"Error: Database file '{DB_FILE}' not found.")
    conn = sqlite3.connect(DB_FILE)
    conn.row_factory = sqlite3.Row
    cursor = conn.cursor()
    processed_data = {}

    alias_subquery = "(SELECT GROUP_CONCAT(name, ' / ') FROM format_aliases fa WHERE fa.standard_id = s.standard_id ORDER BY fa.is_primary DESC)" if show_all_aliases else "(SELECT GROUP_CONCAT(name, ' / ') FROM format_aliases fa WHERE fa.standard_id = s.standard_id AND fa.is_primary = 1)"
    maker_subquery = "(SELECT GROUP_CONCAT(m.maker_name, ', ') FROM standard_makers sm JOIN makers m ON sm.maker_id = m.maker_id WHERE sm.standard_id = s.standard_id)"

    def get_supported_codecs(container_id):
        cursor.execute("""
            SELECT DISTINCT fa.name, ccs.support_level_id, ccs.codec_id
            FROM container_codec_support ccs
            JOIN format_aliases fa ON ccs.codec_id = fa.standard_id
            JOIN profiles p ON ccs.codec_id = p.standard_id
            WHERE ccs.container_id = ? 
              AND fa.is_primary = 1 
              AND ccs.support_level_id <= ?
              AND p.relevance <= ?
            ORDER BY ccs.support_level_id, ccs.codec_id
        """, (container_id, container_threshold, relevance_threshold))
        return cursor.fetchall()

    for category_name, active_columns in view_config.items():
        if not active_columns: continue

        query = f"""
            SELECT s.release_year, {alias_subquery} AS display_aliases, {maker_subquery} as maker_names, p.*, 
                   l.license_name, l.emoji AS license_emoji, l.hex_colour AS license_hex,
                   cm.color_model_name, 
                   lr.level_name AS latency, lr.emoji AS latency_emoji, lr.hex_colour AS latency_hex,
                   qr.rating_name AS editing_performance, qr.emoji AS editing_performance_emoji, qr.hex_colour AS editing_performance_hex
            FROM profiles p JOIN standards s ON p.standard_id = s.standard_id JOIN categories c ON p.category_id = c.category_id 
            LEFT JOIN licenses l ON s.license_id = l.license_id 
            LEFT JOIN qualitative_ratings qr ON p.editing_performance_id = qr.rating_id 
            LEFT JOIN level_ratings lr ON p.latency_level_id = lr.level_id 
            LEFT JOIN color_models cm ON p.color_model_id = cm.color_model_id
            WHERE c.category_name = ? AND p.relevance <= ? ORDER BY s.standard_id, p.profile_id
        """

        cursor.execute(query, (category_name, relevance_threshold))
        rows = [dict(row) for row in cursor.fetchall()]
        if not rows: continue

        for row in rows:
            display_name = row['display_aliases']
            profile_name = row['profile_name']
            if profile_name and profile_name.lower() != 'default': display_name += f" ({profile_name})"
            row['display_name'] = display_name

            if category_name == 'Container' and container_mode != 'off':
                supported = get_supported_codecs(row['standard_id'])
                levels = {1: [], 2: [], 3: []}
                all_flat = []
                for name, level, _ in supported:
                    levels[level].append(name)
                    all_flat.append(name)

                row['supported_official'] = ", ".join(levels[1])
                row['supported_common'] = ", ".join(levels[2])
                row['supported_nonstandard'] = ", ".join(levels[3])
                row['supported_combined'] = ", ".join(all_flat)
                tagged_parts = []
                if levels[1]: tagged_parts.append(f"**Official:** {', '.join(levels[1])}")
                if levels[2]: tagged_parts.append(f"**Common:** {', '.join(levels[2])}")
                if levels[3]: tagged_parts.append(f"**Non-Std:** {', '.join(levels[3])}")
                row['supported_combined_tagged'] = "<br>".join(tagged_parts)

        processed_data[category_name] = rows

    conn.close()
    return processed_data

# ==============================================================================
# RENDERING
# ==============================================================================

def inject_container_columns(category_name, active_columns, container_mode, container_threshold):
    """Helper to modify column list for Container table"""
    if category_name == 'Container':
        if container_mode == 'combined':
            active_columns.append('supported_combined')
        elif container_mode == 'combined-tagged':
            active_columns.append('supported_combined_tagged')
        elif container_mode == 'split':
            if container_threshold >= 1: active_columns.append('supported_official')
            if container_threshold >= 2: active_columns.append('supported_common')
            if container_threshold >= 3: active_columns.append('supported_nonstandard')

def render_as_markdown(all_data, view_config, tooltip_style=None):
    full_markdown = ""
    for category_name, rows in all_data.items():
        active_columns = list(view_config.get(category_name, []))
        if not active_columns: continue

        inject_container_columns(category_name, active_columns, container_mode, container_threshold)

        full_markdown += f"### {category_name}\n\n"
        if not rows: full_markdown += "_No data available for this category._\n\n"; continue
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
                if col_name == 'display_name' and tooltip_style and 'notes' not in active_columns and row.get('notes'):
                    safe_notes = row['notes'].replace('"', '&quot;')
                    if tooltip_style == 'html': processed_cell = f'<span title="{safe_notes}">{processed_cell}</span>'
                row_data.append(f"{emoji_prefix}{processed_cell}")
            full_markdown += "| " + " | ".join(row_data) + " |\n"
        full_markdown += "\n"
    return full_markdown

def render_as_html(all_data, view_config, use_colors=False):
    html_parts = ["""<!DOCTYPE html><html lang="en"><head><meta charset="UTF-8"><style>body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif; line-height: 1.6; padding: 2em; color: #333; } h1, h3 { color: #111; } table { border-collapse: collapse; width: 100%; margin-bottom: 2em; box-shadow: 0 2px 3px rgba(0,0,0,0.1); } th, td { border: 1px solid #ddd; padding: 10px 12px; text-align: left; vertical-align: top; } thead { background-color: #f2f2f2; font-weight: bold; } tbody tr:nth-child(even) { background-color: #f9f9f9; } span { text-decoration: underline dotted; cursor: help; }</style></head><body>"""]
    for category_name, rows in all_data.items():
        active_columns = list(view_config.get(category_name, []))
        if not active_columns: continue
        
        inject_container_columns(category_name, active_columns, container_mode, container_threshold)

        html_parts.append(f"<h3>{category_name}</h3>")
        if not rows: html_parts.append("<p><em>No data available for this category.</em></p>"); continue
        html_parts.append("<table><thead><tr>")
        for header in [HEADER_MAPPING.get(col, col) for col in active_columns]: html_parts.append(f"<th>{header}</th>")
        html_parts.append("</tr></thead><tbody>")
        for row in rows:
            html_parts.append("<tr>")
            for col_name in active_columns:
                cell_value = row.get(col_name)
                style_str = ""; emoji_prefix = ""; hex_color = None
                if use_colors:
                    if col_name in COLOR_MAP: hex_color = row.get(COLOR_MAP[col_name])
                    elif col_name in PERCENTAGE_COLUMNS: hex_color = get_color_for_percentage(cell_value, PERCENTAGE_COLUMNS[col_name])
                    if hex_color: text_color = get_text_color_for_bg(hex_color); style_str = f' style="background-color: {hex_color}; color: {text_color};"'
                if not style_str:
                    if col_name in EMOJI_MAP and row.get(EMOJI_MAP[col_name]): emoji_prefix = f"{row[EMOJI_MAP[col_name]]} "
                    elif col_name in PERCENTAGE_COLUMNS: emoji_prefix = get_emoji_for_percentage(cell_value, PERCENTAGE_COLUMNS[col_name])
                if col_name == 'has_alpha_channel' or col_name == 'subtitle_is_image':
                    if col_name == 'subtitle_is_image': cell_value = 'Image' if cell_value == 1 else 'Text'
                    else: cell_value = 'Yes' if cell_value == 1 else ('No' if cell_value == 0 else 'N/A')
                processed_cell = str(cell_value) if cell_value is not None else 'N/A'
                if col_name == 'display_name' and 'notes' not in active_columns and row.get('notes'):
                    safe_notes = row['notes'].replace('"', '&quot;')
                    processed_cell = f'<span title="{safe_notes}">{processed_cell}</span>'
                html_parts.append(f"<td{style_str}>{emoji_prefix}{processed_cell}</td>")
            html_parts.append("</tr>")
        html_parts.append("</tbody></table>")
    html_parts.append("</body></html>")
    return "\n".join(html_parts)

def render_as_csv(rows, category_name, view_config, delimiter=','):
    if not rows: return None
    active_columns = list(view_config.get(category_name, []))
    if not active_columns: return None
    
    inject_container_columns(category_name, active_columns, container_mode, container_threshold)

    output = io.StringIO()
    writer = csv.writer(output, delimiter=delimiter, quoting=csv.QUOTE_MINIMAL)
    headers = [HEADER_MAPPING.get(col, col) for col in active_columns]
    writer.writerow(headers)
    for row in rows:
        row_data = [row.get(col_name) for col_name in active_columns]
        writer.writerow(row_data)
    return output.getvalue()

# ==============================================================================
# EXECUTION
# ==============================================================================

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Generates comparison tables for codecs in various formats.", formatter_class=argparse.RawTextHelpFormatter)
    parser.add_argument('-f', '--format', choices=['simple-md', 'tooltip-md', 'html', 'color-html', 'single-us-csv', 'multi-us-csv', 'single-eu-csv', 'multi-eu-csv'], default='simple-md', help="The output format to generate.")
    parser.add_argument('-r', '--relevance', type=int, choices=[1, 2, 3], default=2, help="Filter by relevance level.")
    parser.add_argument('-a', '--show-aliases', action='store_true', help="Show all non-primary aliases.")
    parser.add_argument('--full', action='store_true', help="Use the full, detailed set of columns.")
    parser.add_argument('--full-debug', action='store_true', help="Show ALL available data columns.")
    parser.add_argument('--container-mode', choices=['combined', 'combined-tagged', 'split', 'off'], default='combined', help="How to display supported codecs.")
    parser.add_argument('--container-threshold', type=int, choices=[1, 2, 3], default=2, help="Filter supported codecs by level.")
    
    args = parser.parse_args()

    container_mode = args.container_mode
    container_threshold = args.container_threshold

    try:
        effective_view_config = {}
        if args.full_debug: pass 
        elif args.full: effective_view_config = VIEW_CONFIG_FULL
        else: effective_view_config = VIEW_CONFIG

        all_category_data = get_data_for_categories(
            view_config=effective_view_config,
            relevance_threshold=args.relevance, 
            show_all_aliases=args.show_aliases,
            container_mode=args.container_mode,
            container_threshold=args.container_threshold
        )

        if args.full_debug:
            print("Running in --full-debug mode: showing all available columns.")
            effective_view_config = {}
            for category_name, rows in all_category_data.items():
                if rows: effective_view_config[category_name] = list(rows[0].keys())

        if 'csv' in args.format:
            is_single_file = 'single' in args.format
            delimiter = ',' if 'us' in args.format else ';'
            if is_single_file:
                full_csv_output = []
                for category_name, rows in all_category_data.items():
                    if not rows: continue
                    csv_output = render_as_csv(rows, category_name, effective_view_config, delimiter=delimiter)
                    if csv_output: full_csv_output.append(csv_output)
                max_cols = max(len(effective_view_config.get(cat, [])) for cat in all_category_data.keys() if effective_view_config.get(cat))
                separator_line = delimiter * (max_cols - 1) if max_cols > 1 else ""
                final_output = f"\n{separator_line}\n".join(full_csv_output)
                output_filename = f"all_tables_{'us' if 'us' in args.format else 'eu'}.csv"
                with open(output_filename, 'w', encoding='utf-8', newline='') as f: f.write(final_output)
                print(f"Success! All tables written to single file '{output_filename}'.")
            else:
                if not os.path.exists(CSV_OUTPUT_DIR): os.makedirs(CSV_OUTPUT_DIR)
                file_count = 0
                for category_name, rows in all_category_data.items():
                    if not rows: continue
                    csv_output = render_as_csv(rows, category_name, effective_view_config, delimiter=delimiter)
                    if not csv_output: continue
                    safe_filename = category_name.replace(' // ', '_').replace(' ', '_').lower()
                    output_path = os.path.join(CSV_OUTPUT_DIR, f"{safe_filename}.csv")
                    with open(output_path, 'w', encoding='utf-8', newline='') as f: f.write(csv_output)
                    print(f"Success! Wrote {category_name} data to '{output_path}'.")
                    file_count += 1
                print(f"\nFinished generating {file_count} CSV files.")
        else:
            if args.format == 'simple-md':
                output = render_as_markdown(all_category_data, effective_view_config, tooltip_style=None)
                with open(MD_OUTPUT_FILE, 'w', encoding='utf-8') as f: f.write(output)
                print(f"Success! Simple Markdown guide written to '{MD_OUTPUT_FILE}' (Relevance: {args.relevance}).")
            elif args.format == 'tooltip-md':
                output = render_as_markdown(all_category_data, effective_view_config, tooltip_style='html')
                with open(MD_OUTPUT_FILE, 'w', encoding='utf-8') as f: f.write(output)
                print(f"Success! Tooltip Markdown guide written to '{MD_OUTPUT_FILE}' (Relevance: {args.relevance}).")
            elif args.format == 'html':
                output = render_as_html(all_category_data, effective_view_config, use_colors=False)
                with open(HTML_OUTPUT_FILE, 'w', encoding='utf-8') as f: f.write(output)
                print(f"Success! HTML guide with emojis written to '{HTML_OUTPUT_FILE}' (Relevance: {args.relevance}).")
            elif args.format == 'color-html':
                output = render_as_html(all_category_data, effective_view_config, use_colors=True)
                with open(HTML_OUTPUT_FILE, 'w', encoding='utf-8') as f: f.write(output)
                print(f"Success! HTML guide with colors written to '{HTML_OUTPUT_FILE}' (Relevance: {args.relevance}).")

    except Exception as e:
        print(f"An error occurred: {e}")