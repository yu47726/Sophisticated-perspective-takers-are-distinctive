This repository hosts all of the data and code for "Sophisticated perspective-takers are distinctive: neural idiosyncrasy of functional connectivity in the mentalizing network" by Yu Zhang, Chao Ma, Haiming Li, Leonardo Assumpção, Yi Liu

## Data files
PT_fMRI.csv: Perspective-taking scores of 55 fMRI participants.

PT_Rest.csv: Perspective-taking scores of 52 participants who underwent a resting-state fMRI scan.

PT_EyeMove.csv: Perspective-taking scores of 41 participants in the eye movement experiment.

PT_Verbal.csv: Perspective-taking scores of 91 participants in the verbal interpretation analyses.

NetworkBoldData.mat: Data containing the preprocessed time series extracted from regions in the mentalizing network and pain network.

RestBoldData.mat: Data containing the preprocessed time series extracted from regions in the mentalizing network during resting-state.

EyeMoveData.mat: Data containing the preprocessed eye-gaze trajectory data.

TextDissimilarity_matrix.mat: Data containing matrix for the inter-subject dissimilarity of the verbal interpretation.

## Scripts files
TimeDynamic.m: Calculation of inter-subject dissimilarity of time dynamics.
FunctionalConnectivity.m: Calculation of inter-subject dissimilarity of the global functional connectivity.
StrengthCentrlity.m: Calculation of inter-subject dissimilarity of the global strength centrality.
EyeMove.m: Calculation of inter-subject dissimilarity of eye-gaze trajectories.
NetworkEuclidean.R: Comparisons of the inter-subject dissimilarity of the global functional connectivity between different dyad groups using linear mixed-effects models in R.

