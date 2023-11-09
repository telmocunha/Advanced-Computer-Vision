close all; clear; clc;

%Inicial parameters
BRIEF_N_pairs = 128;
BRIEF_patch_size = 41;

%Get all the patterns to be used
BRIEF_Pattern_1 = create_BRIEF_pattern(1, BRIEF_patch_size, BRIEF_N_pairs);
BRIEF_Pattern_2 = create_BRIEF_pattern(2, BRIEF_patch_size, BRIEF_N_pairs);
BRIEF_Pattern_3 = create_BRIEF_pattern(3, BRIEF_patch_size, BRIEF_N_pairs);
BRIEF_Pattern_4 = create_BRIEF_pattern(4, BRIEF_patch_size, BRIEF_N_pairs);
BRIEF_Pattern_5 = create_BRIEF_pattern(5, BRIEF_patch_size, BRIEF_N_pairs);

%Load points
load("..\..\Data\Extracted_points_info.mat")

%load homography matrixes
H1=readmatrix("../../graf/H1to2p.txt");
H2=readmatrix("../../graf/H1to4p.txt");

%Get first Image
Image = imread(Image_paths(1));
Image = rgb2gray(Image);
Image = im2double(Image);

splited_name = strsplit(Image_names(1),'.');
img_name = splited_name(1);

name_format = sprintf("../../Data/%s_points.mat",img_name);
load(name_format);

