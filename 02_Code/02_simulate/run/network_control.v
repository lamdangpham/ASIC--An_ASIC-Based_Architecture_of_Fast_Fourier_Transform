module network_control (clk
           , rst_n
           , ena_fft
           , ena_prepare
           , ena_fft_core
           , ena_fft_wait
           , ena_arrange
           , end_fft
           , max_point_fft
           , max_point_fft_core
	   , stage_level
           , stage_number
           , wr_ena_int_01
           , wr_ena_int_02
           , wr_ena_int_03
           , wr_ena_int_04
           , wr_ena_int_05
           , wr_ena_int_06
           );

//============== PARAMETER

//For state machine

parameter RESET          = 0;
parameter INITIAL        = 1;
parameter PREPARE        = 2;
parameter FFT_CORE       = 3;
parameter FFT_WAIT       = 4;
parameter ARRANGE        = 5;

parameter ADDR_WIDTH = 12;
parameter MAX_WAIT_TIME = 7;
//======================input==========================
input clk;
input rst_n;
input ena_fft;
//======================output=========================
output ena_prepare;
reg    ena_prepare;
output ena_fft_core;
reg    ena_fft_core;
output ena_fft_wait;
reg    ena_fft_wait;
output ena_arrange;
reg    ena_arrange;
output end_fft;
wire   end_fft;
output [ADDR_WIDTH -1:0]max_point_fft;
wire   [ADDR_WIDTH -1:0]max_point_fft;
output [15:0]max_point_fft_core;
wire   [15:0]max_point_fft_core;
output [3:0]stage_number;
wire   [3:0]stage_number;
output [3:0]stage_level;
output wr_ena_int_01;
output wr_ena_int_02;
output wr_ena_int_03;
output wr_ena_int_04;
output wr_ena_int_05;
output wr_ena_int_06;
reg    wr_ena_int_01;
reg    wr_ena_int_02;
reg    wr_ena_int_03;
reg    wr_ena_int_04;
reg    wr_ena_int_05;
reg    wr_ena_int_06;
reg    w_01;
reg    w_02;
reg    w_03;
reg    w_04;
reg    w_05;
reg    w_06;
//=====================wire============================

reg    flag_end;
wire   pre_flag_end;
reg    [2:0] state;
reg    [ADDR_WIDTH -1:0] counter_prepare;
wire   [ADDR_WIDTH -1:0] pre_counter_prepare;
reg    [15:0] counter_fft_core;
wire   [15:0] pre_counter_fft_core;
reg    [ADDR_WIDTH -1:0] counter_fft_wait;
wire   [ADDR_WIDTH -1:0] pre_counter_fft_wait;
reg    [ADDR_WIDTH -1:0] counter_arrange;
wire   [ADDR_WIDTH -1:0] pre_counter_arrange;
reg    ena_state1;
reg    ena_state2;
reg    ena_state3;
reg    ena_state4;
wire   ena_state;   
reg    [2:0] next_state;
reg    w1;
wire   ena_fft_core_flag;
wire   w2;
reg    w3;
wire   w4;
wire pre_end_fft;
reg w5;
reg w6;
reg w7;
reg w8;
reg w9;
reg w10;
reg w11;
reg w12;
reg w13;
reg w14;
reg    [3:0]stage_level;
wire   [3:0]pre_stage_level;

//=================== STATE MACHINE TO CONTROL =====================//
always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        state <= RESET;
    end
    else begin
        state <= next_state;
    end
end

always@(*) begin
    case (state) 
        RESET: begin
            next_state <= INITIAL;
        end
        INITIAL: begin
            if (ena_fft) begin
               next_state   <= PREPARE;
            end
            else begin
               next_state <= state;
            end
        end
        PREPARE: begin
            if (ena_state) begin
               next_state <= FFT_CORE;
            end
            else begin
               next_state   <= state;
            end
        end
        ARRANGE: begin
            if(!flag_end) begin
               if (ena_state) begin
                  next_state <= FFT_CORE;
               end
               else begin
                  next_state   <= state;
               end
            end
            else begin
               next_state   <= INITIAL;
            end
        end
        FFT_CORE: begin
            if(ena_state) begin
               next_state <= FFT_WAIT;
            end
            else begin
               next_state   <= state;
            end
        end
        FFT_WAIT: begin
            if(ena_state) begin
               next_state <= ARRANGE;
            end
            else begin
               next_state   <= state;
            end
        end
  endcase
