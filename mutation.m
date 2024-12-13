function mutated = mutation(offspring, rate, method, rows, cols, start, map)
    % Mutation function for Genetic Algorithm
    % Parameters:
    %   offspring - current crossed-over population
    %   rate - mutation rate, indicating the probability of a point being mutated
    %   method - 0 for random reset, 1 for swap mutation
    %   rows, cols - dimensions of the map
    %   start - starting point (constraint)
    %   map - a grid to indicate obstacles, where 0 represents free space and 1 represents obstacles. 
    %         Obstacles are areas that the robot must avoid.

    % Determine the number of offspring and points in each individual's path
    num_offspring = size(offspring, 1);
    num_points = size(offspring, 2) / 2;
    mutated = offspring;

    % Iterate through each individual in the population
    for i = 1:num_offspring
        if method == 0
            % Method 0: Random reset mutation
            % Iterate over all points in the path
            for j = 1:num_points
                % Mutate only if rand < mutation rate
                if rand < rate
                    % Calculate the index for the current y-coordinate
                    idx = (j - 1) * 2 + 1;

                    % Handle constraints for the first point
                    if j == 1
                        prev_point = start; % The first point must align with the start point
                    else
                        % Get the previous point's coordinates
                        prev_point = [mutated(i, (j-1)*2 + 1), mutated(i, (j-1)*2 + 2)];
                    end

                    % Retry to generate a valid mutation point if necessary
                    max_retries = 100; % Limit retries to avoid infinite loops
                    retries = 0;
                    valid_point = false; % Flag to track whether a valid point is found

                    while ~valid_point && retries < max_retries
                        % Randomly adjust the point's x, y coordinates
                        dx = randi([-10, 10]);
                        dy = randi([-10, 10]);
                        y = prev_point(1) + dy;
                        x = prev_point(2) + dx;

                        % Check if the new point is within bounds and avoids obstacles
                        if y >= 1 && y <= cols && x >= 1 && x <= rows && map(round(x), round(y)) == 0
                            % Ensure forward movement (no backtracking)
                            if x >= prev_point(2) && y >= prev_point(1)
                                valid_point = true; % Valid point found, exit loop
                                mutated(i, idx) = y; % Update y-coordinate in the path
                                mutated(i, idx + 1) = x; % Update x-coordinate in the path
                            end
                        else
                            retries = retries + 1;
                        end
                    end

                    % If no valid point is found, retain the original coordinates
                    if retries == max_retries
                        mutated(i, idx) = prev_point(1);
                        mutated(i, idx + 1) = prev_point(2);
                    end
                end
            end
        % Method 1: Swap mutation
        elseif method == 1
            % Mutate only if the random probability is less than the mutation rate
            if rand < rate
                % Randomly select two points to swap
                idx1 = randi(num_points) * 2 - 1; % Index of the first point's x-coordinate
                idx2 = randi(num_points) * 2 - 1; % Index of the second point's x-coordinate

                % Swap the (x, y) coordinates of the two points
                temp_y = mutated(i, idx1);
                temp_x = mutated(i, idx1 + 1);
                mutated(i, idx1) = mutated(i, idx2);
                mutated(i, idx1 + 1) = mutated(i, idx2 + 1);
                mutated(i, idx2) = temp_y;
                mutated(i, idx2 + 1) = temp_x;
            end
        end
    end
end
