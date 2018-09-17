function [] = plot_gates_candidates(gate_candidates,color,line_width,fitnesses,figure_num)
if(exist('figure_num', 'var') && ~isempty(figure_num))
    for i = 1:size(gate_candidates,1)
        if(exist('fitnesses', 'var') && ~isempty(fitnesses))
           plot_square(gate_candidates(i,:),fitnesses(i) * [0 1 0] + (1-fitnesses(i)) * [1 0 0] ,line_width,figure_num);
        else
            plot_square(gate_candidates(i,:),color,line_width,figure_num);
        end
    end
else
    for i = 1:size(gate_candidates,1)
        if(exist('fitnesses', 'var') && ~isempty(fitnesses))
            plot_square(gate_candidates(i,:),fitnesses(i) * [0 1 0] + (1-fitnesses(i)) * [1 0 0] ,line_width);
        else
            plot_square(gate_candidates(i,:),color,line_width);
        end
    end
end
end