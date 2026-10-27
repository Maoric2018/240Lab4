//`default_nettype none

//seven segment decoder
module SevenSegmentDisplay (
  output logic [6:0] segment,
  input logic [3:0] value
);

  always_comb begin
    case (value)
      4'd0: segment = 7'b100_0000;
      4'd1: segment = 7'b111_1001;
      4'd2: segment = 7'b010_0100;
      4'd3: segment = 7'b011_0000;
      4'd4: segment = 7'b001_1001;
      4'd5: segment = 7'b001_0010;
      4'd6: segment = 7'b000_0010;
      4'd7: segment = 7'b111_1000;
      4'd8: segment = 7'b000_0000;
      4'd9: segment = 7'b001_1000;
      default: segment = 7'b111_1111;
    endcase
  end

endmodule : SevenSegmentDisplay