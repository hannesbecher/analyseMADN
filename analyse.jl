using Pkg
Pkg.activate(".")
#Pkg.instantiate()
using Plots
#ENV["PYTHON"] = "/Users/hannesbecher/miniconda3/bin/python3"
#Pkg.build("PyCall")
using PyCall
using StatsBase
using Statistics
pwd()
#cd() to correct dir
cd("..")
pushfirst!(PyVector(pyimport("sys")."path"), "")
MADN = pyimport("MADN")
# @time [MADN.oneGame() for _ in 1:100]; # Takes about twice as long as running directly in python3
#MADN.oneGame()
#MADN.oneGame(tak=["k", "k", "k", "k"])
allK1000 = [MADN.oneGame(tak=["k", "k", "k", "k"]) for _ in 1:1000];
allR1000 = [MADN.oneGame(tak=["r", "r", "r", "r"]) for _ in 1:1000];
halfKHalfR1000 = [MADN.oneGame(tak=["r", "k", "r", "k"]) for _ in 1:1000];
oneKThreeR1000 = [MADN.oneGame(tak=["k", "r", "r", "r"]) for _ in 1:1000];
threeKOneR1000 = [MADN.oneGame(tak=["k", "k", "k", "r"]) for _ in 1:1000];

# keys(allK100[1])
# KeySet for a Dict{Any, Any} with 5 entries. Keys:
#     "kickingWhom"
#     "finishingTurns"
#     "finishingOrder"
#     "kickingTurns"
#     "kickingWho"

function nOfKicks(madnList)
    map(x -> length(x["kickingTurns"]), madnList)
end

function lenOfGame(madnList)
    map(x -> x["finishingTurns"][end], madnList)
end

function winningFreq(madnList; rel=false)
    a = map(x -> x["finishingOrder"][1], madnList)
    l = ifelse(rel, length(a), 1)
    Dict(i => sum(a.==i)/l for i in 1:4)
end

function whoKicksWhom(madnDict; rel=false)
    a = madnDict["kickingWho"]
    b = madnDict["kickingWhom"]
    #println(length(a))
    #println(length(b))
    c = zeros(4,4)
    ct=0
    for i in zip(a,b)
        c[i...] += 1
    end
    return ifelse(rel, c/sum(c), c)
end

function kickAvgMat(madnList)
    a = sum(whoKicksWhom.(madnList), dims=1)[1]
    a/sum(a)
end

allK1000[2]["kickingWho"]
allK1000[2]["kickingWhom"]
a = sum(whoKicksWhom.(threeKOneR1000), dims=1)[1]
heatmap(a/sum(a))
kickAvgMat(allK1000) |> heatmap
ylabel!("Who")
xlabel!("Whom")
kickAvgMat(allR1000) |> heatmap
kickAvgMat(halfKHalfR1000) |> heatmap
kickAvgMat(oneKThreeR1000) |> heatmap
kickAvgMat(threeKOneR1000) |> heatmap

whoKicksWhom(allK1000[1], rel=true)
whoKicksWhom(oneKThreeR1000[2]) |> heatmap
bar(winningFreq(allK1000, rel=true))
bar(winningFreq(allR1000, rel=true))
bar(winningFreq(halfKHalfR1000, rel=true))
bar(winningFreq(oneKThreeR1000, rel=true))
bar(winningFreq(threeKOneR1000, rel=true))
winningFreq(halfKHalfR1000, rel=true)

nOfKicks(allK1000) |> mean
nOfKicks(allR1000) |> mean
nOfKicks(halfKHalfR1000) |> mean

histogram(nOfKicks(allK1000), label="K", bins=0:5:150, alpha=0.5)
histogram!(nOfKicks(allR1000), label="R", bins=0:5:150, alpha=0.5)
histogram!(nOfKicks(halfKHalfR1000), label="Half", bins=0:5:150, alpha=0.5)
histogram!(nOfKicks(oneKThreeR1000), label="1K3R", bins=0:5:150, alpha=0.5)
histogram!(nOfKicks(threeKOneR1000), label="3K1R", bins=0:5:150, alpha=0.5)
title!("Number of kicks in game")
xlabel!("Kicks")

lenOfGame(allK1000) |> mean
lenOfGame(threeKOneR1000) |> mean
lenOfGame(halfKHalfR1000) |> mean
lenOfGame(oneKThreeR1000) |> mean
lenOfGame(allR1000) |> mean


histogram(lenOfGame(allK1000), label="K", bins=0:50:1500, alpha=0.5)
histogram!(lenOfGame(allR1000), label="R", bins=0:50:1500, alpha=0.5)
histogram!(lenOfGame(halfKHalfR1000), label="Half", bins=0:50:1500, alpha=0.5)
histogram!(lenOfGame(oneKThreeR1000), label="1K3R", bins=0:50:1500, alpha=0.5)
histogram!(lenOfGame(threeKOneR1000), label="3K1R", bins=0:50:1500, alpha=0.5)
title!("Length of game")
xlabel!("Rounds")


winningFreq(allK1000, rel=true)
winningFreq(allR1000, rel=true)
winningFreq(halfKHalfR1000, rel=true)
