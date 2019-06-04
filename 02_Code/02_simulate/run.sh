#cd run
#cp -f ./../../01_design/control_floating_point.v t_control_floating_point.v ./
#cp -f ./../../01_design/t_control_floating_point.v ./
#vcs +v2k -R -debug_all ./*.v | tee ./

cd run
cp -f ./../../01_design/*.v ./
cp -f ./../../03_script/output/mem_w_real.v ./mem_w_real.v
cp -f ./../../03_script/output/mem_w_image.v ./mem_w_image.v
cp -f ./../../03_script/output/mem_input.v ./mem_input.v
vcs +v2k -R -debug_all ./*.v | tee ./../../04_Sim_Log/log.txt

input_file=log.txt
output_file_1=report_real.txt
output_file_2=report_image.txt
echo "$input_file"
echo "$output_file_1"
echo "$output_file_2"
/usr/bin/perl ./../perl_tee.pl $input_file $output_file_1
/usr/bin/perl ./../perl_tee_01.pl $input_file $output_file_2

