input_file_w=mem_w_real.txt
output_file_w=mem_w_real.v
input_file_mfcc=mem_input.txt
output_file_mfcc=mem_input.v
input_file_para=mem_w_image.txt
output_file_para=mem_w_image.v
echo "$input_file_w"
echo "$output_file_w"
echo "$input_file_mfcc"
echo "$output_file_mfcc"
echo "$input_file_para"
echo "$output_file_para"
/usr/bin/perl gen_mem_w_real.pl $input_file_w $output_file_w
/usr/bin/perl gen_mem_input.pl $input_file_mfcc $output_file_mfcc
/usr/bin/perl gen_mem_w_image.pl $input_file_para $output_file_para
