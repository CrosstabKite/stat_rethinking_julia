# Practice implementation of code blocks 4.1 through 4.6 in McElreath's Statistical
# Rethinking, 2nd ed.

using Random
using Distributions: Uniform, rand, pdf
using Plots: histogram


# Set up
Random.seed!(17)


# Code block 4.1
distro = Uniform(-1, 1)
steps = rand(distro, 1000, 16)
positions = sum(steps, dims=2)
display(histogram(positions, bins=:40, xlabel="Position", ylabel="Frequency"))


# Code blocks 4.2 and 4.3: Gaussian through multiplication
distro = Uniform(0, 0.1)
effects = rand(distro, 1000, 12) .+ 1
growth = prod(effects, dims=2)
display(histogram(growth, bins=:40, xlabel="Growth", ylabel="Frequency"))


# Code block 4.4
distro = Uniform(0, 0.5)
effects = rand(distro, 1000, 12) .+ 1
big_growth = prod(effects, dims=2)
display(histogram(big_growth, bins=:40, xlabel="Growth", ylabel="Frequency"))

distro = Uniform(0, 0.01)
effects = rand(distro, 1000, 12) .+ 1
small_growth = prod(effects, dims=2)
display(histogram(small_growth, bins=:40, xlabel="Growth", ylabel="Frequency"))


# Code block 4.5
log_big_growth = log.(big_growth)
display(histogram(log_big_growth, bins=:40, xlabel="Log(growth)", ylabel="Frequency"))


# Code block 4.6
w = 6
n = 9
param_grid = 0.0:1/100:1.0
posterior = [pdf(Binomial(n, p), w) * pdf(Uniform(0, 1), p) for p in param_grid]
posterior = posterior / sum(posterior)