.feature force_range
.debuginfo +

.ifdef DARWIN
.setcpu "65c02"
.else
.setcpu "6502"
.endif
.macpack longbranch

.include "defines.s"
.include "macros.s"
.include "zeropage.s"

.include "header.s"
.include "token.s"
.include "error.s"
.include "message.s"
.include "memory.s"
.include "program.s"
.include "flow1.s"
.include "loadsave.s"
.include "flow2.s"
.include "misc1.s"
.include "print.s"
.include "input.s"
.include "eval.s"
.include "var.s"
.include "array.s"
.include "misc2.s"
.include "string.s"
.include "misc3.s"
.include "poke.s"
.include "float.s"
.include "chrget.s"
.include "rnd.s"
.include "trig.s"
.include "init.s"
.include "extra.s"
.include "lcd.s"
.include "video.s"
.include "sound.s"

