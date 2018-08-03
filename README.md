# 32bit_mips
A simple RISC processor from scratch with
  - Data forwarding
  - Stall
  - flush,
that can execute 20 instructions

mipsCore.sv is literally the core of the processor. Start there if you want to explore the architecture.
top_mipsCore.sv is a testbench program for the procesor.
iCache.sv holds the instructions that will be executed by the processor
dCache.sv repesents a DRAM
instr_decode.sv, execute.sv, memAccess.sv, writeBack.sv represents the pipeline stages of the processor
