function scale_to_noise(neuron,num)
%  We estimate the noise from the remnant between the raw and deconvolved calcium trace.
% we use a moving window of size=num
a=round(size(neuron.C_raw,2)/num);
t=round(linspace(1,size(neuron.C_raw,2),a));
for i=2:size(t,2)
    temp=real(neuron.C_raw(:,t(i-1):t(i))-neuron.C(:,t(i-1):t(i))); % 1) we susbtract the deconvolved signal from the raw calcium trace.
    temp(isnan(temp))=0; 
    temp=temp-medfilt1(temp,5,[],2); % 2) we do some filtering 
    ns=GetSn(temp); % 3) we estimate the noise
    neuron.C_raw(:,t(i-1):t(i))= neuron.C_raw(:,t(i-1):t(i))./ns;   % 3) we scale the raw signal. 
end 


