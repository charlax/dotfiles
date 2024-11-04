#!/bin/bash

# Function to convert size to human readable format
human_size() {
    local bytes=$1
    if [[ $bytes -lt 1024 ]]; then
        echo "${bytes}B"
    elif [[ $bytes -lt 1048576 ]]; then
        echo "$(( (bytes + 512)/1024 ))KB"
    else
        echo "$(( (bytes + 524288)/1048576 ))MB"
    fi
}

# Function to format time in HH:MM:SS
format_time() {
    printf '%02d:%02d:%02d' $(($1/3600)) $(($1%3600/60)) $(($1%60))
}

# Create output directory if it doesn't exist
mkdir -p encoded

# Count total files
total_files=$(ls -1 *.dv 2>/dev/null | wc -l)
if [ "$total_files" -eq 0 ]; then
    echo "No .dv files found in current directory"
    exit 1
fi

current_file=0
total_original_size=0
total_new_size=0

echo "Found $total_files DV files to process"
echo "----------------------------------------"

# Process each .dv file
for input in *.dv; do
    # Skip if no .dv files
    [ -f "$input" ] || continue

    current_file=$((current_file + 1))
    output="encoded/${input%.*}.mp4"

    # Get original file size and duration
    original_size=$(stat -f %z "$input" 2>/dev/null || stat -c %s "$input")
    duration=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$input")
    duration_rounded=${duration%.*}

    echo "Processing file $current_file of $total_files: $input"
    echo "Original size: $(human_size $original_size)"
    echo "Duration: $(format_time $duration_rounded)"

    # Encode the file
    ffmpeg -i "$input" \
        -c:v libx264 \
        -preset medium \
        -crf 20 \
        -vf "yadif" \
        -c:a aac \
        -b:a 192k \
        "$output" \
        -hide_banner \
        -loglevel warning

    # Get new file size
    new_size=$(stat -f %z "$output" 2>/dev/null || stat -c %s "$output")
    reduction=$(echo "scale=2; (1 - $new_size/$original_size) * 100" | bc)

    total_original_size=$((total_original_size + original_size))
    total_new_size=$((total_new_size + new_size))

    echo "New size: $(human_size $new_size)"
    echo "Reduction: ${reduction}%"
    echo "----------------------------------------"
done

# Calculate total reduction
total_reduction=$(echo "scale=2; (1 - $total_new_size/$total_original_size) * 100" | bc)

echo "Encoding complete!"
echo "Total original size: $(human_size $total_original_size)"
echo "Total new size: $(human_size $total_new_size)"
echo "Total reduction: ${total_reduction}%"
echo "Encoded files are in the 'encoded' directory"
