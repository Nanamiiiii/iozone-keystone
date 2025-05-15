#
# RISC-V musl build with no threads, no largefiles, no async I/O
#
.PHONY: all
all: riscv_musl riscv_keystone_adm

riscv_musl: iozone_riscv_musl.o libbif.o
	$(CCRV) -O0 $(LDFLAGS) -static iozone_riscv_musl.o libbif.o -o iozone-rv

riscv_keystone_adm: iozone_riscv_keystone_adm.o libbif.o
	$(CCRV) -O0 $(LDFLAGS) -static iozone_riscv_keystone_adm.o libbif.o $(KEYSTONE_SDK)/lib/libkeystone-edge.a $(KEYSTONE_SDK)/lib/libkeystone-app-syscall.a -o iozone-keystone-adm

iozone_riscv_musl.o: iozone.c
	@echo ""
	@echo "Building iozone RISC-V + musl-libc (Generic)"
	@echo ""
	$(CCRV) -c -O0 -Wno-implicit-function-declaration -DARGS_VARIANT=$(ARGS_VARIANT) -DRISCV_FU740 -Dgeneric -Dunix -DHAVE_ANSIC_C -DNO_THREADS -DNO_SOCKET -DNO_FORK -DNO_MADVISE -DNO_SIGNAL \
		-DNAME='"RISC-V_musl"' $(CFLAGS) iozone.c -o iozone_riscv_musl.o

iozone_riscv_keystone_adm.o: iozone.c
	@echo ""
	@echo "Building iozone RISC-V + keystone-adm"
	@echo ""
	$(CCRV) -c -O0 -Wno-implicit-function-declaration -DARGS_VARIANT=$(ARGS_VARIANT) -DRISCV_FU740 -Dgeneric -Dunix -DHAVE_ANSIC_C -DNO_THREADS -DNO_SOCKET -DNO_FORK -DNO_MADVISE -DNO_SIGNAL -DADM_MALLOC -I $(KEYSTONE_SDK)/include \
		-DNAME='"RISC-V_keystone"' $(CFLAGS) iozone.c -o iozone_riscv_keystone_adm.o

libbif.o: libbif.c
	$(CCRV) -c -O0 -Dgeneric -Dunix -DHAVE_ANSIC_C -DNO_THREADS -DNO_SOCKET -DNO_FORK -DNO_MADVISE -DNO_SIGNAL \
		$(CFLAGS) libbif.c -o libbif.o

.PHONY: clean
clean:
	rm -f riscv_musl riscv_keystone_sdk
	rm -f *.o

