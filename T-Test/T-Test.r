#t-test example
x1 <- rnorm(1000, mean = 1, sd = 0.99)
x2 <- rnorm(1000, mean = -1, sd = 1.01)

hist(x1)
hist(x2)

t.test(x1, x2)
