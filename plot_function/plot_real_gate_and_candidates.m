function [] = plot_real_gate_and_candidates(RGB,candidates,color,linewidth,fig_num)
figure(fig_num)
imshow(RGB);
hold on
for i = 1:size(candidates,1)
   plot_square(candidates(i,:),color,linewidth,fig_num); 
end
end