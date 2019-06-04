&main;
sub main {
    #===========================================================================//
    #========================== GENERATE THE FLASH_MEM.v ========================//
    #===========================================================================//
    $INPUT_FILE      = $ARGV[0];
    $TARGET_FILE     = $ARGV[1];
   
    open ($LOG_FILE, "./../../04_Sim_Log/$INPUT_FILE") || die("There is no input  file \n");                # Open verilog file
    open ($REPORT_FILE, ">./../../04_Sim_Log/$TARGET_FILE");                          # Open the report file
    $count = 0;
    foreach $line (<$LOG_FILE>)
    {      # Get every line to $line
        chop($line);                    # Cut the \n at very final line
        @line_mem = split(/:/, $line);  # Split the line member by space
        if( @line_mem[0] =~ /XXXXX/) 
        {
       		$count = $count + 1;
		if($count >1) {
                printf $REPORT_FILE ("@line_mem[2]\n");
		}
        } 
    }

    close($INPUT_FILE);
    close($TARGET_FILE);
}
