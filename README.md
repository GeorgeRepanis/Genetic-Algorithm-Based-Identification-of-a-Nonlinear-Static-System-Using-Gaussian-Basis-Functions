 # Genetic-Algorithm-Based-Identification-of-a-Nonlinear-Static-System-Using-Gaussian-Basis-Functions
MATLAB project that implements a Genetic Algorithm from scratch to identify a nonlinear static system  𝑦 = 𝑓 ( 𝑢 1 , 𝑢 2 ) y=f(u 1,u 2 ) by fitting a Gaussian (RBF) basis-function model. Includes train/test data generation, MSE cost, tournament selection, crossover, mutation, elitism, and visualization of true vs estimated surfaces

# Genetic Algorithm Identification of a Nonlinear Static System (MATLAB)

Course project for **Optimization Techniques** (Genetic Algorithms).
This repository implements a **Genetic Algorithm (GA) from scratch** (no `ga()` built-in) to identify a nonlinear static system with two inputs:

\[
y = f(u_1, u_2)
\]

The true function used to generate data is:
\[
f(u_1,u_2)=\sin(u_1+u_2)\cdot \sin(u_2^2)
\]

## Goal
Approximate the unknown nonlinear mapping \(f(u_1,u_2)\) using a **low-complexity analytic model** based on a weighted sum of **Gaussian basis functions (RBF model)**, by minimizing the **training MSE** and evaluating generalization on a test set.

## Model (Gaussian basis / RBF)
The estimated model is:
\[
\hat{f}(u_1,u_2)=\sum_{i=1}^{M} w_i \exp\left(-\left(\frac{(u_1-c_{1i})^2}{2\sigma_{1i}^2}+\frac{(u_2-c_{2i})^2}{2\sigma_{2i}^2}\right)\right)
\]

Each Gaussian has parameters:
- weight: \(w_i\)
- center: \((c_{1i}, c_{2i})\)
- spreads: \((\sigma_{1i}, \sigma_{2i})\)

Total decision variables: \(D = 5M\)

Default setup (in `GA_main.m`):
- `M = 15`  → `D = 75` parameters
- input domain:
  - \(u_1 \in [-1, 2]\)
  - \(u_2 \in [-2, 1]\)
- training points: `Ntrain = 1000`
- test points: `Ntest = 1000`

## Optimization Objective (Cost)
Mean Squared Error (MSE) on training data:
\[
J(\theta)=\frac{1}{N}\sum_{k=1}^{N}(y_k-\hat{y}_k)^2
\]

Optional penalty term (disabled by default) to encourage lower effective complexity:
- `usePenalty = false`
- `lambda = 1e-3`

## GA Implementation Details
Implemented GA components:
- **Initialization** within bounds
- **Tournament selection**
- **Arithmetic crossover**
- **Gaussian mutation** (gene-wise probability)
- **Elitism** (top K individuals survive)
- **Bounds clamping** for feasibility

Default GA hyperparameters:
- population: `P = 80`
- generations: `G = 200`
- crossover probability: `pc = 0.85`
- mutation probability: `pm = 0.05`
- elite count: `eliteK = 2`
- tournament size: `tSize = 3`
- mutation scale: `mutScale = 0.08`

## Outputs / Visualizations
Running the main script produces:
- GA convergence plot (best MSE vs generation)
- 3D surface of:
  - true function \(f(u_1,u_2)\)
  - estimated function \(\hat{f}(u_1,u_2)\)
  - error surface \(f-\hat{f}\)

## Files
- `GA_main.m` — main script (data generation, GA loop, plots)
- `generateData.m` — generates train/test datasets (uniform sampling)
- `f_true.m` — ground-truth function definition
- `predictModel.m` — computes \(\hat{f}\) from chromosome parameters
- `decodeChromosome.m` — parses chromosome into (w, c1, c2, s1, s2)
- `costFunction.m` — MSE (and optional penalty)
- `tournamentSelect.m` — tournament selection operator
- `mutate.m` — Gaussian mutation operator
- `makeBounds.m` — lower/upper bounds for parameters
- `report.pdf` — full report (theory, algorithm design, results)

## How to Run
1. Open MATLAB and set the repository folder as the current directory.
2. Run:
   - `GA_main`
3. Inspect the generated figures and printed best solution info.

## Notes / Customization
- Increase `M` for more expressive models (at the cost of more parameters).
- Tune GA hyperparameters (`P`, `G`, `pm`, `pc`, `mutScale`) for performance.
- Enable penalty (`usePenalty=true`) to push small weights toward zero.

## Author
George Repanis (AUTH) — Course project submission
