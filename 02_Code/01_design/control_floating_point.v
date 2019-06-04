module control_floating_point(clk,rst_n
                              ,ena_fft_core
                              ,ena_mul_fp_clk
                              ,ena_add_fp_clk
                             );

//parameter
parameter OVERLOAD = 9;

//Input define
input clk;
input rst_n;
input ena_fft_core;

//Output define
output ena_mul_fp_clk;
output ena_add_fp_clk;

//Internal signals
reg [3:0] counter;
reg ena_mul_fp_clk;
reg ena_add_fp_clk;
reg  w1;
reg  w2;
reg  w3;
reg  w4;
reg  w5;
reg  w6;
reg  w7;
reg  w8;
reg  w9;
wire[3:0]pre_counter;
wire ena_fft_core;

///////////////////////////////////////////
always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
      counter    <= 0;
      ena_mul_fp_clk <= 1'b0;
    end
    else begin
      if(ena_fft_core) begin
        if (pre_counter == OVERLOAD) begin
          counter    <= 0;
          ena_mul_fp_clk <= 1'b1;
        end
        else begin
          counter    <= pre_counter + 1;
          ena_mul_fp_clk <= 1'b0;
        end
       end
     else begin
          counter    <= 0;
          ena_mul_fp_clk <= 1'b0;
       end
    end
end
assign pre_counter = counter;

///////////////////////////////////////////

always@(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    w1        <= 0;
  end
  else begin
    w1        <= ena_mul_fp_clk;
  end
end
always@(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    w2        <= 0;
  end
  else begin
    w2        <= w1;
  end
end
always@(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    w3        <= 0;
  end
  else begin
    w3        <= w2;
  end
end
always@(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    w4        <= 0;
  end
  else begin
    w4        <= w3;
  end
end
always@(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    w5        <= 0;
  end
  else begin
    w5        <= w4;
  end
end
always@(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    w6        <= 0;
  end
  else begin
    w6        <= w5;
  end
end
always@(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    w7        <= 0;
  end
  else begin
    w7        <= w6;
  end
end
always@(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    w8        <= 0;
  end
  else begin
    w8        <= w7;
  end
end
always@(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    w9        <= 0;
  end
  else begin
    w9        <= w8;
  end
end
always@(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    ena_add_fp_clk        <= 0;
  end
  else begin
    ena_add_fp_clk        <= w9;
  end
end

endmodule







