module top_fft(clk
               ,rst_n
               ,ena_fft
               ,ena_mag
               ,data_rd_int_01
               ,data_rd_int_02
               ,data_rd_int_03
               ,data_rd_int_04
               ,data_rd_int_05
               ,data_rd_int_06
               ,data_w_real
               ,data_w_image
               ,wr_ena_int_01        
               ,wr_ena_int_02
               ,wr_ena_int_03
               ,wr_ena_int_04
               ,wr_ena_int_05
               ,wr_ena_int_06
               ,addr_mem_int_01
               ,addr_mem_int_02
               ,addr_mem_int_03
               ,addr_mem_int_04
               ,addr_mem_int_05
               ,addr_mem_int_06
               ,addr_input
               ,addr_w
               ,data_wr_int_01
               ,data_wr_int_02
               ,data_wr_int_03
               ,data_wr_int_04
               ,data_wr_int_05
               ,data_wr_int_06
               ,data_input
               ,stage_number
               ,max_point_fft
               ,max_point_fft_core
               );


parameter ADDR_WIDTH = 12;
parameter DATA_WIDTH = 32;
input clk;
input rst_n;
input ena_fft;

input [3:0]stage_number;
input [ADDR_WIDTH-1:0]max_point_fft;
input [15:0]max_point_fft_core;
wire [3:0]stage_number;
wire [ADDR_WIDTH-1:0]max_point_fft;
wire [15:0]max_point_fft_core;

output ena_mag;
////////////03/11/2015//////////

input[DATA_WIDTH-1:0] data_rd_int_01;
input[DATA_WIDTH-1:0] data_rd_int_02;
input[DATA_WIDTH-1:0] data_rd_int_03;
input[DATA_WIDTH-1:0] data_rd_int_04;
input[DATA_WIDTH-1:0] data_rd_int_05;
input[DATA_WIDTH-1:0] data_rd_int_06;
input[DATA_WIDTH-1:0] data_w_real;
input[DATA_WIDTH-1:0] data_w_image;

output wr_ena_int_01;
output wr_ena_int_02;
output wr_ena_int_03;
output wr_ena_int_04;
output wr_ena_int_05;
output wr_ena_int_06;
output[ADDR_WIDTH-1:0] addr_mem_int_01;
output[ADDR_WIDTH-1:0] addr_mem_int_02;
output[ADDR_WIDTH-1:0] addr_mem_int_03;
output[ADDR_WIDTH-1:0] addr_mem_int_04;
output[ADDR_WIDTH-1:0] addr_mem_int_05;
output[ADDR_WIDTH-1:0] addr_mem_int_06;
output[ADDR_WIDTH-1:0] addr_input;
output[ADDR_WIDTH-1:0] addr_w;
output[DATA_WIDTH-1:0] data_wr_int_01;
output[DATA_WIDTH-1:0] data_wr_int_02;
output[DATA_WIDTH-1:0] data_wr_int_03;
output[DATA_WIDTH-1:0] data_wr_int_04;
output[DATA_WIDTH-1:0] data_wr_int_05;
output[DATA_WIDTH-1:0] data_wr_int_06;
output[DATA_WIDTH-1:0] data_input;
/////////////////////////////
wire ena_mag;

