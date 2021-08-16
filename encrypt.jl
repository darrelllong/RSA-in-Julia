#!/usr/bin/env julia

using Getopt

include("rsa.jl")

function main()
    infile = stdin
    outfile = stdout
    pubkey = open("/tmp/rsa.pub")

    for (opt, arg) in getopt(ARGS, "i:o:k:", ["infile=", "outfile=", "pubkey="])
        if opt == "-i" || opt == "--infile"
            infile = open(arg, "r")
        elseif opt == "-o" || opt == "--outfile"
            outfile = open(arg, "w")
        elseif opt == "-k" || opt == "--pubkey"
            pubkey = open(arg, "r")
        end
    end

    # Public key: (n, e)
    n = parse(BigInt, readline(pubkey))
    e = parse(BigInt, readline(pubkey))

    block = (floor(UInt64, log2(n)) - 1) ÷ 8
    while !eof(infile)
        bytes = prepend!(read(infile, block - 1), [0xFF])
        m = parse(BigInt, "0x" * bytes2hex(bytes))
        c = encrypt(m, e, n)
        println(outfile, c)
    end

    close(infile)
    close(outfile)
    close(pubkey)
end

main()
