cmake_minimum_required(VERSION 3.10)
project(DOM02 ASM)

# Common config for Linux and WSL
set(BIN_OUTPUT_DIR ${CMAKE_SOURCE_DIR}/bin)
set(MINIPRO minipro)
set(ASSEMBLER ${CMAKE_SOURCE_DIR}/bin/6502/6502c)
set(CA65 /usr/bin/ca65)
set(LD65 /usr/bin/ld65)

# Output files
set(ROM_BIN ${BIN_OUTPUT_DIR}/rom.bin)
set(ROM_LST ${BIN_OUTPUT_DIR}/rom.bin.lst)
set(WOZ_BIN ${BIN_OUTPUT_DIR}/woz.bin)
set(WOZ_LST ${BIN_OUTPUT_DIR}/woz.bin.lst)
set(WOZ_OBJ ${BIN_OUTPUT_DIR}/woz.o)

# Ensure output directory exists
file(MAKE_DIRECTORY ${BIN_OUTPUT_DIR})

# ROM build
add_custom_command(
    OUTPUT ${ROM_BIN}
    COMMAND ${ASSEMBLER} -dotdir -Fbin -L ${ROM_LST} ${CMAKE_SOURCE_DIR}/main.s
    COMMAND ${CMAKE_COMMAND} -E rename a.out ${ROM_BIN}
    DEPENDS main.s serial.s lcd.s
    COMMENT "Assembling ROM to ${ROM_BIN}"
)

add_custom_target(buildR ALL DEPENDS ${ROM_BIN})

# WozMon build
add_custom_command(
    OUTPUT ${WOZ_BIN}
    COMMAND ${CA65} -o ${WOZ_OBJ} ${CMAKE_SOURCE_DIR}/wozmon.s
    COMMAND ${LD65} -C ${CMAKE_SOURCE_DIR}/rom.cfg -o ${WOZ_BIN} ${BIN_OUTPUT_DIR}/woz.o
    COMMAND ${MINIPRO} -p at28c256 -w ${WOZ_BIN}
    DEPENDS wozmon.s
    COMMENT "Assembling WozMon to ${WOZ_BIN}"
)

add_custom_target(buildWoz DEPENDS ${WOZ_BIN})

# Flash target
add_custom_target(WriteChip
    COMMAND ${MINIPRO} -p at28c256 -w ${ROM_BIN}
    DEPENDS ${ROM_BIN}
    COMMENT "Writing ROM to EEPROM using Minipro"
)

# Clean rule
add_custom_target(clean_generated
    COMMAND ${CMAKE_COMMAND} -E remove -f ${ROM_BIN} ${ROM_LST} ${WOZ_BIN} ${WOZ_LST} a.out
    COMMENT "Cleaning up generated files"
)


# Combined: Clean + Build + Flash for ROM
add_custom_target(flashR ALL
    DEPENDS clean_generated buildR WriteChip
    COMMENT "Cleaned, built, and flashed ROM"
)

# Combined: Clean + Build for WozMon
add_custom_target(buildWozClean
    DEPENDS clean_generated buildWoz
    COMMENT "Cleaned and built WozMon"
)
