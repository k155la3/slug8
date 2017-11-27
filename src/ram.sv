module ram(
  input wclk, rclk0, rclk1, rst, we, re0, re1,
  input tri[ADDR_WIDTH-1:0] a,
  input tri[DATA_WIDTH-1:0] x,
  output tri[DATA_WIDTH-1:0] y
);
  parameter DATA_WIDTH = 8;
  parameter ADDR_WIDTH = 16;
  parameter DATA_FILE = "ram.data";

  logic[DATA_WIDTH-1:0] m[0:2**ADDR_WIDTH-1];
  logic[DATA_WIDTH-1:0] r0, r1;

  initial begin
    $readmemh(DATA_FILE, m);
  end

  always @(posedge wclk)
    if (we)
      m[a] <= x;

  always @(posedge rclk0)
    if (!rst)
      r0 <= 0;
    else if (re0)
      r0 <= m[a];

  always @(posedge rclk1)
    if (!rst)
      r1 <= 0;
    else if (re1)
      r1 <= m[a];

  assign y = re0 ? r0 : (re1 ? r1 : {DATA_WIDTH{1'bz}});
endmodule