# Genetic Algorithm for Pathfinding

This project demonstrates a **Genetic Algorithm (GA)** implementation for finding paths in an environment with obstacles. The goal is to evolve a population of candidate paths to find an optimal solution that avoids obstacles while minimizing the distance between a start and a finish point.

---

## Features
- **Random Map Generation**: Generates a customizable binary map (`random_map.bmp`) with random shapes as obstacles.
- **Customizable Genetic Operators**:
  - Selection: Supports Roulette Wheel, Tournament, and Rank-based selection.
  - Crossover: Single-point and uniform crossover methods are implemented.
  - Mutation: Random reset and swap mutation methods are available.
- **Obstacle Avoidance**: Paths are constrained to avoid obstacles during crossover, mutation, and initialization.
- **Visualization**: Displays the map with paths during iterations and outputs the final solution.

---

## File Structure

### Main Scripts
1. **`main.m`**: The primary script to execute the GA. It includes:
   - Population initialization
   - Selection, crossover, mutation, and fitness evaluation
   - Visualization of intermediate and final results

2. **`main2.m`**: An alternate main script integrating enhanced obstacle detection and path smoothing.

### Supporting Files
- **`Generate_Random_Map.m`**: Generates a random obstacle map.
- **`crossover.m`**: Implements the crossover operation for GAs.
- **`mutation.m`**: Handles mutations for maintaining population diversity.
- **`selection.m`**: Provides selection strategies for parent selection.

### Input Files
- **`random_map.bmp`**: Binary obstacle map used for pathfinding.

### Output
- Visual plots showing path evolution and the final path.
- Console outputs for solution path and statistics (e.g., execution time).

---

## How to Use

1. **Generate a Map**:
   Run `Generate_Random_Map.m` to create a custom obstacle map (`random_map.bmp`).

2. **Configure Parameters**:
   Open `main.m` and configure the following parameters:
   - Population size (`pop_size`)
   - Number of generations (`iter`)
   - Mutation and crossover rates
   - Selection, crossover, and mutation methods

3. **Run the GA**:
   Execute `main.m` or `main2.m` in MATLAB.

4. **View Results**:
   - Path evolution and the final path are visualized on the map.
   - The console displays the best path and its fitness.

---

## Example

### Map Generation
```matlab
% Generate a random map with 30 obstacles
Generate_Random_Map;
```
### GA Execution
```matlab
% Run the main genetic algorithm
main;
```
## Customization
<ul>
<li>Map Settings: Modify Generate_Random_Map.m to change the number, size, and type of obstacles.</li>
<li>GA Parameters: Adjust parameters like population size, mutation rate, and the number of generations in main.m.</li>
<li>Selection Methods: Choose among Roulette Wheel (0), Tournament (1), and Rank-based (2).</li>
<li>Crossover and Mutation: Select single-point (0) or uniform crossover (1), and random reset (0) or swap mutation (1).</li>
</ul>

## Notes
<ul>
<li>Ensure the map has a clear path from the start to the finish to guarantee feasible solutions.</li>
<li>Paths touching obstacles will be penalized heavily during fitness evaluation.</li>
</ul>

## Dependencies
<ul>
<li>MATLAB (R2020b or later recommended).</li>
</ul>

## Contributor
<ul>
<li>KONG JIA JUN</li>
<li>Email: kongjiajun040103@gmail.com</li>
</ul>

## License
This project is licensed under the MIT License.



