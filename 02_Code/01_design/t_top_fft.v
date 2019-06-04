module t_top_fft;

reg t_clk;
reg t_rst_n;
reg t_ena_fft;
reg [3:0] t_stage_number;
reg [11:0] t_max_point_fft;
reg [15:0] t_max_point_fft_core;


wire t_ena_mag;

//Generate clk
always begin
        t_clk = 0;
    #50 t_clk = 1;
    #50;
end

//Instance module
top_fft top_fft_01 (.clk(t_clk)
           , .rst_n(t_rst_n)
           , .ena_fft(t_ena_fft)
           , .ena_mag(t_ena_mag)
           , .stage_number(t_stage_number)
           , .max_point_fft(t_max_point_fft)
           , .max_point_fft_core(t_max_point_fft_core) 
           );
always@(posedge top_fft_01.clk) begin
if (top_fft_01.wr_ena_int_03 == 1) begin
 // if (top_fft_01.network_control_01.stage_level == (top_fft_01.network_control_01.stage_number -1)) begin	
    $display("XXXXX:DATA TO MEM:%h:%t\n",top_fft_01.data_wr_int_03,$time) ;
//$display("X:%h\n",top_01.network_control_01.layer_count) ;
//end
end
end
always@(posedge top_fft_01.clk) begin
if (top_fft_01.wr_ena_int_06 == 1) begin	
 // if (top_fft_01.network_control_01.stage_level == (top_fft_01.network_control_01.stage_number -1)) begin	
    $display("YYYYY:DATA TO MEM:%h:%t\n",top_fft_01.data_wr_int_06,$time) ;
//$display("X:%h\n",top_01.network_control_01.layer_count) ;
//end
end
end
initial begin
#0   t_rst_n = 0;
     t_ena_fft = 0;
#100 t_rst_n = 1;
#100  t_ena_fft = 1;
      t_stage_number = 4'd3;
      t_max_point_fft = 12'd8;
      t_max_point_fft_core = 15'd110;
#400  t_ena_fft = 0;
#120000000;
 $finish;
end
initial begin
        $vcdplusfile ("fft.pvd");
        $vcdpluson();
end
endmodule


