function y = ComputeH(x, v)
    %Given a Nx2 matrix ,returns the correspondent points in the other
    %image, represented by the homography
    x=x';
    q = v * [x; ones(1, size(x,2))];
    p = q(3,:);
    y = [q(1,:)./p; q(2,:)./p]';

end