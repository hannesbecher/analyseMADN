# code scraps for testing MADN.jl

using Pkg
using Revise
#Pkg.develop(path=expanduser("~/Code/MADN.jl/"))
using MADN
using BenchmarkTools

a = setupGame(4);
whoOnBf(a, 45)
printGameState(a)



# @benchmark oneTurn!(a)
iOnBf(a, 41)
otherOnBf(a, 41)
otherOnBf(a, 39)
whoOnBf(a, 45)
otherOnBf(a, 45)
isStartField(a, 41)
MADN.playerPiecePositions(a, 5)
myPiecePositionDict(a)