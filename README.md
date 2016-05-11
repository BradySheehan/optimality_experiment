# optimality_experiment

Work toward reproducing levin and nadler's experiment from "Natural image denoising: Optimality and inherent bounds" for bounding patch based curvature denoising algorithms.


Curvature Directory:
  
  Core functions for performing Levin and Nadler's experiment for bounding the curvature of the level lines of an image with respect to  minimum mean squared error.
  
Natural_Image Directory:

  Core functions for reproducing the experiment performed by Levin and Nadler on natural images.
  
Sampling Directory:

  R code that fits a Normal distribution to the number of patches to be sampled from each image according to the number of images and the desired number of total patches.
  
Utilities Directory:

  Code that is used in conjunction with the Curvature Directory code and the Natural_Image Directory code. 
  
  get_all_files.m - a function for getting a list of files from a specified directory.
  find_center.m - a function that returns a vector of center pixels given a matrix of patches and the patch size

Data Directory:
	
	images.zip - the original, unprocessed, images used in the experiments.
	processed_images.zip - original images after downsampling by two and low-pass filtering with a Gaussian filter.
	curvature_images_clean.zip - the curvature of the level lines of the processed_images.
	curvature_images_noisy.zip - the curvature of the level lines of the processed_images after adding random Gaussian noise with standard deviation 18. 