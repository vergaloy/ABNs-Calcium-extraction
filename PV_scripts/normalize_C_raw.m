function out=normalize_C_raw(neuron)


for i=1:size(neuron.batches,1)
    temp=neuron.batches{i, 1}.neuron.C_raw;
    for s=1:size(temp,1)
    temp(s,:)=detrend(temp(s,:),1);   
    end
    temp=temp./GetSn(temp);
    neuron.batches{i, 1}.neuron.C_raw=temp;
    neuron.batches{i, 1}.neuron.C = deconvTemporal(neuron.batches{i, 1}.neuron, 1,1); 
end

