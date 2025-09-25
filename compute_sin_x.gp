\pb64   \\ set n significant digits / bits \p n, \pb n

num=2^32
parfor(k = 1, num, print(sin(Pi/2/k))) \\并行计算num个sin(x)的值

\quit