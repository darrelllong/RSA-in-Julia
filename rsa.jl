using Random

odd(n) = n % 2 == 1; even(n) = n % 2 == 0

#=
a^b (mod n) using the method of repeated squares.
=#

function powerMod(a, d, n)
    v = 1
    p = a
    while d > 0
        if odd(d)
           v = (v * p) % n
        end
        p = p^2 % n
        d >>>= 1
    end
    return v
end

#=
Greatest common divisor, Euclidean version.
=#

function gcd(a, b)
    while b ≠ 0
        t = b
        b = a % b
        a = t
    end
    return a
end

#=
Least common multiple, necessary for Carmichael's 𝝺 function.
=#

lcm(a, b) = abs(a * b) ÷ gcd(a, b)

#=
Witness loop of the Miller-Rabin probablistic primarlity test.
=#

function witness(a, n)
    u = n - 1
    t = 0
    while even(u)
        t += 1
        u >>>= 1
    end
    x = powerMod(a, u, n)
    for i in 1:t
        y = powerMod(x, 2, n)
        if y == 1 && x ≠ 1 && x ≠ n - 1
            return true
        end
        x = y
    end
    return x ≠ 1
end

function isPrime(n, k)
    if n < 2 || (n ≠ 2 && even(n))
        return false
    end
    if n < 4
        return true
    end
    for j in 1:k
        a = rand(2:n - 2)
        if witness(a, n)
            return false
        end
    end
    return true
end

#=
Multiplicative inverse of a (mod n), using Bézout's identity.
=#

function inverse(a, n)
    (r, rP) = (n, a)
    (t, tP) = (0, 1)
    while rP != 0
        q = r ÷ rP
        (r, rP) = (rP, r - q * rP)
        (t, tP) = (tP, t - q * tP)
    end
    if r > 1
        return "no inverse"
    end
    if t < 0
        t = t + n
    end
    return t
end

#=
We need a random prime number in [low, high] and for now a 1/4^100 chance of a composite is
good enough.
=#

function randomPrime(low, high)
    guess = 0   # Certainly not prime!
    while !isPrime(guess, 100)
        guess = rand(low:high)  # Half will be even, the rest have Pr[prime] ≈ 1/log(N).
    end
    return guess
end

#=
An RSA key is a triple (e, d, n):

    e is the public exponent
    d is the private exponent
    n is the modulus
=#

function makeKey(bits)
    size = bits ÷ 2
    low  = big"2"^(size - 1)    # Assure the primes are each approximately half of the
    high = big"2"^(size + 1)    # bits in the modulus.
    p = randomPrime(low, high)
    q = randomPrime(low, high)
    𝝺 = lcm(p - 1, q - 1)   # Carmichael 𝝺(n) = lcm(𝝺(p), 𝝺(q)) = lcm(p - 1, q - 1)
    e = 2^16 + 1            # A good default public exponent
    while gcd(e, 𝝺) ≠ 1     # Happens if we are very unlucky
        e = randomPrime(low, high)
    end
    d = inverse(e, 𝝺)   # The private key
    n = p * q           # The modulus
    return (e, d, n)
end

#=
Transform a string into a BigInt, add in 0xAA to avoid unpleasantness. Proper PKCS
padding will have to wait for now.
=#

function encode(s)
    sum = BigInt(0)
    pow = BigInt(1)
    for i in firstindex(s):lastindex(s)
        sum += pow * (0xAA ⊻ BigInt(s[i]))
        pow *= 256
    end
    return sum
end

#=
Transform a BigInt back into a string, subtracting off the 0xAA.
=#

function decode(n)
    s = ""
    while n > 0
        s = string(s, Char(0xAA ⊻ (n % 256)))
        n ÷= 256
    end
    return s
end

#=
Accepts a string and returns a BigInt.
=#

encrypt(m, e, n) = powerMod(encode(m), e, n)

#=
Accepts a BigInt and returns a string.
=#

decrypt(c, d, n) = decode(powerMod(c, d, n))
