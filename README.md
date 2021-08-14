# RSA in Julia
A simple implementation of RSA in the Julia language.

Originally written for the students of CSE 13S at the University of California, Santa Cruz.

This is just a demonstration. A truly secure version is much more careful
with its selection of *p* and *q* to avoid known attacks.

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

```
(e, d, n) = makeKey(bits)

c = encrypt("string", e, n)

m = decrypt(c, d, n)
```

Running it on the command line executes interactively to encrypt and decrypt strings.

```
manet :: ~/RSA-in-Julia » ./rsa.jl
How many bits? 128
e = 65537
d = 6461515747311439153622520953113725473
n = 149056092056159728222654887328287483533
>> Hi, Buckaroos!
En[Hi, Buckaroos!] = 144797609806694200858786780738786404614
De[144797609806694200858786780738786404614] = Hi, Buckaroos!
>> ^D
```
