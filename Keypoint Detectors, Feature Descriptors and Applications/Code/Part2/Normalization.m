function [xyn,T] = Normalization(xy)
    
    %Calculate centroid
    xy_centroid = [mean(xy(1,:)); mean(xy(2,:))];
    
    %Subtract centroid center location to all coordinates of the point cloud
    xyc=xy(1:2,:)-xy_centroid;
    
    %Get scale values for x and y
    s2dx=sum(abs(xyc(1,:)))/size(xyc,2);
    s2dy=sum(abs(xyc(2,:)))/size(xyc,2);
    
    %Construct the normalization matrix
    T = [s2dx 0    xy_centroid(1);
     0    s2dy xy_centroid(2);
     0    0    1];
    T=inv(T);
    
    %Calculating the normalized points
    xyn = T*xy;

end