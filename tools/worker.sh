#!/bin/bash

set -x

# Required image files
REQUIRED_IMAGES=(
    "boot.img"
    "init_boot.img"
    "recovery.img"
    "vbmeta.img"
    "dt.img"
    "dtbo.img"
    "dtb.img"
    "vendor_boot.img"
	"vbmeta_system.img"
    #super.img
    #up_param.bin
    #you can add more...
    #enter the file names without .lz4 extensions
)

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
}

collect_and_package_files() {
    echo -e "${MINT_GREEN}[+] Copying the Required stock files for Magisk...${RESET}\n"
    
    # Create output directory if it doesn't exist
    mkdir -p "$WDIR/output"
    
    # Copy all existing required images to output directory
    cd "$WDIR/Downloads"
    for img in "${REQUIRED_IMAGES[@]}"; do
        if [ -e "$img" ]; then
            echo -e "${LIGHT_YELLOW}[i] Copying $img${RESET}"
            cp "$img" "$WDIR/output/"
        fi
    done
    
    # Create the tar file with all image files
    cd "$WDIR/output"
    TAR_NAME="${MODEL}-Magisk-files.tar"
    tar -cvf "$TAR_NAME" *.img && rm *.img
    
    # Create maximum compressed zip from the tar file
    mkdir -p "$WDIR/Dist"
    zip -9 "$WDIR/Dist/${TAR_NAME}.zip" "$TAR_NAME"
    rm "$TAR_NAME"
    
    echo -e "\n${LIGHT_YELLOW}[i] Zip file created: ${TAR_NAME}.zip${RESET}\n"
}

# Main execution
extract
collect_and_package_files
