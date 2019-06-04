module arrange (clk,rst_n
            , ena_arrange
            , max_point_fft
            , arrange_addr
            , arrange_addr_out
            );
parameter ADDR_WIDTH = 12;
input clk;
input rst_n;
input ena_arrange;
input  [ADDR_WIDTH-1:0]max_point_fft;
output [ADDR_WIDTH-1:0]arrange_addr;
wire   [ADDR_WIDTH-1:0]arrange_addr;
output [ADDR_WIDTH-1:0]arrange_addr_out;
reg    [ADDR_WIDTH-1:0]arrange_addr_out;//***
reg    [ADDR_WIDTH-1:0]w1;              //***
reg    [ADDR_WIDTH-1:0]w2;              //***
wire   [ADDR_WIDTH-1:0]pre_count_addr;
reg    [ADDR_WIDTH-1:0]count_addr;

always@(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    count_addr <= 0;
  end
  else if (ena_arrange) begin
    if (pre_count_addr == max_point_fft) begin
      count_addr <= 0;
    end
    else begin
      count_addr <= pre_count_addr + 1;
    end
  end
  else begin
    count_addr <= 0;
  end
end
assign pre_count_addr = count_addr;
assign arrange_addr = count_addr;

always@(posedge clk or negedge rst_n) begin 
  if (!rst_n) begin
    w1 <= 0;
  end
  else begin
    w1 <= arrange_addr;
  end
end

always@(posedge clk or negedge rst_n) begin 
  if (!rst_n) begin
    w2 <= 0;
  end
  else begin
    w2 <= w1;
  end
end

always@(posedge clk or negedge rst_n) begin 
  if (!rst_n) begin
    arrange_addr_out <= 0;
  end
  else begin
    arrange_addr_out <= w2;
  end
end

endmodule
