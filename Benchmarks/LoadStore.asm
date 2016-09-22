myloop:

addi r1, r0, 4      # R1 <= 4
lw r2, 4(r1)        # R2 <= 0
sw 20(r2), r1       # Mem(20) <= 4
lw r5, 20(r2)       # R5 <= 4
addi r4, r5, 15     # STALL R4 <= 19
addi r7, r0, myloop # move label into r7
j r7        	      # jump
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
