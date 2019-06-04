module add(s,a,b,ci,co);
input ci;
input a;
input b;
output co;
output s;
assign s = (a^b)^ci;
assign co = ((a^b)&ci)|(a&b);
endmodule 
