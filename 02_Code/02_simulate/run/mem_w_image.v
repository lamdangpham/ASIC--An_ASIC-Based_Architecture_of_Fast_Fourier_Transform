module mem_w_image (clk, addr, wr_ena, data);
parameter DATA_WIDTH =  32;
input clk;
input [11:0] addr;
input wr_ena;
output [DATA_WIDTH-1:0] data;
reg    [DATA_WIDTH-1:0] data;
always@(posedge clk) begin
    case(addr)
        0:  data   <=  32'b0_0000_0000_0000_0000_0000_0000_0000_000;
        1:  data   <=  32'b0_0000_0000_0000_0000_0000_0000_0000_000 ;
        2:  data   <=  32'b1_0111_1110_0110_1010_0000_1001_1110_011 ;
        3:  data   <=  32'b1_0111_1111_0000_0000_0000_0000_0000_000 ;
        4:  data   <=  32'b1_0111_1110_0110_1010_0000_1001_1110_011 ;
        5:  data   <=  32'b1_0100_1010_0001_1010_0110_0010_0110_001 ;
        6:  data   <=  32'b0_0111_1110_0110_1010_0000_1001_1110_011 ;
        7:  data   <=  32'b0_0111_1111_0000_0000_0000_0000_0000_000 ;
        8:  data   <=  32'b0_0111_1110_0110_1010_0000_1001_1110_011;
        default: data <= 0;
    endcase
end
endmodule
