module fft_core( clk, rst_n
                , ena_fft_core
                , ena_mul_fp_clk
                , ena_add_fp_clk
                , real_fft_input
                , image_fft_input
                , real_fft_input_jump
                , image_fft_input_jump
                , real_w_input
                , image_w_input
                , real_fft_core
                , image_fft_core
                );

parameter DATA_WIDTH = 32;

input clk;
input rst_n;
input ena_fft_core;
input ena_mul_fp_clk;
input ena_add_fp_clk;
input [DATA_WIDTH-1:0] real_fft_input;
input [DATA_WIDTH-1:0] image_fft_input;
input [DATA_WIDTH-1:0] real_fft_input_jump;
input [DATA_WIDTH-1:0] image_fft_input_jump;
input [DATA_WIDTH-1:0] real_w_input;
input [DATA_WIDTH-1:0] image_w_input;

output [DATA_WIDTH-1:0] real_fft_core;
output [DATA_WIDTH-1:0] image_fft_core;
reg    [DATA_WIDTH-1:0] real_fft_core;
reg    [DATA_WIDTH-1:0] image_fft_core;

reg   [DATA_WIDTH-1:0] real_next_fft_input;
reg   [DATA_WIDTH-1:0] real_next_fft_input_jump;
reg   [DATA_WIDTH-1:0] real_next_w_input;
reg   [DATA_WIDTH-1:0] real_next_fft_input_01;
reg   [DATA_WIDTH-1:0] real_next_fft_input_03;
reg   [DATA_WIDTH-1:0] real_next_mul_out_01;
reg   [DATA_WIDTH-1:0] real_next_mul_out_02;
wire  [DATA_WIDTH-1:0] sub_real_next_mul_out_02;
reg   [DATA_WIDTH-1:0] real_next_add_out_01;
reg   [DATA_WIDTH-1:0] image_next_fft_input;
reg   [DATA_WIDTH-1:0] image_next_fft_input_jump;
reg   [DATA_WIDTH-1:0] image_next_w_input;
reg   [DATA_WIDTH-1:0] image_next_fft_input_01;
reg   [DATA_WIDTH-1:0] image_next_fft_input_03;
reg   [DATA_WIDTH-1:0] image_next_mul_out_01;
reg   [DATA_WIDTH-1:0] image_next_mul_out_02;
reg   [DATA_WIDTH-1:0] image_next_add_out_01;

wire   [DATA_WIDTH-1:0] real_next_fft_input_02;
wire   [DATA_WIDTH-1:0] real_next_fft_input_04;
wire   [DATA_WIDTH-1:0] real_mul_out_01;
wire   [DATA_WIDTH-1:0] real_mul_out_02;
wire   [DATA_WIDTH-1:0] real_add_out_01;
wire   [DATA_WIDTH-1:0] real_add_out_02;
wire   [DATA_WIDTH-1:0] image_next_fft_input_02;
wire   [DATA_WIDTH-1:0] image_next_fft_input_04;
wire   [DATA_WIDTH-1:0] image_mul_out_01;
wire   [DATA_WIDTH-1:0] image_mul_out_02;
wire   [DATA_WIDTH-1:0] image_add_out_01;
wire   [DATA_WIDTH-1:0] image_add_out_02;
//=============================================//
wire   [DATA_WIDTH-1:0] pre_real_fft_input; 
wire   [DATA_WIDTH-1:0] pre_image_fft_input;
wire   [DATA_WIDTH-1:0] pre_real_fft_input_jump;
wire   [DATA_WIDTH-1:0] pre_image_fft_input_jump;
wire   [DATA_WIDTH-1:0] pre_real_w_input;
wire   [DATA_WIDTH-1:0] pre_image_w_input;
wire   [DATA_WIDTH-1:0] pre_real_mul_out_01;
wire   [DATA_WIDTH-1:0] pre_real_mul_out_02;
wire   [DATA_WIDTH-1:0] pre_image_mul_out_01;
wire   [DATA_WIDTH-1:0] pre_image_mul_out_02;
wire   [DATA_WIDTH-1:0] pre_real_next_fft_input_02;
wire   [DATA_WIDTH-1:0] pre_image_next_fft_input_02;
wire   [DATA_WIDTH-1:0] pre_real_next_fft_input_04;
wire   [DATA_WIDTH-1:0] pre_image_next_fft_input_04;
wire   [DATA_WIDTH-1:0] pre_real_add_out_01;
wire   [DATA_WIDTH-1:0] pre_image_add_out_01;


wire   [DATA_WIDTH-1:0] pre_real_add_out_02;
wire   [DATA_WIDTH-1:0] pre_image_add_out_02;

//=========================clk 1===========================
always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
       real_next_fft_input <= 0;
    end
    else if(ena_fft_core) begin 
            if(ena_mul_fp_clk)begin    
            	real_next_fft_input <= real_fft_input;
            end
            else begin
            	real_next_fft_input <= pre_real_fft_input;
            end
    end
    else begin
        real_next_fft_input <= 0;
    end
end

