clear
echo ""
echo "Installing Cyanogenmod 14.1 without Gapps"
echo ""
sleep 1
echo "Please boot your Nexus 5 into bootloader/fastboot mode by pressing Power & Volume Down (-)"
echo ""
sleep 1
echo -n "Is your Nexus 5 in bootloader/fastboot mode now? [Y] "; read bootloadermode
if [ "$bootloadermode"==Y -o "$bootloadermode"==y -o "$bootloadermode"=="" ]; then
  clear
  echo ""
  echo "Detecting device"
  echo ""
  sleep 1
  fastboot devices > /tmp/AttachedDevices
fi
if grep 'device$\|fastboot$' /tmp/AttachedDevices
then
  echo "Device detected !"
  sleep 1
  clear
  fastboot format cache
  fastboot format userdata
  fastboot reboot-bootloader
  sleep 6
  clear
  echo ""
  echo "Downloading TWRP recovery"
  echo ""
  wget -c --quiet --show-progress --tries=10 http://people.ubuntu.com/~misterq/magic-device-tool/recoverys/twrp-3.0.2-0-hammerhead.img
  sleep 1
  echo ""
  echo "Downloading Cyanogenmod 14.1 .."
  echo ""
  sleep 1
  wget -c --quiet --show-progress --tries=10 https://download.cyanogenmod.org/get/jenkins/187675/cm-14.1-20161125-NIGHTLY-hammerheadcaf.zip
  echo ""
  sleep 2
  clear
  echo ""
  echo "Installing TWRP recovery"
  echo ""
  fastboot flash recovery twrp-3.0.2-0-hammerhead.img
  sleep 1
  echo ""
  echo "Rebooting device.."
  echo ""
  echo "This will take ~35 seconds. Don't disconnect your device!"
  echo ""
  fastboot reboot-bootloader
  sleep 7
  fastboot boot twrp-3.0.2-0-hammerhead.img
  sleep 7
  adb reboot recovery
  sleep 15
  echo ""
  clear
  echo ""
  echo "Pushing zip's to device"
  sleep 1
  echo ""
  echo "Please wait this can take a while"
  echo ""
  echo "You may see a prompt asking you for read/write permissions"
  echo "Ignore that prompt, the tool will take care of the installation"
  echo ""
  echo "  → CM 14.1 zip "
  adb push -p cm-14.1-20161125-NIGHTLY-hammerheadcaf.zip /sdcard/
  echo ""
  echo "========================================="
  sleep 1
  echo ""
  echo "Installing Cyanogenmod.."
  echo ""
  adb shell twrp install /sdcard/cm-14.1-20161125-NIGHTLY-hammerheadcaf.zip
  sleep 1
  echo ""
  echo "Wipe cache.."
  echo ""
  adb shell twrp wipe cache
  adb shell twrp wipe dalvik
  echo ""
  adb reboot
  echo "The device is now rebooting. Give it time to flash the new ROM. It will boot on its own."
  echo ""
  sleep 5
  echo ""
  echo "Cleaning up.."
  rm -f /tmp/AttachedDevices
  echo ""
  sleep 1
  echo "Exiting script. Bye Bye"
  sleep 1

else
  echo "Device not found"
  rm -f /tmp/AttachedDevices
  sleep 1
  echo ""
  echo "Back to menu"
  sleep 1
  . ./launcher.sh
fi