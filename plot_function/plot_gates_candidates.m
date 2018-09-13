function [] = plot_gates_candidates(gate_candidates,color,line_width,figure_num)
if(exist('figure_num', 'var') && ~isempty(figure_num))
    for i = 1:size(gate_candidates,1)
        plot_square(gate_candidates(i,:),color,line_width,figure_num);
    end
else
    for i = 1:size(gate_candidates,1)
        plot_square(gate_candidates(i,:),color,line_width);
    end
end
end