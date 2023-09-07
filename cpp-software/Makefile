TARGET_EXEC := main
TEST_EXEC := test
CXX := clang++

BUILD_DIR := ./build
SRC_DIRS := ./src

# Find all the C and C++ files we want to compile
# Note the single quotes around the * expressions. Make will incorrectly expand these otherwise.
MAIN_SRC := ./src/main.cpp
TEST_SRC := ./src/test.cpp ./src/catch/catchmain.cpp
SRCS := $(filter-out $(MAIN_SRC) $(TEST_SRC) ./src/catch.hpp, $(shell find $(SRC_DIRS) -name '*.cpp' -or -name '*.s'))

# String substitution for every C++ file
# As an example, hello.cpp turns into ./build/hello.cpp.o
OBJS := $(SRCS:%=$(BUILD_DIR)/%.o)
MAIN_OBJ := $(MAIN_SRC:%=$(BUILD_DIR)/%.o)
TEST_OBJ := $(TEST_SRC:%=$(BUILD_DIR)/%.o)

# String substitution (suffix version without %).
# As an example, ./build/hello.cpp.o turns into ./build/hello.cpp.d
DEPS := $(OBJS:.o=.d)
MAIN_DEP := $(MAIN_OBJ:.o=.d)
TEST_DEP := $(TEST_OBJ:.o=.d)

# Every folder in ./src will need to be passed to GCC so that it can find header files
INC_DIRS := $(shell find $(SRC_DIRS) -type d)
# Add a prefix to INC_DIRS. So moduleA would become -ImoduleA. GCC understands this -I flag
INC_FLAGS := $(addprefix -I,$(INC_DIRS)) 

# The -MMD and -MP flags together generate Makefiles for us!
# These files will have .d instead of .o as the output.
CPPFLAGS := $(INC_FLAGS) -MMD -MP -std=c++17 -O3

$(TARGET_EXEC): $(OBJS) $(MAIN_OBJ)
	$(CXX) $(OBJS) $(MAIN_OBJ) -o $@ $(LDFLAGS)

$(TEST_EXEC): $(OBJS) $(TEST_OBJ)
	$(CXX) $(OBJS) $(TEST_OBJ) -o $@ $(LDFLAGS)

# Build step for C++ source
$(BUILD_DIR)/%.cpp.o: %.cpp
	mkdir -p $(dir $@)
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c $< -o $@


.PHONY: clean
clean:
ifneq ("$(wildcard $(BUILD_DIR))","")
	rm -r $(BUILD_DIR)
endif
ifneq ("$(wildcard $(TARGET_EXEC))","")
	rm $(TARGET_EXEC)
endif
ifneq ("$(wildcard $(TEST_EXEC))","")
	rm $(TEST_EXEC)
endif

# Include the .d makefiles. The - at the front suppresses the errors of missing
# Makefiles. Initially, all the .d files will be missing, and we don't want those
# errors to show up.
-include $(DEPS)
-include $(MAIN_DEP)
-include $(TEST_DEP)