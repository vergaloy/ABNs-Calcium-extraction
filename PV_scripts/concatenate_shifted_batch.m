function  concatenate_shifted_batch(neuron)

total_frames=neuron.batches{size(neuron.batches,1), 1}.neuron.frame_range(2);
C_raw(1:size(neuron.batches{1, 1}.neuron.C_raw  ,1),1:total_frames)=0;
offset=floor(neuron.batches{1, 1}.neuron.frame_range(2)/4);
i=1;
   frame_range=neuron.batches{i, 1}.neuron.frame_range;
   s=size(neuron.batches{i, 1}.neuron.C_raw,2);
   C_raw(:,frame_range(1):frame_range(2))=neuron.batches{i, 1}.neuron.C_raw(:,1:s);

for i=2:size(neuron.batches,1)
   frame_range=neuron.batches{i, 1}.neuron.frame_range;
   s=size(neuron.batches{i, 1}.neuron.C_raw,2);
   C_raw(:,frame_range(1)+offset:frame_range(2))=neuron.batches{i, 1}.neuron.C_raw(:,1+offset:s);
end

neuron.C_raw=C_raw;