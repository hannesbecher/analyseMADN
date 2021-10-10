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
allK100 = [MADN.oneGame(tak=["k", "k", "k", "k"]) for _ in 1:100]
allR100 = [MADN.oneGame(tak=["r", "r", "r", "r"]) for _ in 1:100]
halfKHalfR100 = [MADN.oneGame(tak=["r", "k", "r", "k"]) for _ in 1:100]

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

winningFreq(allK100, rel=true)
winningFreq(allR100, rel=true)
winningFreq(halfKHalfR100, rel=true)

nOfKicks(allK100) |> mean
nOfKicks(allR100) |> mean
nOfKicks(halfKhalfR100) |> mean

histogram(nOfKicks(allK100), label="K", bins=0:10:150, alpha=0.5)
histogram!(nOfKicks(allR100), label="R", bins=0:10:150, alpha=0.5)
histogram!(nOfKicks(halfKHalfR100), label="Half", bins=0:10:150, alpha=0.5)
title!("Number of kicks in game")
xlabel!("Kicks")

lenOfGame(allK100) |> mean
lenOfGame(allR100) |> mean
lenOfGame(halfKhalfR100) |> mean

histogram(lenOfGame(allK100), label="K", bins=0:50:1500, alpha=0.5)
histogram!(lenOfGame(allR100), label="R", bins=0:50:1500, alpha=0.5)
histogram!(lenOfGame(halfKHalfR100), label="Half", bins=0:50:1500, alpha=0.5)
title!("Length of game")
xlabel!("Rounds")


winningFreq(allK100, true)
winningFreq(allR100, true)
winningFreq(halfKhalfR100, true)
