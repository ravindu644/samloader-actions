#!/bin/bash

# Copyright (c) [2025] [@ravindu644]

clear
export WDIR=$(pwd)
source "$WDIR/res/colors"
source "$WDIR/tools/gofile.sh"

echo -e "\n${BLUE}Samloader Actions - By @ravindu644${RESET}\n"
echo -e "\n\t${UNBOLD_GREEN}Installing requirements...${RESET}\n"

# Install dependencies
sudo apt update -y && sudo apt install simg2img lz4 openssl python3 python-is-python3 python3-pip -y > /dev/null 2>&1
echo -e "${MAGENTA}\n[+] Success..! ${RESET}\n"

# Create necessary directories
rm -rf Downloads output Dist
mkdir -p Downloads output Dist

# Check if direct download link is provided
if [ ! -z "$SAMFW_LINK" ]; then

    echo -e "====================================\n"
    echo -e "${LIGHT_YELLOW}[+] Model: ${BOLD_WHITE}${MODEL}${RESET}\n${LIGHT_YELLOW}"
    echo -e "====================================\n"

    echo -e "${MINT_GREEN}[+] Attempting to Download the Firmware From the Provided Link...${RESET}\n"
    curl -L --fail "$SAMFW_LINK" -o "$WDIR/Downloads/firmware.zip" || { 
        echo -e "\n${RED}[x] Download Failed..! Please provide a Direct Download Link. ${RESET}\n" >&2
        exit 1
    }
else
    # Install samloader if not already installed
    echo -e "${UNBOLD_GREEN}[+] Installing Samloader...${RESET}\n"
    if [ ! -f "$WDIR/.samloader" ]; then
        cd ~
        pip3 install git+https://github.com/martinetd/samloader.git --no-warn-script-location > /dev/null 2>&1
        touch "$WDIR/.samloader"
        cd "$WDIR"
    else
        echo -e "${RED}[x] Existing Installation found..!\n${RESET}"
    fi

    # Display device information
    echo -e "====================================\n"
    echo -e "${LIGHT_YELLOW}[+] Model: ${BOLD_WHITE}${MODEL}${RESET}\n${LIGHT_YELLOW}"
    echo -e "${LIGHT_YELLOW}[+] IMEI: ${BOLD_WHITE}${IMEI:0:9}XXXXXX${RESET}\n${LIGHT_YELLOW}"
    echo -e "${LIGHT_YELLOW}[+] CSC: ${BOLD_WHITE}${CSC}${RESET}\n${LIGHT_YELLOW}${RESET}"
    echo -e "====================================\n"

    # Check for firmware updates
    echo -e "${MINT_GREEN}[+] Fetching Latest Firmware...\n${RESET}"
    if ! VERSION=$(python3 -m samloader -m "${MODEL}" -r "${CSC}" -i "${IMEI}" checkupdate 2>/dev/null); then
        echo -e "\n${RED}[x] Model or region not found (403) ${RESET}\n"
        exit 1
    else
        echo -e "${LIGHT_YELLOW}[i] Update found: ${BOLD_WHITE}${VERSION}${RESET}\n${LIGHT_YELLOW}${RESET}"
    fi

    # Download firmware
    echo -e "${MINT_GREEN}[+] Attempting to Download...\n ${RESET}"
    if ! python3 -m samloader -m "${MODEL}" -r "${CSC}" -i "${IMEI}" download -v "${VERSION}" -O "$WDIR/Downloads" ; then
        source "$WDIR/res/colors"
        echo -e "\n${RED}[x] Something Strange Happened :( ${RESET}"
        echo -e "\n${RED}[?] Did you enter the correct IMEI for your device model..? 👀 ${RESET} \n"
        exit 1
    fi

    # Decrypt firmware
    echo -e "\n${MINT_GREEN}[+] Decrypting...\n${RESET}\n"
    FILE="$(ls $WDIR/Downloads/*.enc*)"
    if ! python3 -m samloader -m "${MODEL}" -r "${CSC}" -i "${IMEI}" decrypt -v "${VERSION}" -i "$FILE" -o "$WDIR/Downloads/firmware.zip"; then
        echo -e "\n${RED}[x] Something Strange Happened :( ${RESET}\n"
        exit 1
    fi
    rm "${FILE}"
fi

# Run worker script to extract and package files
bash "$WDIR/tools/worker.sh"
