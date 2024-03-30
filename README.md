# samloader-actions ⚙️

**samloader-actions** is a GitHub CI script designed to download required files for Magisk to root your phone!
<br>

**❗️WARN:** If you input a **wrong IMEI**, the script will be fail to get the firmware from the Samsung server.

**❗️WARN:** You must update the phone's software to the latest version before unlocking bootloader.
> [!NOTE]
> If you wish to upload the final results to your Telegram, create a public Telegram channel and a bot, add the bot to the channel, and set the GitHub environment secret `TELEGRAM_BOT_TOKEN` with your bot token and `TELEGRAM_CHAT_ID` with your channel's ID.

## ☑️ Usage:
#### 1. Give this repository a Star ⭐️ and [fork](https://github.com/ravindu644/samloader-actions/fork) it.
#### 2. Navigate to the "Actions" tab and select "Create a zip for Magisk". <br><br>
   <img src="https://github.com/ravindu644/samloader-actions/blob/tmp/assets/3.png?raw=true" width="65%">

#### 3. Fill in all the required information there and press "Run workflow" button ✅.
<br><img src="https://github.com/ravindu644/samloader-actions/blob/tmp/assets/4.png?raw=true" width="50%">

**🗒 Note:** You can find the value for CSC in "Settings > About phone > Software information > Service provider software version".
<br><br><img src="https://github.com/ravindu644/samloader-actions/blob/tmp/assets/5.png?raw=true" width="30%">

#### 4. The script will start the downloading process for you.
<br><img src="https://github.com/ravindu644/samloader-actions/blob/tmp/assets/6.png?raw=true" width="60%">

#### 5. After 10-15 minutes, you can find the output files in your Telegram channel or Workflow's artifacts. (I'll choose the artifact.)
<img src="https://github.com/ravindu644/samloader-actions/blob/tmp/assets/7.png?raw=true" width="60%">

> [!NOTE]
> IF you didn't add the Telegram bot token and Channel ID to environment secrets, you will see a failure at the end of the script, just ignore it..!
#### 6. Download the artifact and extract the "tar.xz" file inside it.
<img src="https://github.com/ravindu644/samloader-actions/blob/tmp/assets/8.png?raw=true" width="60%">

#### 7. Extract the "Magisk-Patch-Me-YOUR-MODEL.tar" inside that "tar.xz" file.
<img src="https://github.com/ravindu644/samloader-actions/blob/tmp/assets/9.png?raw=true" width="60%">

#### 8. Now, copy the extracted "Magisk-Patch-Me-YOUR-MODEL.tar" to your phone's internal storage.

<img src="https://github.com/ravindu644/samloader-actions/blob/tmp/assets/10.png?raw=true" width="30%">

#### 9. [Install the latest Magisk Manager APK from from here.](https://github.com/topjohnwu/Magisk/releases/latest)
#### 10. Open Magisk Manager > Choose the first "Install" button > "Select and Patch a File" > Choose the tar file which we copied to internal storage > "LET'S GO ->"

https://github.com/ravindu644/samloader-actions/assets/126038496/9d6cc143-abcd-46ce-9726-77bdbe328688

#### 11. The patched tar file will be located in your "Download" folder.
<img src="https://github.com/ravindu644/samloader-actions/blob/tmp/assets/11.png?raw=true" width="40%">


## Credits:
- [Scamsung](https://github.com/ravindu644/Scamsung) + [Samloader](https://github.com/martinetd/samloader) - The core.
- [Magisk](https://github.com/topjohnwu/Magisk) - The powerful rooting method.
- [vbmeta-disable-verification](https://github.com/libxzr/vbmeta-disable-verification) - Used to Disable AVB.
- [AIK-Linux](https://github.com/draekko/AIK-Linux) - Used to Unpack the boot.img to check the Ramdisk status.

---
