CA65=/usr/bin/ca65
LD65=/usr/bin/ld65
RUN6502=run6502

rom.bin: main.o bios.cfg
	$(LD65) --define sim_putchar=0xFFEE \
			 --define sim_gethar=0xFFEC \
			 --define sim_exit=0xFFEA \
			 -o rom.bin \
			 -C bios.cfg \
			 main.o

main.o: main.s
	$(CA65) main.s

clean:
	rm -f main.o rom.bin

run: rom.bin
	$(RUN6502) -l 8000 rom.bin -R 8000 -P FFEE -G FFEC -X FFEA

