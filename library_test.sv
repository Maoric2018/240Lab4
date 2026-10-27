`default_nettype none

module RangeCheck_test();
  logic [9:0] val, high, low;
  logic       is_between;

  logic [3:0] val4, high4, low4;
  logic       is_between4;

  RangeCheck DUT(.val, .high, .low, .is_between);

  RangeCheck #(4) DUT4
    (.val(val4), .high(high4), .low(low4),
     .is_between(is_between4));

  initial begin
    val = 10'd5; low = 10'd3; high = 10'd10; #5;
    if (is_between !== 1'b1) $display("RangeCheck error: inside range");
    val = 10'd3; #5;
    if (is_between !== 1'b1) $display("RangeCheck error: lower boundary");
    val = 10'd10; #5;
    if (is_between !== 1'b1) $display("RangeCheck error: upper boundary");
    val = 10'd2; #5;
    if (is_between !== 1'b0) $display("RangeCheck error: below range");
    val = 10'd11; #5;
    if (is_between !== 1'b0) $display("RangeCheck error: above range");
    val = 10'd5; low = 10'd5; high = 10'd5; #5;
    if (is_between !== 1'b1) $display("RangeCheck error: inside equal bounds");
    val = 10'd6; #5;
    if (is_between !== 1'b0) $display("RangeCheck error: outside equal bounds");
    val = 10'd5; low = 10'd10; high = 10'd3; #5;
    if (is_between !== 1'b0) $display("RangeCheck error: reversed bounds");
    val = 10'd0; low = 10'd0; high = 10'd1023; #5;
    if (is_between !== 1'b1) $display("RangeCheck error: minimum");
    val = 10'd1023; #5;
    if (is_between !== 1'b1) $display("RangeCheck error: maximum");
    val4 = 4'd7; low4 = 4'd5; high4 = 4'd10; #5;
    if (is_between4 !== 1'b1) $display("RangeCheck error: WIDTH 4 inside");
    val4 = 4'd11; #5;
    if (is_between4 !== 1'b0) $display("RangeCheck error: WIDTH 4 outside");
    $finish;
  end
endmodule : RangeCheck_test

module OffsetCheck_test();
  logic [9:0] val, delta, low;
  logic       is_between;

  logic [3:0] val4, delta4, low4;
  logic       is_between4;

  OffsetCheck DUT(.val, .delta, .low, .is_between);
  OffsetCheck #(4) DUT4
    (.val(val4), .delta(delta4), .low(low4),
     .is_between(is_between4));

  initial begin
    val = 10'd7; low = 10'd5; delta = 10'd3; #5;
    if (is_between !== 1'b1) $display("OffsetCheck error: inside range");
    val = 10'd5; #5;
    if (is_between !== 1'b1) $display("OffsetCheck error: lower boundary");
    val = 10'd8; #5;
    if (is_between !== 1'b1) $display("OffsetCheck error: upper boundary");
    val = 10'd4; #5;
    if (is_between !== 1'b0) $display("OffsetCheck error: below range");
    val = 10'd9; #5;
    if (is_between !== 1'b0) $display("OffsetCheck error: above range");
    val = 10'd5; delta = 10'd0; #5;
    if (is_between !== 1'b1) $display("OffsetCheck error: zero delta");
    val = 10'd6; #5;
    if (is_between !== 1'b0) $display("OffsetCheck error: outside zero delta");
    val = 10'd1023; low = 10'd1020; delta = 10'd10; #5;
    if (is_between !== 1'b1) $display("OffsetCheck error: overflow range");
    val = 10'd1019; #5;
    if (is_between !== 1'b0) $display("OffsetCheck error: below overflow range");
    val = 10'd1023; low = 10'd0; delta = 10'd1023; #5;
    if (is_between !== 1'b1) $display("OffsetCheck error: maximum range");
    val4 = 4'd15; low4 = 4'd14; delta4 = 4'd3; #5;
    if (is_between4 !== 1'b1) $display("OffsetCheck error: WIDTH 4 overflow");
    val4 = 4'd13; #5;
    if (is_between4 !== 1'b0) $display("OffsetCheck error: WIDTH 4 below range");
    $finish;
  end
endmodule : OffsetCheck_test