end
//*************************/Output of state machine to control data flow
always@(state) begin
        case(state)
          INITIAL: begin
            ena_prepare    <= 1'b0;
            ena_fft_core   <= 1'b0;
            ena_fft_wait   <= 1'b0;
            ena_arrange    <= 1'b0;
            w_01  <= 1'b0;
            w_02  <= 1'b0;
            w_03  <= 1'b0;
            w_04  <= 1'b0;
            w_05  <= 1'b0;
            w_06  <= 1'b0;
          end
          PREPARE: begin
            ena_prepare    <= 1'b1;
            ena_fft_core   <= 1'b0;
            ena_fft_wait   <= 1'b0;
            ena_arrange    <= 1'b0;
            w_01  <= 1'b1;
            w_02  <= 1'b1;
            w_03  <= 1'b0;
            w_04  <= 1'b1;
            w_05  <= 1'b1;
            w_06  <= 1'b0;
          end
          FFT_CORE: begin
            ena_prepare    <= 1'b0;
            ena_fft_core   <= 1'b1;
            ena_fft_wait   <= 1'b0;
            ena_arrange    <= 1'b0;
            w_01  <= 1'b0;
            w_02  <= 1'b0;
            w_03  <= 1'b1;
            w_04  <= 1'b0;
            w_05  <= 1'b0;
            w_06  <= 1'b1;
          end
          FFT_WAIT: begin
            ena_prepare    <= 1'b0;
            ena_fft_core   <= 1'b0;
            ena_fft_wait   <= 1'b1;
            ena_arrange    <= 1'b0;
            w_01  <= 1'b0;
            w_02  <= 1'b0;
            w_03  <= 1'b1;
            w_04  <= 1'b0;
            w_05  <= 1'b0;
            w_06  <= 1'b1;
          end
          ARRANGE: begin
            ena_prepare    <= 1'b0;
            ena_fft_core   <= 1'b0;
            ena_fft_wait   <= 1'b0;
            ena_arrange    <= 1'b1;
            w_01  <= 1'b1;
            w_02  <= 1'b1;
            w_03  <= 1'b0;
            w_04  <= 1'b1;
            w_05  <= 1'b1;
            w_06  <= 1'b0;
          end
          default: begin 
            ena_prepare    <= 1'b0;
            ena_fft_core   <= 1'b0;
            ena_fft_wait   <= 1'b0;
            ena_arrange    <= 1'b0;
            w_01  <= 1'b0;
            w_02  <= 1'b0;
            w_03  <= 1'b0;
            w_04  <= 1'b0;
            w_05  <= 1'b0;
            w_06  <= 1'b0;
           end
        endcase
    end
//================Counter prepare========================
always@(posedge clk or negedge rst_n) begin    
    if(!rst_n) begin
      counter_prepare  <= 0;
      ena_state1     <= 1'b0;
    end
    else begin
      if(ena_prepare) begin
        if (pre_counter_prepare == max_point_fft) begin
          counter_prepare  <= 0;
          ena_state1     <= 1'b1;
        end
        else begin               
          counter_prepare  <= pre_counter_prepare + 1;
          ena_state1     <= 1'b0;
        end
       end
       else begin
               counter_prepare <= 0;
               ena_state1    <= 1'b0;
       end
    end
end
assign pre_counter_prepare = counter_prepare;
//==============Counter fft==============================
always@(posedge clk or negedge rst_n) begin    
    if(!rst_n) begin
      counter_fft_core  <= 0;
      ena_state2        <= 1'b0;
    end
    else begin
      if(ena_fft_core) begin
        if (pre_counter_fft_core == max_point_fft_core) begin  
          counter_fft_core  <= 0;
          ena_state2        <= 1'b1;
        end
        else begin               
          counter_fft_core  <= pre_counter_fft_core + 1;
          ena_state2        <= 1'b0;
        end
       end
       else begin
          counter_fft_core <= 0;
          ena_state2       <= 1'b0;
       end
    end
end
assign pre_counter_fft_core = counter_fft_core;

