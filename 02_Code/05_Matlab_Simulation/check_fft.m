
h = fopen('C:\Users\G551\Desktop\FFT Matlab\02_MFCC\fft\USB_ver_out/report_real.txt','r');
nextline = '';
str='';
while ischar(nextline)
    nextline = fgetl(h);
    if ischar(nextline)
        str = [str;nextline];
    end
end
[p,q] = size(str);
mem_size = p;
% hex >>>> bin
b_hang = '';
b_cot  = '';
for i=1: mem_size
    for j=1:8
        switch str(i,j)
            case '0'
                b_hang = [b_hang,'0','0','0','0'];
            case '1'
                b_hang = [b_hang,'0','0','0','1'];
            case '2'
                b_hang = [b_hang,'0','0','1','0'];
            case '3'
                b_hang = [b_hang,'0','0','1','1'];
            case '4'
                b_hang = [b_hang,'0','1','0','0'];
            case '5'
                b_hang = [b_hang,'0','1','0','1'];
            case '6'
                b_hang = [b_hang,'0','1','1','0'];
            case '7'
                b_hang = [b_hang,'0','1','1','1'];
            case '8'
                b_hang = [b_hang,'1','0','0','0'];
            case '9'
                b_hang = [b_hang,'1','0','0','1'];
            case 'a'
                b_hang = [b_hang,'1','0','1','0'];
            case 'b'
                b_hang = [b_hang,'1','0','1','1'];
            case 'c'
                b_hang = [b_hang,'1','1','0','0'];
            case 'd'
                b_hang = [b_hang,'1','1','0','1'];
            case 'e'
                b_hang = [b_hang,'1','1','1','0'];
            case 'f'
                b_hang = [b_hang,'1','1','1','1'];
        end
    end
    b_cot = [b_cot;b_hang];
    b_hang = '';
end
b = b_cot;
%%%%%%%%%%%%%% bin >>> floating_point ( ftp)
ftp = [];
for i=1:mem_size
    s = bin2dec(b(i,1))*(-2) + 1;
    e = bin2dec(b(i,2:9)) - 127;
    f = 0;
    for j=10:32
      f = bin2dec(b(i,j)) * 2^(9-j) + f;
    end
    f = f + 1;
    f_p = s * f * 2^e;
    ftp = [ftp;f_p];
end
kq_real = ftp;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
h = fopen('C:\Users\G551\Desktop\FFT Matlab\02_MFCC\fft\USB_ver_out/report_image.txt','r');
nextline = '';
str='';
while ischar(nextline)
    nextline = fgetl(h);
    if ischar(nextline)
        str = [str;nextline];
    end
end
[p,q] = size(str);
mem_size = p;
% hex >>>> bin
b_hang = '';
b_cot  = '';
for i=1: mem_size
    for j=1:8
        switch str(i,j)
            case '0'
                b_hang = [b_hang,'0','0','0','0'];
            case '1'
                b_hang = [b_hang,'0','0','0','1'];
            case '2'
                b_hang = [b_hang,'0','0','1','0'];
            case '3'
                b_hang = [b_hang,'0','0','1','1'];
            case '4'
                b_hang = [b_hang,'0','1','0','0'];
            case '5'
                b_hang = [b_hang,'0','1','0','1'];
            case '6'
                b_hang = [b_hang,'0','1','1','0'];
            case '7'
                b_hang = [b_hang,'0','1','1','1'];
            case '8'
                b_hang = [b_hang,'1','0','0','0'];
            case '9'
                b_hang = [b_hang,'1','0','0','1'];
            case 'a'
                b_hang = [b_hang,'1','0','1','0'];
            case 'b'
                b_hang = [b_hang,'1','0','1','1'];
            case 'c'
                b_hang = [b_hang,'1','1','0','0'];
            case 'd'
                b_hang = [b_hang,'1','1','0','1'];
            case 'e'
                b_hang = [b_hang,'1','1','1','0'];
            case 'f'
                b_hang = [b_hang,'1','1','1','1'];
        end
    end
    b_cot = [b_cot;b_hang];
    b_hang = '';
end
b = b_cot;
%%%%%%%%%%%%%% bin >>> floating_point ( ftp)
ftp = [];
for i=1:mem_size
    s = bin2dec(b(i,1))*(-2) + 1;
    e = bin2dec(b(i,2:9)) - 127;
    f = 0;
    for j=10:32
      f = bin2dec(b(i,j)) * 2^(9-j) + f;
    end
    f = f + 1;
    f_p = s * f * 2^e;
    ftp = [ftp;f_p];
end
kq_image = ftp;
%%----------------------------------------------------------------
kq_ver = kq_real + kq_image*(1i);

path = 'C:\Users\G551\Desktop\FFT Matlab\02_MFCC\fft/data_input.mat';
load(path);
kq_mat = fft(input_data(:,1),1024);
error = kq_ver - kq_mat;