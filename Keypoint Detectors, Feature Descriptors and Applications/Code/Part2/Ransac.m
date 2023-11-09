function [Homography_mat, Max_N_inliers] = Ransac(Pts1, Pts2, N_it, Threshold_dist)

%Add a row of ones to make possible homography calculations
Pts1 = [Pts1.Location'; ones(1,length(Pts1))];
Pts2 = [Pts2.Location'; ones(1,length(Pts2))];

%Apply normalization
[Pts1_n, T1] = Normalization(Pts1);
[Pts2_n, T2] = Normalization(Pts2);

%RANSAC
%Initialization of the parameters
Max_N_inliers = 0;
Homography_mat = [];
for i=1:N_it
    %get random point index
    subset_index = randperm(length(Pts1),4);

    %Compute homography matrix
    H_n = Compute_homography(Pts1_n(1:2,subset_index)',Pts2_n(1:2,subset_index)');
    
    %Denormalize the points
    H = inv(T2)*H_n*T1;
    
    %Calculated the correspondent points of Image 1 in Image 2
    Pts2_Calculated = ComputeH(Pts1, H);
    
    %Calculate the distance from the real matched points
    dist = sqrt( (Pts2_Calculated(1,:) - Pts2(1,:)).^2 + (Pts2_Calculated(2,:) - Pts2(2,:)).^2);
    
    %Count number of inliers
    N_inliers = sum(dist<Threshold_dist);
    
    %Check if the result deserves to be saved
    if N_inliers > Max_N_inliers
        Max_N_inliers = N_inliers;
        Homography_mat = H;
    end

end


end