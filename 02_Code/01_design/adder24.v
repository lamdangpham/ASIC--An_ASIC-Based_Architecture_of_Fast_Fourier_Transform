// a+ b hoac a-b
module adder24(out,a,b,cin,clk,rst_n);

parameter WIDTH=24;

input  clk;
input  rst_n;
input  [WIDTH-1:0]a;
input  [WIDTH-1:0]b;
input  cin;
output [WIDTH:0]out;
reg    [WIDTH:0]out;

wire [WIDTH:0]s;
wire [WIDTH-1:0]c;

always@(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		out <= 0;
	end
	else begin
		out <= s[WIDTH:0];
	end
end

add add_01(.s(s[0]),.a(a[0]),.b(b[0]^cin),.ci(cin),.co(c[0]));
add add_02(.s(s[1]),.a(a[1]),.b(b[1]^cin),.ci(c[0]),.co(c[1]));
add add_03(.s(s[2]),.a(a[2]),.b(b[2]^cin),.ci(c[1]),.co(c[2]));
add add_04(.s(s[3]),.a(a[3]),.b(b[3]^cin),.ci(c[2]),.co(c[3]));
add add_05(.s(s[4]),.a(a[4]),.b(b[4]^cin),.ci(c[3]),.co(c[4]));
add add_06(.s(s[5]),.a(a[5]),.b(b[5]^cin),.ci(c[4]),.co(c[5]));
add add_07(.s(s[6]),.a(a[6]),.b(b[6]^cin),.ci(c[5]),.co(c[6]));
add add_08(.s(s[7]),.a(a[7]),.b(b[7]^cin),.ci(c[6]),.co(c[7]));
add add_09(.s(s[8]),.a(a[8]),.b(b[8]^cin),.ci(c[7]),.co(c[8]));
add add_10(.s(s[9]),.a(a[9]),.b(b[9]^cin),.ci(c[8]),.co(c[9]));
add add_11(.s(s[10]),.a(a[10]),.b(b[10]^cin),.ci(c[9]),.co(c[10]));
add add_12(.s(s[11]),.a(a[11]),.b(b[11]^cin),.ci(c[10]),.co(c[11]));
add add_13(.s(s[12]),.a(a[12]),.b(b[12]^cin),.ci(c[11]),.co(c[12]));
add add_14(.s(s[13]),.a(a[13]),.b(b[13]^cin),.ci(c[12]),.co(c[13]));
add add_15(.s(s[14]),.a(a[14]),.b(b[14]^cin),.ci(c[13]),.co(c[14]));
add add_16(.s(s[15]),.a(a[15]),.b(b[15]^cin),.ci(c[14]),.co(c[15]));
add add_17(.s(s[16]),.a(a[16]),.b(b[16]^cin),.ci(c[15]),.co(c[16]));
add add_18(.s(s[17]),.a(a[17]),.b(b[17]^cin),.ci(c[16]),.co(c[17]));
add add_19(.s(s[18]),.a(a[18]),.b(b[18]^cin),.ci(c[17]),.co(c[18]));
add add_20(.s(s[19]),.a(a[19]),.b(b[19]^cin),.ci(c[18]),.co(c[19]));
add add_21(.s(s[20]),.a(a[20]),.b(b[20]^cin),.ci(c[19]),.co(c[20]));
add add_22(.s(s[21]),.a(a[21]),.b(b[21]^cin),.ci(c[20]),.co(c[21]));
add add_23(.s(s[22]),.a(a[22]),.b(b[22]^cin),.ci(c[21]),.co(c[22]));
add add_24(.s(s[23]),.a(a[23]),.b(b[23]^cin),.ci(c[22]),.co(c[23]));

assign s[24] = c[23]^cin;
endmodule

