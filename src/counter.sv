module counter(
  input logic clk, rst, ldx, oey,
  input logic[INC_WIDTH-1:0] inc,
  input tri[DATA_WIDTH-1:0] x,
  output tri[DATA_WIDTH-1:0] y);

  parameter DATA_WIDTH = 8;
  parameter INC_WIDTH = 1;

  logic[DATA_WIDTH-1:0] r;

  initial begin
    r = 0;
  end

  always @(posedge clk)
    if (!rst)
      r <= 0;
    else if (ldx)
      r <= x;
    else
      r <= r + {{DATA_WIDTH-2{1'b0}}, inc};

  assign y = oey ? r : {DATA_WIDTH{1'bz}};
endmodule