%% MaxRatio tests
for o = 1:100
    [BRIEF_descriptors_FAST_img1_1, vp_img1_FAST_BRIEF_1]= extract_BRIEF_features(FAST_points, 0, BRIEF_Pattern_1, Image, BRIEF_patch_size, BRIEF_N_pairs);
    [BRIEF_descriptors_FAST_img1_2, vp_img1_FAST_BRIEF_2]= extract_BRIEF_features(FAST_points, 0, BRIEF_Pattern_2, Image, BRIEF_patch_size, BRIEF_N_pairs);
    [BRIEF_descriptors_FAST_img1_3, vp_img1_FAST_BRIEF_3]= extract_BRIEF_features(FAST_points, 0, BRIEF_Pattern_3, Image, BRIEF_patch_size, BRIEF_N_pairs);
    [BRIEF_descriptors_FAST_img1_4, vp_img1_FAST_BRIEF_4]= extract_BRIEF_features(FAST_points, 0, BRIEF_Pattern_4, Image, BRIEF_patch_size, BRIEF_N_pairs);
    [BRIEF_descriptors_FAST_img1_5, vp_img1_FAST_BRIEF_5]= extract_BRIEF_features(FAST_points, 0, BRIEF_Pattern_5, Image, BRIEF_patch_size, BRIEF_N_pairs);
    
    
    for i = 2:2 
        Image_2 = imread(Image_paths(i));
        Image_2 = rgb2gray(Image_2);
        Image_2 = im2double(Image_2);
        
        splited_name = strsplit(Image_names(i),'.');
        img_name = splited_name(1);
        name_format = sprintf("../../Data/%s_points.mat",img_name);
        load(name_format)
    
        [BRIEF_descriptors_FAST_img2_1, vp_img2_FAST_BRIEF_1]= extract_BRIEF_features(FAST_points, 0, BRIEF_Pattern_1, Image_2, BRIEF_patch_size, BRIEF_N_pairs);
        [BRIEF_descriptors_FAST_img2_2, vp_img2_FAST_BRIEF_2]= extract_BRIEF_features(FAST_points, 0, BRIEF_Pattern_2, Image_2, BRIEF_patch_size, BRIEF_N_pairs);
        [BRIEF_descriptors_FAST_img2_3, vp_img2_FAST_BRIEF_3]= extract_BRIEF_features(FAST_points, 0, BRIEF_Pattern_3, Image_2, BRIEF_patch_size, BRIEF_N_pairs);
        [BRIEF_descriptors_FAST_img2_4, vp_img2_FAST_BRIEF_4]= extract_BRIEF_features(FAST_points, 0, BRIEF_Pattern_4, Image_2, BRIEF_patch_size, BRIEF_N_pairs);
        [BRIEF_descriptors_FAST_img2_5, vp_img2_FAST_BRIEF_5]= extract_BRIEF_features(FAST_points, 0, BRIEF_Pattern_5, Image_2, BRIEF_patch_size, BRIEF_N_pairs);
    
    
        [indexPairs_FAST_BRIEF_1,matchmetric_FAST_BRIEF_1] = matchFeatures(BRIEF_descriptors_FAST_img1_1,BRIEF_descriptors_FAST_img2_1, "MatchThreshold", 60, "MaxRatio", o/100);
        [indexPairs_FAST_BRIEF_2,matchmetric_FAST_BRIEF_2] = matchFeatures(BRIEF_descriptors_FAST_img1_2,BRIEF_descriptors_FAST_img2_2, "MatchThreshold", 60, "MaxRatio", o/100);
        [indexPairs_FAST_BRIEF_3,matchmetric_FAST_BRIEF_3] = matchFeatures(BRIEF_descriptors_FAST_img1_3,BRIEF_descriptors_FAST_img2_3, "MatchThreshold", 60, "MaxRatio", o/100);
        [indexPairs_FAST_BRIEF_4,matchmetric_FAST_BRIEF_4] = matchFeatures(BRIEF_descriptors_FAST_img1_4,BRIEF_descriptors_FAST_img2_4, "MatchThreshold", 60, "MaxRatio", o/100);
        [indexPairs_FAST_BRIEF_5,matchmetric_FAST_BRIEF_5] = matchFeatures(BRIEF_descriptors_FAST_img1_5,BRIEF_descriptors_FAST_img2_5, "MatchThreshold", 60, "MaxRatio", o/100);
    
        figure;
        [Accuracy_FAST_BRIEF_1, Precision_FAST_BRIEF_1, Recall_FAST_BRIEF_1] = Show_metrics(Image,Image_2, vp_img1_FAST_BRIEF_1,vp_img2_FAST_BRIEF_1, indexPairs_FAST_BRIEF_1, H1, 15);
        figure;
        [Accuracy_FAST_BRIEF_2, Precision_FAST_BRIEF_2, Recall_FAST_BRIEF_2] = Show_metrics(Image,Image_2, vp_img1_FAST_BRIEF_2,vp_img2_FAST_BRIEF_2, indexPairs_FAST_BRIEF_2, H1, 15);
        figure;
        [Accuracy_FAST_BRIEF_3, Precision_FAST_BRIEF_3, Recall_FAST_BRIEF_3] = Show_metrics(Image,Image_2, vp_img1_FAST_BRIEF_3,vp_img2_FAST_BRIEF_3, indexPairs_FAST_BRIEF_3, H1, 15);
        figure;
        [Accuracy_FAST_BRIEF_4, Precision_FAST_BRIEF_4, Recall_FAST_BRIEF_4] = Show_metrics(Image,Image_2, vp_img1_FAST_BRIEF_4,vp_img2_FAST_BRIEF_4, indexPairs_FAST_BRIEF_4, H1, 15);
        figure;
        [Accuracy_FAST_BRIEF_5, Precision_FAST_BRIEF_5, Recall_FAST_BRIEF_5] = Show_metrics(Image,Image_2, vp_img1_FAST_BRIEF_5,vp_img2_FAST_BRIEF_5, indexPairs_FAST_BRIEF_5, H1, 15);
        close all;
        
        fprintf("Iterantion nº: %d\n", o);
        fprintf("Correspondences between image 1 and %d\n", i)
        fprintf("FAST + BRIEF(method 1): Accuracy: %.3f Precision: %.3f Recall: %.3f -  Matched points: %d\n", Accuracy_FAST_BRIEF_1, Precision_FAST_BRIEF_1, Recall_FAST_BRIEF_1, length(indexPairs_FAST_BRIEF_1));
        fprintf("FAST + BRIEF(method 2): Accuracy: %.3f Precision: %.3f Recall: %.3f -  Matched points: %d\n", Accuracy_FAST_BRIEF_2, Precision_FAST_BRIEF_2, Recall_FAST_BRIEF_2, length(indexPairs_FAST_BRIEF_2));
        fprintf("FAST + BRIEF(method 3): Accuracy: %.3f Precision: %.3f Recall: %.3f -  Matched points: %d\n", Accuracy_FAST_BRIEF_3, Precision_FAST_BRIEF_3, Recall_FAST_BRIEF_3, length(indexPairs_FAST_BRIEF_3));
        fprintf("FAST + BRIEF(method 4): Accuracy: %.3f Precision: %.3f Recall: %.3f -  Matched points: %d\n", Accuracy_FAST_BRIEF_4, Precision_FAST_BRIEF_4, Recall_FAST_BRIEF_4, length(indexPairs_FAST_BRIEF_4));
        fprintf("FAST + BRIEF(method 5): Accuracy: %.3f Precision: %.3f Recall: %.3f -  Matched points: %d\n\n", Accuracy_FAST_BRIEF_5, Precision_FAST_BRIEF_5, Recall_FAST_BRIEF_5, length(indexPairs_FAST_BRIEF_5));
        
        Accuracy_mat(o,:) = [o/100 Accuracy_FAST_BRIEF_1 Accuracy_FAST_BRIEF_2 Accuracy_FAST_BRIEF_3 Accuracy_FAST_BRIEF_4 Accuracy_FAST_BRIEF_5];
        Precision_mat(o,:) = [o/100 Precision_FAST_BRIEF_1 Precision_FAST_BRIEF_2 Precision_FAST_BRIEF_3 Precision_FAST_BRIEF_4 Precision_FAST_BRIEF_5];
        Recall_mat(o,:) = [o/100 Recall_FAST_BRIEF_1 Recall_FAST_BRIEF_2 Recall_FAST_BRIEF_3 Recall_FAST_BRIEF_4 Recall_FAST_BRIEF_5];
    end
