#!/bin/bash

# Based on : https://github.com/Mesa-Labs-Archive/UN1CA

MAGISK_DIR="${WDIR}/Magisk"
TMP_DIR="${MAGISK_DIR}/Workspace"
AIK_DIR="${WDIR}/tools/AIK"

check_ramdisk(){
    echo -e "[i] Checking Ramdisk status..\n"
    sudo chmod +775 -R "${AIK_DIR}"
    sudo bash "${AIK_DIR}/cleanup.sh" > /dev/null 2>&1
    rm "${AIK_DIR}/boot.img" > /dev/null 2>&1
    cp "$WDIR/Downloads/boot.img" "${AIK_DIR}/boot.img"
    sudo bash "${AIK_DIR}/unpackimg.sh" > /dev/null 2>&1

    if [ "$(ls -A "${AIK_DIR}/ramdisk")" ]; then
        echo -e "${MINT_GREEN}[i] Ramdisk found in 'boot.img' ${RESET}\n"
        export RAMDISK=1
        export IMG="boot"
        export TAR="$WDIR/Downloads/${IMG}.img"
        export BOOT_SIZE="$(stat -c '%s' "${WDIR}/Downloads/${IMG}.img")"
    else
        echo -e "${RED}[x] Ramdisk not found in 'boot.img' ${RESET}"
        echo -e "${LIGHT_YELLOW}[i] Using 'recovery.img' instead.. ${RESET}\n"
        export RAMDISK=0
        export IMG="recovery"
        export TAR="$WDIR/Downloads/${IMG}.img"
        export BOOT_SIZE="$(stat -c '%s' "${WDIR}/Downloads/${IMG}.img")"      
    fi
}

download_magisk() {
    local latest_version
    latest_version=$(curl -s https://api.github.com/repos/topjohnwu/Magisk/releases/latest | grep -o '"tag_name": "[^"]*' | grep -Eo '[0-9]+(\.[0-9]+)+' | head -n 1)
    local apk_url="https://github.com/topjohnwu/Magisk/releases/download/v${latest_version}/Magisk-v${latest_version}.apk"
    local output_file="$MAGISK_DIR/Magisk.apk"
    
    curl -L -o "$output_file" "$apk_url" || wget -O "$output_file" "$apk_url"
}

patch_kernel() {
    if [ ! -f "$TAR" ]; then
        echo -e "${RED}[x] File not found: ${TAR}${RESET}"
        exit 1
    fi

    mkdir -p "$TMP_DIR" "$WDIR/output/Magisk_Patched"

    if [ ! -f "$MAGISK_DIR/Magisk.apk" ]; then
        echo -e "\n${MINT_GREEN}[+] Downloading Latest Magisk...${RESET}\n"
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

        if [ "$RAMDISK" -eq 0 ]; then
            echo 'RECOVERYMODE=true'
        fi

    } > "$TMP_DIR/util_functions.sh"

    echo -e "\n${LIGHT_YELLOW}[i] Patching $TAR...${RESET}\n"
    cp -a --preserve=all "$TAR" "$TMP_DIR/stock.img"
    sh "$TMP_DIR/boot_patch.sh" "$TMP_DIR/stock.img" 2> /dev/null

    # Move patched boot image to appropriate directory
    dd if="$TMP_DIR/new-boot.img" of="$TMP_DIR/${IMG}.img" bs=4k count=${BOOT_SIZE} iflag=count_bytes
    mv -f "$TMP_DIR/${IMG}.img" "$WDIR/output/Magisk_Patched/${IMG}.img"

    # Clean up temporary directory if needed
    rm -rf "$TMP_DIR"
}

vbmeta_patch(){
    echo -e "\n${MINT_GREEN}[+] Patching VBMETA...${RESET}\n"
    cp "${WDIR}/Downloads/vbmeta.img" "$WDIR/output/Magisk_Patched/vbmeta.img"
    "${WDIR}/tools/vbmeta-disable-verification" "${WDIR}/output/Magisk_Patched/vbmeta.img"
    echo -e "\n${LIGHT_YELLOW}[i] Patching Done...${RESET}\n"
}

repacking(){
    echo -e "\n${MINT_GREEN}[+] Repacking tar...${RESET}\n"
    cd "$WDIR/output/Magisk_Patched"
    tar -cvf "Magisk_Patched-${IMG}-${MODEL}.tar" "${IMG}.img" vbmeta.img
    zip "Magisk_Patched-${IMG}-${MODEL}.tar.zip" "Magisk_Patched-${IMG}-${MODEL}.tar"
    mv "Magisk_Patched-${IMG}-${MODEL}.tar.zip" "$WDIR/Dist"
    echo -e "\n${LIGHT_YELLOW}[i] Repacking Done...! ${RESET}\n"    
}

check_ramdisk
patch_kernel
vbmeta_patch
repacking