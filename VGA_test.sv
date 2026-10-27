
`default_nettype none

module VGA_test();
  logic       clock_40MHz;
  logic       HS, VS, blank;
  logic [9:0] row, col;
  integer     h, v, errors;

  VGA DUT(.clock_40MHz, .HS, .VS, .blank, .row, .col);

  initial begin
    clock_40MHz = 1'b0;
    forever #5 clock_40MHz = ~clock_40MHz;
  end

  initial begin
    errors = 0;

    for (v = 0; v < 628; v = v + 1) begin
      for (h = 0; h < 1056; h = h + 1) begin

        if (HS !== (h >= 128)) begin
            $display("VGA HS error at h=%0d v=%0d", h, v);
            errors = errors + 1;
        end

        if (VS !== (v >= 4)) begin
            $display("VGA VS error at h=%0d v=%0d", h, v);
            errors = errors + 1;
        end

        if (blank !== (h < 216 || h > 1015 || v < 27 || v > 626)) begin
            $display("VGA blank error at h=%0d v=%0d", h, v);
            errors = errors + 1;
        end

        if (h >= 216 && h <= 1015 &&
            v >= 27 && v <= 626) begin
            if (col !== (h - 216)) begin
                $display("VGA col error at h=%0d v=%0d", h, v);
                errors = errors + 1;
            end

        if (row !== (v - 27)) begin
            $display("VGA row error at h=%0d v=%0d", h, v);
            errors = errors + 1;
          end
        end
        @(negedge clock_40MHz);
      end
    end

    if (HS !== 1'b0 || VS !== 1'b0 || blank !== 1'b1) begin
      $display("VGA error: frame did not restart correctly");
      errors = errors + 1;
    end

    if (errors == 0)
      $display("VGA test passed");
    else
      $display("VGA test found %0d errors", errors);

    $finish;
  end
endmodule : VGA_test
