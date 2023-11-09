close all; clear; clc;

%load previously saved data
load("..\..\Data\Extracted_points_info.mat")

%Read homography matrixes
H1=readmatrix("../../graf/H1to2p.txt");
H2=readmatrix("../../graf/H1to4p.txt");

%Read the first image 
Image = imread(Image_paths(1));
Image = rgb2gray(Image);
Image = im2double(Image);

splited_name = strsplit(Image_names(1),'.');
img_name = splited_name(1);

name_format = sprintf("../../Data/%s_points.mat",img_name);
load(name_format);

%Define BRIEF parameters
BRIEF_N_pairs = 512;
BRIEF_patch_size = 31;
flag_method = 2;
%Create the BRIEF pattern to be used
BRIEF_Pattern = create_BRIEF_pattern(flag_method, BRIEF_patch_size, BRIEF_N_pairs);

%Get all the descriptores for the first image
[SIFT_descriptors_img1, vp_img1_SIFT] = extractFeatures(Image,SIFT_points,"Method","SIFT");
[SURF_descriptors_img1, vp_img1_SURF] = extractFeatures(Image,SURF_points,"Method","SURF");
[BRISK_descriptors_FAST_img1, vp_img1_FAST_BRISK] = extractFeatures(Image,FAST_points,"Method","BRISK");
[FREAK_descriptors_FAST_img1, vp_img1_FAST_FREAK] = extractFeatures(Image,FAST_points,"Method","FREAK");
[BRIEF_descriptors_FAST_img1, vp_img1_FAST_BRIEF]= extract_BRIEF_features(FAST_points, 0, BRIEF_Pattern, Image, BRIEF_patch_size, BRIEF_N_pairs);
[KAZE_descriptors_img1, vp_img1_KAZE] = extractFeatures(Image,KAZE_points,"Method","KAZE");
[ORB_descriptors_img1, vp_img1_ORB] = extractFeatures(Image,ORB_points,"Method","ORB");
[BRISK_descriptors_img1, vp_img1_BRISK] = extractFeatures(Image,BRISK_points,"Method","BRISK");