end

save("..\..\Data\FAST_BRIEF_MaxRatio_test.mat","Accuracy_mat","Precision_mat","Recall_mat");

%% MatchThreshold tests
for o = 1:100
    [BRIEF_descriptors_FAST_img1_1, vp_img1_FAST_BRIEF_1]= extract_BRIEF_features(FAST_points, 0, BRIEF_Pattern_1, Image, BRIEF_patch_size, BRIEF_N_pairs);
    [BRIEF_descriptors_FAST_img1_2, vp_img1_FAST_BRIEF_2]= extract_BRIEF_features(FAST_points, 0, BRIEF_Pattern_2, Image, BRIEF_patch_size, BRIEF_N_pairs);
    [BRIEF_descriptors_FAST_img1_3, vp_img1_FAST_BRIEF_3]= extract_BRIEF_features(FAST_points, 0, BRIEF_Pattern_3, Image, BRIEF_patch_size, BRIEF_N_pairs);
    [BRIEF_descriptors_FAST_img1_4, vp_img1_FAST_BRIEF_4]= extract_BRIEF_features(FAST_points, 0, BRIEF_Pattern_4, Image, BRIEF_patch_size, BRIEF_N_pairs);
    [BRIEF_descriptors_FAST_img1_5, vp_img1_FAST_BRIEF_5]= extract_BRIEF_features(FAST_points, 0, BRIEF_Pattern_5, Image, BRIEF_patch_size, BRIEF_N_pairs);
    
    
    for i = 2:2 
        Image_2 = imread(Image_paths(i));
        Image_2 = rgb2gray(Image_2);
        Image_2 = im2double(Image_2);
        
        splited_name = strsplit(Image_names(i),'.');
        img_name = splited_name(1);
        name_format = sprintf("../../Data/%s_points.mat",img_name);
        load(name_format)
    
        [BRIEF_descriptors_FAST_img2_1, vp_img2_FAST_BRIEF_1]= extract_BRIEF_features(FAST_points, 0, BRIEF_Pattern_1, Image_2, BRIEF_patch_size, BRIEF_N_pairs);
        [BRIEF_descriptors_FAST_img2_2, vp_img2_FAST_BRIEF_2]= extract_BRIEF_features(FAST_points, 0, BRIEF_Pattern_2, Image_2, BRIEF_patch_size, BRIEF_N_pairs);
        [BRIEF_descriptors_FAST_img2_3, vp_img2_FAST_BRIEF_3]= extract_BRIEF_features(FAST_points, 0, BRIEF_Pattern_3, Image_2, BRIEF_patch_size, BRIEF_N_pairs);
        [BRIEF_descriptors_FAST_img2_4, vp_img2_FAST_BRIEF_4]= extract_BRIEF_features(FAST_points, 0, BRIEF_Pattern_4, Image_2, BRIEF_patch_size, BRIEF_N_pairs);
        [BRIEF_descriptors_FAST_img2_5, vp_img2_FAST_BRIEF_5]= extract_BRIEF_features(FAST_points, 0, BRIEF_Pattern_5, Image_2, BRIEF_patch_size, BRIEF_N_pairs);
    
    
        [indexPairs_FAST_BRIEF_1,matchmetric_FAST_BRIEF_1] = matchFeatures(BRIEF_descriptors_FAST_img1_1,BRIEF_descriptors_FAST_img2_1, "MatchThreshold", o, "MaxRatio", 0.65);
        [indexPairs_FAST_BRIEF_2,matchmetric_FAST_BRIEF_2] = matchFeatures(BRIEF_descriptors_FAST_img1_2,BRIEF_descriptors_FAST_img2_2, "MatchThreshold", o, "MaxRatio", 0.65);
        [indexPairs_FAST_BRIEF_3,matchmetric_FAST_BRIEF_3] = matchFeatures(BRIEF_descriptors_FAST_img1_3,BRIEF_descriptors_FAST_img2_3, "MatchThreshold", o, "MaxRatio", 0.65);
        [indexPairs_FAST_BRIEF_4,matchmetric_FAST_BRIEF_4] = matchFeatures(BRIEF_descriptors_FAST_img1_4,BRIEF_descriptors_FAST_img2_4, "MatchThreshold", o, "MaxRatio", 0.65);
        [indexPairs_FAST_BRIEF_5,matchmetric_FAST_BRIEF_5] = matchFeatures(BRIEF_descriptors_FAST_img1_5,BRIEF_descriptors_FAST_img2_5, "MatchThreshold", o, "MaxRatio", 0.65);
    
        figure;
        [Accuracy_FAST_BRIEF_1, Precision_FAST_BRIEF_1, Recall_FAST_BRIEF_1] = Show_metrics(Image,Image_2, vp_img1_FAST_BRIEF_1,vp_img2_FAST_BRIEF_1, indexPairs_FAST_BRIEF_1, H1, 15);
        figure;
        [Accuracy_FAST_BRIEF_2, Precision_FAST_BRIEF_2, Recall_FAST_BRIEF_2] = Show_metrics(Image,Image_2, vp_img1_FAST_BRIEF_2,vp_img2_FAST_BRIEF_2, indexPairs_FAST_BRIEF_2, H1, 15);
        figure;
        [Accuracy_FAST_BRIEF_3, Precision_FAST_BRIEF_3, Recall_FAST_BRIEF_3] = Show_metrics(Image,Image_2, vp_img1_FAST_BRIEF_3,vp_img2_FAST_BRIEF_3, indexPairs_FAST_BRIEF_3, H1, 15);
        figure;
        [Accuracy_FAST_BRIEF_4, Precision_FAST_BRIEF_4, Recall_FAST_BRIEF_4] = Show_metrics(Image,Image_2, vp_img1_FAST_BRIEF_4,vp_img2_FAST_BRIEF_4, indexPairs_FAST_BRIEF_4, H1, 15);
        figure;
        [Accuracy_FAST_BRIEF_5, Precision_FAST_BRIEF_5, Recall_FAST_BRIEF_5] = Show_metrics(Image,Image_2, vp_img1_FAST_BRIEF_5,vp_img2_FAST_BRIEF_5, indexPairs_FAST_BRIEF_5, H1, 15);
        close all;
        
        fprintf("Iterantion nº: %d\n", o);
        fprintf("Correspondences between image 1 and %d\n", i)
        fprintf("FAST + BRIEF(method 1): Accuracy: %.3f Precision: %.3f Recall: %.3f -  Matched points: %d\n", Accuracy_FAST_BRIEF_1, Precision_FAST_BRIEF_1, Recall_FAST_BRIEF_1, length(indexPairs_FAST_BRIEF_1));
        fprintf("FAST + BRIEF(method 2): Accuracy: %.3f Precision: %.3f Recall: %.3f -  Matched points: %d\n", Accuracy_FAST_BRIEF_2, Precision_FAST_BRIEF_2, Recall_FAST_BRIEF_2, length(indexPairs_FAST_BRIEF_2));
        fprintf("FAST + BRIEF(method 3): Accuracy: %.3f Precision: %.3f Recall: %.3f -  Matched points: %d\n", Accuracy_FAST_BRIEF_3, Precision_FAST_BRIEF_3, Recall_FAST_BRIEF_3, length(indexPairs_FAST_BRIEF_3));
        fprintf("FAST + BRIEF(method 4): Accuracy: %.3f Precision: %.3f Recall: %.3f -  Matched points: %d\n", Accuracy_FAST_BRIEF_4, Precision_FAST_BRIEF_4, Recall_FAST_BRIEF_4, length(indexPairs_FAST_BRIEF_4));
        fprintf("FAST + BRIEF(method 5): Accuracy: %.3f Precision: %.3f Recall: %.3f -  Matched points: %d\n\n", Accuracy_FAST_BRIEF_5, Precision_FAST_BRIEF_5, Recall_FAST_BRIEF_5, length(indexPairs_FAST_BRIEF_5));
        
        Accuracy_mat_MatchThreshold(o,:) = [o Accuracy_FAST_BRIEF_1 Accuracy_FAST_BRIEF_2 Accuracy_FAST_BRIEF_3 Accuracy_FAST_BRIEF_4 Accuracy_FAST_BRIEF_5];
        Precision_mat_MatchThreshold(o,:) = [o Precision_FAST_BRIEF_1 Precision_FAST_BRIEF_2 Precision_FAST_BRIEF_3 Precision_FAST_BRIEF_4 Precision_FAST_BRIEF_5];
        Recall_mat_MatchThreshold(o,:) = [o Recall_FAST_BRIEF_1 Recall_FAST_BRIEF_2 Recall_FAST_BRIEF_3 Recall_FAST_BRIEF_4 Recall_FAST_BRIEF_5];
    end
