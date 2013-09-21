INSTALL_DIR := /usr/lib/ubuntu-luks-suspend

all: install
.PHONY: all

install:
	install -Dm755 ubuntu-luks-suspend "$(INSTALL_DIR)/ubuntu-luks-suspend"
	install -Dm755 initramfs-suspend "$(INSTALL_DIR)/initramfs-suspend"
	install -Dm755 initramfs-hook "/etc/initramfs-tools/hooks/suspend"
	update-initramfs -u
	install -Dm644 systemd-suspend.service "/etc/systemd/system/systemd-suspend.service"
.PHONY: install

unninstall:
	rm /etc/systemd/system/systemd-suspend.service
	rm /etc/initramfs-tools/hooks/suspend
	update-initramfs -u
	rm -Rf $(INSTALL_DIR)/ubuntu-lunks-suspend
.PHONY: unninstall
