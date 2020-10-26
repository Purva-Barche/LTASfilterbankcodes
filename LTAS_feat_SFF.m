function F_LTAS=LTAS_feat_SFF(data,fs)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This code to find Long term average spectral features from the speech Signal
% Authors:  G Krishna  (Speech Lab, IIIT Hyderabad)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --------       inputs         --------
% data      : input raw speech signal
% fs        : sampling freqnecy
% --------      outputs         --------
% F_LTAS    : Long term average spectral features (99 dimentional)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Dependencies:
%       SFF_SPECTRUM.m to find single freqeuncy filter based harmonic components
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% References:
%       (1) http://www.public.asu.edu/~visar/IS2018Supp.pdf
%       (2) Differences in voice quality between men and women: Use of the long-term average spectrum (LTAS)
%       (3) K. Gurugubelli and A. K. Vuppala, "Perceptually Enhanced Single Frequency Filtering for Dysarthric Speech Detection
%           and Intelligibility Assessment", in Proc. ICASSP 2019, Brighton, United Kingdom, 2019, pp. 6410-6414.
%       (4) G Aneeja, B Yegnanarayana, "Single frequency filtering approach for discriminating speech and nonspeech", IEEE/ACM 
%           Transactions on Audio Speech and Language Processing, vol. 23, no. 4, pp. 705-717, 2015.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

x=data;Fs=fs;
x=x./max(x);
if(size(x,2)==1)
    x=x';
end

[ybpf]=SFF_SPECTRUM(x,fs,20,0,4000,0.98);


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
