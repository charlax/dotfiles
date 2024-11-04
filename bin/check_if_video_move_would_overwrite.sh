#!/bin/bash

# Usage function
usage() {
    echo "Usage: $0 source_file destination"
    echo "destination can be either a full file path or a folder"
    echo "If destination is a folder, the source filename will be used"
    exit 1
}

# Check if both arguments are provided
if [ $# -ne 2 ]; then
    usage
fi

source_file="$1"
destination="$2"

# Check if source file exists
if [ ! -f "$source_file" ]; then
    echo "Error: Source file '$source_file' does not exist"
    exit 1
fi

# If destination is a directory, append the source filename
if [ -d "$destination" ]; then
    destination="${destination%/}/$(basename "$source_file")"
fi

echo "Comparing:"
echo "Source:      $source_file"
echo "Destination: $destination"
echo "---"

# Check if destination file exists
if [ ! -f "$destination" ]; then
    echo "No conflict - destination file does not exist"
    exit 0
fi

# Quick size check first
source_size=$(stat -f%z "$source_file")
dest_size=$(stat -f%z "$destination")

if [ "$source_size" != "$dest_size" ]; then
    echo "Files differ - different sizes"
    echo "Source: $source_size bytes"
    echo "Destination: $dest_size bytes"
    exit 2
fi
echo "✓ Same size: $source_size bytes"

# Check video duration using ffprobe
source_duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$source_file")
dest_duration=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$destination")

if [ "$source_duration" != "$dest_duration" ]; then
    echo "Files differ - different durations"
    echo "Source: $source_duration seconds"
    echo "Destination: $dest_duration seconds"
    exit 2
fi
echo "✓ Same duration: $source_duration seconds"

# Compare first 10MB
if ! cmp -n 10485760 "$source_file" "$destination" >/dev/null 2>&1; then
    echo "Files differ - first 10MB don't match"
    exit 2
fi
echo "✓ First 10MB match"

# Check video resolution and codec info
source_info=$(ffprobe -v quiet -select_streams v:0 -show_entries stream=width,height,codec_name -of csv=p=0 "$source_file")
dest_info=$(ffprobe -v quiet -select_streams v:0 -show_entries stream=width,height,codec_name -of csv=p=0 "$destination")

if [ "$source_info" != "$dest_info" ]; then
    echo "Files differ - different resolution or codec"
    echo "Source: $source_info"
    echo "Destination: $dest_info"
    exit 2
fi
echo "✓ Same resolution and codec: $source_info"

# Compare frames at 20% and 80% of the duration
# (avoiding start/end which might have credits or black frames)
duration_seconds=$(printf "%.0f" "$source_duration")
for percentage in 0.2 0.8; do
    timestamp=$(echo "$duration_seconds * $percentage" | bc)

    # Extract and compare frame at specific timestamp
    # Using md5 hash to compare frames
    source_frame=$(ffmpeg -ss "$timestamp" -i "$source_file" -vframes 1 -f image2pipe -vcodec rawvideo -pix_fmt rgb24 - 2>/dev/null | md5)
    dest_frame=$(ffmpeg -ss "$timestamp" -i "$destination" -vframes 1 -f image2pipe -vcodec rawvideo -pix_fmt rgb24 - 2>/dev/null | md5)

    if [ "$source_frame" != "$dest_frame" ]; then
        echo "Files differ - frames at ${percentage}% duration don't match"
        echo "Source frame hash: $source_frame"
        echo "Dest frame hash: $dest_frame"
        exit 2
    fi
    echo "✓ Frames match at ${percentage}% duration (${timestamp}s)"
done

# Check modification time (might be different but worth showing)
source_time=$(stat -f "%Sm" -t "%Y-%m-%d %H:%M:%S" "$source_file")
dest_time=$(stat -f "%Sm" -t "%Y-%m-%d %H:%M:%S" "$destination")

if [ "$source_time" != "$dest_time" ]; then
    echo "Note: Different modification times"
    echo "Source: $source_time"
    echo "Destination: $dest_time"
fi

echo "---"
echo "Files appear to be identical"
exit 0
