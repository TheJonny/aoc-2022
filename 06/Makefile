AS = riscv64-linux-gnu-as
CC = riscv64-linux-gnu-gcc
QEMU = qemu-riscv64 -L /usr/riscv64-linux-gnu/
06:

.PHONY: run
run: 06
	$(QEMU) ./06

.PHONY: samples
samples: 06
	echo bvwbjplbgvbhsrlpgdmjqwftvncz | $(QEMU) ./06 # 5
	echo nppdvjthqldpwncqszvftbrmjlhg | $(QEMU) ./06 # 6
	echo nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg | $(QEMU) ./06 # 10
	echo zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw | $(QEMU) ./06 # 11
