#!/bin/bash

# http://ktnr74.blogspot.com/2013/07/installing-android-platform-tools-adb.html

[ -f /etc/os-release ] && . /etc/os-release
[ "$ID" == "debian" ] || [ "$ID" == "ubuntu" ] || exit 1
[ "$HOSTTYPE" == "x86_64" ] && dpkg --add-architecture i386 2>/dev/null
#apt-get -qqy update
#apt-get -qqy install wget xml2 unzip
#[ "$HOSTTYPE" == "x86_64" ] && apt-get -qqy install libncurses5:i386 libstdc++6:i386 zlib1g:i386

DESTDIR=${ANDROID_SDK_HOME:-$HOME/android}
mkdir -p "$DESTDIR"

#REPO=$(wget -qO - "https://android.googlesource.com/platform/tools/base/+archive/master/sdklib/src/main/java/com/android/sdklib/repository.tar.gz" | tar xzOf - SdkRepoConstants.java | tr -d '\n ' | sed -e 's/URL_GOOGLE_SDK_SITE="\([^"]*\)/\n\1\n/' | grep ^http)
REPO="https://dl-ssl.google.com/android/repository/"

R=9
while [ "$?" -eq "0" ];do 
  ((R += 1))
  XML="$XMLTMP"
  XMLTMP=`wget -qO - ${REPO}repository-$R.xml`
done

PACKAGES=($@)
[ "${PACKAGES[0]}" == "" ] && PACKAGES=("platform-tools")

NEWPATH=""
TMPDIR=`mktemp -d`
for PKG in ${PACKAGES[@]}; do
  PKGZIP=`echo "$XML" | xml2 | awk -F= '/sdk:url='$PKG'.*zip$/{print $2}' | grep -vE "(windows|macosx)\.zip$" | tail -1`
  wget -qO $TMPDIR/$PKGZIP ${REPO}$PKGZIP && \
    unzip -qo $TMPDIR/$PKGZIP -d "$DESTDIR/${PKGZIP%-linux.zip}" && \
    ln -sf `find "$DESTDIR/${PKGZIP%-linux.zip}" -mindepth 1 -maxdepth 1 | head -1` "$DESTDIR/$PKG" && \
    NEWPATH="$NEWPATH:$DESTDIR/$PKG" && \
    echo "${REPO}$PKGZIP unpacked to $DESTDIR/$PKG"
done
rm -rf "$TMPDIR"

export PATH="$PATH$NEWPATH"
echo -e "run the following command to make \$PATH changes permanent:\n"
echo -e "\techo -e \"\\\nexport PATH=\\\"\\\$PATH$NEWPATH\\\"\\\n\" >> ~/.bashrc\n\n"


echo -e '\nACTION=="add", SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device",' \
  'ENV{ID_USB_INTERFACES}=="*:ff420?:*", MODE="0666", GROUP="plugdev",' \
  'SYMLINK+="android/$env{ID_SERIAL_SHORT}"\n' > /etc/udev/rules.d/90-android.rules

udevadm control --reload-rules
udevadm trigger --action=add --subsystem-match=usb
