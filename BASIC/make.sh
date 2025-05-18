
for i in darwin; do

echo $i
ca65 -D $i msbasic.s -o ../bin/$i.o &&
ld65 -C $i.cfg ../bin/$i.o -o ../bin/$i.bin -Ln ../bin/$i.lbl

done

