# samloader-actions ⚙️

**samloader-actions** is a GitHub CI script designed to download required files for Magisk to root your phone!

## ☑️ Usage:
1. Give this repository a Star ⭐️ and [fork](https://github.com/ravindu644/samloader-actions/fork) it.
   ![Fork Image](https://github.com/ravindu644/samloader-actions/blob/tmp/assets/2.png?raw=true)

2. Navigate to the "Actions" tab and select "Create a zip for Magisk".
   ![Actions Image](https://github.com/ravindu644/samloader-actions/blob/tmp/assets/3.png?raw=true)

3. Fill in all the required information.
   ![Information Image](https://github.com/ravindu644/samloader-actions/blob/tmp/assets/4.png?raw=true)

   > **Note:** You can find the value for CSC in "Settings > About phone > Software information > Service Provider software version".

   > **Note:** If you wish to upload the final results to your Telegram, create a public Telegram channel and a bot, add the bot to the channel, and set the GitHub environment secret `TELEGRAM_BOT_TOKEN` with your bot token and `TELEGRAM_CHAT_ID` with your channel's ID.

## Credits:
- [Scamsung](https://github.com/ravindu644/Scamsung) + [Samloader](https://github.com/martinetd/samloader) - The core.
- [Magisk](https://github.com/topjohnwu/Magisk) - The powerful rooting method.
- [vbmeta-disable-verification](https://github.com/libxzr/vbmeta-disable-verification) - Used to Disable AVB.
- [AIK-Linux](https://github.com/draekko/AIK-Linux) - Used to Unpack the boot.img to check the Ramdisk status.

---
