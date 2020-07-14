function [PNR_all,Cn_all]=create_PNR_batch(neuron);
for i=1:size(neuron.batches,1)
    PNR_all(:,:,i)=neuron.batches{i, 1}.neuron.PNR;
    Cn_all(:,:,i)=neuron.batches{i, 1}.neuron.Cn;
end
neuron.PNR=max(PNR_all,[],3);
neuron.Cn=max(Cn_all,[],3);