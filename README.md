# RSA in Julia
A simple implementation of RSA in the Julia language.

My first Julia program, while waiting for a Julia book to arrive, so it it not (yet)
idiomatic Julia.

This is just a demonstration. A truly secure version is much more careful
with its selection of *p* and *q* to avoid known attacks.

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
