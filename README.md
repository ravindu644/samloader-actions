# samloader-actions ⚙️

**samloader-actions** is a GitHub CI script designed to download required files for Magisk to root your phone!
<br>
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

#### 5. After 10-15 minutes, you can find the output files in your Telegram channel or Workflow's artifacts.

## Credits:
- [Scamsung](https://github.com/ravindu644/Scamsung) + [Samloader](https://github.com/martinetd/samloader) - The core.
- [Magisk](https://github.com/topjohnwu/Magisk) - The powerful rooting method.
- [vbmeta-disable-verification](https://github.com/libxzr/vbmeta-disable-verification) - Used to Disable AVB.
- [AIK-Linux](https://github.com/draekko/AIK-Linux) - Used to Unpack the boot.img to check the Ramdisk status.

---
