.PHONY: serve serve-drafts build clean scrobbles build-full update-deps help

help:
	@echo "Available targets:"
	@echo "  serve        - Start development server at localhost:1313"
	@echo "  serve-drafts - Start development server with draft posts"
	@echo "  build        - Build the site"
	@echo "  clean        - Clean build and rebuild"
	@echo "  scrobbles    - Fetch latest Last.fm scrobbles"
	@echo "  build-full   - Fetch scrobbles and build site"
	@echo "  update-deps  - Update Go dependencies"

serve:
	hugo server

serve-drafts:
	hugo server -D

build:
	hugo

clean:
	hugo --cleanDestinationDir

scrobbles:
	go run scripts/fetch-scrobbles.go

build-full:
	./scripts/build.sh

update-deps:
	go get -u ./...
	go mod tidy
