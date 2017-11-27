  /* verilator lint_off UNUSED */

module slug(
  input logic fclk, dclk, rclk, wclk, arst);

  tri[19:0] addr;
  tri[7:0] data;

  logic rst;
  logic stage;
  logic[3:0] sel;
  logic[23:0] control;

  initial begin
    stage = 0;
    rst = 0;
    sel = 0;
    control = 0;
  end

  always @(posedge wclk)
    rst <= arst;

  always @(posedge dclk, posedge wclk)
    if (!rst)
      stage <= 0;
    else
      stage <= !stage;

  always @(posedge dclk)
    if (!rst)
      sel <= 4'b0;
    else
      sel <= data[3:0];

  counter #(20, 2) ip(
    .clk(wclk),
    .rst(rst),
    .ldx('b0),
    .oey(!stage),
    .inc('b01),
    .x(addr),
    .y(addr));

  ram #(8, 20) ram(
    .wclk(wclk),
    .rclk0(fclk),
    .rclk1(rclk),
    .rst(rst),
    .we('b0),
    .re0(!stage),
    .re1('b0),
    .a(addr),
    .x(data),
    .y(data)
  );

  rom #(24, 11, "ucode.data") ucode(
    .clk(dclk),
    .rst(rst),
    .a({3'b0, data}),
    .y(control)
  );

endmodule