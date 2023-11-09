close all; clear; clc;

graphs_flag = 1; %Flag to show or not, all the plots
Img1_color = im2double(imread("../../Panorama/keble_a.jpg"));
Img2_color = im2double(imread("../../Panorama/keble_b.jpg"));
Img3_color = im2double(imread("../../Panorama/keble_c.jpg"));

%Color to gray scale images
Img1 = rgb2gray(Img1_color);
Img2 = rgb2gray(Img2_color);
Img3 = rgb2gray(Img3_color);

%Detect Orb keypoints
Points_1= detectORBFeatures(Img1);
Points_2= detectORBFeatures(Img2);
Points_3= detectORBFeatures(Img3);

%Extract all the features
[Descriptors_1, vp_1] = extractFeatures(Img1,Points_1);
[Descriptors_2, vp_2] = extractFeatures(Img2,Points_2);
[Descriptors_3, vp_3] = extractFeatures(Img3,Points_3);

%Get matches between Image 1 and 2, and 2 and 3
indexPairs_12 = matchFeatures(Descriptors_1,Descriptors_2,'MatchThreshold', 5);
indexPairs_23 = matchFeatures(Descriptors_2,Descriptors_3,'MatchThreshold', 5);

%Create list of matched points
matchedPoints1 = vp_1(indexPairs_12(:,1));
matchedPoints2_1 = vp_2(indexPairs_12(:,2));
matchedPoints2_3 = vp_2(indexPairs_23(:,1));
matchedPoints3 = vp_3(indexPairs_23(:,2));

%Matched points plot
if graphs_flag == 1
    match_12_fig = figure; ax = axes;
    showMatchedFeatures(Img1,Img2,matchedPoints1,matchedPoints2_1,"montag",Parent=ax);
    title(ax,"Candidate point matches between Img1 and Img2");
    legend(ax,"Matched points 1","Matched points 2");
    drawnow;

    match_23_fig = figure; ax = axes;
    showMatchedFeatures(Img2,Img3,matchedPoints2_3,matchedPoints3,"montag",Parent=ax);
    title(ax,"Candidate point matches between Img2 and Img3");
    legend(ax,"Matched points 2","Matched points 3");
    drawnow;
end

%Estimate the homography matrixes with RANSAC
[H12, N_inliers_12] = Ransac(matchedPoints1, matchedPoints2_1, 10000, 0.9);
[H32, N_inliers_32] = Ransac(matchedPoints3, matchedPoints2_3, 10000, 0.9);

%Plot that shows the project points of Image 1 and 3 on image 2
if graphs_flag==1
    matchedPoints1_2 = [matchedPoints1.Location'; ones(1,length(matchedPoints1))];
    matchedPoints3_2 = [matchedPoints3.Location'; ones(1,length(matchedPoints3))];
    
    Points_1_2 = ComputeH(matchedPoints1_2, H12);
    Points_3_2 = ComputeH(matchedPoints3_2, H32);
    
    points_1_to_2_calculated = figure;
    scatter(Points_1_2(1,:), Points_1_2(2,:), 'r')
    hold on
    scatter(matchedPoints2_1.Location(:,1), matchedPoints2_1.Location(:,2), 'g')
    Pimg=imshow(Img2);
    uistack(Pimg, 'bottom');
    legend("Calculated points","Matched points")
    drawnow;

    points_3_to_2_calculated = figure;
    scatter(Points_3_2(1,:), Points_3_2(2,:), 'r')
    hold on
    scatter(matchedPoints2_3.Location(:,1), matchedPoints2_3.Location(:,2), 'g')
    Pimg=imshow(Img2);
    uistack(Pimg, 'bottom');
    legend("Calculated points","Matched points")
    drawnow;
end
%% Building the final panorama image
Img = Build_Panorama(Img1_color, Img2_color, Img3_color, H12, H32);

%Plot of the builded panorama image, and save all the images until now
if graphs_flag == 1
    panorama_fig_handler = figure;
    imshow(Img)
    
    saveas(points_1_to_2_calculated,"../../Results/Panorama/Points_1_on_2.png")
    saveas(points_3_to_2_calculated,"../../Results/Panorama/Points_3_on_2.png")
    saveas(match_12_fig,"../../Results/Panorama/Graf_matches_1_2.png")
    saveas(match_23_fig,"../../Results/Panorama/Graf_matches_2_3.png")
    saveas(panorama_fig_handler,"../../Results/Panorama/Panorama.png")
end

%save results, including homography matrixs for later use
save("../../Results/Panorama/Image_inliers.mat", "N_inliers_12", "N_inliers_32");
writematrix(H12,"../../Results/Panorama/H_1to2");
writematrix(H32,"../../Results/Panorama/H_3to2");

