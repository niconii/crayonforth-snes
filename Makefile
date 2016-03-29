INPUT    = main.asm
OUTPUT   = program.sfc

SOURCE   = $(wildcard *.asm) $(wildcard *.inc)

DIRS     = build/tools build/gfx

TOOLSSRC = $(wildcard tools/*.rs)
TOOLS    = $(patsubst tools/%.rs,build/tools/%,$(TOOLSSRC))

GFXSRC   = $(wildcard gfx/*.pcx)
GFX      = $(patsubst gfx/%.pcx,build/gfx/%,$(GFXSRC))

all: $(DIRS) $(TOOLS) $(GFX) build/$(OUTPUT)

$(DIRS):
	mkdir -p $@

build/$(OUTPUT): $(SOURCE) $(TOOLS) $(GFX)
	tools/build.sh >build/build.asm
	ca65 main.asm -o build/main.o
	ld65 -C lorom.ld build/main.o -o $@
	build/tools/checksum $@

$(TOOLS): build/tools/% : tools/%.rs
	rustc -O $< -o $@

$(GFX): build/gfx/% : gfx/%.pcx
	build/tools/pcx2snes $<
	mv $<.til $@

clean:
	rm -r build/
