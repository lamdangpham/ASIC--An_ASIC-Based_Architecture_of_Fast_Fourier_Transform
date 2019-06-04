//============ File : floating_point_adder.v 

module floating_point_adder (clk, rst_n, input_factor_01, input_factor_02, output_adder);

//Parameters
parameter DATA_WIDTH         = 32;
parameter EXPONENT_WIDTH     = 8;
parameter SIGNIFICANDS_WIDTH = 23;
parameter ADDER_WIDTH        = 25;

//Inputs
input clk;
input rst_n;
input [DATA_WIDTH-1:0] input_factor_01;
input [DATA_WIDTH-1:0] input_factor_02;

//Outputs
output [DATA_WIDTH-1:0] output_adder;
wire   [DATA_WIDTH-1:0] output_adder;

//Internal signals
wire sign_factor_01;
wire sign_factor_02;
wire [EXPONENT_WIDTH-1:0]   exponent_factor_01;
wire [EXPONENT_WIDTH-1:0]   exponent_factor_02;
wire [EXPONENT_WIDTH-1:0]   exponent_factor_21;
wire [EXPONENT_WIDTH-1:0]   exponent_factor_12;
wire [SIGNIFICANDS_WIDTH:0] significand_factor_01;
wire [SIGNIFICANDS_WIDTH:0] significand_factor_02;
wire [ADDER_WIDTH-1:0]      add_sub_result;
wire [ADDER_WIDTH-1:0]      sub_result;
wire [ADDER_WIDTH-1:0]      add_result;

//For C_01
wire is_factor_01_zero;
wire is_factor_02_zero;

//For C_04,05
wire [DATA_WIDTH-1:0]exp_xor_bit;
wire is_exp_eqr;

//For C_06,07
wire e0, e1, e2, e3, e4, e5, e6, e7;
wire s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20, s21, s22;
wire is_sig2_lgr_eqr_sig1;
wire is_exp2_lgr_eqr_exp1;

wire is_add_sub_result_zero;
wire is_same_sign;

//For C_10
wire bit_00, bit_01,  bit_02,  bit_03,  bit_04,  bit_05,  bit_06,  bit_07,  bit_08,  bit_09;
wire bit_10, bit_11,  bit_12,  bit_13,  bit_14,  bit_15,  bit_16,  bit_17;
wire bit_18, bit_19,  bit_20, bit_21, bit_22, bit_23, bit_24;
wire bit_temp_01;
wire bit_temp_02;
wire bit_temp_03;
wire bit_temp_04;

reg [EXPONENT_WIDTH-1:0] exp_diff_value;
reg [EXPONENT_WIDTH-1:0] shift_temp_01;
reg [EXPONENT_WIDTH-1:0] shift_temp_02;
reg [EXPONENT_WIDTH-1:0] shift_temp_03;
reg [EXPONENT_WIDTH-1:0] shift_temp_04;

reg [EXPONENT_WIDTH-1:0] larger_exponent;
reg [SIGNIFICANDS_WIDTH:0] shift_smaller_factor;
reg [SIGNIFICANDS_WIDTH:0] larger_factor;

reg [SIGNIFICANDS_WIDTH-1:0] pre_sig_res_01;
reg [SIGNIFICANDS_WIDTH-1:0] pre_sig_res_02;
reg [SIGNIFICANDS_WIDTH-1:0] pre_sig_res_03;
reg [SIGNIFICANDS_WIDTH-1:0] pre_sig_res_04;

wire [SIGNIFICANDS_WIDTH:0] add_1_significand_01;  
wire [SIGNIFICANDS_WIDTH:0] add_1_significand_02;

//For the output
reg  add_output_sign; 
reg  [EXPONENT_WIDTH-1:0]     add_output_exponent;
wire [EXPONENT_WIDTH-1:0]     add_output_exponent_w1;
wire [EXPONENT_WIDTH-1:0]     add_output_exponent_w2;
wire [EXPONENT_WIDTH-1:0]     add_output_exponent_w3;
wire [EXPONENT_WIDTH-1:0]     add_output_exponent_w4;
reg  [SIGNIFICANDS_WIDTH-1:0] add_output_significands;


//========== Get the information ============ //
assign sign_factor_01        = input_factor_01[DATA_WIDTH-1]; 
assign sign_factor_02        = input_factor_02[DATA_WIDTH-1]; 
assign exponent_factor_01    = input_factor_01[DATA_WIDTH-2: DATA_WIDTH-9]; 
assign exponent_factor_02    = input_factor_02[DATA_WIDTH-2: DATA_WIDTH-9];
assign significand_factor_01 = input_factor_01[SIGNIFICANDS_WIDTH-1: 0]; 
assign significand_factor_02 = input_factor_02[SIGNIFICANDS_WIDTH-1: 0];

