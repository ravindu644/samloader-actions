#!/bin/bash

# --- Configuration and Setup ---
export WDIR
WDIR=$(pwd)

# Load color definitions, exit if they're missing.
if [ -f "$WDIR/tools/colors" ]; then
    source "$WDIR/tools/colors"
else
    echo "Error: Color definitions not found at '$WDIR/tools/colors'." >&2
    exit 1
fi


# --- Helper Functions for Colored Output ---
red() { echo -e "${RED}$1${RESET}"; }
yellow() { echo -e "${LIGHT_YELLOW}$1${RESET}"; }
green() { echo -e "${MINT_GREEN}$1${RESET}"; }
blue() { echo -e "${BLUE}$1${RESET}"; }


# --- Script Functions ---

# Display usage information
usage() {
    echo ""
    echo "$(yellow "Usage:") ./sam.sh [mode_options]"
    echo ""
    echo "$(blue "Mode 1: Direct Download")"
    echo "  Downloads firmware from a provided URL."
    echo "  $(yellow "Required:") --url <link> --model <model>"
    echo ""
    echo "$(blue "Mode 2: Samloader Download")"
    echo "  Finds and downloads firmware using device-specific info."
    echo "  $(yellow "Required:") --model <model> --imei <imei> --csc <csc>"
    echo ""
    echo "$(yellow "General Options:")"
    echo "  --help           Show this help message"
    echo ""
    echo "$(yellow "Examples:")"
    echo "  ./sam.sh --url \"https://example.com/firmware.zip\" --model \"SM-G998B\""
    echo "  ./sam.sh --model \"SM-G998B\" --imei \"123456789012345\" --csc \"XAA\""
}

# Parse all command-line arguments into global variables
parse_args() {
    while [[ $# -gt 0 ]]; do
        key="$1"
        case $key in
            --url=*)
                URL="${key#*=}"
                shift # past argument=value
                ;;
            --model=*)
                MODEL="${key#*=}"
                shift # past argument=value
                ;;
            --imei=*)
                IMEI="${key#*=}"
                shift # past argument=value
                ;;
            --csc=*)
                CSC="${key#*=}"
                shift # past argument=value
                ;;
            --url|--model|--imei|--csc)
                if [[ -z "$2" || "$2" =~ ^-- ]]; then
                    red "Error: Argument for $1 is missing." >&2
                    usage >&2
                    exit 1
                fi
                case $key in
                    --url) URL="$2" ;;
                    --model) MODEL="$2" ;;
                    --imei) IMEI="$2" ;;
                    --csc) CSC="$2" ;;
                esac
                shift # past argument
                shift # past value
                ;;
            --help)
                usage
                exit 0
                ;;
            *)  # unknown option
                red "Error: Unknown option '$1'." >&2
                usage >&2
                exit 1
                ;;
        esac
    done
}

# Validate that the correct arguments were provided for the chosen mode
validate_args() {
    if [[ -n "$URL" ]]; then
        # Direct Download Mode
        MODE="direct"
        if [[ -z "$MODEL" ]]; then
            red "Error: Direct download mode requires --model." >&2; usage >&2; exit 1
        fi
        if [[ -n "$IMEI" || -n "$CSC" ]]; then
            red "Error: --imei and --csc cannot be used with --url." >&2; usage >&2; exit 1
        fi
    elif [[ -n "$MODEL" ]]; then
        # Samloader Mode
        MODE="samloader"
        if [[ -z "$IMEI" || -z "$CSC" ]]; then
            red "Error: Samloader mode requires --model, --imei, and --csc." >&2; usage >&2; exit 1
        fi
    else
        # No mode could be determined
        red "Error: Invalid combination of arguments." >&2
        yellow "Please specify arguments for either Direct or Samloader mode." >&2
        usage >&2
        exit 1
    fi
}

# Initialize git submodules with clear error handling
init_submodules() {
    if [ ! -f "$WDIR/lptools/lpunpack" ]; then
        green "Initializing required Git submodules..."
        if ! git submodule update --init --recursive; then
            red "Error: Failed to initialize Git submodules." >&2
            yellow "Please check your Git configuration and network connection." >&2
            exit 1
        fi
    fi
}

