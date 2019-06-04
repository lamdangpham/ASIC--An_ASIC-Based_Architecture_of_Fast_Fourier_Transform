module mul_fp_clk(clk,rst_n
              , ena_mul_fp_clk
              , data_in_1
              , data_in_2
              , data_out
              );

parameter DATA_WIDTH = 32;

input clk;
input rst_n;
input ena_mul_fp_clk;

input [DATA_WIDTH-1:0]data_in_1;
input [DATA_WIDTH-1:0]data_in_2;
output [DATA_WIDTH-1:0]data_out;

reg [DATA_WIDTH-1:0]dff_data_in_1;
reg [DATA_WIDTH-1:0]dff_data_in_2;
reg [DATA_WIDTH-1:0]data_out;

wire [DATA_WIDTH-1:0]data_out_wire;


//////////////////////////////////
always@(posedge clk or negedge rst_n)begin
     if(!rst_n)begin
           dff_data_in_1 <= 0;
     end
     else if(ena_mul_fp_clk)begin
           dff_data_in_1 <= data_in_1;

     end
     else begin
           dff_data_in_1 <= 0;

     end 
end

always@(posedge clk or negedge rst_n)begin
     if(!rst_n)begin
           dff_data_in_2 <= 0;
     end
     else if(ena_mul_fp_clk)begin
           dff_data_in_2 <= data_in_2;

     end
     else begin
           dff_data_in_2 <= 0;

     end 
end

floating_point_multiple floating_point_multiple_01 ( .clk(clk)
                                          , .rst_n(rst_n)
                                          , .input_factor_01(dff_data_in_1)
                                          , .input_factor_02(dff_data_in_2)
                                          , .output_multiply(data_out_wire)
                                          );

always@(posedge clk or negedge rst_n) begin
     if(!rst_n) begin
     data_out <= 0;
     end
     else if(ena_mul_fp_clk)begin
     data_out <= data_out_wire;
     end
     else begin
     data_out <= data_out;
     end
end

endmodule



