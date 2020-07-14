function get_frame_ranges(neuron)


for i=1:size(neuron.batches,1)
    neuron.frame_range(i,:)=neuron.batches{i, 1}.neuron.frame_range; 
end