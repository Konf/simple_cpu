`timescale 1ns / 1ps

module simple_cpu_tb();

  reg clk;    
  reg rst;

  reg  [15:0] sw;  
  wire [15:0] led;

  initial 
    begin
      clk = 0;
      rst = 1;
      sw  = 16'h00ff; 
      #100
      rst = 0;
    end
    
  always
    #5 clk = ~clk;



  simple_cpu_basys3 DUT(
   .clk  (clk),
   .sw   (sw),
   .btnC (),
   .btnU (),
   .btnL (),
   .btnR (rst),
   .btnD (),
   .led  (led)

  );
    


endmodule