ubuntu-luks-suspend
===================

_A non-functional attempt to make [Ubuntu Linux][] 14.04 lock the encrypted root volume uppon suspending (to RAM)_


About
-----

When using [Ubuntu Full Disk Encryption][] (that is based on dm-crypt with LUKS) to set up full system encryption, the encryption key is kept in memory when suspending the system. This drawback defeats the purpose of encryption if you carry around your suspended laptop a lot. One can use the `cryptsetup luksSuspend` command to freeze all I/O and flush the key from memory, but special care must be taken when applying it to the root device.

This was an attempt to change the default suspend mechanism. The basic idea is to change to a chroot outside of the encrypted root fs and then lock it (with `cryptsetup luksSuspend`).

[Ubuntu Full Disk Encryption]: https://www.eff.org/deeplinks/2012/11/privacy-ubuntu-1210-full-disk-encryption
[Ubuntu Linux]: https://www.ubuntu.com/

For more information on dm-crypt with LUKS check out this [guide for Arch Linux][dm-crypt with LUKS on Arch].

[dm-crypt with LUKS on Arch]: https://wiki.archlinux.org/index.php/Dm-crypt_with_LUKS


Progress
--------

So far the approuch was to change `pm-suspend`. However, there still appears to be some kernel modules loaded that require access to the root fs when trying to suspend (with `echo mem > /sys/power/state`).

_Updated in November/2019:_

This collection of scripts has not seen any development since 2014, and was never functional.  One reason for that could be [a missing patch](https://lwn.net/Articles/582648/) to the kernel (see: #2), but there could be others.

Regardless, by now it is most certainly outdated.  For Ubuntu 14.04, check [this Gist by Andrei Pozolotin](https://gist.github.com/Andrei-Pozolotin/2ab50d4f160c2ed8bd1a).  For other distributions running systemd consult the [ArchLinux Wiki](https://wiki.archlinux.org/index.php/Dm-crypt/Swap_encryption#With_suspend-to-disk_support) or the [original approach taken by Vianney](https://github.com/vianney/arch-luks-suspend).


Installation
------------

_Don't use this directly!_

Based on Ubuntu 14.04 'pm-action' and 'pm-functions' files.


Files
-----

 * 'uls-pm-functions' and 'pm-functions' are (for now) identical
 * 'uls-pm-action' and 'pm-action' differ only by the sourcing of complementary functions in 'uls-pm-luks' and by using these functions for suspend-to-memory and suspend-to-disk
 * 'uls-pm-luks' includes LUKS-aware `do_luks_suspend` and `do_luks_hibernate` functions
 * 'uls-pm-luks-suspend' is the script that runs in the temporary initramfs


Author, base work and license
-----------------------------

Copyright 2013 [Jonas Malaco Filho][] <jonas@jonasmalaco.com>

Based on [work for Arch Linux][arch-luks-suspend] by [Vianney le Clément de Saint-Marcq][]

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; version 3 of the License.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with This program.  If not, see <http://www.gnu.org/licenses/>.

[arch-luks-suspend]:https://github.com/vianney/arch-luks-suspend
[Jonas Malaco Filho]:https://github.com/jonasmalacofilho
[Vianney le Clément de Saint-Marcq]:https://github.com/vianney
