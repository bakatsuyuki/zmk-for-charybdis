SHELL := /bin/bash

# Zephyr SDK (defaults; override if必要)
export ZEPHYR_TOOLCHAIN_VARIANT ?= zephyr
export ZEPHYR_SDK_INSTALL_DIR ?= $(HOME)/.local/zephyr-sdk/zephyr-sdk-0.16.3

# Build config (minimal)
ZMK_CONFIG ?= $(CURDIR)/config
BOARD ?= nice_nano_v2
LEFT_BUILD_DIR ?= build_left
RIGHT_BUILD_DIR ?= build_right
DIST_DIR ?= dist

.PHONY: build left right clean distclean

build: left right

left:
	@test -d .west || west init -l config
	west build -p always -s zmk/app -d $(LEFT_BUILD_DIR) -b $(BOARD) -- -DZMK_CONFIG=$(ZMK_CONFIG) -DSHIELD=charybdis_left
	@mkdir -p $(DIST_DIR)
	cp $(LEFT_BUILD_DIR)/zephyr/zmk.uf2 $(DIST_DIR)/charybdis_left.uf2

right:
	@test -d .west || west init -l config
	west build -p always -s zmk/app -d $(RIGHT_BUILD_DIR) -b $(BOARD) -- -DZMK_CONFIG=$(ZMK_CONFIG) -DSHIELD=charybdis_right
	@mkdir -p $(DIST_DIR)
	cp $(RIGHT_BUILD_DIR)/zephyr/zmk.uf2 $(DIST_DIR)/charybdis_right.uf2

clean:
	rm -rf $(LEFT_BUILD_DIR) $(RIGHT_BUILD_DIR)

distclean: clean
	rm -rf $(DIST_DIR)


