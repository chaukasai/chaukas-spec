# Copyright 2025 Chaukas AI
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0

.PHONY: gen-python gen-go gen-all clean-python clean-go clean-all lint install-client install-server build-client build-server build-packages test-packages clean-packages

# Generate all code (Python + Go)
gen-all: clean-all
	buf generate
	@$(MAKE) create-python-init-files
	@echo "✅ All code generated successfully"

# Generate Python code only (for packages)
gen-python: clean-python  
	buf generate
	@$(MAKE) create-python-init-files
	@echo "✅ Python code ready for packaging"

# Generate Go code only
gen-go: clean-go
	buf generate
	@echo "✅ Go code generated in chaukas/spec/"

# Clean generated Python files
clean-python:
	rm -rf .generated/python

# Clean generated Go files
clean-go:
	rm -rf chaukas

# Clean all generated files
clean-all: clean-python clean-go

# Build and install client package for development
install-client: build-client
	pip3 install --force-reinstall dist/chaukas-spec-client-*.whl

# Build and install server package for development  
install-server: build-server
	pip3 install --force-reinstall dist/chaukas-spec-server-*.whl

# Lint proto files
lint:
	buf lint

# Format proto files
format:
	buf format --write

# Check for breaking changes
breaking:
	buf breaking --against '.git#branch=main'

# Build client package
build-client:
	./scripts/build-client.sh

# Build server package
build-server:
	./scripts/build-server.sh

# Build both packages
build-packages: build-client build-server
	@echo "✅ All packages built successfully!"
	@echo "📦 Available packages:"
	@ls -la dist/

# Test package installations
test-packages: build-packages
	@echo "🧪 Testing client package..."
	pip3 install --force-reinstall dist/chaukas-spec-client-*.whl
	python3 -c "from chaukas.spec.client.v1.client_pb2_grpc import ChaukasClientServiceStub; print('✅ Client package works')"
	pip3 uninstall -y chaukas-spec-client
	
	@echo "🧪 Testing server package..."
	pip3 install --force-reinstall dist/chaukas-spec-server-*.whl
	python3 -c "from chaukas.spec.server.v1.server_pb2_grpc import ChaukasServerServiceServicer; print('✅ Server package works')"
	pip3 uninstall -y chaukas-spec-server
	
	@echo "✅ All packages test successfully!"

# Clean package builds
clean-packages:
	rm -rf dist/
	rm -rf python-client/chaukas python-client/dist python-client/build
	rm -rf python-server/chaukas python-server/dist python-server/build
	find . -name "*.egg-info" -type d -exec rm -rf {} \; 2>/dev/null || true

# Create Python __init__.py and py.typed files
create-python-init-files:
	@echo "Creating Python package files..."
	mkdir -p .generated/python/chaukas/spec/client/v1
	mkdir -p .generated/python/chaukas/spec/common/v1
	mkdir -p .generated/python/chaukas/spec/server/v1
	
	# Create __init__.py files
	touch .generated/python/chaukas/__init__.py
	touch .generated/python/chaukas/spec/__init__.py
	touch .generated/python/chaukas/spec/client/__init__.py
	touch .generated/python/chaukas/spec/client/v1/__init__.py
	touch .generated/python/chaukas/spec/common/__init__.py
	touch .generated/python/chaukas/spec/common/v1/__init__.py
	touch .generated/python/chaukas/spec/server/__init__.py
	touch .generated/python/chaukas/spec/server/v1/__init__.py
	
	# Create py.typed file
	touch .generated/python/chaukas/py.typed

# Full clean including packages and generated files
clean-all-packages: clean-all clean-packages
	rm -rf .generated/