//==============Counter wait==============================
always@(posedge clk or negedge rst_n) begin    
    if(!rst_n) begin
      counter_fft_wait  <= 0;
      ena_state3        <= 1'b0;
    end
    else begin
      if(ena_fft_wait) begin
        if (pre_counter_fft_wait == MAX_WAIT_TIME) begin  
          counter_fft_wait  <= 0;
          ena_state3        <= 1'b1;
        end
        else begin               
          counter_fft_wait  <= pre_counter_fft_wait + 1;
          ena_state3        <= 1'b0;
        end
       end
       else begin
          counter_fft_wait <= 0;
          ena_state3       <= 1'b0;
       end
    end
end
assign pre_counter_fft_wait = counter_fft_wait;


//====================Counter arrange=====================================
always@(posedge clk or negedge rst_n) begin    
    if(!rst_n) begin
      counter_arrange  <= 0;
      ena_state4        <= 1'b0;
    end
    else begin
      if(ena_arrange) begin
        if (pre_counter_arrange == max_point_fft+2) begin
          counter_arrange  <= 0;
          ena_state4        <= 1'b1;
        end
        else begin               
          counter_arrange  <= pre_counter_arrange + 1;
          ena_state4        <= 1'b0;
        end
       end
       else begin
               counter_arrange <= 0;
               ena_state4       <= 1'b0;
       end
    end
end
assign pre_counter_arrange = counter_arrange;

assign ena_state = ((ena_state1 | ena_state2) | ena_state3 | ena_state4); 
//=================== tinh stage_level=================================
always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
     	stage_level <= 0;
      flag_end    <= 1'b0;
    end
    else begin
      if (ena_fft_core_flag) begin
          if (stage_level == (stage_number - 1)) begin
            stage_level <= 0;
            flag_end    <= 1'b1;
          end
          else begin
            stage_level <= pre_stage_level + 1;
            flag_end    <= 1'b0;
          end
      end
      else begin
         stage_level <= pre_stage_level;
         flag_end    <= pre_flag_end;
      end
    end
end
assign pre_stage_level = stage_level;
assign pre_flag_end    = flag_end;
//-----------------enable---------------
always@(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    wr_ena_int_01 <= 0;
    wr_ena_int_02 <= 0;
    wr_ena_int_03 <= 0;
    wr_ena_int_04 <= 0;
    wr_ena_int_05 <= 0;
    wr_ena_int_06 <= 0;
  end
  else begin
    wr_ena_int_01 <= w_01;
    wr_ena_int_02 <= w_02;
    wr_ena_int_03 <= w_03;
    wr_ena_int_04 <= w_04;
    wr_ena_int_05 <= w_05;
    wr_ena_int_06 <= w_06;
  end
end
//========================= xu ly tin hieu ena_fft============================
always@(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		w1 <= 0;
	end
	else begin 
        	w1 <= ena_fft_core;
	end
end
assign w2 = w1 ^ ena_fft_core;
assign ena_fft_core_flag = w1 &  w2;
//=================== xu ly tin hieu out_fft============================
always@(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		w3 <= 1'b0;
	end
	else begin
       	 	w3 <= flag_end;
	end
end

assign w4 = w3 ^ flag_end;
assign pre_end_fft = flag_end &  w4;

always@(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
                w5 <= 0;
        end
        else begin
                w5 <= pre_end_fft;
        end
end

always@(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
                w6 <= 0;
        end
        else begin
                w6 <= w5;
        end
end
always@(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
                w7 <= 0;
        end
        else begin
                w7 <= w6;
        end
end
always@(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
                w8 <= 0;
        end
        else begin
                w8 <= w7;
        end
end
always@(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
                w9 <= 0;
        end
        else begin
                w9 <= w8;
        end
end
always@(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
                w10 <= 0;
        end
        else begin
                w10 <= w9;
        end
end
always@(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
                w11 <= 0;
        end
        else begin
                w11 <= w10;
        end
end
always@(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
                w12 <= 0;
        end
        else begin
                w12 <= w11;
        end
end
always@(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
                w13 <= 0;
        end
        else begin
                w13 <= w12;
        end
end
always@(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
                w14 <= 0;
        end
        else begin
                w14 <= w13;
        end
end
assign end_fft = w14;

//==================== doc cac du lieu tu bo nho====================================
//para_input para_input01(.clk(clk), .rst_n(rst_n), .max_point_fft(max_point_fft), .max_point_fft_core(max_point_fft_core), .stage_number(stage_number)); 
endmodule
