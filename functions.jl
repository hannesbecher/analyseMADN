
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

function finishingTurns(madnList)
    return madnList["finishingTurns"]
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
    xticks!([1,2,3,4,5],["Total", "1", "2", "3", "4"])
    yticks!([1,2,3,4,5],["Total", "1", "2", "3", "4"])
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

function whoFieldWho(madnDict, who)
    a = zip(madnDict["kickingWho"], madnDict["whoField"])
    return [i[2] for i in a if i[1] == who]
end

function whomFieldWhom(madnDict, whom)
    a = zip(madnDict["kickingWhom"], madnDict["whomField"])
    return [i[2] for i in a if i[1] == whom]
end