function fix_Baseline(nums,neuron)
for i=1:size(neuron.C_raw,1)
    temp=medfilt1(neuron.C_raw(i,:),nums,'truncate');
    neuron.C_raw(i,:)=neuron.C_raw(i,:)-temp;
    
end
    