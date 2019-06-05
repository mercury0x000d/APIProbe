asflags = -f bin

build:
	./xenops --file main.asm
	nasm $(asflags) -o ap.com main.asm
	virtualbox --startvm "FreeDOS" --debug-command-line --start-running