end

save("..\..\Data\FAST_BRIEF_MatchThreshold_test.mat","Accuracy_mat_MatchThreshold","Precision_mat_MatchThreshold","Recall_mat_MatchThreshold");
%% Patch_Size Plots

BRIEF_N_pairs = 128;
BRIEF_patch_size = 3;

for o=1:27
    BRIEF_Pattern_1 = create_BRIEF_pattern(1, BRIEF_patch_size, BRIEF_N_pairs);
    BRIEF_Pattern_2 = create_BRIEF_pattern(2, BRIEF_patch_size, BRIEF_N_pairs);
    BRIEF_Pattern_3 = create_BRIEF_pattern(3, BRIEF_patch_size, BRIEF_N_pairs);
    BRIEF_Pattern_4 = create_BRIEF_pattern(4, BRIEF_patch_size, BRIEF_N_pairs);
    BRIEF_Pattern_5 = create_BRIEF_pattern(5, BRIEF_patch_size, BRIEF_N_pairs);
    
    load("..\..\Data\Extracted_points_info.mat")
    
    H1=readmatrix("../../graf/H1to2p.txt");
    H2=readmatrix("../../graf/H1to4p.txt");
    
    Image = imread(Image_paths(1));
    Image = rgb2gray(Image);
    Image = im2double(Image);
    
    splited_name = strsplit(Image_names(1),'.');
    img_name = splited_name(1);
    
    name_format = sprintf("../../Data/%s_points.mat",img_name);
    load(name_format);
    
    [BRIEF_descriptors_FAST_img1_1, vp_img1_FAST_BRIEF_1]= extract_BRIEF_features(FAST_points, 0, BRIEF_Pattern_1, Image, BRIEF_patch_size, BRIEF_N_pairs);
    [BRIEF_descriptors_FAST_img1_2, vp_img1_FAST_BRIEF_2]= extract_BRIEF_features(FAST_points, 0, BRIEF_Pattern_2, Image, BRIEF_patch_size, BRIEF_N_pairs);
    [BRIEF_descriptors_FAST_img1_3, vp_img1_FAST_BRIEF_3]= extract_BRIEF_features(FAST_points, 0, BRIEF_Pattern_3, Image, BRIEF_patch_size, BRIEF_N_pairs);
    [BRIEF_descriptors_FAST_img1_4, vp_img1_FAST_BRIEF_4]= extract_BRIEF_features(FAST_points, 0, BRIEF_Pattern_4, Image, BRIEF_patch_size, BRIEF_N_pairs);
    [BRIEF_descriptors_FAST_img1_5, vp_img1_FAST_BRIEF_5]= extract_BRIEF_features(FAST_points, 0, BRIEF_Pattern_5, Image, BRIEF_patch_size, BRIEF_N_pairs);
    
    for i = 2:2
        Image_2 = imread(Image_paths(i));
        Image_2 = rgb2gray(Image_2);
        Image_2 = im2double(Image_2);
    
        splited_name = strsplit(Image_names(i),'.');
        img_name = splited_name(1);
        name_format = sprintf("../../Data/%s_points.mat",img_name);
        load(name_format)
    
        [BRIEF_descriptors_FAST_img2_1, vp_img2_FAST_BRIEF_1]= extract_BRIEF_features(FAST_points, 0, BRIEF_Pattern_1, Image_2, BRIEF_patch_size, BRIEF_N_pairs);
        [BRIEF_descriptors_FAST_img2_2, vp_img2_FAST_BRIEF_2]= extract_BRIEF_features(FAST_points, 0, BRIEF_Pattern_2, Image_2, BRIEF_patch_size, BRIEF_N_pairs);
        [BRIEF_descriptors_FAST_img2_3, vp_img2_FAST_BRIEF_3]= extract_BRIEF_features(FAST_points, 0, BRIEF_Pattern_3, Image_2, BRIEF_patch_size, BRIEF_N_pairs);
        [BRIEF_descriptors_FAST_img2_4, vp_img2_FAST_BRIEF_4]= extract_BRIEF_features(FAST_points, 0, BRIEF_Pattern_4, Image_2, BRIEF_patch_size, BRIEF_N_pairs);
        [BRIEF_descriptors_FAST_img2_5, vp_img2_FAST_BRIEF_5]= extract_BRIEF_features(FAST_points, 0, BRIEF_Pattern_5, Image_2, BRIEF_patch_size, BRIEF_N_pairs);
    
    
        [indexPairs_FAST_BRIEF_1,matchmetric_FAST_BRIEF_1] = matchFeatures(BRIEF_descriptors_FAST_img1_1,BRIEF_descriptors_FAST_img2_1, "MatchThreshold", 60, "MaxRatio", 0.65);
        [indexPairs_FAST_BRIEF_2,matchmetric_FAST_BRIEF_2] = matchFeatures(BRIEF_descriptors_FAST_img1_2,BRIEF_descriptors_FAST_img2_2, "MatchThreshold", 60, "MaxRatio", 0.65);
        [indexPairs_FAST_BRIEF_3,matchmetric_FAST_BRIEF_3] = matchFeatures(BRIEF_descriptors_FAST_img1_3,BRIEF_descriptors_FAST_img2_3, "MatchThreshold", 60, "MaxRatio", 0.65);
        [indexPairs_FAST_BRIEF_4,matchmetric_FAST_BRIEF_4] = matchFeatures(BRIEF_descriptors_FAST_img1_4,BRIEF_descriptors_FAST_img2_4, "MatchThreshold", 60, "MaxRatio", 0.65);
        [indexPairs_FAST_BRIEF_5,matchmetric_FAST_BRIEF_5] = matchFeatures(BRIEF_descriptors_FAST_img1_5,BRIEF_descriptors_FAST_img2_5, "MatchThreshold", 60, "MaxRatio", 0.65);
    
        figure;
        [Accuracy_FAST_BRIEF_1, Precision_FAST_BRIEF_1, Recall_FAST_BRIEF_1] = Show_metrics(Image,Image_2, vp_img1_FAST_BRIEF_1,vp_img2_FAST_BRIEF_1, indexPairs_FAST_BRIEF_1, H1, 15);
        figure;
        [Accuracy_FAST_BRIEF_2, Precision_FAST_BRIEF_2, Recall_FAST_BRIEF_2] = Show_metrics(Image,Image_2, vp_img1_FAST_BRIEF_2,vp_img2_FAST_BRIEF_2, indexPairs_FAST_BRIEF_2, H1, 15);
        figure;
        [Accuracy_FAST_BRIEF_3, Precision_FAST_BRIEF_3, Recall_FAST_BRIEF_3] = Show_metrics(Image,Image_2, vp_img1_FAST_BRIEF_3,vp_img2_FAST_BRIEF_3, indexPairs_FAST_BRIEF_3, H1, 15);
        figure;
        [Accuracy_FAST_BRIEF_4, Precision_FAST_BRIEF_4, Recall_FAST_BRIEF_4] = Show_metrics(Image,Image_2, vp_img1_FAST_BRIEF_4,vp_img2_FAST_BRIEF_4, indexPairs_FAST_BRIEF_4, H1, 15);
        figure;
        [Accuracy_FAST_BRIEF_5, Precision_FAST_BRIEF_5, Recall_FAST_BRIEF_5] = Show_metrics(Image,Image_2, vp_img1_FAST_BRIEF_5,vp_img2_FAST_BRIEF_5, indexPairs_FAST_BRIEF_5, H1, 15);
        close all;
    
        fprintf("Iterantion nº: %d\n", o);
        fprintf("Correspondences between image 1 and %d\n", i)
        fprintf("FAST + BRIEF(method 1): Accuracy: %.3f Precision: %.3f Recall: %.3f -  Matched points: %d\n", Accuracy_FAST_BRIEF_1, Precision_FAST_BRIEF_1, Recall_FAST_BRIEF_1, length(indexPairs_FAST_BRIEF_1));
        fprintf("FAST + BRIEF(method 2): Accuracy: %.3f Precision: %.3f Recall: %.3f -  Matched points: %d\n", Accuracy_FAST_BRIEF_2, Precision_FAST_BRIEF_2, Recall_FAST_BRIEF_2, length(indexPairs_FAST_BRIEF_2));
        fprintf("FAST + BRIEF(method 3): Accuracy: %.3f Precision: %.3f Recall: %.3f -  Matched points: %d\n", Accuracy_FAST_BRIEF_3, Precision_FAST_BRIEF_3, Recall_FAST_BRIEF_3, length(indexPairs_FAST_BRIEF_3));
        fprintf("FAST + BRIEF(method 4): Accuracy: %.3f Precision: %.3f Recall: %.3f -  Matched points: %d\n", Accuracy_FAST_BRIEF_4, Precision_FAST_BRIEF_4, Recall_FAST_BRIEF_4, length(indexPairs_FAST_BRIEF_4));
        fprintf("FAST + BRIEF(method 5): Accuracy: %.3f Precision: %.3f Recall: %.3f -  Matched points: %d\n\n", Accuracy_FAST_BRIEF_5, Precision_FAST_BRIEF_5, Recall_FAST_BRIEF_5, length(indexPairs_FAST_BRIEF_5));
    
        Accuracy_mat_PatchSize(o,:) = [BRIEF_patch_size Accuracy_FAST_BRIEF_1 Accuracy_FAST_BRIEF_2 Accuracy_FAST_BRIEF_3 Accuracy_FAST_BRIEF_4 Accuracy_FAST_BRIEF_5];
        Precision_mat_PatchSize(o,:) = [BRIEF_patch_size Precision_FAST_BRIEF_1 Precision_FAST_BRIEF_2 Precision_FAST_BRIEF_3 Precision_FAST_BRIEF_4 Precision_FAST_BRIEF_5];
        Recall_mat_PatchSize(o,:) = [BRIEF_patch_size Recall_FAST_BRIEF_1 Recall_FAST_BRIEF_2 Recall_FAST_BRIEF_3 Recall_FAST_BRIEF_4 Recall_FAST_BRIEF_5];
    end
    BRIEF_patch_size = BRIEF_patch_size + 2;
