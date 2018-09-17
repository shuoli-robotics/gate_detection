function [] = plot_gates_candidates(gate_candidates,color,line_width,fitnesses,figure_num, minimal_fitness)
if(exist('figure_num', 'var') && ~isempty(figure_num))
    for i = 1:size(gate_candidates,1)
        if(exist('fitnesses', 'var') && ~isempty(fitnesses))
            if(~exist('minimal_fitness', 'var') || isempty(minimal_fitness) || fitnesses(i) >= minimal_fitness)
                plot_square(gate_candidates(i,:),fitnesses(i) * [0 1 0] + (1-fitnesses(i)) * [1 0 0] ,line_width,figure_num);
            end
        else
            plot_square(gate_candidates(i,:),color,line_width,figure_num);
        end
    end
else
    for i = 1:size(gate_candidates,1)
        if(exist('fitnesses', 'var') && ~isempty(fitnesses))
            if(~exist('minimal_fitness', 'var') || isempty(minimal_fitness) || fitnesses(i) >= minimal_fitness)
                plot_square(gate_candidates(i,:),fitnesses(i) * [0 1 0] + (1-fitnesses(i)) * [1 0 0] ,line_width);
            end
        else
            plot_square(gate_candidates(i,:),color,line_width);
        end
    end
end
end