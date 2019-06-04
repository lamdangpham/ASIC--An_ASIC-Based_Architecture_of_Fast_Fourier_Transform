module mem_int (clk, addr, wr_ena, data_rd, data_wr) ;
//module mem_int (clk, addr_rd, wr_ena, data_rd, addr_wr, data_wr) ;
parameter DATA_WIDTH =  32;
input clk;
input wr_ena;
input [11:0] addr;
//input [11:0] addr_rd;
//input [11:0] addr_wr;
input [DATA_WIDTH-1:0] data_wr;
output reg [DATA_WIDTH-1:0] data_rd;

reg    [DATA_WIDTH-1:0] mem [2048:0];

always@(posedge clk) begin 
   if(wr_ena) begin
        mem[addr] <= data_wr;
   end
   else begin
       data_rd <= mem[addr];
   end
end

endmodule