end

save("..\..\Data\FAST_BRIEF_PatchSize_test.mat","Accuracy_mat_PatchSize","Precision_mat_PatchSize","Recall_mat_PatchSize");
%% MaxRatio Plots
clear;clc;

load("..\..\Data\FAST_BRIEF_MaxRatio_test.mat")

Accuracy_graf = figure;
plot(Accuracy_mat(:,1),Accuracy_mat(:,2), 'g', 'LineWidth', 2)
hold on;
plot(Accuracy_mat(:,1),Accuracy_mat(:,3), 'r', 'LineWidth', 2)
hold on;
plot(Accuracy_mat(:,1),Accuracy_mat(:,4), 'b', 'LineWidth', 2)
hold on;
plot(Accuracy_mat(:,1),Accuracy_mat(:,5), 'k', 'LineWidth', 2)
hold on;
plot(Accuracy_mat(:,1),Accuracy_mat(:,6), 'c', 'LineWidth', 2)
grid on
legend("Method 1","Method 2","Method 3","Method 4","Method 5", "Location", "northwest")
xlabel("MaxRatio values")
ylabel("Accuracy")

Precision_graf = figure;
plot(Precision_mat(:,1),Precision_mat(:,2), 'g', 'LineWidth', 2)
hold on;
plot(Precision_mat(:,1),Precision_mat(:,3), 'r', 'LineWidth', 2)
hold on;
plot(Precision_mat(:,1),Precision_mat(:,4), 'b', 'LineWidth', 2)
hold on;
plot(Precision_mat(:,1),Precision_mat(:,5), 'k', 'LineWidth', 2)
hold on;
plot(Precision_mat(:,1),Precision_mat(:,6), 'c', 'LineWidth', 2)
grid on
legend("Method 1","Method 2","Method 3","Method 4","Method 5", "Location", "northwest")
xlabel("MaxRatio values")
ylabel("Precision")