assign pre_real_fft_input = real_next_fft_input;

always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
       image_next_fft_input <= 0;
    end
    else if(ena_fft_core) begin
            if(ena_mul_fp_clk)begin
                image_next_fft_input <= image_fft_input;
            end
            else begin
               image_next_fft_input <= pre_image_fft_input;
            end
    end
    else begin
        image_next_fft_input <= 0;
    end
end
assign pre_image_fft_input = image_next_fft_input;

always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        real_next_fft_input_jump <= 0;
    end
    else if(ena_fft_core) begin
             if(ena_mul_fp_clk)begin
                real_next_fft_input_jump <= real_fft_input_jump;
             end
             else begin
                real_next_fft_input_jump <= pre_real_fft_input_jump;
             end
    end
    else begin
        real_next_fft_input_jump <= 0;
    end
end
assign pre_real_fft_input_jump = real_next_fft_input_jump;

always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        image_next_fft_input_jump <= 0;
    end
    else if(ena_fft_core) begin
             if(ena_mul_fp_clk)begin
                image_next_fft_input_jump <= image_fft_input_jump;
             end
             else begin
                image_next_fft_input_jump <= pre_image_fft_input_jump;
             end
   end
   else begin
        image_next_fft_input_jump <= 0;
    end
end
assign pre_image_fft_input_jump = image_next_fft_input_jump;

always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        real_next_w_input <= 0;
    end
    else if(ena_fft_core) begin
             if(ena_mul_fp_clk)begin
                 real_next_w_input <= real_w_input;
             end
             else begin
                 real_next_w_input <= pre_real_w_input;
             end
    end
    else begin
        real_next_w_input <= 0;
    end
end
assign pre_real_w_input = real_next_w_input;

always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        image_next_w_input <= 0;
    end
    else if(ena_fft_core) begin
             if(ena_mul_fp_clk)begin
                 image_next_w_input <= image_w_input;
             end
             else begin
                 image_next_w_input <= pre_image_w_input;
             end
    end
    else begin
        image_next_w_input <= 0;
    end
end
assign pre_image_w_input = image_next_w_input;

//=================== CALL Multiply ===============//
floating_point_multiple floating_point_multiple_01 ( .clk(clk)
                                         , .rst_n(rst_n)
                                         , .input_factor_01(real_next_w_input)
                                         , .input_factor_02(real_next_fft_input_jump)
                                         , .output_multiply(real_mul_out_01)
                                         );

floating_point_multiple floating_point_multiple_02 ( .clk(clk)
                                         , .rst_n(rst_n)
                                         , .input_factor_01(image_next_w_input)
                                         , .input_factor_02(image_next_fft_input_jump)
                                         , .output_multiply(real_mul_out_02)
                                         );
floating_point_multiple floating_point_multiple_03 ( .clk(clk)
                                         , .rst_n(rst_n)
                                         , .input_factor_01(real_next_w_input)
                                         , .input_factor_02(image_next_fft_input_jump)
                                         , .output_multiply(image_mul_out_01)
                                         );
floating_point_multiple floating_point_multiple_04 ( .clk(clk)
                                         , .rst_n(rst_n)
                                         , .input_factor_01(image_next_w_input)
                                         , .input_factor_02(real_next_fft_input_jump)
                                         , .output_multiply(image_mul_out_02)
                                         );

//=================== CLK 2 =====================//
always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
       real_next_mul_out_01 <= 0;
    end
    else if(ena_fft_core)begin
             if(ena_add_fp_clk)begin
                 real_next_mul_out_01 <= real_mul_out_01;
             end
             else begin
                 real_next_mul_out_01 <= pre_real_mul_out_01;
             end
    end
    else begin
      real_next_mul_out_01 <= 0;
    end
end
assign pre_real_mul_out_01 = real_next_mul_out_01;

always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
       real_next_mul_out_02 <= 0;
    end
    else if(ena_fft_core)begin
             if(ena_add_fp_clk)begin
             real_next_mul_out_02 <= real_mul_out_02;
             end
             else begin
             real_next_mul_out_02 <= pre_real_mul_out_02;
             end
    end
    else begin
       real_next_mul_out_02 <= 0;
    end
end
assign pre_real_mul_out_02 = real_next_mul_out_02;

assign sub_real_next_mul_out_02 = {~real_next_mul_out_02[31],real_next_mul_out_02[30:0]};

always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
       image_next_mul_out_01 <= 0;
    end
    else if(ena_fft_core)begin
             if(ena_add_fp_clk)begin
                image_next_mul_out_01 <= image_mul_out_01;
             end
             else begin
                image_next_mul_out_01 <= pre_image_mul_out_01;
             end
    end
    else begin
       image_next_mul_out_01 <= 0;
    end
end
assign pre_image_mul_out_01 = image_next_mul_out_01;

always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
       image_next_mul_out_02 <= 0;
    end
    else if(ena_fft_core)begin
             if(ena_add_fp_clk)begin
                 image_next_mul_out_02 <= image_mul_out_02;
             end
             else begin
                 image_next_mul_out_02 <= pre_image_mul_out_02;
             end
    end
    else begin
       image_next_mul_out_02 <= 0;
    end
