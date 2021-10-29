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
whoOnBf(a, 45)
printGameState(a)
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
iOnBF(a, 2)
otherOnBF(a, 46)
whoseTurn(a)
kickOut(a, 1)



44 % 4
mod1(45, 4)
bf2pf(40, 4)
bf2pf.(57:60, 3)
bf2pf.(57:60,1)