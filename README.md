This repository hosts all of the data and code for "Sophisticated perspective-takers are distinctive: neural idiosyncrasy of functional connectivity in the mentalizing network" by Yu Zhang, Chao Ma, Haiming Li, Leonardo Assumpção, Yi Liu

## Data files
PT_fmri.csv: Perspective-taking scores of fMRI participants.
PT_EyeMove.csv: Perspective-taking scores of participants in the eye movement experiment.
NetworkBoldData.mat: Data containing the preprocessed time series extracted from regions in the mentalizing network and pain network.
EyeMoveData.mat: Data containing the preprocessed eye-gaze trajectory data.

## Scripts files
TimeDynamic.m: Calculation of inter-subject dissimilarity of time dynamics.
FunctionalConnectivity.m: Calculation of inter-subject dissimilarity of the global functional connectivity.
StrengthCentrlity.m: Calculation of inter-subject dissimilarity of the global strength centrality.
EyeMove.m: Calculation of inter-subject dissimilarity of eye-gaze trajectories and results.
NetworkEuclidean.R: Comparisons of the inter-subject dissimilarity between different dyad groups using linear mixed-effects models in R.