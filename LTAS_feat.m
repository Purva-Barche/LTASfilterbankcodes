function F_LTAS=LTAS_feat(data,fs)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This code to find Long term average spectral features from the speech Signal
% Authors:  G Krishna  (Speech Lab, IIIT Hyderabad)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --------       inputs         --------
% data      : input raw speech signal
% fs        : sampling freqnecy
% --------      outputs         --------
% F_LTAS    : Long term average spectral features (99 dimentional)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% References:
%       (1) http://www.public.asu.edu/~visar/IS2018Supp.pdf
%       (2) Differences in voice quality between men and women: Use of the long-term average spectrum (LTAS)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

x=data;Fs=fs;
x=x./max(x);
if(size(x,2)==1)
    x=x';
end


NORDER = 32;

if (Fs==16000)
    PF=[0 30 60 120 240 480 960 1920 3840 7680];
else
    PF=[0 30 60 120 240 480 960 1920 2400 3840];
end


for i=1:length(PF)-1
    
    %   fprintf('Band Pass Filter:  Band %g of %g \n',i,NBANDS);
    
    if(i==1)
        F=[0.1 PF(i+1)] ;           %in Hz
        ybpf(i,:)=criticalbandfir_V3(x,F,Fs,NORDER);
    else
        F=[PF(i)-0.05*PF(i) PF(i+1)];
        ybpf(i,:)=criticalbandfir_V3(x,F,Fs,NORDER);
    end
    
end


y=[x;ybpf];
for i=1:size(y,1)
    frames=buffer(y(i,:),20*fs/1000);
    rms_frams(i,:)=rms(frames);
end

feat1 = rms(y(2:end,:)')./rms(y(1,:)'); % 9 dim

feat2 = mean(rms_frams')./rms(y(1,:)'); % 10

feat3 = std(rms_frams'); % 10

feat4 = std(rms_frams')./rms(y(1,:)'); % 10

feat5 = std(rms_frams')./rms(y'); % 10

feat6 = skewness(rms_frams'); % 10

feat7 = kurtosis(rms_frams'); % 10

feat8 = range(rms_frams'); % 10

feat9 = range(rms_frams')./rms(y(1,:)');  % 10

feat10 = mean(abs(diff(rms_frams')))./rms(y(1,:)'); 

F_LTAS=[feat1 feat2 feat3 feat4 feat5 feat6 feat7 feat8 feat9 feat10];


function y= criticalbandfir_V3(x,F,Fs,N) 

Fs1=Fs/2;

F1=F(1)/Fs1;
F2=F(2)/Fs1;
F3=(F(2)+0.01*F(2))/Fs1;

if(F3>1)
    F2=0.99;
    F3=0.999;
end

f = [0 F1 F2 F3 1];
m = [0 0  1  0  0];

b = fir2(N,f,m);
y1=conv(b,x);
y=y1((N/2)+1:end-(N/2));