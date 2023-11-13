# Advanced-Computer-Vision
## Keypoint Detectors, Feature Descriptores and Applicattions

This project involves the introduction of more efficient keypoint detectors and features detectors, employing them for feature-based homography estimation to stitch together panoramas from multiple images. This project is divided into two parts: the first part consists of the study of several detectors and descriptors, while the second part involves the analysis of descriptors to build a panorama from multiple images.

In the first part of this project, the following techniques were employed: SIFT (Scale-Invariant Features Transform), SURF (Speed Up Robust Features), KAZE, ORB (Oriented Fast and Rotated BRIEF), BRISK (Binary Robust Invariant Scalable Keypoints), FAST (Features from Accelerated Segment Test), AGAST (Adaptive and Generic Accelerated Segment Test), BRIEF (Binary Robust Independent Elementary Features), and FREAK (Fast Retina Keypoint).

For the construction of the panorama, the following techniques were used: ORB to determine keypoints and corresponding points, and RANSAC.

## Age and Gender Estimation from Face Imagery

This second project consists of the analysis of facial images with the aim of determining the age and gender of a person. This project is composed of two parts. The first part involves preparing the dataset, extracting the labels and images to be tested, and analyzing the facial representation using Eigenfaces and Fisherfaces techniques. The second part of the work involves determining a person’s age and gender using SVM classifiers, one for each element to be evaluated, as well as using CNNs.  