//===========int - signal=====
wire clk;
wire  wr_ena_int_01;
wire  wr_ena_int_02;
wire  wr_ena_int_03;
wire  wr_ena_int_04;
wire  wr_ena_int_05;
wire  wr_ena_int_06;
wire ena_prepare;
wire ena_fft_core;
wire ena_mul_fp_clk;
wire ena_add_fp_clk;
reg  w1;
reg  w2;
reg  w3;
reg  w4;
reg  w5;
reg  w6;
reg  w7;
reg  w8;
wire ena_fft_wait;
wire ena_arrange;
reg  w9;
reg  w10;
wire w11;
wire [3:0]ena_sel;
reg  [ADDR_WIDTH-1:0]addr_rd_int_01;
reg  [ADDR_WIDTH-1:0]addr_rd_int_02;
reg  [ADDR_WIDTH-1:0]addr_rd_int_03;
reg  [ADDR_WIDTH-1:0]addr_rd_int_04;
reg  [ADDR_WIDTH-1:0]addr_rd_int_05;
reg  [ADDR_WIDTH-1:0]addr_rd_int_06;
reg  [ADDR_WIDTH-1:0]addr_wr_int_01;
reg  [ADDR_WIDTH-1:0]addr_wr_int_02;
reg  [ADDR_WIDTH-1:0]addr_wr_int_03;
reg  [ADDR_WIDTH-1:0]addr_wr_int_04;
reg  [ADDR_WIDTH-1:0]addr_wr_int_05;
reg  [ADDR_WIDTH-1:0]addr_wr_int_06;
wire [ADDR_WIDTH-1:0]addr_input;
wire [ADDR_WIDTH-1:0]addr_fft_prepare;
wire [ADDR_WIDTH-1:0]addr_fft;
wire [ADDR_WIDTH:0]addr_jump_fft;
wire [ADDR_WIDTH-1:0]addr_fft_out;
reg  [ADDR_WIDTH-1:0]addr_w;
wire [ADDR_WIDTH-1:0]addr_w1;
reg  [ADDR_WIDTH-1:0]addr_w2;
wire [ADDR_WIDTH-1:0]addr_arrange;
wire [ADDR_WIDTH-1:0]addr_arrange_out;
wire [3:0]stage_level;
wire [DATA_WIDTH-1:0]data_rd_int_01;
wire [DATA_WIDTH-1:0]data_rd_int_02;
wire [DATA_WIDTH-1:0]data_rd_int_03;
wire [DATA_WIDTH-1:0]data_rd_int_04;
wire [DATA_WIDTH-1:0]data_rd_int_05;
wire [DATA_WIDTH-1:0]data_rd_int_06;
reg  [DATA_WIDTH-1:0]data_wr_int_01;
reg  [DATA_WIDTH-1:0]data_wr_int_02;
reg  [DATA_WIDTH-1:0]data_wr_int_03;
reg  [DATA_WIDTH-1:0]data_wr_int_04;
reg  [DATA_WIDTH-1:0]data_wr_int_05;
reg  [DATA_WIDTH-1:0]data_wr_int_06;
wire [DATA_WIDTH-1:0]data_w_real;
wire [DATA_WIDTH-1:0]data_w_image;
wire [DATA_WIDTH-1:0]data_input;
reg  [DATA_WIDTH-1:0]real_fft_input;
reg  [DATA_WIDTH-1:0]real_arrange_in;
wire [DATA_WIDTH-1:0]real_arrange_out;
wire [DATA_WIDTH-1:0]real_fft_core;
wire [DATA_WIDTH-1:0]real_w_input;
reg  [DATA_WIDTH-1:0]real_fft_input_jump;
reg  [DATA_WIDTH-1:0]image_arrange_in;
wire [DATA_WIDTH-1:0]image_arrange_out;
wire [DATA_WIDTH-1:0]image_fft_core;
reg  [DATA_WIDTH-1:0]image_fft_input;
reg  [DATA_WIDTH-1:0]image_fft_input_jump;
wire [DATA_WIDTH-1:0]image_w_input;

