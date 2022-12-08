.section .text
.global main
.equ N, 14 # part 1: 4, part 2: 14
main:
	addi sp,sp,-16
	sd ra, 0(sp)
	sd s0, 8(sp)

	mv s0, zero
8: # loop
	# read input into tab[s0 % N]
	call getchar
	#  exit on eof
	blt a0,zero,99f
	# store in buf
	li t0, N
	remu t0, s0, t0
	lla t1, buf
	add t0, t0, t1
	sb a0, 0(t0)

	# increment counter s0 and skip next part if <4
	addi s0,s0,1
	addi t0,s0,-4
	blt t0,zero,8b

	# check for marker 
	# FOR(t0,1,N) FOR(t1,0,i) if (buf[t0] == buf[t1]) continue outer
	li t0, 1
88:
	li t1, 0
888:
	lla t2,buf
	mv t3,t2
	add t2,t2,t0
	add t3,t3,t1
	lb t4,0(t2)
	lb t5,0(t3)
	beq t4,t5,8b	

	addi t1,t1,1
	bne t1,t0, 888b
	addi t0,t0,1
	li t2,N
	bne t0,t2, 88b

	mv a1,s0
	lla a0, format
	call printf
	mv a0, zero

	#addi a0, zero, format
	#auipc ra, %pcrel_hi(getchar)
	#jalr ra, %pcrel_lo(getchar)(ra)
99:
	ld ra, 0(sp)
	ld s0, 8(sp)
	addi sp,sp,16
	ret

format: .string "%d\n"
debug: .string "%.3d %.d3 %.3d %.3d\n"
.section .bss
.align 3
buf: .zero N
