#!/bin/bash
set -e

# Build client package script
echo "🔧 Building chaukas-spec-client package..."

# Clean up previous builds
rm -rf python-client/chaukas python-client/dist python-client/build

# Create the package structure
mkdir -p python-client/chaukas/spec

# Copy common files (shared between client and server)
cp -r .generated/python/chaukas/spec/common python-client/chaukas/spec/

# Copy client-specific files  
cp -r .generated/python/chaukas/spec/client python-client/chaukas/spec/

# Copy package metadata files
cp resources/client-init.py python-client/chaukas/spec/__init__.py
cp .generated/python/chaukas/py.typed python-client/chaukas/

# Copy license file
cp LICENSE python-client/

# Build the package
cd python-client
python3 -m build

echo "✅ Client package built successfully!"
echo "📦 Files created:"
ls -la dist/

# Move to main dist directory
cd ..
mkdir -p dist
mv python-client/dist/* dist/