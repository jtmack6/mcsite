#!/bin/bash

# Build script for Hugo site with Last.fm integration
set -e

echo "Fetching recent scrobbles..."
go run scripts/fetch-scrobbles.go

echo "Building Hugo site..."
hugo --minify

echo "Build complete!" 