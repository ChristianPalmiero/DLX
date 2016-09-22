addi r1, r0, 100  # r1 = 100
xor r2, r2, r2    # r2 = 0
addi r3, r3, 10   # r3 = 10
subi r2, r2, 1    # r2 = 65535
beqz r4, ciclo    # TAKEN
addi r10, r10, 65535
ori r5, r4, 100000
add r6, r4, r5
ciclo:
addi r10, r10, 5  # r10 = 5
or r11, r10, r3   # r11 = 15
nop
nop
nop
nop
nop
nop
nop
nop
