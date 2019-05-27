PROJ_PATH= $(CURDIR)
CC= gcc
EXECUTABLES = curl tar gzip $(CC)
K := $(foreach exec,$(EXECUTABLES),\
        $(if $(shell which $(exec)),some string,$(error "No $(exec) in PATH")))

IMPORT= import

BUILD_dir= build

SDL2_url= https://www.libsdl.org/release/SDL2-2.0.9.tar.gz
SDL2_dir= $(PROJ_PATH)/$(IMPORT)/SDL2
SDL2_source= $(IMPORT)/SDL2-source
SDL2_config= $(SDL2_dir)/bin/sdl2-config --prefix=$(SDL2_dir) --static-libs
SDL2_conf_flags= --enable-shared=no --silent --prefix=$(SDL2_dir)

.PHONY: game sdl2 test dependencies directories
all: game
	echo "done"

game: $(BUILD_dir) dependencies
	$(CC) -I $(SDL2_dir)/include/SDL2 -o $(BUILD_dir)/game main.cpp `$(SDL2_config)`

dependencies: $(IMPORT) $(SDL2_dir)
	echo "dependencies done"

$(SDL2_dir):
	echo "downloading and extracting SDL2"
	curl -s $(SDL2_url) | tar -xzC $(IMPORT)/
	mv $(IMPORT)/SDL2-2.0.9 $(SDL2_source)
	echo "configuring SDL2"
	cd $(SDL2_source) && ./configure $(SDL2_conf_flags) && echo "building SDL2" && make && make install

$(IMPORT):
	mkdir -p $(IMPORT)

$(BUILD_dir):
	mkdir -p $(BUILD_dir)


clean:
	rm -rf $(IMPORT) $(BUILD_dir)
	echo "clean done"

