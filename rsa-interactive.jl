#!/usr/bin/env julia

include("rsa.jl")

#=
Transform a string into a BigInt, add in 0xAA to avoid unpleasantness. Proper PKCS
padding will have to wait for now. We treat it as a base-256 integer and just pull
off the digits.
=#

function str2bigint(s)
    sum::BigInt = 0
    pow::BigInt = 1
    for c in s
        sum += pow * (0xAA ⊻ BigInt(c))
        pow *= 256
    end
    sum
end

#=
Transform a BigInt back into a string, subtracting off the 0xAA. We treat it as a base-256
integer and just pull off the digits.
=#

function bigint2str(n)
    s = ""
    while n > 0
        s = s * Char(0xAA ⊻ (n % 256))
        n ÷= 256
    end
    s
end

print("How many bits? ")

bits = parse(Int64, readline())

(e, d, n) = makeKey(bits);

println("e = $e")
println("d = $d")
println("n = $n")

print(">> ")
for m in eachline()
    c = encrypt(str2bigint(m), e, n); println("En[$m] = $c")
    t = bigint2str(decrypt(c, d, n)); println("De[$c] = $t")
    print(">> ")
end
