function Homography_mat = Compute_homography(points1,points2)
%Function used to calculate the homography matrix given a set of points

if length(points1) ~= length(points2)
    error("Inserted points do not have tthe same length!")
end
if length(points1)<4
    error("Homography needs at least 4 points!")
end

Homography_mat =[];

for i=1:length(points1)
    Homography_mat = [Homography_mat;
                      -points1(i,1) -points1(i,2) -1 0 0 0 points1(i,1)*points2(i,1) points1(i,2)*points2(i,1) points2(i,1);
                      0 0 0 -points1(i,1) -points1(i,2) -1 points1(i,1)*points2(i,2) points1(i,2)*points2(i,2) points2(i,2)];
end


[~,~,V] = svd(Homography_mat);

Homography_mat = [V(1:3,end)';V(4:6,end)';V(7:9,end)'];

end