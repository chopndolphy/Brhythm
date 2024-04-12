# Directories
SRC = src
BUILD = build
INCLUDE = include
GRAPHICS = graphics
AUDIO = audio
LIB = lib
DOC = doc

ALL_INCLUDES = -I./$(LIB) -I./$(INCLUDE) -I./$(INCLUDE)/$(AUDIO) -I./$(INCLUDE)/$(GRAPHICS) -I./$(GLM) -I./$(STB_IMAGE) -I./$(VKBOOTSTRAP)/src -I./$(VMA)
GLM = $(LIB)/glm
STB_IMAGE = $(LIB)/stb_image
VKBOOTSTRAP = $(LIB)/vkbootstrap
VMA = $(LIB)/vma

# Compiler and flags
CC = gcc
CXX = g++
CFLAGS = -Wall -O2 -g $(ALL_INCLUDES)
# CFLAGS = -Wall -ggdb -O3 $(INCLUDES)
CXXFLAGS = -std=c++17 -O2 -Wall -Wextra -pedantic -g -O2 -D_GLIBCXX_DEBUG $(ALL_INCLUDES)
# CXXFLAGS = -Wall -ggdb -O3 $(INCLUDES)
LDFLAGS = -lglfw -lX11 -lpthread -lXrandr -lXi -ldl -lvulkan -L$(VKBOOTSTRAP)/build -lvk-bootstrap

# SHARED OBJECTS AND TARGETS  (Targets are executables)

# Shared objects by multiple executables
CPP_FILES := Engine.cpp Window.cpp
OBJECTS := $(CPP_FILES:.cpp=.o) stb_image.o vk_mem_alloc.o  
OBJECTS := $(addprefix $(BUILD)/, $(OBJECTS))

# Targets
CPP_EXEC := brhythm.cpp
TARGETS_OBJ := $(CPP_EXEC:%.cpp=$(BUILD)/%.o)
TARGETS := $(TARGETS_OBJ:%.o=%)

# RECIPES
all: $(TARGETS)

# executables depend on shared objects
$(TARGETS): $(OBJECTS) 

# Link
# Secondary expansions allow to use the automatic variable $@ in the prerequisites list.
# https://www.gnu.org/software/make/manual/html_node/Secondary-Expansion.html
.SECONDEXPANSION:
$(TARGETS): $(OBJECTS) $$@.o 
	$(CXX) -o $@ $^ $(LDFLAGS)

# Compile objects
# Order of recipes matter. Recipe 2 has to be before recipe 3 to take into account .h prerrequisites. 

#stb_image:
$(BUILD)/stb_image.o: $(STB_IMAGE)/stb_image.cpp $(STB_IMAGE)/stb_image.h | $(BUILD)
	$(CXX) $(CXXFLAGS) -c $< -o $@

#vma:
$(BUILD)/vk_mem_alloc.o: $(VMA)/vk_mem_alloc.cpp $(VMA)/vk_mem_alloc.h | $(BUILD)
	$(CXX) $(CXXFLAGS) -c $< -o $@

# recipe 2: compile objects - cpp files with header files
$(BUILD)/%.o: $(SRC)/%.cpp $(INCLUDE)/%.h | $(BUILD)
	$(CXX) $(CXXFLAGS) -c $< -o $@ 

# recipe 3: compile executables - cpp files without header files
$(BUILD)/%.o: $(SRC)/%.cpp | $(BUILD)
	$(CXX) $(CXXFLAGS) -c $< -o $@    

# recipe 2: compile objects - cpp files with header files
$(BUILD)/%.o: $(SRC)/$(AUDIO)/%.cpp $(INCLUDE)/%.h | $(BUILD)
	$(CXX) $(CXXFLAGS) -c $< -o $@ 

# recipe 3: compile executables - cpp files without header files
$(BUILD)/%.o: $(SRC)/$(AUDIO)/%.cpp | $(BUILD)
	$(CXX) $(CXXFLAGS) -c $< -o $@    

# recipe 2: compile objects - cpp files with header files
$(BUILD)/%.o: $(SRC)/$(GRAPHICS)/%.cpp $(INCLUDE)/%.h | $(BUILD)
	$(CXX) $(CXXFLAGS) -c $< -o $@ 

# recipe 3: compile executables - cpp files without header files
$(BUILD)/%.o: $(SRC)/$(GRAPHICS)/%.cpp | $(BUILD)
	$(CXX) $(CXXFLAGS) -c $< -o $@    

# PHONY
.PHONY: all clean run

clean:
	rm -rf $(BUILD)

run: $(TARGETS)
	./$(BUILD)/brhythm

$(BUILD):
	mkdir -p $(BUILD)