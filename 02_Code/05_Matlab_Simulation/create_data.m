clc
N=8;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:N
  W(i)=exp(-1i*2*pi*(i-1)/N);
  w_thuc(i)=real(W(i));
  w_ao(i) = imag(W(i));
  
end
save('C:\Users\G551\Desktop\FFT Matlab\02_MFCC\fft/data_w_thuc.mat','w_thuc');
save('C:\Users\G551\Desktop\FFT Matlab\02_MFCC\fft/data_w_ao.mat','w_ao');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load('C:\Users\G551\Desktop\FFT Matlab\02_MFCC\fft/data_w_thuc.mat');
input_data = w_thuc';
h = fopen('C:\Users\G551\Desktop\FFT Matlab\02_MFCC\fft\USB_ver_in/mem_w_real.txt','w');
w_real = fpt2bin(input_data);
[p,q] =size(w_real)
for k=1:(p-1)
    fprintf(h,'%s\n',w_real(k,:));
end
fprintf(h,'%s',w_real(p,:));
fclose(h);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load('C:\Users\G551\Desktop\FFT Matlab\02_MFCC\fft/data_w_ao.mat');
input_data = w_ao';
h = fopen('C:\Users\G551\Desktop\FFT Matlab\02_MFCC\fft\USB_ver_in/mem_w_image.txt','w');
w_image = fpt2bin(input_data);
[p,q] =size(w_image)
for k=1:(p-1)
    fprintf(h,'%s\n',w_image(k,:));
end
fprintf(h,'%s',w_image(p,:));
fclose(h);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
input_data = random('Normal',0,1,N,1);
save('C:\Users\G551\Desktop\FFT Matlab\02_MFCC\fft/data_input.mat','input_data');
h = fopen('C:\Users\G551\Desktop\FFT Matlab\02_MFCC\fft\USB_ver_in/mem_input.txt','w');
in_data = fpt2bin(input_data);
[p,q] =size(in_data)
for k=1:(p-1)
    fprintf(h,'%s\n',in_data(k,:));
end
fprintf(h,'%s',in_data(p,:));
fclose(h);
display('ok');