include("data.jl")

# Produces
# allK
# allR
# halfKHalfR
# oneKThreeR
# threeKOneR

include("functions.jl")

# keys(allK[1])
# KeySet for a Dict{Any, Any} with 5 entries. Keys:
# "kickingWhom"
# "kickingWho"
# "whomField"
# "kickingTurns"
# "finishingOrder"
# "whoField"
# "finishingTurns"

#mkpath("PLOTS")



histogram(lenOfGame(allK), label="All kickers", alpha=0.4, bins=200:20:1200, dpi=300)
histogram!(lenOfGame(allR), label="All runners", alpha=0.4, bins=200:20:1200)
vline!([median(lenOfGame(allK)), median(lenOfGame(allR))], line=(2, :dash, "grey"), label="Medians")
title!("Length of game")
xlabel!("Rounds")
ylabel!("Number of games")
quantile(lenOfGame(allK), [0.025, 0.5, 0.975])
# 368.0 # 521.0 # 754.0
quantile(lenOfGame(allR), [0.025, 0.5, 0.975])
# 299.0 # 391.0 # 518.0
#savefig("PLOTS/lenOfGamKR.png")



allKKicks = matVec2Arr(whoKicksWhom.(allK));
allRKicks = matVec2Arr(whoKicksWhom.(allR));
kickMatMeanSdHeat(allKKicks, "All kickers")
#savefig("PLOTS/KickNumsAllK.png")
kickMatMeanSdHeat(allRKicks, "All runners")
#savefig("PLOTS/KickNumsAllR.png")







histogram!(lenOfGame(halfKHalfR), label="Half", bins=0:50:1500, alpha=0.5)
histogram!(lenOfGame(oneKThreeR), label="1K3R", bins=0:50:1500, alpha=0.5)
histogram!(lenOfGame(threeKOneR), label="3K1R", bins=0:50:1500, alpha=0.5)
title!("Length of game")
xlabel!("Rounds")
ylabel!("Number of games")




histogram(reduce(vcat, whoFieldWho.(oneKThreeR, 1)), alpha=0.5, label="Pl1", normalize=:probability)
histogram!(reduce(vcat, whoFieldWho.(oneKThreeR, 2)), alpha=0.5, label="Pl2", normalize=:probability)
histogram(reduce(vcat, whomFieldWhom.(oneKThreeR, 1)), alpha=0.5, label="Pl1", normalize=:probability)
histogram!(reduce(vcat, whomFieldWhom.(oneKThreeR, 2)), alpha=0.5, label="Pl2", normalize=:probability)

halfKHalfRKicks = matVec2Arr(whoKicksWhom.(halfKHalfR));
oneKThreeRKicks = matVec2Arr(whoKicksWhom.(oneKThreeR));
threeKOneRKicks = matVec2Arr(whoKicksWhom.(threeKOneR));


kickMatMeanSdHeat(allKKicks, "All kickers")
#savefig("PLOTS/KickNumsAllK.pdf")
kickMatMeanSdHeat(allRKicks, "All runners")
#savefig("PLOTS/KickNumsAllR.pdf")
kickMatMeanSdHeat(halfKHalfRKicks, "Kickers 2&4, runners 1&3")
kickMatMeanSdHeat(oneKThreeRKicks, "Kicker 1, runners 2,3,4")
kickMatMeanSdHeat(threeKOneRKicks, "Kickers 1,2,3, runner 4")

allKKicks[4,1,:] |> mean
allKKicks[4,1,:] |> histogram

bar(winningFreq(allK, rel=true))
bar(winningFreq(allR, rel=true))
bar(winningFreq(halfKHalfR, rel=true))
bar(winningFreq(oneKThreeR, rel=true))
bar(winningFreq(threeKOneR, rel=true))
winningFreq(halfKHalfR, rel=true)

nOfKicks(allK) |> mean
nOfKicks(allR) |> mean
nOfKicks(halfKHalfR) |> mean

