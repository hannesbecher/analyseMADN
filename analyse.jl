using Pkg
Pkg.activate(".")
using Plots
using PyCall
using StatsBase
using Statistics
#ENV["PYTHON"] = "/Users/hannesbecher/miniconda3/bin/python3"
#Pkg.build("PyCall")
cd("..")
pushfirst!(PyVector(pyimport("sys")."path"), "")
#cd() to correct dir
MADN = pyimport("MADN")
@time [MADN.oneGame() for _ in 1:100]; # Takes about twice as long as running directly in python3

allK100 = [MADN.oneGame(tak=["k", "k", "k", "k"]) for _ in 1:100]
allR100 = [MADN.oneGame(tak=["r", "r", "r", "r"]) for _ in 1:100]
halfKhalfR100 = [MADN.oneGame(tak=["r", "k", "r", "k"]) for _ in 1:100]

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

function winningFreq(madnList, rel=false)
    a = map(x -> x["finishingOrder"][1], madnList)
    l = ifelse(rel, length(a), 1)
    Dict(i => sum(a.==i)/l for i in 1:4)
end

winningFreq(allK100, rel=true)
winningFreq(allR100, rel=true)
winningFreq(halfKhalfR100, rel=true)

nOfKicks(allK100) |> mean
nOfKicks(allR100) |> mean
nOfKicks(halfKhalfR100) |> mean


lenOfGame(allK100) |> mean
lenOfGame(allR100) |> mean
lenOfGame(halfKhalfR100) |> mean


winningFreq(allK100, true)
winningFreq(allR100, true)
winningFreq(halfKhalfR100, true)
