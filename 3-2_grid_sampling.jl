# Implement code blocks 3.2 - 3.10 in McElreath's Statistical Rethinking, 2nd edition.

using Distributions
using Plots
using Statistics
using StatsBase


grid_size = 1000
num_samples = 1000


## Code block 3.2
param_grid = range(0, 1, length=grid_size)  
prior = ones((grid_size))
likelihood = [pdf(Binomial(9, p), 6) for p in param_grid]
posterior = likelihood .* prior
posterior = posterior / sum(posterior)

@assert abs(sum(posterior) - 1) < 1e-4 "Posterior does not sum to 1."
@assert minimum(posterior) >= 0
@assert maximum(posterior) <= 1


## Code block 3.3
samples = sample(param_grid, Weights(posterior), num_samples; replace=true, ordered=false)


## Code block 3.4
display(scatter(samples, xlabel="Sample number", ylabel="Proportion water (p)"))


## Code block 3.5
# use a histogram, because I don't yet know a comparable tool for density estimation in
# Julia.
display(histogram(samples, bins=:40))


## Code block 3.6
sum(posterior[param_grid .< 0.5])


## Code block 3.7
sum(samples .< 0.5) / num_samples


## Code block 3.8
sum(0.5 .< samples .< 0.75) / num_samples


## Code block 3.9
quantile(samples, 0.8)


## Code block 3.10
quantile(samples, [0.1, 0.9])
