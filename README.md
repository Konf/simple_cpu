# The (Very) Simple CPU

## How to build HDL project
#### For Xilinx Vivado IDE you can use included .tcl script to build a project for Digilent Basys 3 board:
     vivado -nojournal -nolog -source simple_cpu_basys3.tcl

## How to build ROM files
#### You can use included python script to convert your ASM code into ROM data files
	python3 input_asm_file [output_rom_file]
#### And don't forget to modify **ROM_FILE** parameter in *simple_cpu.v*!