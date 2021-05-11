
using Distributions
using Plots

grid_size = 40
proba_grid = range(0, 1, length=grid_size)

## Code block 2.5
# prior = ones((grid_size))
# prior = collect(proba_grid) .>= 0.5
prior = exp.(-5 * abs.(collect(proba_grid) .- 0.5))

plot(
    proba_grid, prior, title="40 Points", xlabel="Probability of water", 
    ylabel="Prior probability", lw=3
)

likelihood = [pdf(Binomial(9, p), 6) for p in proba_grid]
posterior = prior .* likelihood
posterior_proba = posterior / sum(posterior)

## Code block 2.4
plot(
    proba_grid, posterior_proba, title="40 Points", xlabel="Probability of water", 
    ylabel="Posterior probability", lw=3
)