histogram(nOfKicks(allK), label="K", bins=0:5:150, alpha=0.5)
histogram!(nOfKicks(allR), label="R", bins=0:5:150, alpha=0.5)
histogram!(nOfKicks(halfKHalfR), label="Half", bins=0:5:150, alpha=0.5)
histogram!(nOfKicks(oneKThreeR), label="1K3R", bins=0:5:150, alpha=0.5)
histogram!(nOfKicks(threeKOneR), label="3K1R", bins=0:5:150, alpha=0.5)
title!("Number of kicks in game")
xlabel!("Kicks")

lenOfGame(allK) |> mean
lenOfGame(threeKOneR) |> mean
lenOfGame(halfKHalfR) |> mean
lenOfGame(oneKThreeR) |> mean
lenOfGame(allR) |> mean



winningFreq(allK, rel=true)
winningFreq(allR, rel=true)
winningFreq(halfKHalfR, rel=true)

a = reshape(1:16, 4, 4)
b = vcat(a, sum(a, dims=1))
c = hcat(sum(b, dims=2), b)

########################
# Kick field

allK[1]
histogram(allK[1]["whoField"])

histogram(reduce(vcat, map(x -> x["whoField"], allK)), normalize=:probability, bins=-0.5:1:39.5, alpha=0.5, label="All kickers", dpi=300)
histogram!(reduce(vcat, map(x -> x["whoField"], allR)), normalize=:probability, bins=-0.5:1:39.5, alpha=0.5, label="All runners")
#histogram!(reduce(vcat, map(x -> x["whoField"], oneKThreeR)), normalize=true, alpha=0.5, label="allR")
title!("Kicks handed out")
xlabel!("Kicks on player field")
ylabel!("Relative frequency")
#savefig("PLOTS/KicksWhoField.png")

histogram(mod.(reduce(vcat, map(x -> x["whoField"], allK)), 10), normalize=:probability, alpha=0.5, label="allK")
histogram!(mod.(reduce(vcat, map(x -> x["whoField"], allR)), 10), normalize=:probability, alpha=0.5, label="allR")
histogram!(mod.(reduce(vcat, map(x -> x["whoField"], oneKThreeR)), 10), normalize=:probability, alpha=0.5, label="allR")
title!("Kicks whoField, mod10")
#savefig("PLOTS/KicksWhoFieldMod10.pdf")

histogram(reduce(vcat, map(x -> x["whomField"], allK)),  normalize=:probability, bins=-0.5:1:39.5, alpha=0.5, label="All kickers", dpi=300)
histogram!(reduce(vcat, map(x -> x["whomField"], allR)),  normalize=:probability, bins=-0.5:1:39.5, alpha=0.5, label="All runners")
#histogram!(reduce(vcat, map(x -> x["whomField"], oneKThreeR)), normalize=true, alpha=0.5, label="1K3R")
title!("Kicks received")
xlabel!("Kicks on player field")
ylabel!("Relative frequency")
#savefig("PLOTS/KicksWhomField.png")

histogram(mod.(reduce(vcat, map(x -> x["whomField"], allK)), 10), normalize=:probability, alpha=0.5, label="allK")
histogram!(mod.(reduce(vcat, map(x -> x["whomField"], allR)), 10), normalize=:probability, alpha=0.5, label="allR")
title!("Kicks whomField, mod10")
#savefig("PLOTS/KicksWhomFieldMod10.pdf")


finishingTurnsAllK = reduce(hcat, finishingTurns.(allK));

scatter(map(x -> finishingTurnsAllK[x,:], 1:2)...)
plot!(x -> x)
scatter!(map(x -> finishingTurnsAllK[x,:], 2:3)...)
scatter(map(x -> finishingTurnsAllK[x,:], [1,3])...)
histogram(finishingTurnsAllK[1,:], alpha=0.5, label="Finish1")
histogram!(finishingTurnsAllK[2,:], alpha=0.5, label="Finish2")
histogram!(finishingTurnsAllK[3,:], alpha=0.5, label="Finish3")