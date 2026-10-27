//`default_nettype none
module ChipInterface
  (input  logic        CLOCK_100,
   input  logic [ 3:0] BTN,
   input  logic [15:0] SW,
   output logic [ 3:0] D2_AN, D1_AN,
   output logic [ 7:0] D2_SEG, D1_SEG,
   output logic        hdmi_clk_n, hdmi_clk_p,
   output logic [ 2:0] hdmi_tx_p, hdmi_tx_n);

  // Signals for the clock wizard and HDMI IP
  logic clock_40MHz, clock_200MHz, locked;

  // Define your signals here
  logic reset;
  logic HS, VS, blank;
  logic [9:0] row, col;
  logic [7:0] red, green, blue;

  assign reset = BTN[0];

  // Instantiate your TPG
  TestPatternGenerator tpg(
    .row,
    .col,
    .red,
    .green,
    .blue
   );

  // Instantiate your VGA module
  VGA vga(
    .clock_40MHz,
    .HS,
    .VS,
    .blank,
    .row,
    .col
   );

  //clock wizard configured with a 1x and 5x clock
  clk_wiz_0 clk_wiz (
    .clk_out1(clk_40MHz),
    .clk_out2(clk_200MHz),
    .reset(reset),
    .locked(locked),
    .clk_in1(CLOCK_100)
  );


  //Real Digital VGA to HDMI converter
  hdmi_tx_0 vga_to_hdmi (
    //Clocking and Reset
    .pix_clk(clk_40MHz),
    .pix_clkx5(clk_200MHz),
    .pix_clk_locked(locked),
    //Reset is active HIGH
    .rst(reset),

    //Color and Sync Signals
    .red(red),
    .green(green),
    .blue(blue),
    .hsync(HS),
    .vsync(VS),
    .vde(~blank),

    //aux Data (unused)
    .aux0_din(4'b0),
    .aux1_din(4'b0),
    .aux2_din(4'b0),
    .ade(1'b0),

    //Differential outputs
    .TMDS_CLK_P(hdmi_clk_p),          
    .TMDS_CLK_N(hdmi_clk_n),          
    .TMDS_DATA_P(hdmi_tx_p),         
    .TMDS_DATA_N(hdmi_tx_n)          
  );

  assign D1_AN = 4'b1111;
  assign D2_AN = 4'b1111;
  assign D1_SEG = 8'hFF;
  assign D2_SEG = 8'hFF;

endmodule : ChipInterface