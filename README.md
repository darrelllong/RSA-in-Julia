# RSA in Julia

A simple implementation of RSA in the Julia language.

Originally written for the students at the University of California, Santa Cruz.

The implementation uses *safe primes* for *p* and *q*. This can be
a little slow, but you do not need to do this more than once.

```
@misc{cryptoeprint:2001:007,
    author       = {Ronald Rivest and Robert Silverman},
    title        = {Are 'Strong' Primes Needed for {RSA}?},
    howpublished = {Cryptology ePrint Archive, Report 2001/007},
    year         = {2001},
    note         = {\url{https://ia.cr/2001/007}},
}
```

# Usage

There are 3 main programs that interface with the RSA library:
1. `keygen.jl`
2. `encrypt.jl`
3. `decrypt.jl`

## Generating a new keypair

By default, `keygen.jl` creates a new 2048-bit public key as `/tmp/rsa.pub` and a
private key as `/tmp/rsa.priv`.

```
$ ./keygen.jl [-b bits] [-e pubkey] [-d privkey]
```

## Encrypting a file

`encrypt.jl` encrypts a specified input file, writing the encrypted contents to a
specified output file. By default, `encrypt.jl` uses `/tmp/rsa.pub` as the public
key, reads from `stdin` and writes to `stdout`.

```
$ ./encrypt.jl [-k pubkey] [-i infile] [-o outfile]
```

## Decrypting a file

`decrypt.jl` decrypts a specified input file, writing the decrypted contents to a
specified output file. By default, `decrypt.jl` uses `/tmp/rsa.priv` as the private
key, reads from `stdin` and writes to `stdout`.

```
$ ./decrypt.jl [-k pubkey] [-i infile] [-o outfile]
```

# Using the library interactively

A simple program, `rsa-interactive.jl`, is supplied to encrypt and decrypt
  strings interactively.

```
$ ./rsa-interactive.jl
How many bits? 128
e = 65537
d = 6461515747311439153622520953113725473
n = 149056092056159728222654887328287483533
>> Hi, Buckaroos!
En[Hi, Buckaroos!] = 144797609806694200858786780738786404614
De[144797609806694200858786780738786404614] = Hi, Buckaroos!
>> ^D
```
