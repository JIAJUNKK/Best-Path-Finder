% Load 0binary map and check its size
map = im2bw(imread('random_map.bmp'));  % Load the map in binary (black & white) format
[map_rows, map_cols] = size(map);  % Obtain the dimensions of the map
num_obstacles = sum(map(:));  % Count the total number of obstacles (1s) in the map

disp(['Number of obstacles: ', num2str(num_obstacles)]);  % Display the number of obstacles
start = [1, 1];  % Starting point of the path
finish = [500, 500];  % Endpoint of the path

% Prompt the user to select methods
disp('Choose selection method: 0=Roulette Wheel, 1=Tournament, 2=Rank-based');
selection_method = input('Selection Method (0/1/2): ');  % User selects the selection method
disp('Choose crossover method: 0=single point crossover, 1=uniform crossover');
crossover_method = input('Crossover Method (0/1): ');  % User selects the crossover method
disp('Choose mutation method: 0=random reset, 1=swap mutation');
mutation_method = input('Mutation Method (0/1): ');  % User selects the mutation method

% Parameters
num_points = 10;  % Number of intermediate points in the path
pop_size = 1000;    % Population size
iter = 10;    % Maximum number of generations for the genetic algorithm
mutation_rate = 0.6; % Probability of mutation
crossover_rate = 0.8; % Probability of crossover

% Initialise the population
population = initialise_population(pop_size, num_points, start, finish, map);  % Randomly generate initial paths

% Start timing the algorithm
tic;
% Main genetic algorithm loop
solution = [];
best_fitness = inf;  % Initialise the best fitness as a very high value (since we aim to minimise fitness)

for k = 1:iter
    % Evaluate the fitness of all paths in the population
    fitness = evaluate_fitness(population, map, start, finish);
    
    % Selection process
    selected_population = selection(population, fitness, selection_method);  % Select individuals based on method
    
    % Perform crossover to create offspring
    offspring_population = crossover(selected_population, crossover_rate, crossover_method, map);  
    
    % Perform mutation to introduce diversity into the population
    mutated_population = mutation(offspring_population, mutation_rate, mutation_method, map_rows, map_cols, start, map);  
    
    % Combine populations to create the next generation
    offspring_fitness = evaluate_fitness(mutated_population, map, start, finish);
    combined_population = [population; mutated_population];
    combined_fitness = [fitness; offspring_fitness];

    % Apply elitism to retain the best paths
    [sorted_fitness, sorted_idx] = sort(combined_fitness, 'ascend');
    population = combined_population(sorted_idx(1:pop_size), :);
    
    % Track the best solution
    [min_fitness, idx] = min(sorted_fitness);
    if min_fitness < best_fitness
        best_fitness = min_fitness;
        solution = population(idx, :);
    end
end

disp(solution);  % Print the final solution (path)
execution_time = toc;  % End timing
disp(['Execution Time: ', num2str(execution_time), ' seconds']);

% Display results
path_points = reshape(solution, num_points, 2);  % Reshape the solution to path coordinates
path = [start; path_points; finish];  % Combine start, intermediate points, and finish
clf;  % Clear the figure
imshow(map);  % Display the map
rectangle('position', [1 1 size(map)-1], 'edgecolor', 'k');  % Draw the boundary
line(path(:,2), path(:,1));  % Draw the path

% Calculate and display the total path length
euclidean_distance = compute_path_length(path);
disp(['Total Euclidean Distance: ', num2str(euclidean_distance)]);

% Function to initialise the population with random paths avoiding obstacles
function population = initialise_population(pop_size, num_points, start, finish, map)
    population = zeros(pop_size, num_points * 2);  % Initialise the population array
    for i = 1:pop_size
        path = [];
        prev_point = start;
        for j = 1:num_points
            valid_point = false;
            while ~valid_point
                % Generate a random point closer to the finish
                y = randi([prev_point(1), finish(1)]);
                x = randi([prev_point(2), finish(2)]);
                
                % Ensure the point does not lie on an obstacle
                if map(round(x), round(y)) == 0
                    % Ensure forward movement towards the finish
                    if x >= prev_point(2) && y >= prev_point(1)
                        valid_point = true;
                        path = [path; y, x]; %#ok<AGROW>
                        prev_point = [y, x];
                    end
                end
            end
        end
        population(i, :) = reshape(path, 1, []);  % Flatten the path for storage
    end
end

% Function to evaluate the fitness of paths
function fitness = evaluate_fitness(population, map, start, finish)
    [pop_size, num_vars] = size(population);
    num_points = num_vars / 2;
    fitness = zeros(pop_size, 1);  % Initialise the fitness values
    
    for i = 1:pop_size
        path_points = reshape(population(i, :), num_points, 2);
        path = [start; path_points; finish];
        
        % Compute the path length and penalties for obstacles
        path_length = compute_path_length(path);
        obstacle_penalty = compute_obstacle_penalty(path, map);
        
        % Fitness is the total cost (shorter path + fewer obstacles is better)
        fitness(i) = (path_length + obstacle_penalty);
    end
end

% Function to calculate penalty for obstacles in the path
function penalty = compute_obstacle_penalty(path, map)
    penalty = 0;  % Initialise penalty
    for i = 1:size(path, 1)-1
        p1 = path(i, :);
        p2 = path(i+1, :);
        
        % Interpolate between points
        num_points = 100;  % Higher value for more precise checking
        x_interp = linspace(p1(1), p2(1), num_points);
        y_interp = linspace(p1(2), p2(2), num_points);
        
        x_interp = round(x_interp);
        y_interp = round(y_interp);
        
        % Check for obstacles along the line
        for j = 1:num_points
            x = x_interp(j);
            y = y_interp(j);
            if x >= 1 && x <= size(map, 1) && y >= 1 && y <= size(map, 2)
                if map(x, y) == 0
                    penalty = penalty + 1e6;  % High penalty for obstacles
                end
            else
                penalty = penalty + 1e6;  % Penalty for out-of-bounds points
            end
        end
    end
end

% Function to calculate the Euclidean path length
function length = compute_path_length(path)
    length = sum(sqrt(sum(diff(path).^2, 2)));  % Sum the distances between consecutive points
end
