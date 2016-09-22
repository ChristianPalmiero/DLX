addi r1, r0, 100  # r1 = 100
xor r2, r2, r2    # r2 = 0
ciclo:
addi r3, r3, 10   # r3 = 10
subi r2, r2, 1    # r2 = 65535
bnez r0, ciclo    # NOT TAKEN
addi r10, r10, 65535 # r10 = 65535
ori r5, r4, 100000   # r5 = ...
and r6, r4, r5       # r6 = 0
andi r6, r2, 1       # r6 = 1
nop
nop
nop
nop
nop
nop
nop
nop
nop
