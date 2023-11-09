function [patch_points] = select_patches(points, side, Gray_image, N_points)
    %This function was only design to help selecting points that would not
    %pass the margim of the images, if we selected a patched centered on
    %them
    patch_points = zeros(N_points,2);
    j = 1;

    while j<=N_points
        candidate_index = randi([1,length(points)],1);
        candidate_point = ceil(points.Location(candidate_index,:));

        if ((candidate_point(1)-side)<1) || ((candidate_point(2)-side)<1)
            continue
        elseif ((candidate_point(1)+side)>size(Gray_image,2)) || ((candidate_point(2)+side)>size(Gray_image,1))
            continue
        else
            patch_points(j,:) = candidate_point;
            j = j+1;
        end

    end

end