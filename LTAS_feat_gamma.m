function F_LTAS=LTAS_feat_gamma(data,fs)
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


numchannels=32;
lowfreq=0;
fcoefs=MakeERBFilters(fs,numchannels,lowfreq);
ybpf = ERBFilterBank(x, fcoefs);
[vnvsig,~,~,~,~,~]=zff_analysis(x,fs);
x1=x(vnvsig);
yybpf=[];
for i=1:size(ybpf,1)
    
   temp=ybpf(i,:);
   ybpf1=temp(vnvsig);
   yybpf=[yybpf;ybpf1];
    
end

           
           
%%

y=[x1;yybpf];


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
% 
feat9 = range(rms_frams')./rms(y(1,:)');  % 10

feat10 = mean(abs(diff(rms_frams')))./rms(y(1,:)'); 

F_LTAS=[feat1 feat2 feat3 feat4 feat5 feat6 feat7 feat8 feat9  feat10];



