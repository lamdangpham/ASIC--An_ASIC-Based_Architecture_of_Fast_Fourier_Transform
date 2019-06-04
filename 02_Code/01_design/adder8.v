// a+ b hoac a-b
module adder8(out,a,b,cin);

parameter WIDTH=8;

input  [WIDTH-1:0]a;
input  [WIDTH-1:0]b;
input  cin;
output [WIDTH-1:0]out;

wire [WIDTH:0]s;
wire [WIDTH-1:0]c;

assign out = s[WIDTH-1:0];

add add_01(.s(s[0]),.a(a[0]),.b(b[0]^cin),.ci(cin),.co(c[0]));
add add_02(.s(s[1]),.a(a[1]),.b(b[1]^cin),.ci(c[0]),.co(c[1]));
add add_03(.s(s[2]),.a(a[2]),.b(b[2]^cin),.ci(c[1]),.co(c[2]));
add add_04(.s(s[3]),.a(a[3]),.b(b[3]^cin),.ci(c[2]),.co(c[3]));
add add_05(.s(s[4]),.a(a[4]),.b(b[4]^cin),.ci(c[3]),.co(c[4]));
add add_06(.s(s[5]),.a(a[5]),.b(b[5]^cin),.ci(c[4]),.co(c[5]));
add add_07(.s(s[6]),.a(a[6]),.b(b[6]^cin),.ci(c[5]),.co(c[6]));
add add_08(.s(s[7]),.a(a[7]),.b(b[7]^cin),.ci(c[6]),.co(c[7]));

assign s[8] = c[7]^cin;
endmodule

