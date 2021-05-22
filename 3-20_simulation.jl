# Implement code blocks 3.20 through 3.26 in Statistical Rethinking, 2nd edition.

using Random
using Distributions: Binomial, pdf, rand
using StatsBase: countmap, proportionmap, sample, Weights
using Plots: histogram

Random.seed!(17)


# Code block 3.20
distro = Binomial(2, 0.7)
probas = pdf(distro)


# Code block 3.21
rand(distro, 1)


# Code block 3.22
rand(distro, 10)


# Code block 3.23
draw = rand(distro, 100_000)
countmap(draw)
proportionmap(draw)


# Code block 3.24
distro = Binomial(9, 0.7)
draw = rand(distro, 100_000)
display(histogram(draw, xlabel="Dummy water count", ylabel="Frequency"))


# Code block 3.25
distro = Binomial(9, 0.6)
draw = rand(distro, 10_000)


# Code block 3.26 (also block 3.27 in the practice questions)

# This one is a little confusing - it's not clear what `samples` refers to in the book's
# code snippet. I *think* these are samples from the posterior distribution of the
# parameter P(theta | data), and we use these to then get the posterior predictive
# distribution P(y | data).
# See snippets 3.11 and 3.27 as examples.
grid_size = 1_000
num_samples = 10_000

param_grid = range(0, 1, length=grid_size)
prior = ones((grid_size))
likelihood = [pdf(Binomial(9, p), 6) for p in param_grid]
posterior = (likelihood .* prior)
posterior = posterior ./ sum(posterior)

param_samples = sample(
    param_grid, Weights(posterior), num_samples; replace=true, ordered=false
)

posterior_draw = [rand(Binomial(9, p)) for p in param_samples]  # this seems inefficient

# This figure is the bottom plot in Figure 3.6.
display(
    histogram(
        posterior_draw, xlabel="Water obs count", ylabel="Posterior Predictve Frequency"
    )
)