Recall_graf = figure;
plot(Recall_mat(:,1),Recall_mat(:,2), 'g', 'LineWidth', 2)
hold on;
plot(Recall_mat(:,1),Recall_mat(:,3), 'r', 'LineWidth', 2)
hold on;
plot(Recall_mat(:,1),Recall_mat(:,4), 'b', 'LineWidth', 2)
hold on;
plot(Recall_mat(:,1),Recall_mat(:,5), 'k', 'LineWidth', 2)
hold on;
plot(Recall_mat(:,1),Recall_mat(:,6), 'c', 'LineWidth', 2)
grid on
legend("Method 1","Method 2","Method 3","Method 4","Method 5", "Location", "northwest")
xlabel("MaxRatio values")
ylabel("Recall")

saveas(Accuracy_graf, "..\..\Results\FAST_BRIEF_tests\Accuracy_MaxRatio.png")
saveas(Precision_graf, "..\..\Results\FAST_BRIEF_tests\Precision_MaxRatio.png")
saveas(Recall_graf, "..\..\Results\FAST_BRIEF_tests\Recall_MaxRatio.png")
%% MatchThreshold Plots
clear;clc;

load("..\..\Data\FAST_BRIEF_MatchThreshold_test.mat")

Accuracy_graf = figure;
plot(Accuracy_mat_MatchThreshold(:,1),Accuracy_mat_MatchThreshold(:,2), 'g', 'LineWidth', 2)
hold on;
plot(Accuracy_mat_MatchThreshold(:,1),Accuracy_mat_MatchThreshold(:,3), 'r', 'LineWidth', 2)
hold on;
plot(Accuracy_mat_MatchThreshold(:,1),Accuracy_mat_MatchThreshold(:,4), 'b', 'LineWidth', 2)
hold on;
plot(Accuracy_mat_MatchThreshold(:,1),Accuracy_mat_MatchThreshold(:,5), 'k', 'LineWidth', 2)
hold on;
plot(Accuracy_mat_MatchThreshold(:,1),Accuracy_mat_MatchThreshold(:,6), 'c', 'LineWidth', 2)
grid on
legend("Method 1","Method 2","Method 3","Method 4","Method 5", "Location", "northwest")
xlabel("MatchThreshold values")
ylabel("Accuracy")

