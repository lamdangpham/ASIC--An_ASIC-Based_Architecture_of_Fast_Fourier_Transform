module fft_core_control(clk,rst_n
                      , ena_fft_core
                      , ena_fft_wait
                      , ena_mul_fp_clk
                      , stage_number
                      , stage_level
                      , max_point_fft
                      , fft_addr
                      , jump_fft_addr
                      , w_addr
                      , out_fft_addr
                      );
parameter ADDR_WIDTH = 12;
input clk;
input rst_n;
input ena_fft_core;
input ena_mul_fp_clk;
input ena_fft_wait;
reg ena_fft_result;
input [3:0] stage_level;
input [3:0] stage_number;
input [ADDR_WIDTH-1:0] max_point_fft; 

output [ADDR_WIDTH-1:0] fft_addr;
reg    [ADDR_WIDTH-1:0] fft_addr;
output [ADDR_WIDTH-1:0] w_addr;
reg    [ADDR_WIDTH-1:0] w_addr;
output [ADDR_WIDTH:0] jump_fft_addr;
reg    [ADDR_WIDTH:0] jump_fft_addr;
output [ADDR_WIDTH-1:0] out_fft_addr;
wire   [ADDR_WIDTH-1:0] out_fft_addr;

wire [ADDR_WIDTH-1:0] w2;
wire [ADDR_WIDTH-1:0] w3;
wire [ADDR_WIDTH-1:0] w4;
wire [ADDR_WIDTH-1:0] jump_factor;
wire [ADDR_WIDTH-1:0] pre_w_addr;
wire [ADDR_WIDTH-1:0] pre_sub_jump_factor; //edit
wire [ADDR_WIDTH-1:0] sub_jump_factor; //edit
wire c_in = 1'b0;                      //edit
wire [ADDR_WIDTH-1:0] pre_count_pos;
wire [ADDR_WIDTH-1:0] pre_count_addr;
wire [ADDR_WIDTH-1:0] pre_count_addr_out;
wire pre_is_low_pos;
wire [ADDR_WIDTH:0] jump_fft_addr_inc;
wire [ADDR_WIDTH:0] jump_fft_addr_dec;
wire [3:0] w5;
wire [3:0] w6;
reg ena_rd_w1;
reg [5:0] count_result;
wire [5:0] pre_count_result;

reg [5:0] count_rd;
wire [5:0] pre_count_rd;
wire ena_fft_result_xor_ena_fft_core;
reg ena_fft_core_delay_1clk;

reg [ADDR_WIDTH-1:0] w1;
reg [ADDR_WIDTH-1:0] count_pos;
reg [ADDR_WIDTH-1:0] count_addr;
reg [ADDR_WIDTH-1:0] count_addr_out;
reg is_low_pos;
reg [ADDR_WIDTH-1:0] w7;
wire [ADDR_WIDTH-1:0] w10;
wire w8;
reg w9;
wire pre_w9;

