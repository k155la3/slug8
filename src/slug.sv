  /* verilator lint_off UNUSED */

module slug(
  input logic fclk, dclk, rclk, wclk, arst);

  tri[19:0] addr;
  tri[7:0] data;

  logic rst;
  logic[1:0] stage;
  logic[7:0] control;

  initial begin
    stage = 2'b0;
    rst = 0;
  end

  always @(posedge wclk)
    rst <= arst;

  always @(posedge fclk, posedge dclk, posedge rclk, posedge wclk)
    if (!rst)
      stage <= 2'b0;
    else
      stage <= stage + 1;

  counter #(20, 2) ip(
    .clk(wclk),
    .rst(rst),
    .ldx('b0),
    .oey(stage[1] == 1'b0),
    .inc('b01),
    .x(addr),
    .y(addr));

  ram #(8, 20) ram(
    .wclk(wclk),
    .rclk0(fclk),
    .rclk1(rclk),
    .we('b0),
    .re0(stage[1] == 1'b0),
    .re1('b0),
    .a(addr),
    .x(data),
    .y(data)
  );

  rom #(8, 8) rom(
    .clk(dclk),
    .a(data),
    .y(control)
  );

endmodule