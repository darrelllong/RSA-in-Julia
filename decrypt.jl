#!/usr/bin/env julia

using Getopt

include("rsa.jl")

function main()
    infile = stdin
    outfile = stdout
    privkey = open("/tmp/rsa.priv")

    for (opt, arg) in getopt(ARGS, "i:o:k:", ["infile=", "outfile=", "privkey="])
        if opt == "-i" || opt == "--infile"
            infile = open(arg, "r")
        elseif opt == "-o" || opt == "--outfile"
            outfile = open(arg, "w")
        elseif opt == "-k" || opt == "--privkey"
            privkey = open(arg, "r")
        end
    end

    # Private key: (n, d)
    n = parse(BigInt, readline(privkey))
    d = parse(BigInt, readline(privkey))

    while !eof(infile)
        c = parse(BigInt, readline(infile))
        m = decrypt(c, d, n)
        bytes = hex2bytes(string(m, base=16))
        write(outfile, bytes[2:length(bytes)])
    end

    close(infile)
    close(outfile)
    close(privkey)
end

main()
