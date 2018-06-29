`timescale 1ns / 1ps

module simple_cpu_basys3 (
  input clk,
  input [15:0] sw,
  input btnC,
  input btnU,
  input btnL,
  input btnR,
  input btnD,

  output [15:0] led
  );
  
  wire rst = btnR;

  reg [27:0] clk_divider;

  always @(posedge clk or posedge rst) begin
    if (rst)
      clk_divider <= {64{1'b0}};
    else
      clk_divider <= clk_divider + 1;
  end


  wire cpu_clk = sw[15] ? clk_divider[27] : clk ;
  assign led[15] = cpu_clk;
  assign led[14:8] = 7'd0;

  simple_cpu cpu
( .clk(cpu_clk),
  .rst(rst),  
  .io_in(sw[7:0]),
  .io_out(led[7:0])
  );




endmodule