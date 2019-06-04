module mem_input (clk, addr, wr_ena, data);
parameter DATA_WIDTH =  32;
input clk;
input [11:0] addr;
input wr_ena;
output [DATA_WIDTH-1:0] data;
reg    [DATA_WIDTH-1:0] data;
always@(posedge clk) begin
    case(addr)
        0:  data   <=  32'b0_0000_0000_0000_0000_0000_0000_0000_000;
        1:  data   <=  32'b0_0111_1110_0001_0011_0100_1001_0001_101 ;
        2:  data   <=  32'b0_0111_1111_1101_0101_0111_1001_0111_110 ;
        3:  data   <=  32'b1_1000_0000_0010_0001_0010_0001_1110_010 ;
        4:  data   <=  32'b0_0111_1110_1011_1001_0110_1110_1100_100 ;
        5:  data   <=  32'b0_0111_1101_0100_0110_0110_1010_0110_010 ;
        6:  data   <=  32'b1_0111_1111_0100_1110_1100_0100_1010_100 ;
        7:  data   <=  32'b1_0111_1101_1011_1011_1111_1111_1000_110 ;
        8:  data   <=  32'b0_0111_1101_0101_1110_1101_1000_1111_001;
        default: data <= 0;
    endcase
end
endmodule
