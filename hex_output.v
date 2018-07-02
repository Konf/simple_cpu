module hex_driver(
  input clk,
  input rst,
  input [15:0] data_in,
  output reg [6:0] seg,
  output reg [3:0] an);


  reg [10:0] clk_div;

  always @(posedge clk or posedge rst) begin
    if (rst)
      clk_div <= 10'd0;
    else
      clk_div <= clk_div + 1;
  end


  reg [1:0] scan_cnt;

  always @(posedge clk or posedge rst) begin
    if (rst)
      scan_cnt <= 2'd0;
    else if(clk_div == 0)
      scan_cnt <= scan_cnt + 1;
  end

  wire [6:0] hex0_seg;
  wire [6:0] hex1_seg;
  wire [6:0] hex2_seg;
  wire [6:0] hex3_seg;

  // Hex decoders
  hex_decode decode0(
    .data_in(data_in[3:0]),
    .seg(hex0_seg)
    );

  hex_decode decode1(
    .data_in(data_in[7:4]),
    .seg(hex1_seg)
    );

  hex_decode decode2(
    .data_in(data_in[11:8]),
    .seg(hex2_seg)
    );

  hex_decode decode3(
    .data_in(data_in[15:12]),
    .seg(hex3_seg)
    );

  // Scan demux
  always @(posedge clk  or posedge rst) begin
    if (rst) begin
      seg <= 7'h0;
      an  <= 4'b1111;
    end
    else if(clk_div == 0) begin
      case (scan_cnt)
        2'd0: begin seg <= hex0_seg; an <= 4'b1110; end
        2'd1: begin seg <= hex1_seg; an <= 4'b1101; end
        2'd2: begin seg <= hex2_seg; an <= 4'b1011; end
        2'd3: begin seg <= hex3_seg; an <= 4'b0111; end
      endcase
    end
  end

endmodule


module hex_decode(
  input [3:0] data_in,
  output reg [6:0] seg);

//   ___A
// F|   |
//  |___|B
// E| G | 
//  |___|C
//  D   

  always @(*) begin
    case(data_in)//   GFEDCBA
      4'h0: seg <= 7'b1000000; // ABCDEF +
      4'h1: seg <= 7'b1111001; // BC +
      4'h2: seg <= 7'b0100100; // ABDEG +
      4'h3: seg <= 7'b0110000; // ABCDG +
      4'h4: seg <= 7'b0011001; // BCFG +
      4'h5: seg <= 7'b0010010; // ACDFG +
      4'h6: seg <= 7'b0000010; // ACDEFG +
      4'h7: seg <= 7'b1111000; // ABC +
      4'h8: seg <= 7'b0000000; // ABCDEFG +
      4'h9: seg <= 7'b0010000; // ABCDFG +
      4'ha: seg <= 7'b0001000; // ABCEFG +
      4'hb: seg <= 7'b0000011; // CDEFG +
      4'hc: seg <= 7'b1000110; // ADEF +
      4'hd: seg <= 7'b0100001; // BCDEG +
      4'he: seg <= 7'b0000110; // ADEFG +
      4'hf: seg <= 7'b0001110; // AEFG +
    endcase
  end


endmodule