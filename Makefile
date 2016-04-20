#!/usr/bin/make

CONFIG   := Release
CARTHAGE := /usr/local/bin/carthage

default: archive

.PHONY: build
build:
	@$(CARTHAGE) build --no-skip-current

.PHONY: archive
archive: build
	@$(CARTHAGE) archive

