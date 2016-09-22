addi r1, r0, 6  # r1 = 6
addi r2, r0, 7  # r2 = 7
j fine
add r3, r2, r1
nop
subi r1, r0, 6
addi r2, r0, 7
sle r3,r1,r2
slt r4,r1,r2
fine:
sub r3, r2, r1  # r3 = 1
nop
nop
nop
nop
nop
nop
nop
nop
