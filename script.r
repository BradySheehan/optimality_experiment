# sn <- 10^10;
# mu = sn/21000;
# total = 21000;
# sig = 70000;

total = 21000;
sn <- 10000000;#10M
mu = sn/total;
sig = 80;
N = floor(rnorm(total, mu, sig));

threshold = 0.03*sn;
while(abs(sum(N) - sn) >  threshold) {
	N = floor(rnorm(total, mu, sig));
}

hist(N);
print(max(N));
print(min(N));
print(sum(N));
print(mean(N));
write(N, file="data_10000.txt", ncolumns=1);