assign is_factor_01_zero = !(|input_factor_01) ; //C_01
assign is_factor_02_zero = !(|input_factor_02) ; //C_01

assign exp_xor_bit = exponent_factor_01 ^ exponent_factor_02; //C_04
assign is_exp_eqr = !(|exp_xor_bit);//C_05  XXX

assign is_same_sign           = !(sign_factor_01 ^ sign_factor_02); //C_08

//C_06
assign e0 = (!exponent_factor_01[0]) || exponent_factor_02[0]; 
assign e1 = (e0 && exponent_factor_02[1]) || ( (!exponent_factor_01[1]) && (exponent_factor_02[1] || e0) );
assign e2 = (e1 && exponent_factor_02[2]) || ( (!exponent_factor_01[2]) && (exponent_factor_02[2] || e1) );
assign e3 = (e2 && exponent_factor_02[3]) || ( (!exponent_factor_01[3]) && (exponent_factor_02[3] || e2) );
assign e4 = (e3 && exponent_factor_02[4]) || ( (!exponent_factor_01[4]) && (exponent_factor_02[4] || e3) );
assign e5 = (e4 && exponent_factor_02[5]) || ( (!exponent_factor_01[5]) && (exponent_factor_02[5] || e4) );
assign e6 = (e5 && exponent_factor_02[6]) || ( (!exponent_factor_01[6]) && (exponent_factor_02[6] || e5) );
assign e7 = (e6 && exponent_factor_02[7]) || ( (!exponent_factor_01[7]) && (exponent_factor_02[7] || e6) );
assign is_exp2_lgr_eqr_exp1 = e7;

//C_07
assign s0  = (!significand_factor_01[0]) || significand_factor_02[0]; 
assign s1  = (s0  && significand_factor_02[1 ]) || ( (!significand_factor_01[1 ]) && (significand_factor_02[1 ] || s0 ) );
assign s2  = (s1  && significand_factor_02[2 ]) || ( (!significand_factor_01[2 ]) && (significand_factor_02[2 ] || s1 ) );
assign s3  = (s2  && significand_factor_02[3 ]) || ( (!significand_factor_01[3 ]) && (significand_factor_02[3 ] || s2 ) );
assign s4  = (s3  && significand_factor_02[4 ]) || ( (!significand_factor_01[4 ]) && (significand_factor_02[4 ] || s3 ) );
assign s5  = (s4  && significand_factor_02[5 ]) || ( (!significand_factor_01[5 ]) && (significand_factor_02[5 ] || s4 ) );
assign s6  = (s5  && significand_factor_02[6 ]) || ( (!significand_factor_01[6 ]) && (significand_factor_02[6 ] || s5 ) );
assign s7  = (s6  && significand_factor_02[7 ]) || ( (!significand_factor_01[7 ]) && (significand_factor_02[7 ] || s6 ) );
assign s8  = (s7  && significand_factor_02[8 ]) || ( (!significand_factor_01[8 ]) && (significand_factor_02[8 ] || s7 ) );
assign s9  = (s8  && significand_factor_02[9 ]) || ( (!significand_factor_01[9 ]) && (significand_factor_02[9 ] || s8 ) );
assign s10 = (s9  && significand_factor_02[10]) || ( (!significand_factor_01[10]) && (significand_factor_02[10] || s9 ) );
assign s11 = (s10 && significand_factor_02[11]) || ( (!significand_factor_01[11]) && (significand_factor_02[11] || s10) );
assign s12 = (s11 && significand_factor_02[12]) || ( (!significand_factor_01[12]) && (significand_factor_02[12] || s11) );
assign s13 = (s12 && significand_factor_02[13]) || ( (!significand_factor_01[13]) && (significand_factor_02[13] || s12) );
assign s14 = (s13 && significand_factor_02[14]) || ( (!significand_factor_01[14]) && (significand_factor_02[14] || s13) );
assign s15 = (s14 && significand_factor_02[15]) || ( (!significand_factor_01[15]) && (significand_factor_02[15] || s14) );
assign s16 = (s15 && significand_factor_02[16]) || ( (!significand_factor_01[16]) && (significand_factor_02[16] || s15) );
assign s17 = (s16 && significand_factor_02[17]) || ( (!significand_factor_01[17]) && (significand_factor_02[17] || s16) );
assign s18 = (s17 && significand_factor_02[18]) || ( (!significand_factor_01[18]) && (significand_factor_02[18] || s17) );
assign s19 = (s18 && significand_factor_02[19]) || ( (!significand_factor_01[19]) && (significand_factor_02[19] || s18) );
assign s20 = (s19 && significand_factor_02[20]) || ( (!significand_factor_01[20]) && (significand_factor_02[20] || s19) );
assign s21 = (s20 && significand_factor_02[21]) || ( (!significand_factor_01[21]) && (significand_factor_02[21] || s20) );
assign s22 = (s21 && significand_factor_02[22]) || ( (!significand_factor_01[22]) && (significand_factor_02[22] || s21) );
assign is_sig2_lgr_eqr_sig1 = s22;

