# RISCV-32-Processor

Baremetal 5 stage Pipeline Processor with functionality for 35+ instructions for RiscV-32bit instruction set

**INITIAL SETUP**

Download all the system verilog files and compile them in your choice of simulation software, I used ModelSIM Student Edition. 

Download the c files ( and open/compile these files in your choice of IDE, compile them to create two different executables. 

**Running Test Program on Processor**

Choose a C/++ Program of your choice and run the code through: https://godbolt.org/ with the "RISC-V 32gc 12.01 clang" compiler to generate assembly language for your code

Copy the assembly code from the goldbot site into a txt file and use the txt file as an input to InstructionParser.cpp file. 

The two outputs (names shown in file and can be edited) will be one txt file with only instructions that are compatible with the processor and the other will contain th entired orginal assembly with labels and a "parsed" label for all incompatible instructions.

Use the .txt files with only compatible instructions and copy the assembly code into the editor tab of https://venus.cs61c.org/

Go to the simulator tab, and press simulate and dump and copy the binary machine code from the dump into another txt file.

Use this text file with machine code as the input to assemblytomachine.cpp and the output will be a text file with the machine code formatted in a way that is compatible with the processor.

Copy the output file into the instruntionmemory module initial block within the fetchstage.sv. 

Compile the program again and run the simulate datapathtest. Enjoy looking the waveforms and outputs!

**Structure of Files**

datapathtest is the top level module where the clock is set and an instatiation a datapath module (dp) created
within dp the entire datapath is instaniated. The structure of the files can be broken down through the following

Fetchstage.sv contains instructionmemory,add4 modules 

Decodestage.sv contains-decoder, registerfile, comparator modules 

executestage.sv contains ALU, PCadder modules

memorystage.sv contains datamemory,cache modules

controller.sv contains controller module

branchpred.sv contains branchpred, btb modules

fowardingunit.sv contains fowardingunit, hazard_detection, decodeforward modules

registers.sv contains all registers in between stages necessary for pipiline (ie. fetchdecode,decodeex,exmem,memwb) and PCreg

multiplexers.sv contains mux11, threemux32, mux32,controllermux

Inspect datapath.sv file for further understanding of connections between modules and refer to this to find locations of modules



