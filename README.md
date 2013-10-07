ubuntu-luks-suspend
===================

_An attempt to make [Ubuntu Linux][] lock the encrypted root volume uppon suspending (to RAM)_


About
-----

When using [Ubuntu Full Disk Encryption][] (that is based on dm-crypt with LUKS) to set up full system encryption, the encryption key is kept in memory when suspending the system. This drawback defeats the purpose of encryption if you carry around your suspended laptop a lot. One can use the `cryptsetup luksSuspend` command to freeze all I/O and flush the key from memory, but special care must be taken when applying it to the root device.

So, this is an attempt to change the default suspend mechanism. The basic idea is to change to a chroot outside of the encrypted root fs and then lock it (with `cryptsetup luksSuspend`).

[Ubuntu Full Disk Encryption]: https://www.eff.org/deeplinks/2012/11/privacy-ubuntu-1210-full-disk-encryption
[Ubuntu Linux]: https://www.ubuntu.com/

For more information on dm-crypt with LUKS check out this [guide for Arch Linux][dm-crypt with LUKS on Arch].

[dm-crypt with LUKS on Arch]: https://wiki.archlinux.org/index.php/Dm-crypt_with_LUKS


Progress
--------

So far the approuch was to change `pm-suspend`. However, there still appears to be some kernel modules loaded that require access to the root fs when trying to suspend (with `echo mem > /sys/power/state`).


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
