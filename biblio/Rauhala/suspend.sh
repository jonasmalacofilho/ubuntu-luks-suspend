#!/bin/sh

# A proof of concept script for forgetting LUKS passwords on suspend
# and reasking them on resume.

# The basic idea is to copy all of the files necessary for luksResume
# onto a RAM disk so that we can be sure they'll be available without
# touching the disk at all. Then switch to a text VT to run the resume
# (easier to make sure it'll come up than to do the same with X).

# The suspend itself has to be done from the ramdisk too to make sure it
# won't hang. This is also a reason why this couldn't be reliably done as a
# self-contained /etc/pm/sleep.d script, so to make the concept clear
# (and because I'm lazy) I did just a minimal standalone proof of concept
# instead. Integrating the functionality into the usual pm tools would be
# encouraged. (Though suspend_pmu would apparently need perl on the ramdisk...)

# (C) 2013 Mikko Rauhala 2013, modifiable and distributable under
# CC0, GPLv2 or later, MIT X11 license or 2-clause BSD. Regardless
# of what you pick, there is NO WARRANTY of any kind.

RAMDEV=/dev/ram0
ROOT=/run/cryptosuspend

PATH=/sbin:/bin:/usr/sbin:/usr/bin

# Cleanup not strictly necessary every time but good for development.
# Doing it before rather than after a suspend for debugging purposes

for a in "$ROOT"/dev/pts "$ROOT"/proc "$ROOT"/sys "$ROOT" ; do
	umount "$a" > /dev/null 2>&1
done

if mount | grep -q "$ROOT" ; then
	echo "Cleanup unsuccessful, cryptosuspend root premounted." 1>&2
	exit 2
fi

if grep -q mem /sys/power/state; then
	METHOD=mem
elif grep -q standby /sys/power/state; then
	METHOD=standby
else
	echo "No mem or standby states available, aborting" 1>&2
	exit 1
fi

if ! mount | grep -q "$RAMDEV" ; then
	mkfs -t ext2 -q "$RAMDEV" 8192
	mkdir -p "$ROOT"
	mount "$RAMDEV" "$ROOT"
	mkdir "$ROOT"/sbin "$ROOT"/bin "$ROOT"/dev "$ROOT"/tmp "$ROOT"/proc "$ROOT"/sys
	cp "$(which cryptsetup)" "$ROOT"/sbin
	for a in $(ldd "$(which cryptsetup)" | grep "/" | cut -d / -f 2- | cut -d " " -f 1) ; do
		mkdir -p "$ROOT""$(dirname /$a)"
		cp "/$a" "$ROOT"/"$a"
	done
	cp "$(which busybox)" "$ROOT"/bin/
	ln -s busybox "$ROOT"/bin/sh
	ln -s busybox "$ROOT"/bin/sync
	cp -a /dev "$ROOT"
	mount -t proc proc "$ROOT"/proc
	mount -t sysfs sysfs "$ROOT"/sys
	mount -t devpts devpts "$ROOT"/dev/pts
fi

CRYPTDEVS="$(dmsetup --target crypt status | cut -d : -f 1)"

echo '#!/bin/sh' > "$ROOT"/bin/cryptosuspend
echo "sync" >> "$ROOT"/bin/cryptosuspend
echo "for a in $CRYPTDEVS ; do" >> "$ROOT"/bin/cryptosuspend
echo "  cryptsetup luksSuspend \$a" >> "$ROOT"/bin/cryptosuspend
echo "done" >> "$ROOT"/bin/cryptosuspend
echo "echo -n \"$METHOD\" > /sys/power/state" >> "$ROOT"/bin/cryptosuspend
echo "for a in $CRYPTDEVS ; do" >> "$ROOT"/bin/cryptosuspend
echo '  while ! cryptsetup luksResume'" \$a ; do" >> "$ROOT"/bin/cryptosuspend
echo "    true" >> "$ROOT"/bin/cryptosuspend
echo "  done" >> "$ROOT"/bin/cryptosuspend
echo "done" >> "$ROOT"/bin/cryptosuspend
chmod a+rx "$ROOT"/bin/cryptosuspend

sync
exec openvt -s chroot "$ROOT" /bin/cryptosuspend
