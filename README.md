# samloader-actions ⚙️

**samloader-actions** is a GitHub CI script designed to download the required files for Magisk to root your Samsung device without downloading large firmware files.

> [!NOTE]
> For Telegram uploads: Create a public Telegram channel and bot, add the bot as an admin, and set GitHub secrets `TELEGRAM_BOT_TOKEN` with your bot token and `TELEGRAM_CHAT_ID` with your channel ID.

## Prerequisites 📋

- Unlocked bootloader
- PC with USB cable
- Samsung USB Driver and ODIN ([Download Link 1](https://cloud.ravindu-deshan.workers.dev/0:/Samsung%20Tools%20for%20flashing%20-%20Ravindu%20Deshan.zip), [Download Link 2](https://drive.google.com/file/d/10XM_j-ZOMXOTTJoqkJ_BoNDEpfPeQSmf/view?usp=sharing))

## Important Warnings ⚠️

- **Backup important data** before proceeding as bootloader unlocking will factory reset your device

## Rooting Process

### 🟢 Step 1: Unlock Bootloader

Choose the appropriate guide for your device:
- [Old phones (J and A series 2015-2018)](https://github.com/ravindu644/Scamsung/wiki/How-to-root-your-Samsung-device-with-help-of-my-Script%3F-%5B-NO-TWRP-!-%5D#bootloader-unlocking-process---old-phones-like-j-and-old-a-series)
- [New devices](https://github.com/ravindu644/Scamsung/wiki/How-to-root-your-Samsung-device-with-help-of-my-Script%3F-%5B-NO-TWRP-!-%5D#bootloader-unlocking-process---new-devices)

### 🟢 Step 2: Download Required Files

#### 🟠 Method 1: Using Provided Details (Recommended)

---
#### ⚠️ Important Warnings when using this method:

- **Update your device** to the latest software before unlocking bootloader to avoid boot failures
- **Correct IMEI is crucial** - wrong IMEI will cause the script to fail
---

<br> 

1. [Fork](https://github.com/ravindu644/samloader-actions/fork) this repository and give it a star ⭐️
2. Navigate to the "Actions" tab and select "Download Using Provided Details"

   <img src="./assets/3.png" width="95%">

3. Fill in all required information and press "Run workflow" ✅

   <img src="./assets/4.png" width="95%">

   **Note:** Find your CSC in "Settings > About phone > Software information > Service provider software version"

   <img src="./assets/5.png" width="95%">

4. Wait 10-15 minutes for the download to complete

   <img src="./assets/6.png" width="95%">

5. Download the output files from your Telegram channel or Workflow artifacts

   <img src="./assets/7.png" width="95%">

#### 🟠 Method 2: Using a Direct Link

- We don't need to update the device to the latest software version since we can specify which firmware package to use with this method :)

1. [Fork](https://github.com/ravindu644/samloader-actions/fork) this repository and give it a star ⭐️
2. Navigate to "Actions" tab and select "Download using a Direct Link"

   <img src="./assets/14.png" width="95%">

3. Enter your model number and direct firmware link, then press "Run workflow" ✅

   **To get a direct firmware link:**
   - Visit samfw.com
   - Search for your model and region (CSC)
   - Find the exact firmware version matching your build/baseband number
   - Click "Download on Samfw Server"
   - Cancel the download and go to downloads page (CTRL + J)
   - Right-click on the canceled file and copy the link
  
https://github.com/user-attachments/assets/900b9659-80ef-417f-bf05-213fae090e87

4. Wait 5-10 minutes for processing to complete

   <img src="./assets/15.png" width="95%">

5. Download the output files from Telegram or artifacts

   <img src="./assets/16.png" width="95%">

### 🟢 Step 3: Patching and Flashing

1. Download and extract the artifact zip file

   <img src="./assets/8.png" width="95%">

2. Extract the "YOUR-MODEL-Magisk-files.tar" from the zip

   <img src="./assets/9.png" width="95%">

3. Copy the extracted TAR file to your phone's internal storage

   <img src="./assets/10.png" width="95%">

4. [Download and install Magisk Manager](https://github.com/topjohnwu/Magisk/releases/latest)

5. Open Magisk Manager → Install → Select and Patch a File → Choose the TAR file → LET'S GO

https://github.com/ravindu644/samloader-actions/assets/126038496/143fdec9-af74-49c6-930f-2c11c22dce18

6. Copy the patched file from your Download folder to your PC

   <img src="./assets/11.png" width="95%">

7. Reboot your device to Download mode
   - [Download mode key combinations guide](https://github.com/ravindu644/Scamsung/wiki/How-to-root-your-Samsung-device-with-help-of-my-Script%3F-%5B-NO-TWRP-!-%5D#-download-mode-key-combinations)

   <img src="./assets/1.jpg" width="95%">

8. Open ODIN, click the "AP" button and select "magisk_patched-xxxx.tar"

   <img src="./assets/12.png" width="95%">

9. Press "Start" to flash the patched file

   <img src="./assets/13.png" width="95%">

10. Wait for your device to boot
    - If boot fails, perform a "wipe data/factory reset" using Android recovery

    <img src="./assets/2.jpg" width="95%">

11. Open Magisk Manager and accept the prompt to reboot

    <img src="./assets/3.jpg" width="95%">

12. Verify root access with a root checker app

    <img src="./assets/4.jpg" width="95%">

## 🔴 Troubleshooting

If you encounter issues, refer to the [common issues and fixes guide](https://github.com/ravindu644/Scamsung/wiki/How-to-root-your-Samsung-device-with-help-of-my-Script%3F-%5B-NO-TWRP-!-%5D#debugging-process).

## Credits

- [Scamsung](https://github.com/ravindu644/Scamsung) + [Samloader](https://github.com/martinetd/samloader) - Core functionality
- [Magisk](https://github.com/topjohnwu/Magisk) - Rooting method
