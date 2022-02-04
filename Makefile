O			:= build
CHUTE	    := $(O)/chute
RAMDISKOUT 	:= $(O)/initramfs
RAMDISKDIR	:= ramdisk

INIT		:= $(RAMDISKDIR)/init
BUSYBOX		:= $(RAMDISKDIR)/sbin/busybox

.PHONY: all
all: $(RAMDISKOUT)

.PHONY: clean
clean:
	rm -rf $(O)

$(O):
	mkdir -p $(O)

$(CHUTE):
	mkdir -p $(CHUTE)

.PHONY: $(INIT)
$(INIT):
	chmod +x $(INIT)

.PHONY: $(BUSYBOX)
$(BUSYBOX):
	chmod +x $(BUSYBOX)

populate: $(O) $(INIT) $(BUSYBOX) $(CHUTE)
	cp -a $(RAMDISKDIR)/* $(CHUTE)
	cd $(CHUTE) && \
		mkdir -p usr/{bin,sbin} bin sbin sys proc dev etc

$(RAMDISKOUT): populate
	cd $(CHUTE) && \
		find . | cpio -H newc -o | gzip > ../../$(RAMDISKOUT) && \
		cd ..