Precision_graf = figure;
plot(Precision_mat_MatchThreshold(:,1),Precision_mat_MatchThreshold(:,2), 'g', 'LineWidth', 2)
hold on;
plot(Precision_mat_MatchThreshold(:,1),Precision_mat_MatchThreshold(:,3), 'r', 'LineWidth', 2)
hold on;
plot(Precision_mat_MatchThreshold(:,1),Precision_mat_MatchThreshold(:,4), 'b', 'LineWidth', 2)
hold on;
plot(Precision_mat_MatchThreshold(:,1),Precision_mat_MatchThreshold(:,5), 'k', 'LineWidth', 2)
hold on;
plot(Precision_mat_MatchThreshold(:,1),Precision_mat_MatchThreshold(:,6), 'c', 'LineWidth', 2)
grid on
legend("Method 1","Method 2","Method 3","Method 4","Method 5", "Location", "northwest")
xlabel("MatchThreshold values")
ylabel("Precision")

Recall_graf = figure;
plot(Recall_mat_MatchThreshold(:,1),Recall_mat_MatchThreshold(:,2), 'g', 'LineWidth', 2)
hold on;
plot(Recall_mat_MatchThreshold(:,1),Recall_mat_MatchThreshold(:,3), 'r', 'LineWidth', 2)
hold on;
plot(Recall_mat_MatchThreshold(:,1),Recall_mat_MatchThreshold(:,4), 'b', 'LineWidth', 2)
hold on;
plot(Recall_mat_MatchThreshold(:,1),Recall_mat_MatchThreshold(:,5), 'k', 'LineWidth', 2)
hold on;
plot(Recall_mat_MatchThreshold(:,1),Recall_mat_MatchThreshold(:,6), 'c', 'LineWidth', 2)
grid on
legend("Method 1","Method 2","Method 3","Method 4","Method 5", "Location", "northwest")
xlabel("MatchThreshold values")
ylabel("Recall")

