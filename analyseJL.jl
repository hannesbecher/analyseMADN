# script to analyse the Julia version

a = [oneGame() for _ in 1:1000]
histogram(lenOfGame(a), label="JL default", alpha=0.4, bins=200:20:1200, dpi=300)
histogram!(lenOfGame(a), label="JL default", alpha=0.4, bins=200:20:1200, dpi=300)

aKicks = matVec2Arr(whoKicksWhom.(a));
kickMatMeanSdHeat(aKicks, "All kickers")

histogram(reduce(vcat, map(x -> x["whoField"], a)), normalize=:probability, bins=-0.5:1:39.5, alpha=0.5, label="All kickers", dpi=300)