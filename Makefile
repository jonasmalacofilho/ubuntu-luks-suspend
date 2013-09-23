PM_TOOLS_DIR := /usr/lib/pm-tools/

install:
	install -Dm755 uls-pm-luks "$(PM_TOOLS_DIR)/pm-luks-suspend"
	install -Dm755 uls-pm-luks "$(PM_TOOLS_DIR)/pm-luks"
	install -Dm755 uls-pm-action "$(PM_TOOLS_DIR)/bin/pm-action"
	install -Dm755 uls-pm-functions "$(PM_TOOLS_DIR)/pm-functions"
.PHONY: install

unninstall:
	install -Dm755 pm-functions "$(PM_TOOLS_DIR)/pm-functions"
	install -Dm755 pm-action "$(PM_TOOLS_DIR)/bin/pm-action"
	rm "$(PM_TOOLS_DIR)/pm-luks"
	rm "$(PM_TOOLS_DIR)/pm-luks-suspend"
.PHONY: unninstall
