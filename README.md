ubuntu-luks-suspend
===================

A script for [Ubuntu Linux][] to lock the encrypted root volume on suspend.

When using [Ubuntu Full Disk Encryption][] (that is based on dm-crypt with LUKS) to set up full system encryption, the encryption key is kept in memory when suspending the system. This drawback defeats the purpose of encryption if you carry around your suspended laptop a lot. One can use the `cryptsetup luksSuspend` command to freeze all I/O and flush the key from memory, but special care must be taken when applying it to the root device.

The `ubuntu-linux-suspend` script replaces the default suspend mechanism of systemd. It changes root to initramfs in order to perform the `luksSuspend`, actual suspend, and `luksResume` operations. It relies on the `shutdown` initcpio hook to provide access to the initramfs.

[Ubuntu Full Disk Encryption]: https://www.eff.org/deeplinks/2012/11/privacy-ubuntu-1210-full-disk-encryption
[Ubuntu Linux]: https://www.ubuntu.com/

For more information on dm-crypt with LUKS check out this [guide for Arch Linux][dm-crypt with LUKS on Arch].

[dm-crypt with LUKS on Arch]: https://wiki.archlinux.org/index.php/Dm-crypt_with_LUKS


Installation
------------

Don't use this directly!

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
Heavily based on [work for Arch Linux][arch-luks-suspend] by [Vianney le Clément de Saint-Marcq][]

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; version 3 of the License.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with This program.  If not, see <http://www.gnu.org/licenses/>.

[arch-luks-suspend]:https://github.com/vianney/arch-luks-suspend
[Jonas Malaco Filho]:https://github.com/jonasmalacofilho
[Vianney le Clément de Saint-Marcq]:https://github.com/vianney
