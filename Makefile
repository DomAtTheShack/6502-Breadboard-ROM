CA65=/usr/bin/ca65
LD65=/usr/bin/ld65
6502c=/usr/bin/6502c
RUN6502=run6502
.DEFAULT_GOAL := rom.bin


buildR: main.s
	./6502c -dotdir -Fbin -L rom.bin.lst emuMain.s
	mv a.out rom.bin

buildWoz: main.s
	./6502c -dotdir -Fbin -L woz.bin.lst wozmon.s
	mv a.out woz.bin

rom.bin: main.o bios.cfg
	$(LD65) --define sim_putchar=0xFFEE \
			 --define sim_gethar=0xFFEC \
			 --define sim_exit=0xFFEA \
			 -o rom.bin \
			 -C bios.cfg \
			 main.o


main.o: main.s
	$(CA65) main.s

WriteChip:
	minipro -p at28c256 -w rom.bin

clean:
	rm -f main.o rom.bin a.out

run: rom.bin
	$(RUN6502) -l 8000 rom.bin -R 8000 -P FFEE -G FFEC -X FFEA

