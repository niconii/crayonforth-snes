INPUT    = main.asm
OUTPUT   = program.sfc

SOURCE   = $(wildcard *.asm) $(wildcard *.inc)

DIRS     = build/tools build/gfx

TOOLSSRC = $(wildcard tools/*.rs)
TOOLS    = $(patsubst tools/%.rs,build/tools/%,$(TOOLSSRC))

GFXSRC   = $(wildcard gfx/*.pcx)
GFX      = $(patsubst gfx/%.pcx,build/gfx/%,$(GFXSRC))

all: $(DIRS) $(TOOLS) build/gfx/font0+font1.2bpp build/$(OUTPUT)

$(DIRS):
	mkdir -p $@

build/$(OUTPUT): $(SOURCE) $(TOOLS) build/gfx/font0+font1.2bpp
	tools/build.sh >build/build.asm
	ca65 main.asm -o build/main.o --listing build/program.lst
	ld65 -C lorom.ld build/main.o -o $@
	build/tools/checksum $@

$(TOOLS): build/tools/% : tools/%.rs
	rustc -O $< -o $@

build/gfx/font0+font1.2bpp:
	build/tools/pcx2snes --1+1bpp gfx/font0.1bpp.pcx gfx/font1.1bpp.pcx $@

clean:
	rm -r build/
