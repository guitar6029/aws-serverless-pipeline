#!/bin/bash

set -e

echo "Cleaning previous build..."

rm -rf build
rm -f handler.zip

echo "Creating build directory..."

mkdir build

echo "Installing dependencies..."

uv export --no-hashes > requirements.txt

uv pip install -r requirements.txt --target build

echo "Copying source files..."

cp handler.py build/
cp -r models build/
cp -r processors build/
cp -r repositories build/

echo "Creating deployment package..."

cd build
zip -r ../handler.zip .
cd ..

echo "Build complete."
