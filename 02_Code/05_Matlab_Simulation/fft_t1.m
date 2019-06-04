clc
m=9;
N=2^m;
%mo rong ra thanh 256 diem\
path = 'D:\DIGITAL\DA2\BAO CAO DO AN\02_MFCC\fft/data_input.mat';
load(path);
x_fft_init=input_data;
%tinh ma tran W; sap toi se duoc tinh
%san 
for i=1:N
  W(i)=exp(-1i*2*pi*(i-1)/N);
  w_thuc(i)=real(W(i));
  %w_ao(i) = (W(i)- w_thuc(i))/(1i)
  w_ao(i) = imag(W(i));
end

%sap xep lai de chuan bi nhan bang pp dao bit
for i=1:N
  %doi i ra bit
  i_bis=i-1;
  binary=0;
  for j=1:m
    %binary(1)=LSB; binary(m)=MSB  
    binary(j)=mod(i_bis,2);
    i_bis=floor(i_bis/2);
    %binary(1)=LSB; binary(m)=MSB  
  end
  %dao bit, luc nay: binary(1)=MSB; binary(m)=LSB
  %tinh lai vi tri moi
  i_new=1;
  for j=1:m
    i_new=i_new + binary(m+1-j)*2^(j-1) ;   
  end
  %gan lai cac gia tri trong x_fft_init vao x_fft
  %x_fft
  x_fft(i,:)=x_fft_init(i_new,:);
end
%tinh fft
for i=1:m
  %de tinh fft cho moi stage_ung voi moi i
  %1.tinh buoc nhay
  %2.tinh xem k dang o nhom nao o stage nao
  %3.tinh vi tri cua k o trong nhom
  jump_factor=2^(i-1); % tinh buoc nhay
  x_fft_temp(1:2^m,1)=0;
  for k=1:N  
    %a=ceil((k-1)/(2^i)); % a= nhom cua k
    b=mod(k-1,2^i); %b= vi tri cua k trong nhom thu a

    if (b<=2^(i-1)-1)
      x_fft_temp(k,:)=x_fft(k,:) + x_fft(k+jump_factor,:)*W(b*2^(m-i)+1);
            
    elseif (b>2^(i-1)-1)
      x_fft_temp(k,:)=x_fft(k-jump_factor,:) + x_fft(k,:)*W(b*2^(m-i)+1);
    end
  end
  i
  x_fft=x_fft_temp;
end

%%
x_fft;
path = 'D:\DIGITAL\DA2\BAO CAO DO AN\02_MFCC\fft/data_input.mat';
load(path);
kq_mat = fft(input_data(:,1),512);
error = x_fft-kq_mat