#!/bin/sh

if [[ ! "$INSTALL_LEGACY_JAVA_RUNTIME_6" =~ ^(true|yes|on|1|TRUE|YES|ON])$ ]]; then
    exit
fi

# Get and install Xcode CLI tools
OSX_VERS=$(sw_vers -productVersion | awk -F "." '{print $2}')

# on 10.9+, we can leverage SUS to get the latest CLI tools
if [ "$OSX_VERS" -ge 11 ]; then
    exit
fi

DMGURL=http://support.apple.com/downloads/DL1572/en_US/javaforosx.dmg
TOOLS=javaforosx.dmg
curl "$DMGURL" -o "$TOOLS"
TMPMOUNT=`/usr/bin/mktemp -d /tmp/javaforosx.XXXX`
hdiutil attach "$TOOLS" -mountpoint "$TMPMOUNT"
installer -pkg "$(find $TMPMOUNT -name '*.mpkg')" -target /
hdiutil detach "$TMPMOUNT"
rm -rf "$TMPMOUNT"
rm "$TOOLS"
exit
