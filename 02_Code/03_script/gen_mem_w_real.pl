&main;
sub main {
    $INPUT_FILE      = $ARGV[0];
    $TARGET_FILE     = $ARGV[1];

    open ($MEM_CASE, "./input/$INPUT_FILE") || die("There is no skeleton file \n");
    open ($MEM_V, ">./output/$TARGET_FILE");
    
    printf $MEM_V ("module mem_w_real (clk, addr, wr_ena, data);\n");
    printf $MEM_V ("parameter DATA_WIDTH =  32;\n");
    printf $MEM_V ("input clk;\n");
    printf $MEM_V ("input [11:0] addr;\n");
    printf $MEM_V ("input wr_ena;\n");
    printf $MEM_V ("output [DATA_WIDTH-1:0] data;\n");
    printf $MEM_V ("reg    [DATA_WIDTH-1:0] data;\n");
    printf $MEM_V ("always@(posedge clk) begin\n");
    printf $MEM_V ("    case(addr)\n");
    printf $MEM_V ("        0:  data   <=  32'b0_0000_0000_0000_0000_0000_0000_0000_000;\n");
    $count = 0;
    foreach $line (<$MEM_CASE>)
	{
	    chop($line);
	    $count = $count+1;
            printf $MEM_V ("        $count:  data   <=  32'b$line;\n");
   	 }
    printf $MEM_V ("        default: data <= 0;\n");
    printf $MEM_V ("    endcase\n");
    printf $MEM_V ("end\n");
    printf $MEM_V ("endmodule\n");
    close($INPUT_FILE);
    close($TARGET_FILE);
}
