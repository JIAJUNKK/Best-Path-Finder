function selected = selection(population, fitness, method)
    % This is selection function for Genetic Algorithm
    % Parameters:
    %   population - A matrix, each row is an individual's solution lah.
    %   fitness - A vector of fitness values, 1-to-1 corresponding to population.
    %   method - 0 for Roulette Wheel, 1 for Tournament, 2 for Rank-based.

    switch method
        case 0  % Roulette Wheel Selection
            
            % Add small constant to avoid zero fitness value laa
            fitness = fitness + 1e-6;  % Make sure no division by zero just in case :)
            
            % Calculate total fitness and make it into probabilities
            total_fitness = sum(fitness);  % Sum up all the fitness
            prob = fitness / total_fitness;  % Normalize into probabilities
            cum_prob = cumsum(prob);  % Calculate cumulative probabilities
            
            % Initialise the matrix to store selected individuals first
            selected = zeros(size(population));  
            
            % Loop to select individuals for next generation
            for i = 1:size(population, 1)
                % Random number generation and select lah
                idx = find(cum_prob >= rand, 1, 'first');
                selected(i, :) = population(idx, :);  % Add the selected one to next population
            end

        case 1  % Tournament Selection            
            pop_size = size(population, 1);  % How many individual in population
            selected = zeros(size(population));  % Initilise the selected population
            
            % Loop through all individual, do tournament
            for i = 1:pop_size
                % Randomly pick 2 for tournament fight
                idx1 = randi(pop_size);
                idx2 = randi(pop_size);
                
                % Compare their fitness, lower is better mah
                if fitness(idx1) < fitness(idx2)  % Lower fitness is better (minimise problem mah)
                    selected(i, :) = population(idx1, :);  % Winner
                else
                    selected(i, :) = population(idx2, :);  % Winner
                end
            end

        case 2  % Rank-based Selection            
            % Sort the fitness from small to big, get sorted indices
            [~, sorted_indices] = sort(fitness, 'ascend');
            
            % Assign ranks: 1 for the best fitness, higher number for worse
            % Smallest fitness get rank 1, largest get last.
            ranks = 1:length(fitness);
            
            % Total up the ranks and assign probabilities based on rank
            total_rank = sum(ranks);
            prob = ranks / total_rank;  % Higher rank = higher probability
            cum_prob = cumsum(prob);  % Calculate cumulative probabilities
            
            % Initialise the matrix to store selected individuals
            selected = zeros(size(population));
            
            % Loop to select based on rank probabilities
            for i = 1:size(population, 1)
                idx = find(cum_prob >= rand, 1, 'first');
                % Use sorted indices to get the selected individual
                selected(i, :) = population(sorted_indices(idx), :);
            end
    end
end
