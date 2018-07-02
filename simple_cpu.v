`timescale 1ns / 1ps

module simple_cpu
#(parameter DATA_WIDTH = 8,
  parameter PC_WIDTH = 8,
  parameter OPCODE_WIDTH = 4,
  parameter ARGUMENT_WIDTH = 8,
  parameter INSTR_WIDTH = OPCODE_WIDTH + ARGUMENT_WIDTH,
  parameter REGFILE_DEPTH = 16,
  parameter ROM_FILE = "tb_test_ROM.data")

( input clk,
  input rst,  
  input  [DATA_WIDTH-1:0] io_in,
  output reg [DATA_WIDTH-1:0] io_out,
  output reg [PC_WIDTH-1:0] program_counter
  );



  reg [DATA_WIDTH-1:0] regfile [0:REGFILE_DEPTH-1];
  //reg [PC_WIDTH-1:0]  program_counter;
  reg [DATA_WIDTH-1:0] accumulator;


  reg [INSTR_WIDTH-1:0] iram [0:(2**PC_WIDTH)-1];

  initial $readmemh(ROM_FILE, iram);



  wire [INSTR_WIDTH-1:0] instruction; // instruction (read from iram here)
  assign instruction = iram[program_counter];

  wire [OPCODE_WIDTH-1:0]   instruction_opcode   = instruction[INSTR_WIDTH-1:ARGUMENT_WIDTH]; // instruction opcode (some higher bits from instruction)
  wire [ARGUMENT_WIDTH-1:0] instruction_argument = instruction[ARGUMENT_WIDTH-1:0];

  // Instruction Opcode aliases:
  localparam NOP = 0; // Do nothing, PC++
  
  // Memory
  localparam LA  = 1;  // Load word from memory to accumulator 
  localparam SA  = 2;  // Save word to memory to accumulator
  localparam LC  = 3;  // Load constant to accumulator

  // IO
  localparam RIO = 4; // Read from I/O port
  localparam WIO = 5; // Write to I/O port

  // Arithmetics
  localparam ADD = 6;  // Add register to accumulator
  localparam SUB = 7;  // Substract register from accumulator

  // Logical
  localparam NOT = 8;  // Logical NOT of accumulator
  localparam OR  = 9;  // Logical OR of accumulator and memory at argument addr
  localparam XOR = 10; // Logical XOR of accumulator and memory at argument addr
  localparam AND = 11;  // Logical AND of accumulator and memory at argument addr
  localparam LSH = 12;  // Left shift accumulator
  localparam RSH = 13; // Right shift accumulator

  // Branching
  localparam JMP = 14; // Jump to address
  localparam BZ  = 15; // Branch if accumulator == 0



  // ALU and registers
  always @(posedge clk or posedge rst) begin
    if (rst) begin
      accumulator <= {DATA_WIDTH{1'b0}};
      io_out <= {DATA_WIDTH{1'b0}};
    end
    else begin
      case (instruction_opcode)
        
        NOP: begin end
        
        LA:  accumulator <= regfile[instruction_argument];
        SA:  regfile[instruction_argument] <= accumulator;
        LC:  accumulator <= instruction_argument;

        RIO: accumulator <= io_in;
        WIO: io_out <= accumulator;
        
        ADD: accumulator <= accumulator + regfile[instruction_argument];
        SUB: accumulator <= accumulator - regfile[instruction_argument];

        NOT: accumulator <= ~accumulator; 
        OR:  accumulator <= accumulator | regfile[instruction_argument]; 
        XOR: accumulator <= accumulator ^ regfile[instruction_argument];
        AND: accumulator <= accumulator & regfile[instruction_argument]; 
        LSH: accumulator <= accumulator << 1; 
        RSH: accumulator <= accumulator >> 1; 

        default: begin end

      endcase
    end
  end


  // PC and branch
  always @(posedge clk or posedge rst) begin
    if (rst) begin
      program_counter <= {PC_WIDTH{1'b0}};
    end
    else begin
      case (instruction_opcode)
        JMP: program_counter <= instruction_argument;

        BZ:  if (accumulator == 0) program_counter <= instruction_argument;
             else program_counter <= program_counter + 1;

        default: program_counter <= program_counter + 1;
      endcase
    end
  end


endmodule