# Check for and install required system packages only if they are missing
install_dependencies() {
    local packages="simg2img lz4 openssl python3 python3-pip"
    local to_install=""
    
    # Silently check for missing packages first
    for pkg in $packages; do
        if ! dpkg-query -W -f='${Status}' "$pkg" 2>/dev/null | grep -q "ok installed"; then
            to_install="$to_install $pkg"
        fi
    done

    # Only if packages are missing, print messages and install them
    if [ -n "$to_install" ]; then
        echo -e "\n\t$(yellow "Installing missing packages:$to_install")"
        if ! (sudo apt-get update -y && sudo apt-get install -y$to_install > /dev/null 2>&1); then
            red "Error: Failed to install required packages. Please run the command manually." >&2
            exit 1
        fi
        green "\t[+] Requirements installed successfully."
    fi
}

# Execute the download from a direct link
run_direct_download() {
    green "Direct Download Mode Selected"
    echo -e "====================================\n"
    echo -e "$(yellow "[+] Model:") ${MODEL}"
    echo -e "$(yellow "[+] URL:")   ${URL}\n"
    echo -e "====================================\n"

    green "Attempting to download firmware from the provided link...\n"
    if ! curl -L --fail "$URL" -o "$WDIR/Downloads/firmware.zip"; then
        red "Download failed! Please check the link and your network connection." >&2
        exit 1
    fi
    green "Download completed successfully."
}

# Execute the download using samloader
run_samloader_download() {
    green "Samloader Download Mode Selected"
    
    green "Checking/Installing Samloader pip package..."
    if ! pip3 install --user --upgrade git+https://github.com/martinetd/samloader.git > /dev/null 2>&1; then
        red "Error: Failed to install samloader." >&2
        exit 1
    fi
    
    echo -e "====================================\n"
    echo -e "$(yellow "[+] Model:") ${MODEL}"
    echo -e "$(yellow "[+] IMEI:")  ${IMEI:0:9}XXXXXX"
    echo -e "$(yellow "[+] CSC:")   ${CSC}\n"
    echo -e "====================================\n"

    green "Fetching latest firmware version..."
    VERSION=$(python3 -m samloader -m "${MODEL}" -r "${CSC}" -i "${IMEI}" checkupdate 2>/dev/null)
    if [ -z "$VERSION" ]; then
        red "Model, region, or IMEI not found (403). Please check your inputs." >&2
        exit 1
    fi
    yellow "Update found: ${VERSION}"

    green "Attempting to download firmware..."
    if ! python3 -m samloader -m "${MODEL}" -r "${CSC}" -i "${IMEI}" download -v "${VERSION}" -O "$WDIR/Downloads"; then
        red "Download failed. Did you enter the correct IMEI for your device model?" >&2
        exit 1
    fi
    green "Download completed."

    green "Decrypting firmware..."
    local FILE
    FILE=$(ls "$WDIR"/Downloads/*.enc*)
    if ! python3 -m samloader -m "${MODEL}" -r "${CSC}" -i "${IMEI}" decrypt -v "${VERSION}" -i "$FILE" -o "$WDIR/Downloads/firmware.zip"; then
        red "Decryption failed." >&2
        exit 1
    fi
    rm "${FILE}"
    green "Decryption completed."
}

# --- Main Execution ---
main() {
    clear
    blue "Samloader Actions - By @ravindu644\n"

    # Handle arguments
    parse_args "$@"
    validate_args
    
    # Prepare environment
    init_submodules
    install_dependencies
    rm -rf Downloads output Dist
    mkdir -p Downloads output Dist

    # Run selected mode
    if [ "$MODE" == "direct" ]; then
        run_direct_download
    else
        run_samloader_download
    fi

    # Final step
    green "\nRunning post-processing..."
    if ! bash "$WDIR/tools/worker.sh"; then
        red "Post-processing script failed." >&2
        exit 1
    fi
    green "Script finished successfully!"
}

# Run the main function with all script arguments
main "$@"
