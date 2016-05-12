# optimality_experiment

Work toward reproducing Levin and Nadler's experiment from "Natural image denoising: Optimality and inherent bounds" for bounding patch based curvature denoising algorithms with respect to mean squared error.


* Curvature Directory:
  
  Core functions for performing Levin and Nadler's experiment for bounding the curvature of the level lines of an image with respect to  minimum mean squared error.
  
  - pre_process_and_sample_curv.m
  - vect_mmmse_curv.m
  - sample_n_patches_curv.m
  - IterativeCurvatureMinEpsilon.m
  - laplace_dist.m

  
* Natural_Image Directory:

  Core functions for reproducing the experiment performed by Levin and Nadler on natural images.
  
  - vect_mmse.m: main function that computes the MMSE_U and MMSE_L boud for natural images.
  - sample_n_patches.m: helper function that takes in an image and a number of patches and randomly samples n patches from that image.
  - pre_process_and_sample.m: a function for generate the set of M image patches for a given experiment.
  - gaus_dist.m: function that computes the probability of seeing a noisy M image patch given some clean N image patch (this function does it in blocks and reads in a single M but multiple N patches). 
 

* Sampling_Code Directory:

  R code that fits a Normal distribution to the number of patches to be sampled from each image according to the number of images and the desired number of total patches.
  
  - script.r
  - Rplots.pdf
  - data.txt
  
* Utilities Directory:

  Code that is used in conjunction with the Curvature Directory code and the Natural_Image Directory code. 
  
  - get_all_files.m: a function for getting a list of files from a specified directory.
  - find_center.m: a function that returns a vector of center pixels given a matrix of patches and the patch size
  - b_paramater_estimates.m: a function for empirically selecting the b paramater in the double exponential distribution according to a number of images in the directory.
  - preprocess_data.m: a function for generating a preprocessed image directory, a preprocessed clean curvature directory, and a preprocessed noisy curvature directory.
