function offspring = crossover(parents, rate, method, map)
    %Crossover function for Genetic Algorithm
    % Parameters:
    %   parents - A matrix, each row represents a parent's path as a sequence of (x, y) coordinates.
    %   rate - Crossover rate (probability of performing crossover).
    %   method - 0 for single-point crossover, 1 for uniform crossover.
    %   map - The map used to check for obstacles. A value of 1 indicates an obstacle, 0 indicates free space.

    % Determine the number of parents and points per parent
    num_parents = size(parents, 1);  % Total number of parents
    num_points = size(parents, 2) / 2;  % Number of points per parent path

    % Initialise offspring with parents' paths
    offspring = parents;

    % Iterate over pairs of parents
    for i = 1:2:num_parents-1  % Process two parents at a time
        % Perform crossover if probability less than rate
        if rand < rate
            % Reshape each parent's path into a matrix of (num_points, 2)
            parent1 = reshape(parents(i, :), num_points, 2);
            parent2 = reshape(parents(i+1, :), num_points, 2);

            % Initialise children as empty matrices
            child1 = zeros(num_points, 2);
            child2 = zeros(num_points, 2);

            % Iterate over each point in the path
            for j = 1:num_points
                % Apply the selected crossover method
                if method == 0  % Single-point crossover
                    if rand < 0.5
                        % Exchange points between parents
                        child1(j, :) = parent1(j, :);
                        child2(j, :) = parent2(j, :);
                    else
                        child1(j, :) = parent2(j, :);
                        child2(j, :) = parent1(j, :);
                    end
                elseif method == 1  % Uniform crossover
                    % Randomly assign each point from either parent
                    if rand < 0.5
                        child1(j, :) = parent1(j, :);
                    else
                        child1(j, :) = parent2(j, :);
                    end
                    if rand < 0.5
                        child2(j, :) = parent1(j, :);
                    else
                        child2(j, :) = parent2(j, :);
                    end
                end

                % Check if the point in child1 meets obstacles. 
                if map(round(child1(j, 1)), round(child1(j, 2))) == 1
                    % Revert to the corresponding parent point if hit
                    child1(j, :) = parent1(j, :);
                end
                % Same logic as child1
                if map(round(child2(j, 1)), round(child2(j, 2))) == 1
                    child2(j, :) = parent2(j, :);
                end

                % Ensure no backtracking: points must only move forward
                if j > 1
                    % Check vertical movement for child1
                    if child1(j, 1) < child1(j-1, 1)
                        child1(j, 1) = child1(j-1, 1);  % Prevent moving backwards
                    end
                    % Check horizontal movement for child1
                    if child1(j, 2) < child1(j-1, 2)
                        child1(j, 2) = child1(j-1, 2);  % Prevent moving backwards
                    end

                    % Same logic as child1
                    if child2(j, 1) < child2(j-1, 1)
                        child2(j, 1) = child2(j-1, 1);  
                    end
                    if child2(j, 2) < child2(j-1, 2)
                        child2(j, 2) = child2(j-1, 2); 
                    end
                end
            end

            % Flatten children back to row vectors and add them to offspring
            offspring(i, :) = reshape(child1, 1, []);
            offspring(i+1, :) = reshape(child2, 1, []);
        end
    end
end
