INPUT    = main.asm
OUTPUT   = program.sfc

SOURCE   = $(wildcard *.asm)

TOOLSSRC = $(wildcard tools/*.rs)
TOOLS    = $(patsubst tools/%.rs,build/tools/%,$(TOOLSSRC))

GFXSRC   = $(wildcard gfx/*.pcx)
GFX      = $(patsubst gfx/%.pcx,build/gfx/%,$(GFXSRC))

all: dir $(TOOLS) $(GFX) build/$(OUTPUT)

dir: build/tools build/gfx

build/tools:
	mkdir -p build/tools/

build/gfx:
	mkdir -p build/gfx/

build/build.asm: .FORCE
	tools/build.sh >$@

build/$(OUTPUT): $(SOURCE) build/build.asm $(TOOLS) $(GFX)
	bass -strict $(INPUT) -o build/$(OUTPUT)
	build/tools/checksum build/$(OUTPUT)

$(TOOLS): build/tools/% : tools/%.rs
	rustc -O $< -o $@

$(GFX): build/gfx/% : gfx/%.pcx
	build/tools/pcx2snes $<
	mv $<.til $@

clean:
	rm -r build/

.FORCE:
