# Implement code blocks 3.11 through 3.19 in Statistical Rethinking, 2nd edition.

using Distributions
using Statistics
using StatsBase
using LinearAlgebra

grid_size = 1000
num_observations = 3
num_samples = 1000


# Code block 3.11
param_grid = range(0, 1, length=grid_size)
prior = ones((grid_size))
likelihood = [pdf(Binomial(3, p), num_observations) for p in param_grid]
posterior = likelihood .* prior
posterior = posterior / sum(posterior)

@assert abs(sum(posterior) - 1) < 1e-4 "Posterior does not sum to 1."
@assert minimum(posterior) >= 0
@assert maximum(posterior) <= 1

samples = sample(param_grid, Weights(posterior), num_samples; replace=true, ordered=false)


# Code block 3.12
function central_interval(samples, proba::AbstractFloat)
    @assert proba > 0
    @assert proba < 1
    quantile(samples, [0.5 - proba / 2, 0.5 + proba / 2])
end

central_interval(samples, 0.5)


# Code block 3.13

# UPDATE: all the prob. prog. packages have it right. Because they *sort* the samples
# first, they're really working with the ECDF. Subtracting in the domain of the ECDF
# such that the range always has at least `proba` mass.

# - I'm 85% sure the StatisticalRethinking.jl package has this wrong, it assumes
#   some mass on both sides of the tail, which is not correct.

function high_density_interval(samples, proba::AbstractFloat)
    @assert proba >= 0
    @assert proba <= 1

    count_threshold = proba * length(samples)
    hist = fit(Histogram, samples; closed=:right, nbins=100)

    interval_mass = 0
    start_index = 1
    min_interval_length = Inf
    candidate = (NaN, NaN)
    candidate_mass = 0

    for (i, w) in enumerate(hist.weights)
        interval_mass += w

        while interval_mass >= count_threshold
            interval_length = i - start_index
        
            if (interval_length < min_interval_length) || 
                    ((interval_length == min_interval_length) &&
                     interval_mass > candidate_mass)

                candidate = (start_index, i)
                candidate_mass = interval_mass
                min_interval_length = interval_length
            end

            interval_mass = interval_mass - hist.weights[start_index]
            start_index += 1
        end
    end

    interval = [hist.edges[1][candidate[1]], hist.edges[1][candidate[2]]]
end

high_density_interval(samples, 0.5)


# Code block 3.14 - MAP of the explicit posterior
_, i = findmax(posterior)
posterior_mode = param_grid[i]


# Code block 3.15 - MAP based on posterior samples
# - Based on a density estimate again


# Code block 3.16
mean(samples)
median(samples)


# Code block 3.17 - mean absolute error loss for a point estimate
function mae_loss(point_estimate, param_grid, posterior)
    sum(posterior .* abs.(point_estimate .- param_grid))
end

loss = mae_loss(0.5, param_grid, posterior)


# Code blocks 3.18 and 3.19 - mean absolute error for all param values
# - The book uses `sapply` in R. I don't know how to vectorize like that yet in Julia,
#   so let's just loop.
losses = [mae_loss(p, param_grid, posterior) for p in param_grid]

_, i = findmin(losses)

best_point_estimate = param_grid[i]
