#!/usr/bin/env julia

using Getopt

include("rsa.jl")

function main()
    bits = 2048
    pubfile = open("/tmp/rsa.pub", "w")
    privfile = open("/tmp/rsa.priv", "w")

    for (opt, arg) in getopt(ARGS, "b:e:d:", ["bits=", "pubfile=", "privfile="])
        if opt == "-b" || opt == "--bits"
            bits = parse(UInt64, arg)
        elseif opt == "-e" || opt == "--pubfile"
            pubfile = open(arg, "w")
        elseif opt == "-d" || opt == "--privfile"
            privfile = open(arg, "w")
        end
    end

    (e, d, n) = makeKey(bits);

    # Public key: (n , e)
    println(pubfile, n)
    println(pubfile, e)

    # Private key: (n, d)
    println(privfile, n)
    println(privfile, d)

    close(pubfile)
    close(privfile)
end

main()