always@(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    w1 <= 0;
  end
  else begin
    case (stage_level)
      0: begin
        w1 <= 0;
      end
      1: begin
        w1 <= 1;
      end
      2: begin
        w1 <= 3;
      end
      3: begin
        w1 <= 7;
      end
      4: begin
        w1 <= 15;
      end
      5: begin
        w1 <= 31;
      end
      6: begin
        w1 <= 63;
      end
      7: begin
        w1 <= 127;
      end
      8: begin
        w1 <= 255;
      end
      9: begin
        w1 <= 511;
      end
      default: begin
        w1 <= 1023;
      end
    endcase
  end
end
assign w2 = w1;
assign w3 = w2 << 1;
assign w4 = w3 + 1;
assign jump_factor = w2 + 1;

always@(posedge clk or negedge rst_n) begin
	if (!rst_n) begin 
		ena_rd_w1 <= 0;
		count_rd <= 0;
	end
	else if (ena_fft_core) begin
	if (pre_count_rd == 9) begin
		ena_rd_w1 <= 0;
		count_rd  <= 0;
	end
	else if (pre_count_rd == 0) begin
		count_rd <= pre_count_rd + 1;
		ena_rd_w1 <= 1;
	end
	else begin
 		count_rd <= pre_count_rd + 1;
		ena_rd_w1 <= 0;
	end
	end
	else begin
		count_rd <= 0;
		ena_rd_w1 <= 0;
	end
end
assign pre_count_rd	= count_rd;
		
always@(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    count_pos <= 0;
    is_low_pos <= 1'b1;
  end
  else if (ena_fft_core) begin
	if (ena_rd_w1) begin
	    if (pre_count_pos == w4) begin
	      count_pos <= 0;
	      is_low_pos <= 1'b1;
	    end
	    else if (pre_count_pos == w2) begin
	      count_pos <= pre_count_pos + 1;
	      is_low_pos <= 1'b0;
	    end
	    else begin
	      count_pos <= pre_count_pos + 1;
	      is_low_pos <= pre_is_low_pos;
	    end
	end
	else begin
		count_pos <= pre_count_pos;
		is_low_pos <= pre_is_low_pos;
	end
  end
  else begin
    count_pos <= 0;
    is_low_pos <= 1'b1;
  end
end

assign pre_count_pos = count_pos;
assign pre_is_low_pos = is_low_pos;
assign pre_sub_jump_factor = {~jump_factor[11:0]}; //Edit
assign sub_jump_factor = pre_sub_jump_factor +1 ; //Edit


always@(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    count_addr <= 0;
  end
  else if (ena_fft_core) begin
	if (ena_rd_w1) begin
	    if (pre_count_addr == max_point_fft) begin
	      count_addr <= 0;
	    end
	    else begin
	      count_addr <= pre_count_addr + 1;
	    end
	end
	else begin
	count_addr <= pre_count_addr;
	end
  end
  else begin
    count_addr <= 0;
  end
end
/////////////////////1:55pm 27 Oct///////////
assign pre_count_addr = count_addr;

always@(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    count_addr_out <= 0;
  end
  else if (ena_fft_result_xor_ena_fft_core || ena_fft_wait) begin
	if(ena_mul_fp_clk) begin
          if (pre_count_addr_out == max_point_fft) begin
          count_addr_out <= 0;
          end
          else begin
          count_addr_out <= pre_count_addr_out + 1;
          end
        end
        else begin
        count_addr_out <= pre_count_addr_out;
        end
  end
  else begin
    count_addr_out <= 0;
  end
end
assign pre_count_addr_out = count_addr_out;
assign out_fft_addr = count_addr_out;//////////////////////sua sau
assign ena_fft_result_xor_ena_fft_core = ena_fft_result ^ ena_fft_core;

always@(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
                ena_fft_result <= 0;
                count_result <= 0;
        end
        else if (ena_fft_core) begin
        if (pre_count_result == 32) begin
                ena_fft_result <= 0;
                count_result  <= 0;
        end
	else if ((pre_count_result == 0) && ena_fft_core_delay_1clk) begin
                ena_fft_result <= 0;
                count_result  <= pre_count_result; 
	end
        else begin
                count_result <= pre_count_result + 1;
                ena_fft_result <= 1;
        end
        end
        else begin
                count_result <= 0;
                ena_fft_result <= 0;
        end
end
assign pre_count_result     = count_result;
always@(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		ena_fft_core_delay_1clk <= 0;
	end
	else begin
		ena_fft_core_delay_1clk <= ena_fft_core;
	end
end



//========================= Call cla_12bit ===============================//

cla_12bit cla_12bit_01(   .a(count_addr)
                         ,.b(jump_factor)
                         ,.c_in(c_in)
                         ,.sum(jump_fft_addr_inc)
                         );

cla_12bit cla_12bit_02(   .a(count_addr)
                         ,.b(sub_jump_factor)
                         ,.c_in(c_in)
                         ,.sum(jump_fft_addr_dec)
                         );
//========================================================================//

assign pre_count_addr = count_addr;
//assign jump_fft_addr_inc = count_addr + jump_factor;
//assign jump_fft_addr_dec = count_addr - jump_factor;

assign w8 = is_low_pos;

always@(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    w9 <=0;
  end
  else begin
	if (ena_rd_w1) begin
   	 w9 <=is_low_pos;
	end
	else begin
	w9 <= pre_w9;
	end
  end
end
assign pre_w9 = w9;
always@(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    jump_fft_addr <= 0;
    fft_addr      <= 0;
  end
  else begin
    if (ena_fft_core) begin
      if (w9) begin
        jump_fft_addr <= jump_fft_addr_inc;
        fft_addr      <= count_addr;
      end
      else begin
        jump_fft_addr <= count_addr;
        fft_addr      <= jump_fft_addr_dec;
      end
    end
    else begin
      jump_fft_addr   <= 0;
      fft_addr        <= 0;
    end
  end
end
// tinh dia chi w
assign w5 = stage_level + 1;
assign w6 = stage_number - w5;
always@(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    w7 <= 0;
  end
  else begin
    case (w6)
      0: begin
        w7 <= pre_count_pos;
      end
      1: begin
        w7 <= {pre_count_pos[10:0],1'b0};
      end
      2: begin
        w7 <= {pre_count_pos[9:0],2'b00};
      end
      3: begin
        w7 <= {pre_count_pos[8:0],3'b000};
      end
      4: begin
        w7 <= {pre_count_pos[7:0],4'b0000};
      end
      5: begin
        w7 <= {pre_count_pos[6:0],5'b0000_0};
      end
      6: begin
        w7 <= {pre_count_pos[5:0],6'b0000_00};
      end
      7: begin
        w7 <= {pre_count_pos[4:0],7'b0000_000};
      end
      8: begin
        w7 <= {pre_count_pos[3:0],8'b0000_0000};
      end
      default: begin
        w7 <= {pre_count_pos[2:0],9'b0000_0000_0};
      end
    endcase
  end
end
assign w10 = w7+1;
always@(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    w_addr <= 0;
  end
  else if (ena_fft_core) begin
	if (ena_rd_w1) begin
	    w_addr <= w10;
	end
	else begin
	    w_addr <= pre_w_addr;
	end
  end
  else begin
    w_addr <= 0;
  end
end
assign pre_w_addr = w_addr;
endmodule
