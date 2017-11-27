module rom(
  input clk, rst,
  input logic[ADDR_WIDTH-1:0] a,
  output logic[DATA_WIDTH-1:0] y
);
  parameter DATA_WIDTH = 8;
  parameter ADDR_WIDTH = 16;
  parameter DATA_FILE = "rom.data";
  logic[DATA_WIDTH-1:0] m[0:2**ADDR_WIDTH-1];
  initial begin
    $readmemh(DATA_FILE, m);
  end

  always @(posedge clk)
    if (!rst)
      y <= 0;
    else
      y <= m[a];

endmodule