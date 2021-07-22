#t-test example
x1 <- rnorm(1000, mean = 1, sd = 0.99)
x2 <- rnorm(1000, mean = -1, sd = 1.01)

hist(x1)
hist(x2)

t.test(x1, x2)

#results
# data:  x1 and x2
# t = 44.331, df = 1996.2, p-value < 2.2e-16
# alternative hypothesis: true difference in means is not equal to 0
# 95 percent confidence interval:
#   1.907971 2.084599
# sample estimates:
#   mean of x  mean of y 
# 1.0210487 -0.9752365 