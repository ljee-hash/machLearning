# Makefile to build books

.PHONY: clean build

clean:
	rm -rf _book

build:
	gitbook init
	gitbook serve
