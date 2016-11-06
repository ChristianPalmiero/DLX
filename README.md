# DLX introduction
The DLX (pronounced "Deluxe") is a RISC processor architecture designed by
John L. Hennessy and David A. Patterson, the principal designers of the
Stanford MIPS and the Berkeley RISC designs.<br />
The DLX has a simple
32-bit load/store architecture and emphasises a design for a pipelining efficiency
and an easily decoded instruction set.<br />
The DLX has thirty-two 32-bit general purpose registers (GPRs), named R0,
R1, ..., R31 (the value of R0 is always 0) and thirty-two 64-bit floating-point
registers (FPRs), named F0,F2,…,F30.<br />
The DLX operations work on 32-bit integers and 32- or 64-bit floating point.
The memory is byte addressable with the Big Endian mode, the address is on 32
bits and the available addressing modes are the immediate one and
displacement one. Furthermore, all memory accesses must be aligned.<br />
The instructions have a fixed length on 32 bits and can be broken down into
three subsets: I-type, R-type, J-type.<br />
The DLX, like the MIPS design, bases its performance on the use of an
instruction pipeline. The pipeline contains five stages:<br />
• IF – Fetch unit<br />
• ID – Decode unit<br />
• EX – Execution unit<br />
• MEM – Memory unit<br />
• WB – Write back unit<br />

# My project
In this project I have refined the DLX processor from RTL down to the
synthesis and to the physical design phase. My project consists of four modules
connected together according to the structural approach: a complex data path,
an hardwired control unit, a data memory and an instruction memory.<br />
• Instruction subset: other than the basic instructions, the DLX is able to
perform 8 additional instructions (SEQ, SEQI, SGT, SGTI, SLT, SLTI, MUL
and partially the DIV).<br />
• Data path: the microarchitecture is optimised so that the critical path and the
power consumption is reduced and most of the modules, from the basic ones
to the arithmetical ones, recall the ones analysed during classes (T2 ALU, P4 adder, Booth MUL, divider module with the nonrestoring
algorithm).<br />
• Control hazard: the control unit is able to implement the static branch
prediction technique called “predict untaken”.<br />
• Data hazard and forwarding: the hazard unit integrated in the decode stage is
able to solve RAW, WAW hazards, while the forwarding unit integrated in the
execution stage is able to solve EX/MEM hazards and MEM/WB hazards.<br />
• Power consumption: two main techniques have been applied in order to
reduce power, clock gating and guarded evaluation.<br />
• Physical design: a complete and accurate physical design has been executed.<br />

# Report
Detailed documentation [here](Report_DLX_Group23.pdf).
