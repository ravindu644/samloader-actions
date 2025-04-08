#!/bin/bash

# Function to upload the releases to gofile.io
upload_to_gofile() {
    local file="$1"

    if [[ ! -f "$file" ]]; then
        echo "❌ File not found: $file"
        return 1
    fi

    echo "📤 Uploading $file to GoFile..."

    local link=$(curl -s -X POST 'https://upload.gofile.io/uploadfile' -F "file=@$file" \
                 | grep -oP '"downloadPage"\s*:\s*"\K[^"]+')

    if [[ -n "$link" ]]; then
        echo "✅ Link to Download: $link"
        echo "GOLINK=$link" >> $GITHUB_ENV
    else
        echo "❌ Failed to upload or fetch link."
        return 1
    fi
}
