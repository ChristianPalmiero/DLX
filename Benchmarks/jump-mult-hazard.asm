addi r1, r0, 6  # r1 = 6
addi r2, r0, 7  # r2 = 7
sw 10(r0), r2   # Mem(10) = 7
lw r4, 10(r0)   # r4 = Mem(10) = 7
mult r3, r1, r4 # r3 = 42
j fine
mult r3, r1, r2
sw 20(r2), r1
lw r5, 20(r2)
fine:
j fine
nop
nop
nop
nop
nop
nop
nop
nop
