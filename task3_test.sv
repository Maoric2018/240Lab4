//`default_nettype none

module TestPatternGenerator_tb;

  logic [9:0] row, col;
  logic [7:0] red, green, blue;

  logic [7:0] expected_red;
  logic [7:0] expected_green;
  logic [7:0] expected_blue;

  TestPatternGenerator dut
    (.row(row),
     .col(col),
     .red(red),
     .green(green),
     .blue(blue));

  initial begin

    for (integer r = 0; r < 600; r++) begin
      for (integer c = 0; c < 800; c++) begin

        row = r;
        col = c;

        expected_red = 8'h00;
        expected_green = 8'h00;
        expected_blue = 8'h00;

        if (r < 300) begin
          if (c < 100) begin
            // Black
          end
          else if (c < 200) begin
            expected_blue = 8'hFF;
          end
          else if (c < 300) begin
            expected_green = 8'hFF;
          end
          else if (c < 400) begin
            expected_green = 8'hFF;
            expected_blue = 8'hFF;
          end
          else if (c < 500) begin
            expected_red = 8'hFF;
          end
          else if (c < 600) begin
            expected_red = 8'hFF;
            expected_blue = 8'hFF;
          end
          else if (c < 700) begin
            expected_red = 8'hFF;
            expected_green = 8'hFF;
          end
          else begin
            expected_red = 8'hFF;
            expected_green = 8'hFF;
            expected_blue = 8'hFF;
          end
        end

        #1;

        if ({red, green, blue} !==
            {expected_red, expected_green, expected_blue}) begin

          $error("row=%0d col=%0d Expected=%h %h %h Actual=%h %h %h",
                 r, c,
                 expected_red, expected_green, expected_blue,
                 red, green, blue);

        end

      end
    end

    $finish;
  end

endmodule : TestPatternGenerator_tb
