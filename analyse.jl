using Pkg
using Downloads
#pwd()
# MADNurl = "https://github.com/hannesbecher/MADN/releases/download/v1.0.0-beta/MADN_v1.0.0-beta.tar.gz" 
# basename(MADNurl)
# download(MADNurl, basename(MADNurl))
# run(Cmd(["tar",  "-zxvf", basename(MADNurl)]))
# readdir()
Pkg.activate(".")

#Pkg.instantiate()
using Plots
#ENV["PYTHON"] = "/Users/hannesbecher/miniconda3/bin/python3"
#Pkg.build("PyCall")
using PyCall
using StatsBase
using Statistics
pwd()

pushfirst!(PyVector(pyimport("sys")."path"), "")
MADN = pyimport("MADN")
# @time [MADN.oneGame() for _ in 1:100]; # Takes about twice as long as running directly in python3
#MADN.oneGame()
#MADN.oneGame(tak=["k", "k", "k", "k"])
allK = [MADN.oneGame(tak=["k", "k", "k", "k"]) for _ in 1:10000];
allR = [MADN.oneGame(tak=["r", "r", "r", "r"]) for _ in 1:10000];
halfKHalfR = [MADN.oneGame(tak=["r", "k", "r", "k"]) for _ in 1:10000];
oneKThreeR = [MADN.oneGame(tak=["k", "r", "r", "r"]) for _ in 1:10000];
threeKOneR = [MADN.oneGame(tak=["k", "k", "k", "r"]) for _ in 1:10000];

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

allK[2]["kickingWho"]
allK[2]["kickingWhom"]
a = sum(whoKicksWhom.(threeKOneR), dims=1)[1]
heatmap(a/sum(a))
kickAvgMat(allK) |> heatmap
ylabel!("Who")
xlabel!("Whom")
kickAvgMat(allR) |> heatmap
kickAvgMat(halfKHalfR) |> heatmap
kickAvgMat(oneKThreeR) |> heatmap
kickAvgMat(threeKOneR) |> heatmap

whoKicksWhom(allK[1], rel=true)
whoKicksWhom(oneKThreeR[2]) |> heatmap
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


histogram(lenOfGame(allK), label="K", bins=0:50:1500, alpha=0.5)
histogram!(lenOfGame(allR), label="R", bins=0:50:1500, alpha=0.5)
histogram!(lenOfGame(halfKHalfR), label="Half", bins=0:50:1500, alpha=0.5)
histogram!(lenOfGame(oneKThreeR), label="1K3R", bins=0:50:1500, alpha=0.5)
histogram!(lenOfGame(threeKOneR), label="3K1R", bins=0:50:1500, alpha=0.5)
title!("Length of game")
xlabel!("Rounds")


winningFreq(allK, rel=true)
winningFreq(allR, rel=true)
winningFreq(halfKHalfR, rel=true)
