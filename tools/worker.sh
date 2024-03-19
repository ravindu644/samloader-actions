#!/bin/bash

extract(){
	cd "$WDIR/Downloads" # Change directory
	echo -e "\n${MINT_GREEN}[+] Extracting the firmware Zip...${RESET}\n"
	unzip firmware.zip && rm firmware.zip

	for file in AP*.tar.md5; do
    	tar -xvf "$file" && rm *.md5
	done

	echo -e "\n${LIGHT_YELLOW}[i] Zip Extraction Completed..!${RESET}"

	chk_lz4(){	    
	    files=$(find . -name "*.lz4")
	    if [ -n "$files" ]; then
	        echo -e "${MINT_GREEN}[i] Decompressing LZ4 files...${RESET}\n"
	        lz4 -m *.lz4 > /dev/null 2>&1
			rm *.lz4 #cleaning
	    fi
	}

	chk_lz4
}

is_dynamic(){
	cd "$WDIR/Downloads" # Change directory
	if [ -e super.img ]; then
		PARTITION_SCHEME=1
        	echo -e "${MINT_GREEN}[i] Dynamic Partition Device Detected..!${RESET}\n"		

	elif [ -e system.img ] && [ -e vendor.img ]; then
		PARTITION_SCHEME=2
        	echo -e "${MINT_GREEN}[i] Non-Dynamic Partition Device Detected..!${RESET}"	

    elif [ -e system.img ] || [ -e system.img.ext4 ] && [ ! -e vendor.img ] ; then
    	is_legacy=1   	

    else
        echo -e "${RED}[x] An Internal Error occured..!${RESET}"
        exit 1
    fi
}

stock_files(){
	echo -e "${MINT_GREEN}[+] Copying the Required stock files for Magisk...\n${RESET}"
	if [ "$is_legacy" == 1 ] && [ -e system.img ] || [ -e system.img.ext4 ]; then		
		cd "$WDIR/Downloads" #changed dir
		cp boot.img recovery.img "$WDIR/output/"
		cd "$WDIR/output" #changed dir
		tar cvf "$BASE_TAR_NAME" boot.img recovery.img ; rm *.img #cleaning

	elif [ "$PARTITION_SCHEME" == 1 ]; then
			cd "$WDIR/Downloads" #changed dir
			cp boot.img vbmeta.img recovery.img dtbo.img "$WDIR/output/"
			cd "$WDIR/output" #changed dir
			tar cvf "$BASE_TAR_NAME" boot.img vbmeta.img recovery.img dtbo.img; rm *.img #cleaning
		else
			cd "$WDIR/Downloads" #changed dir
			dt_check(){
				if [ -e dt.img ]; then
					is_dt=1
				fi
				if [ -e dtbo.img ]; then
					is_dtbo=1
				fi
			}
			dt_check
			if [ "$is_dt" == 1 ] && [ $is_dtbo == 1 ]; then 
				cp boot.img vbmeta.img recovery.img dtbo.img dt.img "$WDIR/output/"
				cd "$WDIR/output" #changed dir
				tar cvf "$BASE_TAR_NAME" boot.img vbmeta.img recovery.img dtbo.img dt.img; rm *.img #cleaning
			elif [ ! "$is_dt" == 1 ] && [ $is_dtbo == 1 ]; then
				cp boot.img.lz4 vbmeta.img.lz4 recovery.img.lz4 dtbo.img.lz4 "$WDIR/output/"
				cd "$WDIR/output" #changed dir
				tar cvf "$BASE_TAR_NAME" boot.img vbmeta.img recovery.img dtbo.img ; rm *.img #cleaning
			else
			 	cp boot.img vbmeta.img recovery.img "$WDIR/output/"
				cd "$WDIR/output" #changed dir
				tar cvf "$BASE_TAR_NAME" boot.img vbmeta.img recovery.img ; rm *.img #cleaning
			fi

	fi
	zip "${BASE_TAR_NAME}.zip" "$BASE_TAR_NAME"
	#rm "$BASE_TAR_NAME"
	echo -e "\n${LIGHT_YELLOW}[i] Zip file created: ${BASE_TAR_NAME}.zip${RESET}\n"
}

extract
is_dynamic
stock_files