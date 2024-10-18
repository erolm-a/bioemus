LINUX_MOD_DIR = /lib/modules/$(shell uname -r)/build  

obj-m += dma-proxy.o 
all:
	make -C $(LINUX_MOD_DIR) M=$(PWD) modules 
clean: 
	make -C $(LINUX_MOD_DIR) M=$(PWD) clean
