INPUT    = main.asm
OUTPUT   = program.sfc

TOOLSSRC = $(wildcard tools/*.rs)
TOOLS    = $(patsubst tools/%.rs,build/tools/%,$(TOOLSSRC))

all: dir $(TOOLS) build/$(OUTPUT)

dir:
	mkdir -p build/tools/

build/$(OUTPUT): $(TOOLS)
	bass -strict $(INPUT) -o build/$(OUTPUT)
	build/tools/checksum build/$(OUTPUT)

$(TOOLS): build/tools/% : tools/%.rs
	rustc -O $< -o $@

clean:
	rm -r build/
