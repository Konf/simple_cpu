module hex_driver(
  input clk,
  input rst,
  input [15:0] data_in,
  output reg [6:0] seg,
  output reg [3:0] an);


  reg [3:0] scan_cnt;

  always @(posedge clk or posedge rst) begin
    if (rst)
      scan_cnt <= 4'd0;
    else
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
  always @(posedge clk) begin
    if (rst) begin
      seg <= 7'h0;
      an  <= 4'd0;
    end
    else begin
      case (scan_cnt)
        4'd0: seg <= hex0_seg;
        4'd1: seg <= hex1_seg;
        4'd2: seg <= hex2_seg;
        4'd3: seg <= hex3_seg;
      endcase
      
      an <= scan_cnt;
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
    case(data_in)//   ABCDEFG
      4'h0: seg <= 7'b1111110; // ABCDEF
      4'h1: seg <= 7'b0110000; // BC
      4'h2: seg <= 7'b1100111; // ABDEG
      4'h3: seg <= 7'b1100011; // ABCDG
      4'h4: seg <= 7'b0110011; // BCFG
      4'h5: seg <= 7'b1011011; // ACDFG
      4'h6: seg <= 7'b1011111; // ACDEFG
      4'h7: seg <= 7'b1110000; // ABC
      4'h8: seg <= 7'b1111111; // ABCDEFG
      4'h9: seg <= 7'b1111011; // ABCDFG
      4'ha: seg <= 7'b1110111; // ABCEFG
      4'hb: seg <= 7'b0011111; // CDEFG
      4'hc: seg <= 7'b1001110; // ADEF
      4'hd: seg <= 7'b0111101; // BCDEG
      4'he: seg <= 7'b1001111; // ADEFG
      4'hf: seg <= 7'b1000111; // AEFG
    endcase
  end


endmodule