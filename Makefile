# Makefile for love-scenes project

.PHONY: test demo lint clean package install help

# Default target
all: test

# Run tests
test:
	@echo "Running tests..."
	@lua tests/run_tests.lua

# Run demo
demo:
	@echo "Starting love-scenes demo..."
	@love .

# Check code with luacheck (if available)
lint:
	@echo "Checking code style..."
	@if command -v luacheck >/dev/null 2>&1; then \
		luacheck --config .luacheckrc *.lua scenes/; \
	else \
		echo "luacheck not found. Install with: luarocks install luacheck"; \
		exit 1; \
	fi

# Clean generated files
clean:
	@echo "Cleaning up..."
	@rm -f *.rock
	@rm -rf build/

# Package for LuaRocks
package: test
	@echo "Creating rock package..."
	@luarocks pack love-scenes-1.0-1.rockspec

# Install locally for development
install: package
	@echo "Installing locally..."
	@luarocks install --local love-scenes-1.0-1.rockspec

# Install development dependencies
dev-deps:
	@echo "Installing development dependencies..."
	@echo "Installing luacheck..."
	@luarocks install --local luacheck
	@echo "Installing ldoc..."
	@luarocks install --local ldoc
	@echo "Installing busted (optional test framework)..."
	@luarocks install --local busted || echo "Busted installation failed (optional)"
	@echo "Development dependencies installed!"

# Build documentation with ldoc
docs:
	@echo "Generating documentation with LDoc..."
	@if command -v ldoc >/dev/null 2>&1; then \
		ldoc -c config.ld .; \
		echo "Documentation generated in docs/ directory"; \
	else \
		echo "LDoc not found. Install with: luarocks install ldoc"; \
		exit 1; \
	fi

# Run type checking (if available)
typecheck:
	@echo "Running type checking..."
	@if command -v lua-language-server >/dev/null 2>&1; then \
		echo "Type checking with lua-language-server..."; \
		lua-language-server --check .; \
	else \
		echo "lua-language-server not found for type checking"; \
	fi

# Quick development cycle: test + demo
dev: test demo

# Check everything before release
ci: lint test typecheck docs
	@echo "All checks passed! ✅"

# Pre-commit hook
pre-commit: lint test
	@echo "Pre-commit checks passed! ✅"

# Show available targets
help:
	@echo "Available targets:"
	@echo "  test        - Run all tests"
	@echo "  demo        - Run the demo application"
	@echo "  lint        - Check code style with luacheck"
	@echo "  clean       - Clean generated files"
	@echo "  package     - Create LuaRocks package"
	@echo "  install     - Install locally for development"
	@echo "  dev-deps    - Install development dependencies"
	@echo "  docs        - Generate documentation with LDoc"
	@echo "  typecheck   - Run type checking"
	@echo "  dev         - Quick dev cycle (test + demo)"
	@echo "  ci          - Run all checks for CI (lint + test + typecheck + docs)"
	@echo "  pre-commit  - Run pre-commit checks (lint + test)"
	@echo "  help        - Show this help"
