
using Distributions
using Plots

proba_grid = range(0, 1, length=20)

prior = ones((20))
likelihood = [pdf(Binomial(9, p), 6) for p in proba_grid]
posterior = prior .* likelihood
posterior_proba = posterior / sum(posterior)

plot(
    proba_grid, posterior_proba, title="20 Points", xlabel="Probability of water", 
    ylabel="Posterior probability", lw=3
)
