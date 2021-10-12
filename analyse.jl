using Pkg
Pkg.activate(".")
#Pkg.instantiate()

using Downloads
#pwd()
# MADNurl = "https://github.com/hannesbecher/MADN/releases/download/v1.0.0-beta/MADN_v1.0.0-beta.tar.gz" 
# basename(MADNurl)
# Downloads.download(MADNurl, basename(MADNurl))
# run(Cmd(["tar",  "-zxvf", basename(MADNurl)]))
# readdir()



using Plots
#ENV["PYTHON"] = "/home/hbecher/miniconda3/bin/python3"
#ENV["PYTHON"] = "/Users/hannesbecher/miniconda3/bin/python3"
#Pkg.build("PyCall")
using PyCall
using StatsBase
using Statistics
using Serialization
using Printf

pushfirst!(PyVector(pyimport("sys")."path"), "")
MADN = pyimport("MADN")
# @time [MADN.oneGame() for _ in 1:100]; # Takes about twice as long as running directly in python3

# MADN.oneGame() returns a PyDict:
#MADN.oneGame()
# #MADN.oneGame(tak=["k", "k", "k", "k"])
# allK = [MADN.oneGame(tak=["k", "k", "k", "k"]) for _ in 1:10000];
# allR = [MADN.oneGame(tak=["r", "r", "r", "r"]) for _ in 1:10000];
# halfKHalfR = [MADN.oneGame(tak=["r", "k", "r", "k"]) for _ in 1:10000];
# oneKThreeR = [MADN.oneGame(tak=["k", "r", "r", "r"]) for _ in 1:10000];
# threeKOneR = [MADN.oneGame(tak=["k", "k", "k", "r"]) for _ in 1:10000];

# #serialise into RESULTS/
# # mkpath("RESULTS")
# serialize("RESULTS/allK.jls", allK)
# serialize("RESULTS/allR.jls", allR)
# serialize("RESULTS/halfKHalfR.jls", halfKHalfR)
# serialize("RESULTS/oneKThreeR.jls", oneKThreeR)
# serialize("RESULTS/threeKOneR.jls", threeKOneR)

allK = deserialize("RESULTS/allK.jls");
allR = deserialize("RESULTS/allR.jls");
halfKHalfR = deserialize("RESULTS/halfKHalfR.jls");
oneKThreeR = deserialize("RESULTS/oneKThreeR.jls");
threeKOneR = deserialize("RESULTS/threeKOneR.jls");


# keys(allK[1])
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


#cat(whoKicksWhom.(allK)..., dims=1) # blocks REPL but does not do anything?



function matVec2Arr(mv)
    a = zeros(size(mv[1])..., length(mv))
    for i in 1:length(mv)
        a[:,:,i] = mv[i]
    end
    return a
end

function kickMatMeanSdHeat(kickArr, tit="")
    meanMat = dropdims(sum(kickArr, dims=3), dims=3) ./ size(kickArr)[3]
    
    plotMat = zeros(5,5)
    plotMat[2:5, 2:5] = meanMat
    
    meanMat = vcat(sum(meanMat, dims=1), meanMat)
    meanMat = hcat(sum(meanMat, dims=2), meanMat)
    
    
    p = heatmap(plotMat)
    ylabel!("Who")
    xlabel!("Whom")
    title!(tit)
    for i in 1:size(kickArr)[1]
        for j in 1:size(kickArr)[2]
            if i != j
                annotate!((j+1, i+1.2, @sprintf("μ %.2f", meanMat[i+1,j+1])))
                annotate!((j+1, i+0.8, @sprintf("σ %.2f", std(kickArr[i, j, :]))))
            end
            
        end
        
        
        
    end
    for i in 1:5
        annotate!((1,i+0.2,  (@sprintf("μ %.2f", meanMat[i,1]), "white")))
    end
    for j in 2:5
        annotate!((j,1+0.2,  (@sprintf("μ %.2f", meanMat[1,j]), "white")))
    end
    return p
end


allKKicks = matVec2Arr(whoKicksWhom.(allK));
allRKicks = matVec2Arr(whoKicksWhom.(allR));
halfKHalfRKicks = matVec2Arr(whoKicksWhom.(halfKHalfR));
oneKThreeRKicks = matVec2Arr(whoKicksWhom.(oneKThreeR));
threeKOneRKicks = matVec2Arr(whoKicksWhom.(threeKOneR));


kickMatMeanSdHeat(allKKicks, "All kickers")
kickMatMeanSdHeat(allRKicks, "All runners")
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

a = reshape(1:16, 4, 4)
b = vcat(a, sum(a, dims=1))
c = hcat(sum(b, dims=2), b)