end
assign pre_image_mul_out_02 = image_next_mul_out_02;

assign  real_next_fft_input_02 = real_next_fft_input;
always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        real_next_fft_input_01 <= 0;
    end
    else if(ena_fft_core)begin
             if(ena_add_fp_clk)begin
                real_next_fft_input_01 <= real_next_fft_input_02;
             end
             else begin
                real_next_fft_input_01 <= pre_real_next_fft_input_02; 
             end
    end
    else begin
        real_next_fft_input_01 <= 0;
    end
end
assign pre_real_next_fft_input_02 = real_next_fft_input_01;

assign  image_next_fft_input_02 = image_next_fft_input;
always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        image_next_fft_input_01 <= 0;
    end
    else if(ena_fft_core)begin
             if(ena_add_fp_clk)begin
                 image_next_fft_input_01 <= image_next_fft_input_02;
             end
             else begin
                 image_next_fft_input_01 <= pre_image_next_fft_input_02;
             end
    end
    else begin
        image_next_fft_input_01 <= 0;
    end   
end
assign pre_image_next_fft_input_02 = image_next_fft_input_01;

//======================= CALL Adder ===============//
floating_point_adder floating_point_adder_01 ( .clk(clk)
                                      , .rst_n(rst_n)
                                      , .input_factor_01(real_next_mul_out_01)
                                      , .input_factor_02(sub_real_next_mul_out_02)
                                      , .output_adder(real_add_out_01)
                                      );
floating_point_adder floating_point_adder_02 ( .clk(clk)
                                      , .rst_n(rst_n)
                                      , .input_factor_01(image_next_mul_out_01)
                                      , .input_factor_02(image_next_mul_out_02)
                                      , .output_adder(image_add_out_01)
                                      );

//=================== CLK3 =====================//
assign  real_next_fft_input_04 = real_next_fft_input_01;
always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        real_next_fft_input_03 <= 0;
    end
    else if(ena_fft_core)begin
             if(ena_add_fp_clk)begin
                 real_next_fft_input_03 <= real_next_fft_input_04;
             end
             else begin
                 real_next_fft_input_03 <= pre_real_next_fft_input_04;
             end
    end
    else begin
         real_next_fft_input_03 <= 0;
    end
end
assign pre_real_next_fft_input_04 = real_next_fft_input_03;

assign  image_next_fft_input_04 = image_next_fft_input_01;
always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        image_next_fft_input_03 <= 0;
    end
    else if(ena_fft_core)begin
             if(ena_add_fp_clk)begin
                 image_next_fft_input_03 <= image_next_fft_input_04;
             end
             else begin
                 image_next_fft_input_03 <= pre_image_next_fft_input_04;
             end
    end
    else begin
        image_next_fft_input_03 <= 0;
    end
end
assign pre_image_next_fft_input_04 = image_next_fft_input_03;

always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        real_next_add_out_01 <= 0;
    end
    else if(ena_fft_core)begin
             if(ena_add_fp_clk)begin
                 real_next_add_out_01 <= real_add_out_01;
             end
             else begin
                 real_next_add_out_01 <= pre_real_add_out_01;
             end
    end
    else begin
        real_next_add_out_01 <= 0;
    end
end
assign pre_real_add_out_01 = real_next_add_out_01;

always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        image_next_add_out_01 <= 0;
    end
    else if(ena_fft_core)begin
             if(ena_add_fp_clk)begin
                 image_next_add_out_01 <= image_add_out_01;
             end
             else begin
                 image_next_add_out_01 <= pre_image_add_out_01;
             end
    end
    else begin
        image_next_add_out_01 <= 0;
    end
end
assign pre_image_add_out_01 = image_next_add_out_01;

//======================= CALL Adder ===============//
floating_point_adder floating_point_adder_03 ( .clk(clk)
                                      , .rst_n(rst_n)
                                      , .input_factor_01(real_next_fft_input_03)
                                      , .input_factor_02(real_next_add_out_01)
                                      , .output_adder(real_add_out_02)
                                      );
floating_point_adder floating_point_adder_04 ( .clk(clk)
                                      , .rst_n(rst_n)
                                      , .input_factor_01(image_next_fft_input_03)
                                      , .input_factor_02(image_next_add_out_01)
                                      , .output_adder(image_add_out_02)
                                      );
//=====================clk4=========================//
always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
       real_fft_core <= 0;
    end
    else begin
       if(ena_add_fp_clk) begin
       real_fft_core  <= real_add_out_02;
       end
       else begin
       real_fft_core  <= pre_real_add_out_02;
       end
    end
end
assign pre_real_add_out_02 = real_fft_core;

always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
       image_fft_core <= 0;
    end
    else begin
       if(ena_add_fp_clk) begin
       image_fft_core  <= image_add_out_02;
       end
       else begin
       image_fft_core  <= pre_image_add_out_02;
       end
    end
end
assign pre_image_add_out_02 = image_fft_core;

endmodule
