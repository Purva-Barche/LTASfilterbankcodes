function F_LTAS=LTAS_feat_CQT(data,fs)
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
% Dependencies: cqtfilters, filterbank are in the folder ltfat-2.4.0
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

x=data;Fs=fs;
x=x./max(x);
% if(size(x,2)==1)
%     x=x';
% end

L=length(x);
fmin=5;
fmax=fs/2;
  [g,a,fc]=cqtfilters(fs,fmin,fmax,12,L,'fractional'); % CQT filter bank

c=filterbank(x,g,ones(size(a))); % passing input speech through the filter bank 
ytemp=cell2mat(c(1:end));  % we are converting it to matrix  as filter bank retirns cell array
ytem2=buffer(ytemp,length(x),0); 
y=[x';ytem2'];
for i=1:size(y,1)
    frames=buffer(y(i,:),20*fs/1000);
    rms_frams(i,:)=rms(frames);
end
i
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

end


