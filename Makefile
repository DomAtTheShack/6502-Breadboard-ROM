CA65=/usr/bin/ca65
LD65=/usr/bin/ld65
6502c=/usr/bin/6502c
RUN6502=run6502

buildR: main.s
	6502c -dotdir -Fbin main.s
	mv a.out Rom.bin

rom.bin: main.o bios.cfg
	$(LD65) --define sim_putchar=0xFFEE \
			 --define sim_gethar=0xFFEC \
			 --define sim_exit=0xFFEA \
			 -o rom.bin \
			 -C bios.cfg \
			 main.o
	rm -f Rom.bin

main.o: main.s
	$(CA65) main.s

clean:
	rm -f main.o rom.bin a.out Rom.bin

run: rom.bin
	rm Rom.bin
	$(RUN6502) -l 8000 rom.bin -R 8000 -P FFEE -G FFEC -X FFEA

