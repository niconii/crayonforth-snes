INPUT    = main.asm
OUTPUT   = program.sfc

TOOLSSRC = $(wildcard tools/*.rs)
TOOLS    = $(patsubst tools/%.rs,build/tools/%,$(TOOLSSRC))

GFXSRC   = $(wildcard gfx/*.pcx)
GFX      = $(patsubst gfx/%.pcx,build/gfx/%,$(GFXSRC))

all: dir $(TOOLS) $(GFX) build/$(OUTPUT)

dir:
	mkdir -p build/tools/
	mkdir -p build/gfx/

build/$(OUTPUT): $(TOOLS) $(GFX)
	bass -strict $(INPUT) -o build/$(OUTPUT)
	build/tools/checksum build/$(OUTPUT)

$(TOOLS): build/tools/% : tools/%.rs
	rustc -O $< -o $@

$(GFX): build/gfx/% : gfx/%.pcx
	build/tools/pcx2snes $<
	mv $<.til $@

clean:
	rm -r build/
