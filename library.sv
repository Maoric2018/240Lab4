
`default_nettype none

module Decoder
  (input  logic [2:0] I,
   input  logic       en,
   output logic [7:0] D);

  always_comb begin
    D = 8'b0000_0000;
    if (en) begin
      case (I)
        3'b000: D = 8'b0000_0001;
        3'b001: D = 8'b0000_0010;
        3'b010: D = 8'b0000_0100;
        3'b011: D = 8'b0000_1000;
        3'b100: D = 8'b0001_0000;
        3'b101: D = 8'b0010_0000;
        3'b110: D = 8'b0100_0000;
        3'b111: D = 8'b1000_0000;
        default: D = 8'b0000_0000;
      endcase
    end
  end

endmodule : Decoder


module BarrelShifter
  (input  logic [15:0] V,
   input  logic [3:0]  by,
   output logic [15:0] S);

  assign S = V << by;
endmodule : BarrelShifter


module Multiplexer
  (input  logic [7:0] I,
   input  logic [2:0] S,
   output logic       Y);

  always_comb begin
    case (S)
      3'b000: Y = I[0];
      3'b001: Y = I[1];
      3'b010: Y = I[2];
      3'b011: Y = I[3];
      3'b100: Y = I[4];
      3'b101: Y = I[5];
      3'b110: Y = I[6];
      3'b111: Y = I[7];
      default: Y = 1'b0;
    endcase
  end
endmodule : Multiplexer


module Mux2to1
  (input  logic [7:0] I0,
   input  logic [7:0] I1,
   input  logic       S,
   output logic [7:0] Y);

  always_comb begin
    if (S)
      Y = I1;
    else
      Y = I0;
  end

endmodule : Mux2to1


module MagComp
  (input  logic [7:0] A,
   input  logic [7:0] B,
   output logic       AgtB,
   output logic       AeqB,
   output logic       AltB);

  always_comb begin
    AgtB = 1'b0;
    AeqB = 1'b0;
    AltB = 1'b0;

    if (A > B)
      AgtB = 1'b1;
    else if (A < B)
      AltB = 1'b1;
    else
      AeqB = 1'b1;
  end
endmodule : MagComp


module Comparator
  (input  logic [3:0] A,
   input  logic [3:0] B,
   output logic       AeqB);

  assign AeqB = (A == B);
endmodule : Comparator


module Adder
  (input  logic       cin,
   input  logic [4:0] A,
   input  logic [4:0] B,
   output logic       cout,
   output logic [4:0] sum);

  assign {cout, sum} = {1'b0, A} + {1'b0, B} + cin;
endmodule : Adder


module Subtracter
  (input  logic       bin,
   input  logic [6:0] A,
   input  logic [6:0] B,
   output logic       bout,
   output logic [6:0] diff);

  logic [7:0] result;

  assign result = {1'b0, A} - {1'b0, B} - bin;
  assign diff = result[6:0];
  assign bout = result[7];
endmodule : Subtracter


module RangeCheck
  #(parameter WIDTH = 10)
  (input  logic [WIDTH-1:0] val,
   input  logic [WIDTH-1:0] high,
   input  logic [WIDTH-1:0] low,
   output logic             is_between);

  assign is_between = (val >= low) && (val <= high);
endmodule : RangeCheck


module OffsetCheck
  #(parameter WIDTH = 10)
  (input  logic [WIDTH-1:0] val,
   input  logic [WIDTH-1:0] delta,
   input  logic [WIDTH-1:0] low,
   output logic             is_between);

  logic [WIDTH:0] high;

  assign high = {1'b0, low} + {1'b0, delta};

  RangeCheck #(WIDTH+1) rc
    (.val({1'b0, val}),
     .high(high),
     .low({1'b0, low}),
     .is_between(is_between));

endmodule : OffsetCheck

module Counter
  #(parameter w = 4)
  (input  logic         clock,
   input  logic         clear,
   input  logic         enable,
   output logic [w-1:0] Q);

  initial Q = 0;

  always @(posedge clock)
    if (clear)
      Q <= 0;
    else if (enable)
      Q <= Q + 1;

endmodule : Counter
