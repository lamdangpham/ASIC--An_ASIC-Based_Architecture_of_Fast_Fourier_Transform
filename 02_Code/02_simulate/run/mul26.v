//26*26 multiplier,output 51bit (1 sign bit plus 50 data bits)
module mul26(mulout
		,in1
		,in2
		,en
		,clk
		,reset
		);
//input
input [25:0]in1; //26 bit 2's complement (1 sign bit plus 25 data bits)
input [25:0]in2; //26 bit 2's complement (1 sign bit plus 25 data bits)

input en;
input clk;
input reset;

//output
output [50:0]mulout; //51bit 2's complement (1 sign bit plus 50 data bits)
wire   [50:0]mulout; 

//internal signal
wire [26:0]boothout1;//length(booth)=length(in2)+1
wire [26:0]boothout2;
wire [26:0]boothout3;
wire [26:0]boothout4;
wire [26:0]boothout5;
wire [26:0]boothout6;
wire [26:0]boothout7;
wire [26:0]boothout8;
wire [26:0]boothout9;
wire [26:0]boothout10;
wire [26:0]boothout11;
wire [26:0]boothout12;
wire [26:0]boothout13;

wire [50:0]cout1;
wire [50:0]cout2;
wire [50:0]cout3;
wire [50:0]cout4;
wire [50:0]cout5;
wire [50:0]cout6;
wire [50:0]cout7;
wire [50:0]cout8;
wire [50:0]cout9;
wire [50:0]cout10;
wire [50:0]cout11;
wire [50:0]cout12;

wire [50:0]mulout1;
wire [50:0]mulout2;
wire [50:0]mulout3;
wire [50:0]mulout4;
wire [50:0]mulout5;
wire [50:0]mulout6;
wire [50:0]mulout7;
wire [50:0]mulout8;
wire [50:0]mulout9;
wire [50:0]mulout10;
wire [50:0]mulout11;
wire [50:0]mulout12;

reg  [50:0]a;
reg  [50:0]b;
wire [50:0]sum;

