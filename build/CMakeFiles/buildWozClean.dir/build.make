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

# Utility rule file for buildWozClean.

# Include any custom commands dependencies for this target.
include CMakeFiles/buildWozClean.dir/compiler_depend.make

# Include the progress variables for this target.
include CMakeFiles/buildWozClean.dir/progress.make

CMakeFiles/buildWozClean:
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --blue --bold --progress-dir="/media/dominichann/Main Disk/Programming/IDEProjects/Java/6502-Breadboard-ROM/build/CMakeFiles" --progress-num=$(CMAKE_PROGRESS_1) "Cleaned and built WozMon"

buildWozClean: CMakeFiles/buildWozClean
buildWozClean: CMakeFiles/buildWozClean.dir/build.make
.PHONY : buildWozClean

# Rule to build all files generated by this target.
CMakeFiles/buildWozClean.dir/build: buildWozClean
.PHONY : CMakeFiles/buildWozClean.dir/build

CMakeFiles/buildWozClean.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles/buildWozClean.dir/cmake_clean.cmake
.PHONY : CMakeFiles/buildWozClean.dir/clean

CMakeFiles/buildWozClean.dir/depend:
	cd "/media/dominichann/Main Disk/Programming/IDEProjects/Java/6502-Breadboard-ROM/build" && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" "/media/dominichann/Main Disk/Programming/IDEProjects/Java/6502-Breadboard-ROM" "/media/dominichann/Main Disk/Programming/IDEProjects/Java/6502-Breadboard-ROM" "/media/dominichann/Main Disk/Programming/IDEProjects/Java/6502-Breadboard-ROM/build" "/media/dominichann/Main Disk/Programming/IDEProjects/Java/6502-Breadboard-ROM/build" "/media/dominichann/Main Disk/Programming/IDEProjects/Java/6502-Breadboard-ROM/build/CMakeFiles/buildWozClean.dir/DependInfo.cmake" "--color=$(COLOR)"
.PHONY : CMakeFiles/buildWozClean.dir/depend

