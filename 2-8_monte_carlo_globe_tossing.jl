# Implement code block 2.8 in McElreath's Statistical Rethinking, 2nd edition.

using Random
using Distributions
using Plots

Random.seed!(17)

num_samples = 2000

probas = [0.5]

successes = 6
trials = 9

for i = 2:num_samples
    
    proba_new = rand(Normal(probas[end], 0.1))
    
    if proba_new < 0; proba_new = abs(proba_new); end
    if proba_new > 1; proba_new = 2 - proba_new; end
    
    q0 = pdf(Binomial(trials, probas[end]), successes)
    q1 = pdf(Binomial(trials, proba_new), successes)
    
    push!(probas, rand(Uniform(0, 1)) < q1 / q0 ? proba_new : probas[end])
end

# println(probas)

display(histogram(probas, bins=:40))
