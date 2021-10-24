# code scraps for testing MADN.jl

using Pkg
using Revise
Pkg.develop(path=expanduser("~/Code/MADN.jl/"))
using MADN


a = setupGame(4)
whoOnBf(a, 45)
printGameState(a)
oneTurn!(a, print=true)
iOnBf(a, 41)
otherOnBf(a, 41)
otherOnBf(a, 39)
whoOnBf(a, 45)
otherOnBf(a, 45)
isStartField(a, 41)
myPiecePositions(a)
myPiecePositionDict(a)