%Get all the descriptores for the other images and do the matching
for i = 2:length(Image_names)   
    Image_2 = imread(Image_paths(i));
    Image_2 = rgb2gray(Image_2);
    Image_2 = im2double(Image_2);
    
    splited_name = strsplit(Image_names(i),'.');
    img_name = splited_name(1);
    name_format = sprintf("../../Data/%s_points.mat",img_name);
    load(name_format)
    
    %Get all the descriptores for the current image
    [SIFT_descriptors_img2, vp_img2_SIFT] = extractFeatures(Image_2,SIFT_points,"Method","SIFT");
    [SURF_descriptors_img2, vp_img2_SURF] = extractFeatures(Image_2,SURF_points,"Method","SURF");
    [BRISK_descriptors_FAST_img2, vp_img2_FAST_BRISK] = extractFeatures(Image_2,FAST_points,"Method","BRISK");
    [FREAK_descriptors_FAST_img2, vp_img2_FAST_FREAK] = extractFeatures(Image_2,FAST_points,"Method","FREAK");
    [BRIEF_descriptors_FAST_img2, vp_img2_FAST_BRIEF]= extract_BRIEF_features(FAST_points, 0, BRIEF_Pattern, Image_2, BRIEF_patch_size, BRIEF_N_pairs);
    [KAZE_descriptors_img2, vp_img2_KAZE] = extractFeatures(Image_2,KAZE_points,"Method","KAZE");
    [ORB_descriptors_img2, vp_img2_ORB] = extractFeatures(Image_2,ORB_points,"Method","ORB");
    [BRISK_descriptors_img2, vp_img2_BRISK] = extractFeatures(Image_2,BRISK_points,"Method","BRISK");

    %Matching the descriptors of the first image with the ones from the
    %current image
    [indexPairs_SIFT,matchmetric_SIFT] = matchFeatures(SIFT_descriptors_img1,SIFT_descriptors_img2, "MatchThreshold", 20, "MaxRatio", 0.3);
    [indexPairs_SURF,matchmetric_SURF] = matchFeatures(SURF_descriptors_img1,SURF_descriptors_img2, "MatchThreshold", 20, "MaxRatio", 0.3);
    [indexPairs_FAST_BRISK,matchmetric_FAST_BRISK] = matchFeatures(BRISK_descriptors_FAST_img1,BRISK_descriptors_FAST_img2, "MatchThreshold", 20, "MaxRatio", 0.3);
    [indexPairs_FAST_FREAK,matchmetric_FAST_FREAK] = matchFeatures(FREAK_descriptors_FAST_img1,FREAK_descriptors_FAST_img2, "MatchThreshold", 20, "MaxRatio", 0.5);
    [indexPairs_FAST_BRIEF,matchmetric_FAST_BRIEF] = matchFeatures(BRIEF_descriptors_FAST_img1,BRIEF_descriptors_FAST_img2, "MatchThreshold", 20, "MaxRatio", 0.65);
    [indexPairs_KAZE,matchmetric_KAZE] = matchFeatures(KAZE_descriptors_img1,KAZE_descriptors_img2, "MatchThreshold", 20, "MaxRatio", 0.3);
    [indexPairs_ORB,matchmetric_ORB] = matchFeatures(ORB_descriptors_img1,ORB_descriptors_img2, "MatchThreshold", 20, "MaxRatio", 0.3);
    [indexPairs_BRISK,matchmetric_BRISK] = matchFeatures(BRISK_descriptors_img1,BRISK_descriptors_img2, "MatchThreshold", 20, "MaxRatio", 0.3);
    
    %Calculate the metrics and show matches
    SIFT_fig = figure;
    [Accuracy_SIFT, Precision_SIFT, Recall_SIFT] = Show_metrics(Image,Image_2, vp_img1_SIFT,vp_img2_SIFT, indexPairs_SIFT, H1, 30);
    title("SIFT detector and descriptor")
    SURF_fig = figure;
    [Accuracy_SURF, Precision_SURF, Recall_SURF] = Show_metrics(Image,Image_2, vp_img1_SURF,vp_img2_SURF, indexPairs_SURF, H1, 30);
    title("SURF detector and descriptor")
    FAST_BRIEF_fig = figure;
    [Accuracy_FAST_BRIEF, Precision_FAST_BRIEF, Recall_FAST_BRIEF] = Show_metrics(Image,Image_2, vp_img1_FAST_BRIEF,vp_img2_FAST_BRIEF, indexPairs_FAST_BRIEF, H1, 30);
    title("FAST detector + BRIEF descriptor")
    FAST_BRISK_fig = figure;
    [Accuracy_FAST_BRISK, Precision_FAST_BRISK, Recall_FAST_BRISK] = Show_metrics(Image,Image_2, vp_img1_FAST_BRISK,vp_img2_FAST_BRISK, indexPairs_FAST_BRISK, H1, 30);
    title("FAST detector + BRISK descriptor")
    FAST_FREAK_fig = figure;
    [Accuracy_FAST_FREAK, Precision_FAST_FREAK, Recall_FAST_FREAK] = Show_metrics(Image,Image_2, vp_img1_FAST_FREAK,vp_img2_FAST_FREAK, indexPairs_FAST_FREAK, H1, 30);
    title("FAST detector + FREAK descriptor")
    KAZE_fig = figure;
    [Accuracy_KAZE, Precision_KAZE, Recall_KAZE] = Show_metrics(Image,Image_2, vp_img1_KAZE,vp_img2_KAZE, indexPairs_KAZE, H1, 30);
    title("KAZE detector and descriptor")
    ORB_fig = figure;
    [Accuracy_ORB, Precision_ORB, Recall_ORB] = Show_metrics(Image,Image_2, vp_img1_ORB,vp_img2_ORB, indexPairs_ORB, H1, 30);
    title("ORB detector and descriptor")
    BRISK_fig = figure;
    [Accuracy_BRISK, Precision_BRISK, Recall_BRISK] = Show_metrics(Image,Image_2, vp_img1_BRISK,vp_img2_BRISK, indexPairs_BRISK, H1, 30);
    title("BRISK detector and descriptor")
    
    %Print results
    fprintf("Image 1-%d\n", i);
    fprintf("SIFT: Accuracy: %.3f Precision: %.3f Recall: %.3f -  Matched points: %d\n", Accuracy_SIFT, Precision_SIFT, Recall_SIFT, length(indexPairs_SIFT));
    fprintf("SURF: Accuracy: %.3f Precision: %.3f Recall: %.3f -  Matched points: %d\n", Accuracy_SURF, Precision_SURF, Recall_SURF, length(indexPairs_SURF));
    fprintf("FAST + BRIEF: Accuracy: %.3f Precision: %.3f Recall: %.3f -  Matched points: %d\n", Accuracy_FAST_BRIEF, Precision_FAST_BRIEF, Recall_FAST_BRIEF, length(indexPairs_FAST_BRIEF));
    fprintf("FAST + BRISK: Accuracy: %.3f Precision: %.3f Recall: %.3f -  Matched points: %d\n", Accuracy_FAST_BRISK, Precision_FAST_BRISK, Recall_FAST_BRISK, length(indexPairs_FAST_BRISK));
    fprintf("FAST + FREAK: Accuracy: %.3f Precision: %.3f Recall: %.3f -  Matched points: %d\n", Accuracy_FAST_FREAK, Precision_FAST_FREAK, Recall_FAST_FREAK, length(indexPairs_FAST_FREAK));
    fprintf("KAZE: Accuracy: %.3f Precision: %.3f Recall: %.3f -  Matched points: %d\n", Accuracy_KAZE, Precision_KAZE, Recall_KAZE, length(indexPairs_KAZE));
    fprintf("ORB: Accuracy: %.3f Precision: %.3f Recall: %.3f -  Matched points: %d\n", Accuracy_ORB, Precision_ORB, Recall_ORB, length(indexPairs_ORB));
    fprintf("BRISK: Accuracy: %.3f Precision: %.3f Recall: %.3f  - Matched points: %d\n\n ", Accuracy_BRISK, Precision_BRISK, Recall_BRISK, length(indexPairs_BRISK));
    
    %Save all the images for later comparation
    save_name = sprintf("..\\..\\Results\\Evaluation\\SIFT_%s.png", img_name);
    saveas(SIFT_fig,save_name);
    save_name = sprintf("..\\..\\Results\\Evaluation\\SURF_%s.png", img_name);
    saveas(SURF_fig,save_name);
    save_name = sprintf("..\\..\\Results\\Evaluation\\FAST_BRIEF_%s.png", img_name);
    saveas(FAST_BRIEF_fig,save_name);
    save_name = sprintf("..\\..\\Results\\Evaluation\\FAST_BRISK_%s.png", img_name);
    saveas(FAST_BRISK_fig,save_name);
    save_name = sprintf("..\\..\\Results\\Evaluation\\FAST_FREAK_%s.png", img_name);
    saveas(FAST_FREAK_fig,save_name);
    save_name = sprintf("..\\..\\Results\\Evaluation\\KAZE_%s.png", img_name);
    saveas(KAZE_fig,save_name);
    save_name = sprintf("..\\..\\Results\\Evaluation\\ORB_%s.png", img_name);
    saveas(ORB_fig,save_name);
    save_name = sprintf("..\\..\\Results\\Evaluation\\BRISK_%s.png", img_name);
    saveas(BRISK_fig,save_name);
end

