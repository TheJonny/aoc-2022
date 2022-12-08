.global main
main:
	addi sp,sp,-48
	sd ra, 0(sp)
	sd s0, 8(sp)
	sd s1, 16(sp)
	sd s2, 24(sp)
	sd s3, 32(sp)
	sd s4, 40(sp)

	mv s0, zero
8: # loop
	# shift old input
	mv s4,s3
	mv s3,s2
	mv s2,s1
	# read input into s1
	call getchar
	mv s1, a0
	#  exit on eof
	blt a0,zero,99f

	# increment counter s0 and skip next part if <4
	addi s0,s0,1
	addi t0,s0,-4
	blt t0,zero,8b

	mv a1,s1
	mv a2,s2
	mv a3,s3
	mv a4,s4
	lla a0, debug
	call printf

	# check for marker 
	beq s1,s2,8b
	beq s1,s3,8b
	beq s1,s4,8b
	beq s2,s3,8b
	beq s2,s4,8b
	beq s3,s4,8b

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
	ld s1, 16(sp)
	ld s2, 24(sp)
	ld s3, 32(sp)
	ld s4, 40(sp)
	addi sp,sp,48
	ret

format: .string "%d\n"
debug: .string "%.3d %.d3 %.3d %.3d\n"
