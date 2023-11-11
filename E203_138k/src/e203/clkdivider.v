// Divide clock by 256, used to generate 32.768 kHz clock for AON block
module clkdivider (
    input  wire clk_in,
    output reg  clk_out
);

  reg [9:0] counter;
  initial begin
    counter = 10'd0;
    clk_out = 1;
  end

  always @(posedge clk_in) begin
     if (counter == 10'd243) begin
      counter <= 10'd0;
      clk_out <= ~clk_out;
    end else begin
      counter <= counter + 1'd1;
    end
  end
endmodule
