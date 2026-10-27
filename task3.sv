//'default_nettype none

module TestPatternGenerator
  (input  logic [9:0] row, col,
   output logic [7:0] red, green, blue);

  logic top_half;
  logic blue_area, green_area, light_blue_area;
  logic red_area, purple_area, yellow_area, white_area;

  RangeCheck #(10) top_check
    (.val(row),
     .low(10'd0),
     .high(10'd299),
     .is_between(top_half));

  OffsetCheck #(10) blue_check
    (.val(col),
     .low(10'd100),
     .delta(10'd99),
     .is_between(blue_area));

  OffsetCheck #(10) green_check
    (.val(col),
     .low(10'd200),
     .delta(10'd99),
     .is_between(green_area));

  OffsetCheck #(10) light_blue_check
    (.val(col),
     .low(10'd300),
     .delta(10'd99),
     .is_between(light_blue_area));

  OffsetCheck #(10) red_check
    (.val(col),
     .low(10'd400),
     .delta(10'd99),
     .is_between(red_area));

  OffsetCheck #(10) purple_check
    (.val(col),
     .low(10'd500),
     .delta(10'd99),
     .is_between(purple_area));

  OffsetCheck #(10) yellow_check
    (.val(col),
     .low(10'd600),
     .delta(10'd99),
     .is_between(yellow_area));

  OffsetCheck #(10) white_check
    (.val(col),
     .low(10'd700),
     .delta(10'd99),
     .is_between(white_area));

  assign red = (top_half &&
                (red_area || purple_area ||
                 yellow_area || white_area))
               ? 8'hFF : 8'h00;

  assign green = (top_half &&
                  (green_area || light_blue_area ||
                   yellow_area || white_area))
                 ? 8'hFF : 8'h00;

  assign blue = (top_half &&
                 (blue_area || light_blue_area ||
                  purple_area || white_area))
                ? 8'hFF : 8'h00;

endmodule : TestPatternGenerator
