CC				:=	clang
CFLAGS			:=	-static
SRC_DIR			:=	src
O				:=	build
INITRAMFS_DIR	:= $(O)/initramfs_dir

SRC				:=	$(SRC_DIR)/init.c
OBJ				:=	$(O)/init.o

INIT			:= init
RAMDISK 		:= initramfs

.PHONY: all
all: $(O) $(INIT) $(RAMDISK)

.PHONY: clean
clean:
	rm -rf $(O)

$(O):
	mkdir -p $(O)

$(INITRAMFS_DIR): $(O)
	mkdir -p $(INITRAMFS_DIR)

$(O)/%.o: $(SRC)
	$(CC) -c -o $@ $< $(CFLAGS)

$(INIT): $(OBJ)
	$(CC) -o $(O)/$@ $^ $(CFLAGS)

$(RAMDISK): $(INIT) $(INITRAMFS_DIR)
	cp -av $(O)/$(INIT) $(INITRAMFS_DIR)/$(INIT)
	cd $(INITRAMFS_DIR) && \
	find . | cpio -H newc -o | gzip > ../$(RAMDISK) && \
	cd ..
