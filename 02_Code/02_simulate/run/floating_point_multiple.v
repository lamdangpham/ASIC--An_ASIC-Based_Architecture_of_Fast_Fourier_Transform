
module floating_point_multiple (clk, rst_n, input_factor_01, input_factor_02, output_multiply);

//Parameters
parameter DATA_WIDTH         = 32;
parameter EXPONENT_WIDTH     = 8;
parameter SIGNIFICANDS_WIDTH = 23;
parameter MULTIPLY_WIDTH     = 48;

//parameter POS_EXP            = 150;
//parameter SUM_BIAS_MUWID     = 174;
//Inputs
input clk;
input rst_n;
input [DATA_WIDTH-1:0] input_factor_01;
input [DATA_WIDTH-1:0] input_factor_02;

//Outputs
output [DATA_WIDTH-1:0] output_multiply;
wire   [DATA_WIDTH-1:0] output_multiply;

//Internal signals
wire [EXPONENT_WIDTH-1:0]     exponent_factor_01;
wire [EXPONENT_WIDTH-1:0]     exponent_factor_02;
wire [EXPONENT_WIDTH-1:0]     exponent_factor_12;
wire [SIGNIFICANDS_WIDTH-1:0] significand_factor_01;
wire [SIGNIFICANDS_WIDTH-1:0] significand_factor_02;
wire [SIGNIFICANDS_WIDTH:0]   add_1_sig_factor_01;
wire [SIGNIFICANDS_WIDTH:0]   add_1_sig_factor_02;
wire [50:0] mulout;

wire sign_factor_01;
wire sign_factor_02;
wire is_factor_01_zero;
wire is_factor_02_zero;
wire is_factor_zero;

reg  exponent_larger_bias_flag_factor_01;
reg  exponent_larger_bias_flag_factor_02;
wire is_exp_01_lgr_eqr_bias;
wire is_exp_02_lgr_eqr_bias;

//wire  [MULTIPLY_WIDTH-1:0] decimal_factor_01;
//wire  [MULTIPLY_WIDTH-1:0] decimal_factor_02;
reg  [MULTIPLY_WIDTH-1:0] base_multiply_result;
wire  is_1_final_flag;

//For outputs
reg  mul_output_sign;
wire [EXPONENT_WIDTH-1:0]pre_mul_output_exponent;
reg  [EXPONENT_WIDTH-1:0]mul_output_exponent;
reg  [SIGNIFICANDS_WIDTH-1:0] mul_output_significand;

// ====================================== Main functiona  32'b1100_0001_0101_0110_0000_0000_0000_0000 ============================//

assign sign_factor_01        = input_factor_01[DATA_WIDTH-1]; 
assign sign_factor_02        = input_factor_02[DATA_WIDTH-1]; 
assign exponent_factor_01    = input_factor_01[DATA_WIDTH-2: DATA_WIDTH-9]; 
assign exponent_factor_02    = input_factor_02[DATA_WIDTH-2: DATA_WIDTH-9];
assign significand_factor_01 = input_factor_01[SIGNIFICANDS_WIDTH-1: 0]; 
assign significand_factor_02 = input_factor_02[SIGNIFICANDS_WIDTH-1: 0];

assign add_1_sig_factor_01[SIGNIFICANDS_WIDTH]     = 1'b1;    
assign add_1_sig_factor_02[SIGNIFICANDS_WIDTH]     = 1'b1;
assign add_1_sig_factor_01[SIGNIFICANDS_WIDTH-1:0] = significand_factor_01;
assign add_1_sig_factor_02[SIGNIFICANDS_WIDTH-1:0] = significand_factor_02;


assign is_factor_01_zero = !(|input_factor_01) ; 
assign is_factor_02_zero = !(|input_factor_02) ; 
assign is_factor_zero    = is_factor_01_zero || is_factor_02_zero; 

assign is_exp_01_lgr_eqr_bias = exponent_factor_01[7] || (&exponent_factor_01[6:0]);
assign is_exp_02_lgr_eqr_bias = exponent_factor_02[7] || (&exponent_factor_01[6:0]);

// ============================================ CLK 1======================================== //
always@(posedge clk or negedge rst_n) begin 
    if(!rst_n) begin
        mul_output_sign <= 0;
    end
    else if (is_factor_zero) begin
        mul_output_sign <= 0;
    end
    else begin
        mul_output_sign <= sign_factor_01 ^ sign_factor_02;
    end
end

always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        base_multiply_result <= 0;
    end
    else begin
        base_multiply_result <= mulout[47:0];//add_1_sig_factor_01 * add_1_sig_factor_02;  // 48 bit result 
    end
end

mul26 mul26_01(.mulout(mulout)
		, .in1({2'b0,add_1_sig_factor_01})
		, .in2({2'b0,add_1_sig_factor_02})
		, .en(1'b1)
		, .clk(clk) ,.reset(rst_n));

assign is_1_final_flag   = base_multiply_result[MULTIPLY_WIDTH -1];
//assign decimal_factor_01 = POS_EXP - exponent_factor_01;
//assign decimal_factor_02 = POS_EXP - exponent_factor_02;
//assign pre_mul_output_exponent  = SUM_BIAS_MUWID - decimal_factor_01 - decimal_factor_02;

//assign pre_mul_output_exponent  = exponent_factor_01 + exponent_factor_02 - 126;            //TODO For Addition

adder8 adder8_01(.out(exponent_factor_12),.a(exponent_factor_01),.b(exponent_factor_02),.cin(1'b0));
adder8 adder8_02(.out(pre_mul_output_exponent),.a(exponent_factor_12),.b(8'b01111110),.cin(1'b1));

//always@(posedge clk) begin  
//    #1 $display("significand_01: %b; significand_02: %b", significand_factor_01, significand_factor_02);
//    #1 $display("exponent_01: %d; decimal_factor_01: %d", exponent_factor_01, decimal_factor_01);
//    #1 $display("exponent_02: %d; decimal_factor_02: %d", exponent_factor_02, decimal_factor_02);
//end

// ============================================ CLK 2======================================== //
always@(posedge clk or negedge rst_n)begin
    if(!rst_n) begin
        mul_output_significand <= 0;
    end
    else if (is_factor_zero) begin
        mul_output_significand <= 0;
    end
    else if (is_1_final_flag) begin 
        mul_output_significand <= base_multiply_result[MULTIPLY_WIDTH-2: MULTIPLY_WIDTH-24]; 
    end
    else begin
        mul_output_significand <= base_multiply_result[MULTIPLY_WIDTH-3: MULTIPLY_WIDTH-25]; 
    end
end

always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        mul_output_exponent <= 0;
    end
    else if (is_factor_zero) begin
        mul_output_exponent <= 0;
    end
    else if (is_1_final_flag) begin
        mul_output_exponent <= pre_mul_output_exponent;
    end
    else begin 
        mul_output_exponent <= pre_mul_output_exponent - 1;
    end
end

//Export the output value
assign output_multiply[DATA_WIDTH-1]                  = mul_output_sign;
assign output_multiply[(DATA_WIDTH-2):(DATA_WIDTH-9)] = mul_output_exponent;
assign output_multiply[(DATA_WIDTH-10):0]             = mul_output_significand;

endmodule
