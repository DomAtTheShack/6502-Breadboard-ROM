# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.28

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:

#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:

# Disable VCS-based implicit rules.
% : %,v

# Disable VCS-based implicit rules.
% : RCS/%

# Disable VCS-based implicit rules.
% : RCS/%,v

# Disable VCS-based implicit rules.
% : SCCS/s.%

# Disable VCS-based implicit rules.
% : s.%

.SUFFIXES: .hpux_make_needs_suffix_list

# Command-line flag to silence nested $(MAKE).
$(VERBOSE)MAKESILENT = -s

#Suppress display of executed commands.
$(VERBOSE).SILENT:

# A target that is always out of date.
cmake_force:
.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /usr/bin/cmake

# The command to remove a file.
RM = /usr/bin/cmake -E rm -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = "/media/dominichann/Main Disk/Programming/IDEProjects/Java/6502-Breadboard-ROM"

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = "/media/dominichann/Main Disk/Programming/IDEProjects/Java/6502-Breadboard-ROM/build"

# Utility rule file for clean_generated.

# Include any custom commands dependencies for this target.
include CMakeFiles/clean_generated.dir/compiler_depend.make

# Include the progress variables for this target.
include CMakeFiles/clean_generated.dir/progress.make

CMakeFiles/clean_generated:
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --blue --bold --progress-dir="/media/dominichann/Main Disk/Programming/IDEProjects/Java/6502-Breadboard-ROM/build/CMakeFiles" --progress-num=$(CMAKE_PROGRESS_1) "Cleaning up generated files"
	/usr/bin/cmake -E remove -f /media/dominichann/Main\ Disk/Programming/IDEProjects/Java/6502-Breadboard-ROM/bin/rom.bin /media/dominichann/Main\ Disk/Programming/IDEProjects/Java/6502-Breadboard-ROM/bin/rom.bin.lst /media/dominichann/Main\ Disk/Programming/IDEProjects/Java/6502-Breadboard-ROM/bin/woz.bin /media/dominichann/Main\ Disk/Programming/IDEProjects/Java/6502-Breadboard-ROM/bin/woz.bin.lst a.out

clean_generated: CMakeFiles/clean_generated
clean_generated: CMakeFiles/clean_generated.dir/build.make
.PHONY : clean_generated

# Rule to build all files generated by this target.
CMakeFiles/clean_generated.dir/build: clean_generated
.PHONY : CMakeFiles/clean_generated.dir/build

CMakeFiles/clean_generated.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles/clean_generated.dir/cmake_clean.cmake
.PHONY : CMakeFiles/clean_generated.dir/clean

CMakeFiles/clean_generated.dir/depend:
	cd "/media/dominichann/Main Disk/Programming/IDEProjects/Java/6502-Breadboard-ROM/build" && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" "/media/dominichann/Main Disk/Programming/IDEProjects/Java/6502-Breadboard-ROM" "/media/dominichann/Main Disk/Programming/IDEProjects/Java/6502-Breadboard-ROM" "/media/dominichann/Main Disk/Programming/IDEProjects/Java/6502-Breadboard-ROM/build" "/media/dominichann/Main Disk/Programming/IDEProjects/Java/6502-Breadboard-ROM/build" "/media/dominichann/Main Disk/Programming/IDEProjects/Java/6502-Breadboard-ROM/build/CMakeFiles/clean_generated.dir/DependInfo.cmake" "--color=$(COLOR)"
.PHONY : CMakeFiles/clean_generated.dir/depend

