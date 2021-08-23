using Random

# mod must always be positive

function mod(a, n)
    if (t = a % n) < 0
        n + t
    else
        t
    end
end

#=
a^b (mod n) using the method of repeated squares.

The key here is that every integer can be written as a sum of powers of 2 (binary numbers)
and that includes the exponent. By repeated squaring we get a raised to a power of 2. Also
recall that a^b * a^c = a^(b + c), so rather than adding we multiply since we are dealing
with the exponent.
=#

function powerMod(a, d, n)
    v = 1 # Value
    p = a # Powers of a
    while d > 0
        if isodd(d) # 1 bit in the exponent
           v = mod(v * p, n)
        end
        p = mod(p^2, n) # Next power of two
        d >>>= 1
    end
    v
end

#=
Greatest common divisor, Euclidean version.
=#

function gcd(a, b)
    while b ≠ 0
        a, b = b, mod(a, b)
    end
    a
end

#=
Least common multiple, necessary for Carmichael's 𝝺 function.
=#

lcm(a, b) = abs(a * b) ÷ gcd(a, b)

#=
Witness loop of the Miller-Rabin probabilistic primality test.
=#

function witness(a, n)
    u, t = n - 1, 0
    while iseven(u) # n = u * 2^t + 1
        t += 1   # Increase exponent
        u >>>= 1 # Decrease the multiplier
    end
    x = powerMod(a, u, n)
    for i in 1:t
        y = powerMod(x, 2, n)
        if y == 1 && x ≠ 1 && x ≠ n - 1
            return true
        end
        x = y
    end
    x ≠ 1
end

function isPrime(n, k)
    if n < 2 || (n ≠ 2 && iseven(n)) # 0, 1, and even except for 2 are not prime.
        return false
    elseif n < 4 # 3 is prime
        return true
    end # We must test all others
    for j in 1:k
        a = rand(2:n - 2) # Choose a random witness
        if witness(a, n)
            return false
        end
    end
    true
end

#=
We need a random prime number in [low, high] and for now a 1/4^100 chance of a composite is
good enough.
=#

function randomPrime(low, high)
    guess = 0 # Certainly not prime!
    while !isPrime(guess, 100)
        guess = rand(low:high) # Half will be even, the rest have Pr[prime] ≈ 1/log(N).
    end
    guess
end

#=
A safe prime is the one following a Sophie German prime. If prime(p) and prime(2p + 1) then
2p + 1 is a safe prime.
=#

function safePrime(low, high)
    p = randomPrime(low, high)
    while !isPrime(2 * p + 1,100)
        p = randomPrime(low, high)
    end
    return 2 * p + 1
end

#=
Multiplicative inverse of a (mod n), using Bézout's identity.
=#

function inverse(a, n)
    r, rP = n, a
    t, tP = 0, 1
    while rP ≠ 0
        q = r ÷ rP
        r, rP = rP, r - q * rP
        t, tP = tP, t - q * tP
    end
    if r > 1
        return "no inverse"
    end
    if t < 0
        t + n
    else
        t
    end
end

#=
An RSA key is a triple (e, d, n):
    e is the public exponent
    d is the private exponent
    n is the modulus
=#

function makeKey(bits)
    size = bits ÷ 2
    low  = big"2"^(size - 1) # Assure the primes are each approximately half of the
    high = big"2"^size - 1   # bits in the modulus.
    p = safePrime(low, high)
    q = safePrime(low, high)
    𝝺 = lcm(p - 1, q - 1) # Carmichael 𝝺(n) = lcm(𝝺(p), 𝝺(q)) = lcm(p - 1, q - 1)
    e = 2^16 + 1          # Default public exponent
    while gcd(e, 𝝺) ≠ 1   # Happens only if we are very unlucky
        e = randomPrime(low, high)
    end
    d = inverse(e, 𝝺) # Private key
    n = p * q         # Modulus
    (e, d, n)
end

encrypt(m, e, n) = powerMod(m, e, n)
decrypt(c, d, n) = powerMod(c, d, n)
