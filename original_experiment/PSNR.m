function result = PSNR(mse, range)
    result = 10*log(range^2/mse);
end