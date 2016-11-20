addi r1,r0,#2	# r1 = 2
subi r2,r1,#1	# r2 = 1
addi r3,r1,#-4	# r3 = -2
subi r4,r3,#-1	# r4 = -1
addi r5,r1,#4	# r5 = 6
subi r6,r5,#3	# r6 = 3
add r7,r1,r2	# r7 = 3
sub r8,r5,r6	# r8 = 3
add r9,r6,r1	# r9 = 5
sge r10,r1,r2	# r10= 1
sge r10,r2,r1	# r10= 0
sge r10,r1,r1	# r10= 1
sle r10,r1,r2	# r10= 0
sle r10,r2,r1	# r10= 1
sle r10,r1,r1	# r10= 1
sne r10,r1,r1	# r10= 0
sne r10,r1,r2	# r10= 1
seq r10,r1,r2	# r10= 0
seq r10,r1,r1	# r10= 1
sgt r10,r2,r1	# r10= 0
sgt r10,r1,r2	# r10= 1
slt r10,r2,r1	# r10= 1
slt r10,r1,r2	# r10= 0
sgei r10,r1,#4	# r10= 0
sgei r10,r1,#1	# r10= 1
slei r10,r1,#0	# r10= 0
seqi r10,r1,#0	# r10= 0
seqi r10,r1,#2	# r10= 1
sgti r10,r1,#3	# r10= 0
sgti r10,r1,#1	# r10= 1
slti r10,r1,#1	# r10= 0
slti r10,r1,#3	# r10= 1
nop
nop
nop
nop
nop
nop