//==========See 5.4.2 Multiplier============// 
booth27 booth1(boothout1,{in1[1:0],1'b0},in2);
booth27 booth2(boothout2,in1[3:1],in2);
booth27 booth3(boothout3,in1[5:3],in2);
booth27 booth4(boothout4,in1[7:5],in2);
booth27 booth5(boothout5,in1[9:7],in2);
booth27 booth6(boothout6,in1[11:9],in2);
booth27 booth7(boothout7,in1[13:11],in2);
booth27 booth8(boothout8,in1[15:13],in2);
booth27 booth9(boothout9,in1[17:15],in2);
booth27 booth10(boothout10,in1[19:17],in2);
booth27 booth11(boothout11,in1[21:19],in2);
booth27 booth12(boothout12,in1[23:21],in2);
booth27 booth13(boothout13,{in1[25:23]},in2);

//=========== csa=carry save adder =============//
csa51squ csa51squ1(cout1,mulout1
			,{23'b0,~boothout1[26],boothout1}
			,{21'b0,~boothout2[26],boothout2,2'b0}
			,{19'b0,~boothout3[26],boothout3,4'b0});
          
csa51squ csa51squ2(cout2,mulout2
			,{17'b0,~boothout4[26],boothout4,6'b0}
			,{15'b0,~boothout5[26],boothout5,8'b0}
			,{13'b0,~boothout6[26],boothout6,10'b0});

csa51squ csa51squ3(cout3,mulout3
			,{11'b0,~boothout7[26],boothout7,12'b0}
			,{9'b0,~boothout8[26],boothout8,14'b0}
			,{7'b0,~boothout9[26],boothout9,16'b0});
          
csa51squ csa51squ4(cout4,mulout4
			,{5'b0,~boothout10[26],boothout10,18'b0}
			,{3'b0,~boothout11[26],boothout11,20'b0}
			,{1'b0,~boothout12[26],boothout12,22'b0});
//////////
csa51squ csa51squ5(cout5,mulout5
			,{cout1[49:0],1'b0}
			,mulout1
			,{boothout13,24'b0});

csa51squ csa51squ6(cout6,mulout6
			,{cout2[49:0],1'b0}
			,mulout2
			,{cout3[49:0],1'b0});

csa51squ csa51squ7(cout7,mulout7
			,mulout3
			,{cout4[49:0],1'b0}
			,mulout4);
//////////
csa51squ csa51squ8(cout8,mulout8
			,{cout5[49:0],1'b0}
			,mulout5
			,{cout6[49:0],1'b0});

csa51squ csa51squ9(cout9,mulout9
			,mulout6
			,{cout7[49:0],1'b0}
			,mulout7);
//////////
csa51squ csa51squ10(cout10,mulout10
			,{cout8[49:0],1'b0}
			,mulout8
			,{cout9[49:0],1'b0});
//////////
csa51squ csa51squ11(cout11,mulout11
			,mulout9
			,{cout10[49:0],1'b0}
			,mulout10);
//////////
csa51squ csa51squ12(cout12,mulout12
			,mulout11
			,{cout11[49:0],1'b0}
			,{24'b101010101010101010101011,27'b0});

//========== cla 51 bit ==========//

cla51squ cla51squ(sum,a,b);

always @(negedge clk or negedge reset) begin
  if(!reset) begin
    a <= 0;
    b <= 0;
  end
  else begin
      	if(en==1)begin
        	a <= {cout12[49:0],1'b0};
        	b <= mulout12;
      	end
	else begin
		a <= 0;
		b <= 0;
    	end
  end
end

assign mulout = sum;

endmodule

//==========submodule booth27,see Table4 page 90===========//
module booth27(out1,in1,in2);

parameter zee=27'bz;

input  [2:0]in1;
input  [25:0]in2;
output [26:0]out1;

assign out1=(in1==3'b000)?27'b0:zee;
assign out1=(in1==3'b001)?{in2[25],in2}:zee;
assign out1=(in1==3'b010)?{in2[25],in2}:zee;
assign out1=(in1==3'b011)?{in2,1'b0}:zee;
assign out1=(in1==3'b100)?~{in2,1'b0}+1'b1:zee;
assign out1=(in1==3'b101)?(~{in2[25],in2})+1'b1:zee;
assign out1=(in1==3'b110)?(~{in2[25],in2})+1'b1:zee;
assign out1=(in1==3'b111)?27'b0:zee;

endmodule

//===========CSA=Carry Save Adder==========//
module csa51squ(cout,sumout,in1,in2,in3);

input[50:0]in1;
input[50:0]in2;
input[50:0]in3;
output[50:0]cout;
output[50:0]sumout;

assign sumout=(in1^in2)^in3;
assign cout=((in1^in2)&in3)|(in1&in2);

endmodule

//============submodule cla51squ=============//
//add n bit
//A,B:sign 
//Ket qua chi dung voi dieu kien A[MSB]=A[MSB-1],B[MSB]=B[MSB-1]
//out:sign

module cla51squ(out,a,b);

parameter WIDTH=50;

input  [WIDTH:0]a;
input  [WIDTH:0]b;
output [WIDTH:0]out;

wire [WIDTH+1:0]s;
wire [WIDTH+1:0]c;
wire [WIDTH:0]g;
wire [WIDTH:0]p;

assign out = s[WIDTH:0];
 
assign c[0] = 1'b0;

assign g[0] = a[0] &  b[0];
assign p[0] = a[0] ^  b[0];
assign c[1] = g[0] | (p[0] & c[0]);
assign s[0] = p[0] ^  c[0];

assign g[1] = a[1] &  b[1];
assign p[1] = a[1] ^  b[1];
assign c[2] = g[1] | (p[1] & c[1]);
assign s[1] = p[1] ^  c[1];

assign g[2] = a[2] &  b[2];
assign p[2] = a[2] ^  b[2];
assign c[3] = g[2] | (p[2] & c[2]);
assign s[2] = p[2] ^  c[2];

assign g[3] = a[3] &  b[3];
assign p[3] = a[3] ^  b[3];
assign c[4] = g[3] | (p[3] & c[3]);
assign s[3] = p[3] ^  c[3];

assign g[4] = a[4] &  b[4];
assign p[4] = a[4] ^  b[4];
assign c[5] = g[4] | (p[4] & c[4]);
assign s[4] = p[4] ^  c[4];

assign g[5] = a[5] &  b[5];
assign p[5] = a[5] ^  b[5];
assign c[6] = g[5] | (p[5] & c[5]);
assign s[5] = p[5] ^  c[5];

assign g[6] = a[6] &  b[6];
assign p[6] = a[6] ^  b[6];
assign c[7] = g[6] | (p[6] & c[6]);
assign s[6] = p[6] ^  c[6];

assign g[7] = a[7] &  b[7];
assign p[7] = a[7] ^  b[7];
assign c[8] = g[7] | (p[7] & c[7]);
assign s[7] = p[7] ^  c[7];

assign g[8] = a[8] &  b[8];
assign p[8] = a[8] ^  b[8];
assign c[9] = g[8] | (p[8] & c[8]);
assign s[8] = p[8] ^  c[8];

assign g[9] = a[9] &  b[9];
assign p[9] = a[9] ^  b[9];
assign c[10] =g[9] | (p[9] & c[9]);
assign s[9] = p[9] ^  c[9];

assign g[10] = a[10] &  b[10];
assign p[10] = a[10] ^  b[10];
assign c[11] = g[10] | (p[10] & c[10]);
assign s[10] = p[10] ^  c[10];

assign g[11] = a[11] &  b[11];
assign p[11] = a[11] ^  b[11];
assign c[12] = g[11] | (p[11] & c[11]);
assign s[11] = p[11] ^  c[11];

assign g[12] = a[12] &  b[12];
assign p[12] = a[12] ^  b[12];
assign c[13] = g[12] | (p[12] & c[12]);
assign s[12] = p[12] ^  c[12];

assign g[13] = a[13] &  b[13];
assign p[13] = a[13] ^  b[13];
assign c[14] = g[13] | (p[13] & c[13]);
assign s[13] = p[13] ^  c[13];

assign g[14] = a[14] &  b[14];
assign p[14] = a[14] ^  b[14];
assign c[15] = g[14] | (p[14] & c[14]);
assign s[14] = p[14] ^  c[14];

assign g[15] = a[15] &  b[15];
assign p[15] = a[15] ^  b[15];
assign c[16] = g[15] | (p[15] & c[15]);
assign s[15] = p[15] ^  c[15];

assign g[16] = a[16] &  b[16];
assign p[16] = a[16] ^  b[16];
assign c[17] = g[16] | (p[16] & c[16]);
assign s[16] = p[16] ^  c[16];

assign g[17] = a[17] &  b[17];
assign p[17] = a[17] ^  b[17];
assign c[18] = g[17] | (p[17] & c[17]);
assign s[17] = p[17] ^  c[17];

assign g[18] = a[18] &  b[18];
assign p[18] = a[18] ^  b[18];
assign c[19] = g[18] | (p[18] & c[18]);
assign s[18] = p[18] ^  c[18];

assign g[19] = a[19] &  b[19];
assign p[19] = a[19] ^  b[19];
assign c[20] = g[19] | (p[19] & c[19]);
assign s[19] = p[19] ^  c[19];

assign g[20] = a[20] &  b[20];
assign p[20] = a[20] ^  b[20];
assign c[21] = g[20] | (p[20] & c[20]);
assign s[20] = p[20] ^  c[20];

assign g[21] = a[21] &  b[21];
assign p[21] = a[21] ^  b[21];
assign c[22] = g[21] | (p[21] & c[21]);
assign s[21] = p[21] ^  c[21];

assign g[22] = a[22] &  b[22];
assign p[22] = a[22] ^  b[22];
assign c[23] = g[22] | (p[22] & c[22]);
assign s[22] = p[22] ^  c[22];

assign g[23] = a[23] &  b[23];
assign p[23] = a[23] ^  b[23];
assign c[24] = g[23] | (p[23] & c[23]);
assign s[23] = p[23] ^  c[23];

assign g[24] = a[24] &  b[24];
assign p[24] = a[24] ^  b[24];
assign c[25] = g[24] | (p[24] & c[24]);
assign s[24] = p[24] ^  c[24];

assign g[25] = a[25] &  b[25];
assign p[25] = a[25] ^  b[25];
assign c[26] = g[25] | (p[25] & c[25]);
assign s[25] = p[25] ^  c[25];

assign g[26] = a[26] &  b[26];
assign p[26] = a[26] ^  b[26];
assign c[27] = g[26] | (p[26] & c[26]);
assign s[26] = p[26] ^  c[26];

assign g[27] = a[27] &  b[27];
assign p[27] = a[27] ^  b[27];
assign c[28] = g[27] | (p[27] & c[27]);
assign s[27] = p[27] ^  c[27];

assign g[28] = a[28] &  b[28];
assign p[28] = a[28] ^  b[28];
assign c[29] = g[28] | (p[28] & c[28]);
assign s[28] = p[28] ^  c[28];

assign g[29] = a[29] &  b[29];
assign p[29] = a[29] ^  b[29];
assign c[30] = g[29] | (p[29] & c[29]);
assign s[29] = p[29] ^  c[29];

assign g[30] = a[30] &  b[30];
assign p[30] = a[30] ^  b[30];
assign c[31] = g[30] | (p[30] & c[30]);
assign s[30] = p[30] ^  c[30];

assign g[31] = a[31] &  b[31];
assign p[31] = a[31] ^  b[31];
assign c[32] = g[31] | (p[31] & c[31]);
assign s[31] = p[31] ^  c[31];

assign g[32] = a[32] &  b[32];
assign p[32] = a[32] ^  b[32];
assign c[33] = g[32] | (p[32] & c[32]);
assign s[32] = p[32] ^  c[32];

assign g[33] = a[33] &  b[33];
assign p[33] = a[33] ^  b[33];
assign c[34] = g[33] | (p[33] & c[33]);
assign s[33] = p[33] ^  c[33];

assign g[34] = a[34] &  b[34];
assign p[34] = a[34] ^  b[34];
assign c[35] = g[34] | (p[34] & c[34]);
assign s[34] = p[34] ^  c[34];

assign g[35] = a[35] &  b[35];
assign p[35] = a[35] ^  b[35];
assign c[36] = g[35] | (p[35] & c[35]);
assign s[35] = p[35] ^  c[35];

assign g[36] = a[36] &  b[36];
assign p[36] = a[36] ^  b[36];
assign c[37] = g[36] | (p[36] & c[36]);
assign s[36] = p[36] ^  c[36];

assign g[37] = a[37] &  b[37];
assign p[37] = a[37] ^  b[37];
assign c[38] = g[37] | (p[37] & c[37]);
assign s[37] = p[37] ^  c[37];

assign g[38] = a[38] &  b[38];
assign p[38] = a[38] ^  b[38];
assign c[39] = g[38] | (p[38] & c[38]);
assign s[38] = p[38] ^  c[38];

assign g[39] = a[39] &  b[39];
assign p[39] = a[39] ^  b[39];
assign c[40] = g[39] | (p[39] & c[39]);
assign s[39] = p[39] ^  c[39];

assign g[40] = a[40] &  b[40];
assign p[40] = a[40] ^  b[40];
assign c[41] = g[40] | (p[40] & c[40]);
assign s[40] = p[40] ^  c[40];

assign g[41] = a[41] &  b[41];
assign p[41] = a[41] ^  b[41];
assign c[42] = g[41] | (p[41] & c[41]);
assign s[41] = p[41] ^  c[41];

assign g[42] = a[42] &  b[42];
assign p[42] = a[42] ^  b[42];
assign c[43] = g[42] | (p[42] & c[42]);
assign s[42] = p[42] ^  c[42];

assign g[43] = a[43] &  b[43];
assign p[43] = a[43] ^  b[43];
assign c[44] = g[43] | (p[43] & c[43]);
assign s[43] = p[43] ^  c[43];

assign g[44] = a[44] &  b[44];
assign p[44] = a[44] ^  b[44];
assign c[45] = g[44] | (p[44] & c[44]);
assign s[44] = p[44] ^  c[44];

assign g[45] = a[45] &  b[45];
assign p[45] = a[45] ^  b[45];
assign c[46] = g[45] | (p[45] & c[45]);
assign s[45] = p[45] ^  c[45];

assign g[46] = a[46] &  b[46];
assign p[46] = a[46] ^  b[46];
assign c[47] = g[46] | (p[46] & c[46]);
assign s[46] = p[46] ^  c[46];

assign g[47] = a[47] &  b[47];
assign p[47] = a[47] ^  b[47];
assign c[48] = g[47] | (p[47] & c[47]);
assign s[47] = p[47] ^  c[47];

assign g[48] = a[48] &  b[48];
assign p[48] = a[48] ^  b[48];
assign c[49] = g[48] | (p[48] & c[48]);
assign s[48] = p[48] ^  c[48];

assign g[49] = a[49] &  b[49];
assign p[49] = a[49] ^  b[49];
assign c[50] = g[49] | (p[49] & c[49]);
assign s[49] = p[49] ^  c[49];

assign g[50] = a[50] &  b[50];
assign p[50] = a[50] ^  b[50];
assign c[51] = g[50] | (p[50] & c[50]);
assign s[50] = p[50] ^  c[50];

assign s[51] = c[51];
endmodule

