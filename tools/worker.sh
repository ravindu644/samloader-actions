#!/bin/bash

set -x

# Load helper scripts
source "$WDIR/images.conf"
source "$WDIR/tools/gofile.sh"
export PATH="$PATH:$WDIR/lptools"

# Override config with environment variables if set
[ -n "$WORKFLOW_MODE" ] && WORKFLOW_MODE="$WORKFLOW_MODE"
[ -n "$STORAGE_FRIENDLY" ] && STORAGE_FRIENDLY="$STORAGE_FRIENDLY"

extract() {
    cd "$WDIR/Downloads"

    echo -e "\n${MINT_GREEN}[+] Selectively extracting required firmware files...${RESET}\n"

    # Define required files to extract
    required_files=("${REQUIRED_IMAGES[@]}")
    if [ ${#REQUIRED_LOGICAL_IMAGES[@]} -gt 0 ]; then
        required_files+=("super.img")
    fi

    # Extract only .tar.md5 files from zip
    unzip firmware.zip "*.tar.md5" && rm firmware.zip

    # Extract required files from each tar
    for file in *.tar.md5; do
        tar_files=$(tar -tf "$file")
        to_extract=()
        for req in "${required_files[@]}"; do
            if echo "$tar_files" | grep -q "^$req$"; then
                to_extract+=("$req")
            fi
            if echo "$tar_files" | grep -q "^$req.lz4$"; then
                to_extract+=("$req.lz4")
            fi
        done
        if [ ${#to_extract[@]} -gt 0 ]; then
            tar -xvf "$file" "${to_extract[@]}"
        fi
    done

    rm -rf *.tar.md5

    # Decompress only required .lz4 files
    for req in "${required_files[@]}"; do
        if [ -e "$req.lz4" ]; then
            echo -e "${LIGHT_YELLOW}[i] Decompressing $req.lz4${RESET}"
            lz4 -d "$req.lz4" "$req" && rm "$req.lz4"
        fi
    done

    # Convert super.img if it's sparse and logical partitions are defined
    if [ -e "super.img" ] && [ ${#REQUIRED_LOGICAL_IMAGES[@]} -gt 0 ]; then
        if file super.img | grep -q "Android sparse image"; then
            echo -e "${MINT_GREEN}[+] Converting sparse super.img to raw...${RESET}\n"
            simg2img super.img super_raw.img && mv super_raw.img super.img
        fi
    fi

    # Storage-friendly cleanup: remove any remaining unnecessary files
    if [ "${STORAGE_FRIENDLY:-0}" = "1" ]; then
        echo -e "${LIGHT_YELLOW}[i] Storage-friendly mode: Cleaning up unnecessary files...${RESET}"
        for file in *; do
            if [[ "$file" == super.img ]] && [ ${#REQUIRED_LOGICAL_IMAGES[@]} -gt 0 ]; then
                continue
            fi
            if [[ " ${required_files[@]} " =~ " ${file} " ]]; then
                continue
            fi
            if [ -f "$file" ]; then
                rm -f "$file"
            fi
        done
    fi

    echo -e "\n${LIGHT_YELLOW}[i] Selective extraction completed..!${RESET}"
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
                partition_name="${partition%.img}"
                echo -e "${LIGHT_YELLOW}[i] Extracting ${partition_name}.img${RESET}"
                lpunpack "-p=${partition_name}" super.img
                if [ -e "${partition_name}.img" ]; then
                    echo -e "${LIGHT_YELLOW}[i] Copying ${partition_name}.img${RESET}"
                    cp "${partition_name}.img" "$WDIR/output/"
                else
                    echo -e "${LIGHT_RED}[!] ${partition_name}.img not found after extraction${RESET}"
                fi
            fi
        done
        echo -e "\n${LIGHT_YELLOW}[i] Logical partition extraction completed.${RESET}\n"
        
        # Storage-friendly cleanup: remove super.img after logical extraction
        if [ "${STORAGE_FRIENDLY:-0}" = "1" ]; then
            echo -e "${LIGHT_YELLOW}[i] Storage-friendly mode: Removing super.img after logical extraction...${RESET}"
            rm -f "$WDIR/Downloads/super.img"
        fi
    fi
    
    # Copy all existing required images to output directory
    for img in "${REQUIRED_IMAGES[@]}"; do
        if [ -e "$img" ]; then
            echo -e "${LIGHT_YELLOW}[i] Copying $img${RESET}"
            cp "$img" "$WDIR/output/"
        fi
    done
    
    # Storage-friendly cleanup: remove Downloads after copying required files
    if [ "${STORAGE_FRIENDLY:-0}" = "1" ]; then
        echo -e "${LIGHT_YELLOW}[i] Storage-friendly mode: Removing Downloads directory after copying files...${RESET}"
        rm -rf "$WDIR/Downloads"
    fi
    
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
