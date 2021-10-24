using Pkg
Pkg.activate(".")
#Pkg.instantiate()

using Downloads
#pwd()
# MADNurl = "https://github.com/hannesbecher/MADN/releases/download/v1.0.0-beta2/MADN_v1.0.0-beta2.tar.gz" 
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
using Random

pushfirst!(PyVector(pyimport("sys")."path"), "")
#MADN = pyimport("MADN")

# @time [MADN.oneGame() for _ in 1:100]; # Takes about twice as long as running directly in python3

# MADN.oneGame() returns a PyDict:
#MADN.oneGame(seed=12345)
# #MADN.oneGame(tak=["k", "k", "k", "k"])


#allK = [MADN.oneGame(tak=["k", "k", "k", "k"], seed=i) for i in seedsForMADN[1:1000]];
#allR = [MADN.oneGame(tak=["r", "r", "r", "r"], seed=i) for i in seedsForMADN[1:1000]];

# Random.seed!(12345); seedsForMADN = rand(10000); allK = [MADN.oneGame(tak=["k", "k", "k", "k"], seed=i) for i in seedsForMADN];
# Random.seed!(12346); seedsForMADN = rand(10000); allR = [MADN.oneGame(tak=["r", "r", "r", "r"], seed=i) for i in seedsForMADN];
# Random.seed!(12347); seedsForMADN = rand(10000); halfKHalfR = [MADN.oneGame(tak=["r", "k", "r", "k"], seed=i) for i in seedsForMADN];
# Random.seed!(12348); seedsForMADN = rand(10000); oneKThreeR = [MADN.oneGame(tak=["k", "r", "r", "r"], seed=i) for i in seedsForMADN];
# Random.seed!(12349); seedsForMADN = rand(10000); threeKOneR = [MADN.oneGame(tak=["k", "k", "k", "r"], seed=i) for i in seedsForMADN];

# # #serialise into RESULTS/
# # # mkpath("RESULTS")
# serialize("RESULTS/allK.jls", allK)
# serialize("RESULTS/allR.jls", allR)
# serialize("RESULTS/halfKHalfR.jls", halfKHalfR)
# serialize("RESULTS/oneKThreeR.jls", oneKThreeR)
# serialize("RESULTS/threeKOneR.jls", threeKOneR)
println("Deserialising...")
allK = deserialize("RESULTS/allK.jls");
allR = deserialize("RESULTS/allR.jls");
halfKHalfR = deserialize("RESULTS/halfKHalfR.jls");
oneKThreeR = deserialize("RESULTS/oneKThreeR.jls");
threeKOneR = deserialize("RESULTS/threeKOneR.jls");
println("Done.")