# ============================================================
# Strict CPP Project Makefile
# Compiler: G++
# ============================================================

CXX := g++

# ============================================================
# Project
# ============================================================

TARGET_NAME := project_name

# ============================================================
# DIrectories
# ============================================================

TARGET_DIR := target
BUILD_DIR := build

TARGET := $(TARGET_DIR)/$(TARGET_NAME)

# ============================================================
# SOURCE FILES
#
# Manually add every .c file here.
# DO NOT use wildcards, find, or automatic source discovery.
# ============================================================

SOURCES := \
	main.cpp

# ============================================================
# OBJECT FILES
#
# Object files are generated from the manually specified
# source list above.
# main.cpp
#    -> build/main.o
# src/io/reader.cpp
#    -> build/io/reader.o
# ============================================================

#OBJECTS := $(SOURCES:.c=.o)
OBJECTS := $(patsubst %.cpp,$(BUILD_DIR)/%.o,$(SOURCES))

# ============================================================
# Dependency files:
#
#   main.cpp
#       -> build/main.d
#
#   src/io/reader.cpp
#       -> build/src/io/reader.d
# ============================================================

DEPS := $(OBJECTS:.o=.d)

# ============================================================
# C STANDARD
# ============================================================

CXXSTD := -std=c++17

# ============================================================
# WARNING FLAGS
# ============================================================

WARNINGS := \
	-Wall \
	-Wextra \
	-Wpedantic \
	-Werror \
	-Wshadow \
	-Wconversion \
	-Wsign-conversion \
	-Wcast-qual \
	-Wcast-align \
	-Wwrite-strings \
	-Wformat=2 \
	-Wundef \
	-Wstrict-overflow=5 \
	-Wswitch \
	-Wswitch-enum \
	-Wunreachable-code \
	-Wnull-dereference \
	-Wdouble-promotion \
	-Wfloat-equal \
	-Wpointer-arith \
	-Wvla \
	-Winit-self \
	-Wlogical-op \
	-Wduplicated-cond \
	-Wduplicated-branches \
	-Wformat-overflow=2 \
	-Wformat-truncation=2 \
	-Wimplicit-fallthrough=5 \
	-Wnon-virtual-dtor \
	-Woverloaded-virtual \
	-Wold-style-cast \
	-Wuseless-cast \
	-Wzero-as-null-pointer-constant \
	-Wextra-semi \
	-Wctor-dtor-privacy \
	-Woverlength-strings \
	-Wsuggest-override \
	-Wconditionally-supported \
	-Wmissing-declarations \
	-Wmissing-field-initializers

# ============================================================
# DEBUG / DEVELOPMENT FLAGS
# ============================================================

DEBUG_FLAGS := \
	-g3 \
	-O0

# ============================================================
# DEPENDENCY GENERATION
#
# GCC automatically generates .d files containing header
# dependencies.
# ============================================================

DEPFLAGS := \
	-MMD \
	-MP

# ============================================================
# ALL COMPILER FLAGS
# ============================================================

CXXFLAGS := \
	$(CXXSTD) \
	$(WARNINGS) \
	$(DEBUG_FLAGS) \
	$(DEPFLAGS)

# ============================================================
# LINKER FLAGS
# ============================================================

LDFLAGS :=

LDLIBS :=

# ============================================================
# DEFAULT TARGET
# ============================================================

.PHONY: all
all: $(TARGET)

# ============================================================
# LINK
# ============================================================

$(TARGET): $(OBJECTS)
	@mkdir -p $(dir $@)
	$(CXX) $(OBJECTS) $(LDFLAGS) $(LDLIBS) -o $@

# ============================================================
# COMPILE
#
# The directory for the .o file is created automatically.
#
# Example:
#
#   src/io/reader.cpp
#
# becomes:
#
#   build/src/io/reader.o
#
# ==========================================================

$(BUILD_DIR)/%.o: %.cpp
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS) -c $< -o $@

# ============================================================
# HEADER DEPENDENCIES
# ============================================================

-include $(DEPS)

# ============================================================
# CLEAN
# ============================================================

.PHONY: clean
clean:
	rm -rf $(BUILD_DIR)
	rm -rf $(TARGET_DIR)

# ============================================================
# REBUILD
# ============================================================

.PHONY: rebuild
rebuild: clean all

# ============================================================
# RUN
# ============================================================

.PHONY: run
run: $(TARGET)
	./$(TARGET)

# ============================================================
# SANITIZERS
#
# Useful for finding memory errors and undefined behavior.
# ============================================================

.PHONY: sanitize
sanitize:
	$(MAKE) clean
	$(MAKE) CXXFLAGS="$(CXXSTD) $(WARNINGS) -g3 -O0 -fsanitize=address,undefined -fno-omit-frame-pointer $(DEPFLAGS)" all

# ============================================================
# HELP
# ============================================================

.PHONY: help
help:
	@echo "Available targets:"
	@echo "  make          Build the project"
	@echo "  make clean    Remove generated files"
	@echo "  make rebuild  Clean and rebuild"
	@echo "  make run      Build and run"
	@echo "  make sanitize Build with sanitizers"
