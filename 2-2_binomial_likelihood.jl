
using Distributions

distro = Binomial(9, 0.5)
likelihood = pdf(distro, 6)
println(likelihood)
