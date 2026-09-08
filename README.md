# MTH3180_Assignment01

Assignment 01

08/31/2026 - Present

Authors: Cat Cirone, Alex Mineeva

## Key Variables

## User Inputs

Users can choose the solver 

## Outputs

## How to Use
1. Clone the repository
```
git clone https://github.com/amineeva/MTH3180_Assignment01.git
cd MTH3180_Assignment01
```
2. In MATLAB, open files `input_recorder_step_one.m` and `error_computation_plotter.m`
- make sure that the solver files and `input_recorder.m` are in the same folder

3. Run `input_recorder_step_one.m`

4. Run `error_computation_plotter.m`

5. View your plots!

## File Structure

`basic_solver_with_tests_template.m` - template code; used for testing the solvers before splitting them apart

`bisection_solver.m` - function for the bisection method. Outputs the final midpoint (root) and a list of discarded values (for cleaner convergence plotting)

`error_computation_plotter.m` - second step for getting plots. Takes the x-value inputs, finds error values, and creates plots. Uses outputs from `input_recorder_step_one.m`

`input_recorder.m` - Orion's template code for recording x0 and x1 data for the different solvers

`input_recorder_example_newtons.m` - in-progress version of `input_recorder_step_one.m` that only has newton's method

`input_recorder_example_secant.m` - in-progress version of `input_recorder_step_one.m` that only has secant method

`input_recorder_fzero.m` - in-progress version of `input_recorder_step_one.m` that only has MATLAB's fzero function

`input_recorder_step_one.m` - first step for getting plots. Runs `input_recorder.m` with the user-chosen solver. 1 - Newton's Method, 2 - Bisection Method, 3 - Secant Method, 4 - Fzero

