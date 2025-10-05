#!/bin/bash

set -x

# Load helper scripts
source "$WDIR/images.conf"
source "$WDIR/tools/gofile.sh"
export PATH="$PATH:$WDIR/lptools"

extract() {
    cd "$WDIR/Downloads"
    
    echo -e "\n${MINT_GREEN}[+] Extracting the firmware Zip...${RESET}\n"
    
    unzip firmware.zip && rm firmware.zip
    
    for file in *.tar.md5; do
        tar -xvf "$file"
    done

    rm -rf *.md5
    
    echo -e "\n${LIGHT_YELLOW}[i] Zip Extraction Completed..!${RESET}"
    
    # Check and decompress LZ4 files if they exist
    files=$(find . -name "*.lz4")
    if [ -n "$files" ]; then
        echo -e "${MINT_GREEN}[i] Decompressing LZ4 files...${RESET}\n"
        lz4 -m *.lz4 > /dev/null 2>&1
        rm *.lz4
    fi
    
    # Convert super.img if it's sparse and logical partitions are defined
    if [ -e "super.img" ] && [ ${#REQUIRED_LOGICAL_IMAGES[@]} -gt 0 ]; then
        if file super.img | grep -q "Android sparse image"; then
            echo -e "${MINT_GREEN}[+] Converting sparse super.img to raw...${RESET}\n"
            simg2img super.img super_raw.img && mv super_raw.img super.img
        fi
    fi
}

collect_and_package_files() {
    echo -e "${MINT_GREEN}[+] Copying the Required stock files for Magisk...${RESET}\n"
    
    # Create output directory if it doesn't exist
    mkdir -p "$WDIR/output"
    
    # Extract logical partitions from super.img if it exists
    cd "$WDIR/Downloads"
    if [ -e "super.img" ] && [ ${#REQUIRED_LOGICAL_IMAGES[@]} -gt 0 ]; then
        echo -e "${MINT_GREEN}[+] Extracting logical partitions...${RESET}\n"
        for partition in "${REQUIRED_LOGICAL_IMAGES[@]}"; do
            if [ -n "$partition" ]; then
                echo -e "${LIGHT_YELLOW}[i] Extracting $partition.img${RESET}"
                lpunpack -p "$partition" super.img
            fi
        done
        echo -e "\n${LIGHT_YELLOW}[i] Logical partition extraction completed.${RESET}\n"
    fi
    
    # Copy all existing required images to output directory
    for img in "${REQUIRED_IMAGES[@]}"; do
        if [ -e "$img" ]; then
            echo -e "${LIGHT_YELLOW}[i] Copying $img${RESET}"
            cp "$img" "$WDIR/output/"
        fi
    done
    
    # If not in workflow mode, skip packaging and uploading
    if [ "${WORKFLOW_MODE:-0}" != "1" ]; then
        echo -e "\n${LIGHT_YELLOW}[i] Images extracted to output directory (extract only mode)${RESET}\n"
        return
    fi
    
    # Create the tar file with all image files
    cd "$WDIR/output"
    TAR_NAME="${MODEL}-Magisk-files.tar"
    tar -cvf "$TAR_NAME" *.img && rm *.img
    
    # Create maximum compressed zip from the tar file
    mkdir -p "$WDIR/Dist"
    zip -9 "$WDIR/Dist/${TAR_NAME}.zip" "$TAR_NAME"
    rm "$TAR_NAME"
    
    echo -e "\n${LIGHT_YELLOW}[i] Zip file created: ${TAR_NAME}.zip${RESET}\n"

    upload_to_gofile "$WDIR/Dist/${TAR_NAME}.zip"


}

# Main execution
extract
collect_and_package_files