//-------------------------mem input--------------------------------------
mem_input mem_input_01(.clk(clk), .addr(addr_input)
                      , .data(data_input), .wr_ena(1'b0));

//-------------------------real mem_int-----------------------------------

assign addr_mem_int_01 = (wr_ena_int_01)?addr_wr_int_01:addr_rd_int_01;
mem_int mem_int_01  (.clk(clk)
          , .addr(addr_mem_int_01)
          , .data_rd(data_rd_int_01)
          , .wr_ena(wr_ena_int_01)
          , .data_wr(data_wr_int_01)
          );

assign addr_mem_int_02 = (wr_ena_int_02)?addr_wr_int_02:addr_rd_int_02;
mem_int mem_int_02  (.clk(clk)
          , .addr(addr_mem_int_02)
          , .data_rd(data_rd_int_02)
          , .wr_ena(wr_ena_int_02)
          , .data_wr(data_wr_int_02)
          );

assign addr_mem_int_03 = (wr_ena_int_03)?addr_wr_int_03:addr_rd_int_03;
mem_int mem_int_03  (.clk(clk)
          , .addr(addr_mem_int_03)
          , .data_rd(data_rd_int_03)
          , .wr_ena(wr_ena_int_03)
          , .data_wr(data_wr_int_03)
          );
//--------------------------image_mem_int----------------------------------

assign addr_mem_int_04 = (wr_ena_int_04)?addr_wr_int_04:addr_rd_int_04;
mem_int mem_int_04  (.clk(clk)
          , .addr(addr_mem_int_04)
          , .data_rd(data_rd_int_04)
          , .wr_ena(wr_ena_int_04)
          , .data_wr(data_wr_int_04)
          );

assign addr_mem_int_05 = (wr_ena_int_05)?addr_wr_int_05:addr_rd_int_05;
mem_int mem_int_05  (.clk(clk)
          , .addr(addr_mem_int_05)
          , .data_rd(data_rd_int_05)
          , .wr_ena(wr_ena_int_05)
          , .data_wr(data_wr_int_05)
          );

assign addr_mem_int_06 = (wr_ena_int_06)?addr_wr_int_06:addr_rd_int_06;
mem_int mem_int_06  (.clk(clk)
          , .addr(addr_mem_int_06)
          , .data_rd(data_rd_int_06)
          , .wr_ena(wr_ena_int_06)
          , .data_wr(data_wr_int_06)
          );
//-----------------------------real w-----------------------------------
mem_w_real mem_w_real_01(.clk(clk), .addr(addr_w)
              , .data(data_w_real), .wr_ena(1'b0));
//-----------------------------image_w---------------------------------
mem_w_image mem_w_image_01(.clk(clk), .addr(addr_w)
              , .data(data_w_image), .wr_ena(1'b0)); // read only

//--------------- Control_floating_point------------------//
control_floating_point control_floating_point_01(.clk(clk)
                              , .rst_n(rst_n)
                              , .ena_fft_core(ena_fft_core)
                              , .ena_mul_fp_clk(ena_mul_fp_clk)
                              , .ena_add_fp_clk(ena_add_fp_clk)
                              );

//------------------------ lay du lieu tu mem int----------------------
assign ena_sel = {ena_arrange,ena_fft_wait,ena_fft_core,ena_prepare};

always@(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
        addr_rd_int_01 <= 0; 
        addr_rd_int_02 <= 0;
        addr_rd_int_03 <= 0;
        addr_rd_int_04 <= 0;
        addr_rd_int_05 <= 0;
        addr_rd_int_06 <= 0;
        addr_wr_int_01 <= 0;
        addr_wr_int_02 <= 0;
        addr_wr_int_03 <= 0;
        addr_wr_int_04 <= 0;
        addr_wr_int_05 <= 0;
        addr_wr_int_06 <= 0;

        data_wr_int_01 <= 0;
        data_wr_int_02 <= 0;
        data_wr_int_03 <= 0;
        data_wr_int_04 <= 0;
        data_wr_int_05 <= 0;
        data_wr_int_06 <= 0;
  end
  else begin
    case (ena_sel)
      4'b0001: begin //prepare
        addr_rd_int_01 <= 0;
        addr_rd_int_02 <= 0;
        addr_rd_int_03 <= 0;
        addr_rd_int_04 <= 0;
        addr_rd_int_05 <= 0;
        addr_rd_int_06 <= 0;
        addr_wr_int_01 <= addr_fft_prepare;
        addr_wr_int_02 <= addr_fft_prepare;
        addr_wr_int_03 <= 0;
        addr_wr_int_04 <= addr_fft_prepare;
        addr_wr_int_05 <= addr_fft_prepare;
        addr_wr_int_06 <= 0;

        data_wr_int_01 <= data_input;
        data_wr_int_02 <= data_input;
        data_wr_int_03 <= 0;
        data_wr_int_04 <= 0; 
        data_wr_int_05 <= 0;
        data_wr_int_06 <= 0;
      end
      4'b0010: begin //fft_core_control
        addr_rd_int_01 <= addr_fft; 
        addr_rd_int_02 <= addr_jump_fft;
        addr_rd_int_03 <= 0;
        addr_rd_int_04 <= addr_fft;
        addr_rd_int_05 <= addr_jump_fft;
        addr_rd_int_06 <= 0;
        addr_wr_int_01 <= 0;
        addr_wr_int_02 <= 0;
        addr_wr_int_03 <= addr_fft_out;
        addr_wr_int_04 <= 0;
        addr_wr_int_05 <= 0;
        addr_wr_int_06 <= addr_fft_out;

        data_wr_int_01 <= 0;
        data_wr_int_02 <= 0;
        data_wr_int_03 <= real_fft_core;
        data_wr_int_04 <= 0;
        data_wr_int_05 <= 0;
        data_wr_int_06 <= image_fft_core;
      end
      4'b0100: begin // fft_wait
        addr_rd_int_01 <= 0; 
        addr_rd_int_02 <= 0;
        addr_rd_int_03 <= 0;
        addr_rd_int_04 <= 0;
        addr_rd_int_05 <= 0;
        addr_rd_int_06 <= 0;
        addr_wr_int_01 <= 0;
        addr_wr_int_02 <= 0;
        addr_wr_int_03 <= addr_fft_out;
        addr_wr_int_04 <= 0;
        addr_wr_int_05 <= 0;
        addr_wr_int_06 <= addr_fft_out;

        data_wr_int_01 <= 0;
        data_wr_int_02 <= 0;
        data_wr_int_03 <= real_fft_core;
        data_wr_int_04 <= 0;
        data_wr_int_05 <= 0;
        data_wr_int_06 <= image_fft_core;
      end
      4'b1000: begin // arrange,addr_arrange la read mem 3,6/addr_arrange_out la write 1245/ hai thang nay lech nhau 1 clk
        addr_rd_int_01 <= 0;
        addr_rd_int_02 <= 0;
        addr_rd_int_03 <= addr_arrange;
        addr_rd_int_04 <= 0;
        addr_rd_int_05 <= 0;
        addr_rd_int_06 <= addr_arrange;
        addr_wr_int_01 <= addr_arrange_out;
        addr_wr_int_02 <= addr_arrange_out;
        addr_wr_int_03 <= 0;
        addr_wr_int_04 <= addr_arrange_out;
        addr_wr_int_05 <= addr_arrange_out;
        addr_wr_int_06 <= 0;

        data_wr_int_01 <= real_arrange_out;
        data_wr_int_02 <= real_arrange_out;
        data_wr_int_03 <= 0;
        data_wr_int_04 <= image_arrange_out;
        data_wr_int_05 <= image_arrange_out;
        data_wr_int_06 <= 0;
      end
      default: begin
        addr_rd_int_01 <= 0; 
        addr_rd_int_02 <= 0;
        addr_rd_int_03 <= 0;
        addr_rd_int_04 <= 0;
        addr_rd_int_05 <= 0;
        addr_rd_int_06 <= 0;
        addr_wr_int_01 <= 0;
        addr_wr_int_02 <= 0;
        addr_wr_int_03 <= 0;
        addr_wr_int_04 <= 0;
        addr_wr_int_05 <= 0;
        addr_wr_int_06 <= 0;

        data_wr_int_01 <= 0;
        data_wr_int_02 <= 0;
        data_wr_int_03 <= 0;
        data_wr_int_04 <= 0;
        data_wr_int_05 <= 0;
        data_wr_int_06 <= 0;
      end
    endcase
  end
end
//------------------------------ xap xep lan dau tien----------------
prepare prepare_01(.clk(clk), .rst_n(rst_n)
           , .ena_prepare(ena_prepare)
           , .stage_number(stage_number)
           , .max_point_fft(max_point_fft)
           , .input_addr(addr_input)
           , .fft_addr_prepare(addr_fft_prepare)
           );
//----------------------------- address for w mem--------------------
always@(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    addr_w2 <= 0;
  end
  else begin
    addr_w2 <= addr_w1;
  end
end
always@(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    addr_w <= 0;
  end
  else begin
    addr_w <= addr_w2;
  end
end
assign real_w_input = data_w_real; 
assign image_w_input = data_w_image; 

//------------------- tinh canh buom-----------------------------
fft_core_control fft_core_control_01(.clk(clk), .rst_n(rst_n)
           , .ena_fft_core(ena_fft_core)
          // , .ena_result_fft(w8) // w8 la tin hieu ena_fft_core delay
           , .ena_mul_fp_clk(ena_mul_fp_clk)
           , .ena_fft_wait(ena_fft_wait)
           , .stage_number(stage_number)
           , .stage_level(stage_level)
           , .max_point_fft(max_point_fft)
           , .fft_addr(addr_fft)
           , .jump_fft_addr(addr_jump_fft)
           , .w_addr(addr_w1)
           , .out_fft_addr(addr_fft_out)
           );

always@(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    w1        <= 0;
  end
  else begin
    w1        <= ena_fft_core;
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
    real_fft_input        <= 0;
    real_fft_input_jump   <= 0;
    image_fft_input       <= 0;
    image_fft_input_jump  <= 0;
  end
  else if (w2) begin
    real_fft_input        <= data_rd_int_01;
    real_fft_input_jump   <= data_rd_int_02;
    image_fft_input       <= data_rd_int_04;
    image_fft_input_jump  <= data_rd_int_05;
  end
  else begin
    real_fft_input        <= 0;
    real_fft_input_jump   <= 0;
    image_fft_input       <= 0;
    image_fft_input_jump  <= 0;
  end
end    
fft_core fft_core_01(.clk(clk), .rst_n(rst_n)
           , .ena_fft_core(ena_fft_core) 
           , .ena_mul_fp_clk(ena_mul_fp_clk)
           , .ena_add_fp_clk(ena_add_fp_clk)
           , .real_fft_input(real_fft_input)
           , .image_fft_input(image_fft_input)
           , .real_fft_input_jump(real_fft_input_jump)
           , .image_fft_input_jump(image_fft_input_jump)
           , .real_w_input(real_w_input)
           , .image_w_input(image_w_input)
           , .real_fft_core(real_fft_core)
           , .image_fft_core(image_fft_core)
           );
//---------------------------------- xap sep lai
arrange arrange_01(.clk(clk), .rst_n(rst_n)
           , .ena_arrange(ena_arrange)
           , .max_point_fft(max_point_fft)
           , .arrange_addr(addr_arrange)
           , .arrange_addr_out(addr_arrange_out)
           );
always@(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    w9        <= 0;
  end
  else begin
    w9        <= ena_arrange;
  end
end 
always@(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    w10        <= 0;
  end
  else begin
    w10        <= w9;
  end
end 
assign w11 = w10 & ena_arrange;
always@(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    real_arrange_in   <= 0;
    image_arrange_in  <= 0;
  end
  else if (w11) begin
    real_arrange_in   <= data_rd_int_03;
    image_arrange_in  <= data_rd_int_06;
  end
  else begin
    real_arrange_in   <= 0;
    image_arrange_in  <= 0;
  end
end
assign real_arrange_out = real_arrange_in;
assign image_arrange_out = image_arrange_in;
//-----------------------network control --------------------
network_control network_control_01 (.clk(clk)
          , .rst_n(rst_n)
          , .ena_fft(ena_fft)
          , .ena_prepare(ena_prepare)
          , .ena_fft_core(ena_fft_core)
          , .ena_fft_wait(ena_fft_wait)
          , .ena_arrange(ena_arrange)
          , .end_fft(ena_mag)
          , .max_point_fft(max_point_fft)
          , .max_point_fft_core(max_point_fft_core)
          , .stage_level(stage_level)
          , .stage_number(stage_number)
          , .wr_ena_int_01(wr_ena_int_01)
          , .wr_ena_int_02(wr_ena_int_02)
          , .wr_ena_int_03(wr_ena_int_03)
          , .wr_ena_int_04(wr_ena_int_04)
          , .wr_ena_int_05(wr_ena_int_05)
          , .wr_ena_int_06(wr_ena_int_06)
          );
endmodule
