#!/bin/sh
# Note: I've written this using sh so it works in the busybox container too

# USE the trap if you need to also do manual cleanup after the service is stopped,
#     or need to start multiple services in the one container
trap "echo TRAPed signal" HUP INT QUIT TERM

# start service in background here
#$ANDROID_HOME/emulator/emulator -use-system-libs @teste -no-boot-anim -no-audio -no-window -writable-system -memory 2048
chown root:kvm /dev/kvm
chmod g+rw /dev/kvm
Xvfb :1 -screen 0 1280x720x24+32 &
#sleep 5
x11vnc -display :1 &
export DISPLAY=:1
su android -c "$ANDROID_HOME/emulator/emulator -use-system-libs @teste -no-boot-anim -no-audio -writable-system -memory 2048"

echo "[hit enter key to exit] or run 'docker stop <container>'"
read

# stop service and clean up here
echo "stopping android emulator, Xvfb and x11vnc"
adb -s emulator-5554 emu kill

echo "exited $0"