assign add_1_significand_01[SIGNIFICANDS_WIDTH-1:0] = significand_factor_01;
assign add_1_significand_02[SIGNIFICANDS_WIDTH-1:0] = significand_factor_02;
assign add_1_significand_01[SIGNIFICANDS_WIDTH] = 1'b1;
assign add_1_significand_02[SIGNIFICANDS_WIDTH] = 1'b1;

//S_01
always@(posedge clk or negedge rst_n) begin
    if(rst_n == 1'b0) begin
        exp_diff_value <= 0;
    end
    else if(is_exp_eqr)begin
        exp_diff_value <= 0;
    end
    else if(is_exp2_lgr_eqr_exp1) begin
        exp_diff_value <= exponent_factor_21; //exponent_factor_02 - exponent_factor_01;
    end
    else begin
        exp_diff_value <= exponent_factor_12;//exponent_factor_01 - exponent_factor_02;
    end
end

adder8 adder8_01(.out(exponent_factor_21),.a(exponent_factor_02),.b(exponent_factor_01),.cin(1'b1));
adder8 adder8_02(.out(exponent_factor_12),.a(exponent_factor_01),.b(exponent_factor_02),.cin(1'b1));

always@(posedge clk or negedge rst_n) begin
    if(rst_n == 1'b0) begin
        shift_smaller_factor <= 0;
        larger_factor        <= 0;
    end
    else if(is_exp_eqr)begin
        if(is_sig2_lgr_eqr_sig1) begin
            shift_smaller_factor <= add_1_significand_01;
            larger_factor        <= add_1_significand_02;
            larger_exponent      <= exponent_factor_01;
        end
        else begin
            shift_smaller_factor <= add_1_significand_02;
            larger_factor        <= add_1_significand_01;
            larger_exponent      <= exponent_factor_01;
        end
    end
    else if(is_exp2_lgr_eqr_exp1) begin
        shift_smaller_factor <= (add_1_significand_01 >> exp_diff_value);
        larger_factor        <= add_1_significand_02;
        larger_exponent      <= exponent_factor_02;
    end
    else begin
        shift_smaller_factor <= (add_1_significand_02 >> exp_diff_value);
        larger_factor        <= add_1_significand_01;
        larger_exponent      <= exponent_factor_01;
    end
end

//C_09
//assign sub_result             = larger_factor - shift_smaller_factor;
//assign add_result             = larger_factor + shift_smaller_factor;
assign add_sub_result         = (is_same_sign) ? add_result : sub_result;
assign is_add_sub_result_zero = !(|add_sub_result);

adder24 adder24_01(.out(sub_result),.a(larger_factor),.b(shift_smaller_factor),.cin(1'b1),.clk(clk),.rst_n(rst_n));
adder24 adder24_02(.out(add_result),.a(larger_factor),.b(shift_smaller_factor),.cin(1'b0),.clk(clk),.rst_n(rst_n));

//==========For the sign of output ==========//
always@(posedge clk or negedge rst_n) begin
    if(rst_n == 1'b0) begin
        add_output_sign <= 0;
    end 
    else if(is_add_sub_result_zero) begin 
        add_output_sign <= 0;
    end
    else if(is_same_sign) begin // same sign
        add_output_sign <= sign_factor_01;
    end
    else begin // different sign
        if(is_factor_01_zero)begin
            add_output_sign <= sign_factor_02; 
        end
        else if(is_factor_02_zero) begin
            add_output_sign <= sign_factor_01; 
        end
        else if(is_exp_eqr) begin
            if(is_sig2_lgr_eqr_sig1)begin
                add_output_sign <= sign_factor_02 && (!sign_factor_01);
            end
            else begin
                add_output_sign <= (!sign_factor_02) && sign_factor_01;
            end
        end
        else if(is_exp2_lgr_eqr_exp1) begin
            add_output_sign <= sign_factor_02 && (!sign_factor_01);
        end
        else begin     
            add_output_sign <= (!sign_factor_02) && sign_factor_01;
        end            
    end                
end   
                 
//C_10
assign bit_24 = add_sub_result[24];
assign bit_23 = add_sub_result[23] && (!add_sub_result[24]);
assign bit_22 = add_sub_result[22] && (!(|add_sub_result[24:23]));
assign bit_21 = add_sub_result[21] && (!(|add_sub_result[24:22]));
assign bit_20 = add_sub_result[20] && (!(|add_sub_result[24:21]));
assign bit_19 = add_sub_result[19] && (!(|add_sub_result[24:20]));
assign bit_18 = add_sub_result[18] && (!(|add_sub_result[24:19]));
assign bit_17 = add_sub_result[17] && (!(|add_sub_result[24:18]));
assign bit_16 = add_sub_result[16] && (!(|add_sub_result[24:17]));
assign bit_15 = add_sub_result[15] && (!(|add_sub_result[24:16]));
assign bit_14 = add_sub_result[14] && (!(|add_sub_result[24:15]));
assign bit_13 = add_sub_result[13] && (!(|add_sub_result[24:14]));
assign bit_12 = add_sub_result[12] && (!(|add_sub_result[24:13]));
assign bit_11 = add_sub_result[11] && (!(|add_sub_result[24:12]));
assign bit_10 = add_sub_result[10] && (!(|add_sub_result[24:11]));
assign bit_09 = add_sub_result[09] && (!(|add_sub_result[24:10]));
assign bit_08 = add_sub_result[08] && (!(|add_sub_result[24:9] ));
assign bit_07 = add_sub_result[07] && (!(|add_sub_result[24:8] ));
assign bit_06 = add_sub_result[06] && (!(|add_sub_result[24:7] ));
assign bit_05 = add_sub_result[05] && (!(|add_sub_result[24:6] ));
assign bit_04 = add_sub_result[04] && (!(|add_sub_result[24:5] ));
assign bit_03 = add_sub_result[03] && (!(|add_sub_result[24:4] ));
assign bit_02 = add_sub_result[02] && (!(|add_sub_result[24:3] ));
assign bit_01 = add_sub_result[01] && (!(|add_sub_result[24:2] ));
assign bit_00 = add_sub_result[00] && (!(|add_sub_result[24:1] ));

assign bit_temp_01 = bit_24|bit_23;
assign bit_temp_02 = bit_22|bit_21|bit_20|bit_19|bit_18|bit_17|bit_16|bit_15;
assign bit_temp_03 = bit_14|bit_13|bit_12|bit_11|bit_10|bit_09|bit_08;
assign bit_temp_04 = bit_07|bit_06|bit_05|bit_04|bit_03|bit_02|bit_01|bit_00;

// S_04
always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        shift_temp_01  <= 0;
        pre_sig_res_01 <= 0;
    end
    else if(bit_24) begin
        shift_temp_01  <= 1;
        pre_sig_res_01 <= add_sub_result[23:1];
    end
    else begin
        shift_temp_01  <= 0;
        pre_sig_res_01 <= add_sub_result[22:0];
    end
end 
                     
always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        shift_temp_02  <= 0;
        pre_sig_res_02 <= 0;
    end
    else if(bit_22) begin
        shift_temp_02  <= 1; 
        pre_sig_res_02 <= {add_sub_result[21:0],1'b0};
    end
    else if(bit_21) begin
        shift_temp_02  <= 2;
        pre_sig_res_02 <= {add_sub_result[20:0],{2{1'b0}}};
    end
    else if(bit_20) begin
        shift_temp_02  <= 3;
        pre_sig_res_02 <= {add_sub_result[19:0],{3{1'b0}}};
    end
    else if(bit_19)begin
        shift_temp_02  <= 4; 
        pre_sig_res_02 <= {add_sub_result[18:0],{4{1'b0}}};
    end
    else if(bit_18) begin
        shift_temp_02  <= 5;
        pre_sig_res_02 <= {add_sub_result[17:0],{5{1'b0}}};
    end
    else if(bit_17) begin
        shift_temp_02  <= 6;
        pre_sig_res_02 <= {add_sub_result[16:0],{6{1'b0}}};
    end
    else if(bit_16) begin
        shift_temp_02  <= 7;
        pre_sig_res_02 <= {add_sub_result[15:0],{7{1'b0}}};
    end
    else begin
        shift_temp_02  <= 8; //15
        pre_sig_res_02 <= {add_sub_result[14:0],{8{1'b0}}};
    end
end 
                     
always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        shift_temp_03  <= 0;
    end
    else if(bit_14) begin
        shift_temp_03  <= 9;
        pre_sig_res_03 <= {add_sub_result[13:0],{9{1'b0}}};
    end
    else if(bit_13) begin
        shift_temp_03  <= 10;
        pre_sig_res_03 <= {add_sub_result[12:0],{10{1'b0}}};
    end
    else if(bit_12) begin
        shift_temp_03  <= 11;
        pre_sig_res_03 <= {add_sub_result[11:0],{11{1'b0}}};
    end
    else if(bit_11) begin
        shift_temp_03  <= 12;
        pre_sig_res_03 <= {add_sub_result[10:0],{12{1'b0}}};
    end
    else if(bit_10) begin
        shift_temp_03  <= 13;
        pre_sig_res_03 <= {add_sub_result[9:0], {13{1'b0}}};
    end
    else if(bit_09) begin
        shift_temp_03  <= 14;
        pre_sig_res_03 <= {add_sub_result[8:0], {14{1'b0}}};
    end
    else begin
        shift_temp_03  <= 15; //08
        pre_sig_res_03 <= {add_sub_result[7:0], {15{1'b0}}};
    end
end
                      
always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        shift_temp_04  <= 0;
        pre_sig_res_04 <= 0;
    end
    else if(bit_07) begin
        shift_temp_04  <= 16;
        pre_sig_res_04 <= {add_sub_result[6:0], {16{1'b0}}};
    end
    else if(bit_06) begin
        shift_temp_04 <= 17;
        pre_sig_res_04 <= {add_sub_result[5:0], {17{1'b0}}};
    end
    else if(bit_05) begin
        shift_temp_04 <= 18;
        pre_sig_res_04 <= {add_sub_result[4:0], {18{1'b0}}};
    end
    else if(bit_04) begin
        shift_temp_04 <= 19;
        pre_sig_res_04 <= {add_sub_result[3:0], {19{1'b0}}};
    end
    else if(bit_03) begin
        shift_temp_04 <= 20;
        pre_sig_res_04 <= {add_sub_result[2:0], {20{1'b0}}};
    end
    else if(bit_02) begin
        shift_temp_04 <= 21;
        pre_sig_res_04 <= {add_sub_result[1:0], {21{1'b0}}};
    end
    else if(bit_01) begin
        shift_temp_04 <= 22;
        pre_sig_res_04 <= {add_sub_result[0],   {22{1'b0}}};
    end
    else begin
        shift_temp_04  <= 23; //0
        pre_sig_res_04 <= {23{1'b0}};
    end
end                      

// ================================== CLK 5 ================================== //
always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
         add_output_exponent     <= 0;
         add_output_significands <= 0;
    end
    else if(is_factor_01_zero) begin
         add_output_exponent     <= exponent_factor_02;
         add_output_significands <= significand_factor_02;
    end
    else if(is_factor_02_zero) begin
         add_output_exponent     <= exponent_factor_01;
         add_output_significands <= significand_factor_01;
    end
    else if(is_add_sub_result_zero) begin
         add_output_exponent     <= 0;
         add_output_significands <= 0;
    end
    else if(bit_temp_01) begin
         add_output_exponent     <= add_output_exponent_w1;//larger_exponent + shift_temp_01;
         add_output_significands <= pre_sig_res_01;
    end
    else if(bit_temp_02) begin
         add_output_exponent     <= add_output_exponent_w2;//larger_exponent - shift_temp_02;
         add_output_significands <= pre_sig_res_02;
    end
    else if(bit_temp_03) begin
         add_output_exponent     <= add_output_exponent_w3;//larger_exponent - shift_temp_03;
         add_output_significands <= pre_sig_res_03;
    end
    else begin
         add_output_exponent     <= add_output_exponent_w4;//larger_exponent - shift_temp_04;
         add_output_significands <= pre_sig_res_04;
    end
end

                       
adder8 adder8_03(.out(add_output_exponent_w1),.a(larger_exponent),.b(shift_temp_01),.cin(1'b0));
adder8 adder8_04(.out(add_output_exponent_w2),.a(larger_exponent),.b(shift_temp_02),.cin(1'b1));
adder8 adder8_05(.out(add_output_exponent_w3),.a(larger_exponent),.b(shift_temp_03),.cin(1'b1));
adder8 adder8_06(.out(add_output_exponent_w4),.a(larger_exponent),.b(shift_temp_04),.cin(1'b1));

//===========Export the output value===========//
assign output_adder[DATA_WIDTH-1]                  = add_output_sign;
assign output_adder[(DATA_WIDTH-2):(DATA_WIDTH-9)] = add_output_exponent;
assign output_adder[(DATA_WIDTH-10):0]             = add_output_significands;

endmodule
