# code scraps for testing MADN.jl

using Pkg
Pkg.activate(".")
#Pkg.instantiate()
using Revise
#Pkg.develop(path=expanduser("~/Code/MADN.jl/"))
#Pkg.develop(path=expanduser("~/git_repos/MADN.jl/"))
using MADN
using BenchmarkTools

a = setupGame(4);
typeof(a)
whoOnBf(a, 45)
print(a)
swapPieces!(a, 44,1)
swapPieces!(a, 48,2)
moveAndKick(a, 1, 2)

# @benchmark oneTurn!(a)
iOnBf(a, 41)
otherOnBf(a, 41)
otherOnBf(a, 39)
whoOnBf(a, 45)
otherOnBf(a, 45)
isStartField(a, 41)
isStartField(a, 31)
MADN.playerPiecePositions(a, 5)
piecePositionStruct(a,1)
piecePositionStruct(a,2)
piecePositionStruct(a,3)
piecePositionStruct(a,4)
b = myPiecePositionStruct(a)
Revise.errors()
kickBackToWhere(a, 1)
startFromWhere(a, 1)
startFromWhere(a, 2)
playerOnBF(a, 2)
a
iOnBf.(a, [2, 3, 4])
otherOnBF(a, 46)
whoseTurn(a)
kickOut(a, 1)



44 % 4
mod1(45, 4)
bf2pf(40, 4)
bf2pf.(57:60, 1)
bf2pf.(57:60,1)

print(a)
swapPieces!(a, 6, 42)
swapPieces!(a, 61, 47)
swapPieces!(a, 63, 45)
swapPieces!(a, 57, 59)
gapsInGoal(a, 1)
gapsInGoal(a, 2)
gapsInGoal(a, 3)

hasPlFinished(a, 2)
hasPlFinished(a, 1)
mod1(4+1, 4)
rollAndMove!(a)
pf2bf.([0, 45, 46], 1)
pf2bf(43,1)
bf2pf.(collect(40:-1:1),1)

(!).(isnothing.([nothing, nothing, 1]))


all(x -> x==true, [1,0,0])
any(x -> x==true, [1,0,0])

fill(1, size(c))

print(a)
@benchmark swapPieces!(a, 1, 44)
swapPieces!(a, 7, 43)
swapPieces!(a, 57, 42)
#@benchmark rollAndMove!(a)
rollAndMove!(a)

a1 = [1,2,3,4];
@benchmark a1 + [4,3,2,1]
@benchmark(a1 .+= [4,3,2,1])


