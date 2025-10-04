#!/bin/bash
set -e

# Build server package script
echo "🔧 Building chaukas-spec-server package..."

# Clean up previous builds
rm -rf python-server/chaukas python-server/dist python-server/build

# Create the package structure
mkdir -p python-server/chaukas/spec

# Copy common files (shared between client and server)
cp -r .generated/python/chaukas/spec/common python-server/chaukas/spec/

# Copy server-specific files
cp -r .generated/python/chaukas/spec/server python-server/chaukas/spec/

# Copy package metadata files
cp resources/server-init.py python-server/chaukas/spec/__init__.py
cp .generated/python/chaukas/py.typed python-server/chaukas/

# Copy license file
cp LICENSE python-server/

# Build the package
cd python-server
python3 -m build

echo "✅ Server package built successfully!"
echo "📦 Files created:"
ls -la dist/

# Move to main dist directory
cd ..
mkdir -p dist
mv python-server/dist/* dist/