INPUT    = src/main.asm
OUTPUT   = program.sfc

SOURCE   = $(wildcard src/*.asm) $(wildcard src/*.inc)

DIRS     = build/tools build/fonts

TOOLSSRC = $(wildcard tools/*.rs)
TOOLS    = $(patsubst tools/%.rs,build/tools/%,$(TOOLSSRC))

FONTSSRC = fonts/font0.1bpp.pcx fonts/font1.1bpp.pcx

all: $(DIRS) $(TOOLS) fonts build/$(OUTPUT)

$(DIRS):
	mkdir -p $@

build/$(OUTPUT): $(SOURCE) $(TOOLS) fonts
	tools/build.sh >build/build.asm
	ca65 $(INPUT) -o build/program.o --listing build/program.lst
	ld65 -C lorom.ld build/program.o -o $@
	build/tools/checksum $@

$(TOOLS): build/tools/% : tools/%.rs
	rustc -O $< -o $@

fonts: $(TOOLS) $(FONTSSRC)
	build/tools/pcx2snes --1+1bpp fonts/font0.1bpp.pcx fonts/font1.1bpp.pcx build/fonts/font0+font1.2bpp
	build/tools/pcx2snes --64x32font fonts/font0.1bpp.pcx fonts/font1.1bpp.pcx build/fonts/font0+font1.evens.2bpp build/fonts/font0+font1.odds.2bpp

clean:
	rm -r build/