saveas(Accuracy_graf, "..\..\Results\FAST_BRIEF_tests\Accuracy_MatchThreshold.png")
saveas(Precision_graf, "..\..\Results\FAST_BRIEF_tests\Precision_MatchThreshold.png")
saveas(Recall_graf, "..\..\Results\FAST_BRIEF_tests\Recall_MatchThreshold.png")

%% Patch_Size Plots

clear;clc;

load("..\..\Data\FAST_BRIEF_PatchSize_test.mat")

Accuracy_graf = figure;
plot(Accuracy_mat_PatchSize(:,1),Accuracy_mat_PatchSize(:,2), 'g', 'LineWidth', 2)
hold on;
plot(Accuracy_mat_PatchSize(:,1),Accuracy_mat_PatchSize(:,3), 'r', 'LineWidth', 2)
hold on;
plot(Accuracy_mat_PatchSize(:,1),Accuracy_mat_PatchSize(:,4), 'b', 'LineWidth', 2)
hold on;
plot(Accuracy_mat_PatchSize(:,1),Accuracy_mat_PatchSize(:,5), 'k', 'LineWidth', 2)
hold on;
plot(Accuracy_mat_PatchSize(:,1),Accuracy_mat_PatchSize(:,6), 'c', 'LineWidth', 2)
grid on
legend("Method 1","Method 2","Method 3","Method 4","Method 5", "Location", "northwest")
xlabel("Patch Size")
ylabel("Accuracy")

Precision_graf = figure;
plot(Precision_mat_PatchSize(:,1),Precision_mat_PatchSize(:,2), 'g', 'LineWidth', 2)
hold on;
plot(Precision_mat_PatchSize(:,1),Precision_mat_PatchSize(:,3), 'r', 'LineWidth', 2)
hold on;
plot(Precision_mat_PatchSize(:,1),Precision_mat_PatchSize(:,4), 'b', 'LineWidth', 2)
hold on;
plot(Precision_mat_PatchSize(:,1),Precision_mat_PatchSize(:,5), 'k', 'LineWidth', 2)
hold on;
plot(Precision_mat_PatchSize(:,1),Precision_mat_PatchSize(:,6), 'c', 'LineWidth', 2)
grid on
legend("Method 1","Method 2","Method 3","Method 4","Method 5", "Location", "northwest")
xlabel("Patch_Size values")
ylabel("Precision")

Recall_graf = figure;
plot(Recall_mat_PatchSize(:,1),Recall_mat_PatchSize(:,2), 'g', 'LineWidth', 2)
hold on;
plot(Recall_mat_PatchSize(:,1),Recall_mat_PatchSize(:,3), 'r', 'LineWidth', 2)
hold on;
plot(Recall_mat_PatchSize(:,1),Recall_mat_PatchSize(:,4), 'b', 'LineWidth', 2)
hold on;
plot(Recall_mat_PatchSize(:,1),Recall_mat_PatchSize(:,5), 'k', 'LineWidth', 2)
hold on;
plot(Recall_mat_PatchSize(:,1),Recall_mat_PatchSize(:,6), 'c', 'LineWidth', 2)
grid on
legend("Method 1","Method 2","Method 3","Method 4","Method 5", "Location", "northwest")
xlabel("Patch_Side values")
ylabel("Recall")

saveas(Accuracy_graf, "..\..\Results\FAST_BRIEF_tests\Accuracy_Patch_Size.png")
saveas(Precision_graf, "..\..\Results\FAST_BRIEF_tests\Precision_Patch_Size.png")
saveas(Recall_graf, "..\..\Results\FAST_BRIEF_tests\Recall_Patch_Size.png")