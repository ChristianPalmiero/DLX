# DLX
The DLX (pronounced "Deluxe") is a RISC processor architecture designed by
John L. Hennessy and David A. Patterson, the principal designers of the
Stanford MIPS and the Berkeley RISC designs.<br />
The DLX, a cleaned up and a modernised simplified MIPS CPU, has a simple
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
