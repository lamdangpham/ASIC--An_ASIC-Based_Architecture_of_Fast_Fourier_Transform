module prepare(clk,rst_n
                , ena_prepare
                , stage_number
                , max_point_fft
                , input_addr
                , fft_addr_prepare);
parameter ADDR_WIDTH = 12;
input clk;
input rst_n;
input ena_prepare;
input [3:0]stage_number;
input [ADDR_WIDTH-1:0]max_point_fft;

output [ADDR_WIDTH-1:0]input_addr;
wire   [ADDR_WIDTH-1:0]input_addr;
output [ADDR_WIDTH-1:0]fft_addr_prepare;
reg    [ADDR_WIDTH-1:0]fft_addr_prepare;

wire [ADDR_WIDTH-1:0]pre_count_addr;
reg  [ADDR_WIDTH-1:0]count_addr;
reg  [ADDR_WIDTH-1:0]w1;
wire [ADDR_WIDTH-1:0]w2;

always@(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    count_addr <= 0;
  end
  else if (ena_prepare) begin
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

//always@(posedge clk or negedge rst_n) begin
//  if(!rst_n) begin
//    input_addr <= 0;
//  end
//  else begin
assign    input_addr = pre_count_addr;
//  end
//end

always@(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    w1 <= 0;
  end
  else begin
    case (stage_number)
      1: begin
        w1 <= {11'b0,pre_count_addr[0]};
      end
      2: begin
        w1 <= {10'b0,pre_count_addr[0],pre_count_addr[1]};
      end
      3: begin
        w1 <= {9'b0,pre_count_addr[0],pre_count_addr[1],pre_count_addr[2]};
      end
      4: begin
        w1 <= {8'b0,pre_count_addr[0],pre_count_addr[1],pre_count_addr[2],pre_count_addr[3]};
      end
      5: begin
        w1 <= {7'b0,pre_count_addr[0],pre_count_addr[1],pre_count_addr[2],pre_count_addr[3],pre_count_addr[4]};
      end
      6: begin
        w1 <= {6'b0,pre_count_addr[0],pre_count_addr[1],pre_count_addr[2],pre_count_addr[3],pre_count_addr[4],pre_count_addr[5]};
      end
      7: begin
        w1 <= {5'b0,pre_count_addr[0],pre_count_addr[1],pre_count_addr[2],pre_count_addr[3],pre_count_addr[4],pre_count_addr[5],pre_count_addr[6]};
      end
      8: begin
        w1 <= {4'b0,pre_count_addr[0],pre_count_addr[1],pre_count_addr[2],pre_count_addr[3],pre_count_addr[4],pre_count_addr[5],pre_count_addr[6],pre_count_addr[7]};
      end
      9: begin
        w1 <= {3'b0,pre_count_addr[0],pre_count_addr[1],pre_count_addr[2],pre_count_addr[3],pre_count_addr[4],pre_count_addr[5],pre_count_addr[6],pre_count_addr[7],pre_count_addr[8]};
      end
      default: begin
        w1 <= {2'b0,pre_count_addr[0],pre_count_addr[1],pre_count_addr[2],pre_count_addr[3],pre_count_addr[4],pre_count_addr[5],pre_count_addr[6],pre_count_addr[7],pre_count_addr[8],pre_count_addr[9]};
      end
    endcase
  end
end
assign w2 = w1;

always@(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    fft_addr_prepare <= 0;
  end
  else if (ena_prepare) begin
    fft_addr_prepare <= w2+1;
  end
  else begin
    fft_addr_prepare <= 0;
  end
end
endmodule

