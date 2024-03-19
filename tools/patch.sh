#!/bin/bash

# Based on : https://github.com/Mesa-Labs-Archive/UN1CA

MAGISK_DIR="${WDIR}/Magisk"
TMP_DIR="${MAGISK_DIR}/Workspace"

download_magisk() {
    local latest_version
    latest_version=$(curl -s https://api.github.com/repos/topjohnwu/Magisk/releases/latest | grep -o '"tag_name": "[^"]*' | grep -Eo '[0-9]+(\.[0-9]+)+' | head -n 1)
    local apk_url="https://github.com/topjohnwu/Magisk/releases/download/v${latest_version}/Magisk-v${latest_version}.apk"
    local output_file="$MAGISK_DIR/Magisk.apk"
    
    curl -L -o "$output_file" "$apk_url" || wget -O "$output_file" "$apk_url"
}

patch_kernel() {
    local TAR="$WDIR/output/${BASE_TAR_NAME}"
    
    if [ ! -f "$TAR" ]; then
        echo -e "${RED}[x] File not found: ${TAR}${RESET}"
        exit 1
    fi

    mkdir -p "$TMP_DIR" "$WDIR/output/Magisk_Patched"

    if [ ! -f "$MAGISK_DIR/Magisk.apk" ]; then
        echo -e "${MINT_GREEN}\n[+] Downloading Latest Magisk...\n${RESET}"
        download_magisk
    fi

    unzip -q -j "$MAGISK_DIR/Magisk.apk" "assets/boot_patch.sh" -d "$TMP_DIR"
    unzip -q -j "$MAGISK_DIR/Magisk.apk" "assets/stub.apk" -d "$TMP_DIR"
    unzip -q -j "$MAGISK_DIR/Magisk.apk" "lib/x86_64/libmagiskboot.so" -d "$TMP_DIR" && mv -f "$TMP_DIR/libmagiskboot.so" "$TMP_DIR/magiskboot" && chmod 755 "$TMP_DIR/magiskboot"
    unzip -q -j "$MAGISK_DIR/Magisk.apk" "lib/armeabi-v7a/libmagisk32.so" -d "$TMP_DIR" && mv -f "$TMP_DIR/libmagisk32.so" "$TMP_DIR/magisk32"
    unzip -q -j "$MAGISK_DIR/Magisk.apk" "lib/arm64-v8a/libmagisk64.so" -d "$TMP_DIR" && mv -f "$TMP_DIR/libmagisk64.so" "$TMP_DIR/magisk64"
    unzip -q -j "$MAGISK_DIR/Magisk.apk" "lib/arm64-v8a/libmagiskinit.so" -d "$TMP_DIR" && mv -f "$TMP_DIR/libmagiskinit.so" "$TMP_DIR/magiskinit"

    {
        echo 'ui_print() { echo "$1"; }'
        echo 'abort() { ui_print "$1"; exit 1; }'
        echo 'api_level_arch_detect() { true; }'
        echo 'KEEPFORCEENCRYPT=true'
        echo 'KEEPVERITY=true'
        echo 'PREINITDEVICE=cache'
    } > "$TMP_DIR/util_functions.sh"

    echo -e "${LIGHT_YELLOW}[i] Patching $TAR...${RESET}\n"
    cp -a --preserve=all "$TAR" "$TMP_DIR/stock.tar"
    sh "$TMP_DIR/boot_patch.sh" "$TMP_DIR/stock.tar" 2> /dev/null

    # Move patched boot image to appropriate directory
    mv -f "$TMP_DIR/new-boot.img" "$WDIR/output/Magisk_Patched"

    # Clean up temporary directory if needed
    rm -rf "$TMP_DIR"
}

patch_kernel