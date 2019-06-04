module para_input(clk,rst_n,stage_number,max_point_fft,max_point_fft_core);
input clk;
input rst_n;
output [3:0]stage_number;
reg    [3:0]stage_number;
output [11:0]max_point_fft;
reg    [11:0]max_point_fft;

output [15:0]max_point_fft_core;
reg    [15:0]max_point_fft_core;

always@(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    stage_number <= 0;
    max_point_fft <= 0;
    max_point_fft_core <= 0;
  end
  else begin
    stage_number <= 3;
    max_point_fft <= 8;
    max_point_fft_core <= 110;
  end
end
endmodule
