# samloader-actions ⚙️

**samloader-actions** is a GitHub CI script designed to download the required files for Magisk to root your phone without needing to download big firmware files..!
<br>

**❗️WARNING:** If you input a **wrong IMEI**, the script will fail to get the firmware from the Samsung server.

**❗️WARNING:** You must update the phone's software to the latest version before unlocking the bootloader.
> [!NOTE]
> If you wish to upload the final results to your Telegram, create a public Telegram channel and a bot, add the bot to the channel as an admin, and set the GitHub environment secret `TELEGRAM_BOT_TOKEN` with your bot token and `TELEGRAM_CHAT_ID` with your channel's ID.

## How to root your phone using only my Script..? 🌜
**Requirements:**
- a Samsung device with your latest Samsung software update.
- Unlocked bootloader.
- PC and USB cable.
- Samsung USB Driver and ODIN. ( [Link 1](https://cloud.ravindu-deshan.workers.dev/0:/Samsung%20Tools%20for%20flashing%20-%20Ravindu%20Deshan.zip), [Link 2](https://drive.google.com/file/d/10XM_j-ZOMXOTTJoqkJ_BoNDEpfPeQSmf/view?usp=sharing), Or download "Odin" and "Samsung USB drivers" from google )
- 🧠

## 1️⃣. Steps:
**01.** Update your Samsung device to the latest software update.
- Otherwise, your device will fail to boot..❗

**02.** Backup your important files/photos/videos/messages to an external storage.
- Because your device will reset during the bootloader unlocking process.

**03.** Unlock your device's bootloader using the guides below.
- [Old phones like J and Old A series (2015-2018)](https://github.com/ravindu644/Scamsung/wiki/How-to-root-your-Samsung-device-with-help-of-my-Script%3F-%5B-NO-TWRP-!-%5D#bootloader-unlocking-process---old-phones-like-j-and-old-a-series)
- [Bootloader Unlocking Process - New Devices](https://github.com/ravindu644/Scamsung/wiki/How-to-root-your-Samsung-device-with-help-of-my-Script%3F-%5B-NO-TWRP-!-%5D#bootloader-unlocking-process---new-devices)

**04.** Follow every step in the "[Usage](https://github.com/ravindu644/samloader-actions#2%EF%B8%8F%E2%83%A3-usage-%EF%B8%8F)" Section.

**05.** [Fixing common issues.](https://github.com/ravindu644/Scamsung/wiki/How-to-root-your-Samsung-device-with-help-of-my-Script%3F-%5B-NO-TWRP-!-%5D#debugging-process)

## 2️⃣. Usage: ☑️ 
#### 1. Give this repository a Star ⭐️ and [fork](https://github.com/ravindu644/samloader-actions/fork) it.
#### 2. Navigate to the "Actions" tab and select "Create a zip for Magisk". <br><br>
   <img src="https://github.com/ravindu644/samloader-actions/blob/stable/assets/3.png?raw=true" width="95%">

#### 3. Fill in all the required information there and press the "Run workflow" button ✅.
<br><img src="https://github.com/ravindu644/samloader-actions/blob/stable/assets/4.png?raw=true" width="95%">

**🗒 Note:** You can find the value for CSC in "Settings > About phone > Software information > Service provider software version".
<br><br><img src="https://github.com/ravindu644/samloader-actions/blob/stable/assets/5.png?raw=true" width="95%">

#### 4. The script will start the downloading process for you.
<br><img src="https://github.com/ravindu644/samloader-actions/blob/stable/assets/6.png?raw=true" width="95%">

#### 5. After 10-15 minutes, you can find the output files in your Telegram channel or Workflow's artifacts. (I'll choose the artifact.)
<img src="https://github.com/ravindu644/samloader-actions/blob/stable/assets/7.png?raw=true" width="95%">

> [!NOTE]
> IF you didn't add the Telegram bot token and Channel ID to environment secrets, you will see a failure at the end of the script, just ignore it..!
#### 6. Download the artifact and extract the "tar.xz" file inside it.
<img src="https://github.com/ravindu644/samloader-actions/blob/stable/assets/8.png?raw=true" width="95%">

#### 7. Extract the "Magisk-Patch-Me-YOUR-MODEL.tar" inside that "tar.xz" file.
<img src="https://github.com/ravindu644/samloader-actions/blob/stable/assets/9.png?raw=true" width="95%">

#### 8. Now, copy the extracted "Magisk-Patch-Me-YOUR-MODEL.tar" to your phone's internal storage.

<img src="https://github.com/ravindu644/samloader-actions/blob/stable/assets/10.png?raw=true" width="95%">

#### 9. [Install the latest Magisk Manager APK from here.](https://github.com/topjohnwu/Magisk/releases/latest)

#### 10. Open Magisk Manager > Choose the first "Install" button > "Select and Patch a File" > Choose the tar file which we copied to internal storage > "LET'S GO ->"

https://github.com/ravindu644/samloader-actions/assets/126038496/143fdec9-af74-49c6-930f-2c11c22dce18

#### 11. The patched tar file will be located in your "Download" folder. Copy it to your PC.
<img src="https://github.com/ravindu644/samloader-actions/blob/stable/assets/11.png?raw=true" width="95%">

#### 12. Reboot your Device to Download mode.
- [Use this Guide](https://github.com/ravindu644/Scamsung/wiki/How-to-root-your-Samsung-device-with-help-of-my-Script%3F-%5B-NO-TWRP-!-%5D#-download-mode-key-combinations).
<img src="https://github.com/ravindu644/samloader-actions/blob/stable/assets/1.jpg?raw=true" width="95%">

#### 13. Open "ODIN" and click "AP" button and choose the "magisk_patched-xxxx.tar".
<br><img src="https://github.com/ravindu644/samloader-actions/blob/stable/assets/12.png?raw=true" width="95%">

#### 14. Press "Start" in ODIN. It will begin to flash the patched file required for Magisk root to your device.
<br><img src="https://github.com/ravindu644/samloader-actions/blob/stable/assets/13.png?raw=true" width="95%">

#### 15. Now, your device should boot up. If it fails, just do a "wipe data/factory reset" using Android recovery. (In my case, I didn't want to do a reset)
<br><img src="https://github.com/ravindu644/samloader-actions/blob/stable/assets/2.jpg?raw=true" width="95%">

#### 16. Open Magisk Manager and You will see a notice like this:
- Simply press OK and your device will reboot in 5 seconds.
<br><img src="https://github.com/ravindu644/samloader-actions/blob/stable/assets/3.jpg?raw=true" width="95%">

#### 17. 🔥Once booted, install a root checker app and see the magic..! 😉
<br><img src="https://github.com/ravindu644/samloader-actions/blob/stable/assets/4.jpg?raw=true" width="95%">

## Credits:
- [Scamsung](https://github.com/ravindu644/Scamsung) + [Samloader](https://github.com/martinetd/samloader) - The core.
- [Magisk](https://github.com/topjohnwu/Magisk) - The powerful rooting method.
- [vbmeta-disable-verification](https://github.com/libxzr/vbmeta-disable-verification) - Used to Disable AVB.
- [AIK-Linux](https://github.com/draekko/AIK-Linux) - Used to Unpack the boot.img to check the Ramdisk status.

---
