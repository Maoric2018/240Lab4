`default_nettype none

module VGA
  (input  logic       clock_40MHz,
   output logic       HS, VS, blank,
   output logic [9:0] row, col);

  logic [10:0] hcount;
  logic [9:0]  vcount;
  logic        h_end, v_end;
  logic        h_sync, v_sync;
  logic        h_display, v_display;

  assign h_end = (hcount == 11'd1055);
  assign v_end = (vcount == 10'd627);

  Counter #(11) hc
    (.clock(clock_40MHz),
     .clear(h_end),
     .enable(1'b1),
     .Q(hcount));

  Counter #(10) vc
    (.clock(clock_40MHz),
     .clear(h_end && v_end),
     .enable(h_end),
     .Q(vcount));

  RangeCheck #(11) hsync_check
    (.val(hcount),
     .high(11'd127),
     .low(11'd0),
     .is_between(h_sync));

  RangeCheck #(10) vsync_check
    (.val(vcount),
     .high(10'd3),
     .low(10'd0),
     .is_between(v_sync));

  OffsetCheck #(11) hdisplay_check
    (.val(hcount),
     .delta(11'd799),
     .low(11'd216),
     .is_between(h_display));

  OffsetCheck #(10) vdisplay_check
    (.val(vcount),
     .delta(10'd599),
     .low(10'd27),
     .is_between(v_display));

  assign HS = ~h_sync;
  assign VS = ~v_sync;
  assign blank = ~(h_display && v_display);

  assign col = hcount - 11'd216;
  assign row = vcount - 10'd27;

endmodule : VGA