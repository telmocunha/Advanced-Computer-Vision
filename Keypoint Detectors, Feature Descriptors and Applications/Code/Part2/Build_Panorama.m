function [Img] = Build_Panorama(Img1_color, Img2_color, Img3_color, H12, H32)
    %RBG image to gray scale image
    Img1 = rgb2gray(Img1_color);
    Img2 = rgb2gray(Img2_color);
    Img3 = rgb2gray(Img3_color);
    
    %Construct a matrix with the location of left and right image
    img1_x = [1:size(Img1,2)] .* ones(size(Img1));
    img1_y = [1:size(Img1,1)]' .* ones(size(Img1));
    img3_x = [1:size(Img3,2)] .* ones(size(Img3));
    img3_y = [1:size(Img3,1)]' .* ones(size(Img3));
    
    %reshape the above matrixes to have 2 matrixs with 2 columns each,
    %being the first columns the x's and the second column the y's
    img1_coords = [reshape(img1_x,[],1) reshape(img1_y,[],1)]';
    img3_coords = [reshape(img3_x,[],1) reshape(img3_y,[],1)]';
    
    %Get corresponding points in the center image
    img1_coords = [img1_coords; ones(1,length(img1_coords))];
    img3_coords = [img3_coords; ones(1,length(img3_coords))];
    Points_1_2 = ComputeH(img1_coords, H12);
    Points_3_2 = ComputeH(img3_coords, H32);
    
    free_margin = 30; %margin of black space around the image
    
    %Here the size nedeed for the image is calculated
    diff_x = max(Points_3_2(1,:)) - min(Points_1_2(1,:)) + 2*free_margin;
    diff_y = max(Points_3_2(2,:)) - min(Points_1_2(2,:)) + 2*free_margin;
    
    %Center image offset in the new image
    offset_img2_x = abs(floor(min(Points_1_2(1,:)))) + free_margin;
    offset_img2_y = abs(floor(min([Points_1_2(2,:) Points_3_2(2,:)]))) + free_margin;
    
    %Creating the new image with center image in the middle
    [Img2_Y, Img2_X] = size(Img2);
    Img = zeros(ceil(diff_y), ceil(diff_x), 3);
    Img(offset_img2_y:offset_img2_y+Img2_Y-1, offset_img2_x:offset_img2_x+Img2_X-1, :) = Img2_color;
    
    fuse_margin = 70; %Margin that separates the right and left image from the center image

    %going through all the pixeis in the new image and calculate the
    %location of the pixeis in the old images, getting the color values
    %from the old ones
    for x=1:size(Img,2)
        for y=1:size(Img,1)
            if x>offset_img2_x+fuse_margin && x<offset_img2_x+size(Img1,2)-fuse_margin && y>offset_img2_y && y<offset_img2_y+size(Img1,1)
                continue
            end
            Points_2_1 = ceil(ComputeH([x-offset_img2_x;y-offset_img2_y;1], inv(H12)));
            if Points_2_1(2)>size(Img1,1) || Points_2_1(1)>size(Img1,2) || Points_2_1(2)<1 || Points_2_1(1)<1
                continue
            end
            Img(y,x, :) = Img1_color(Points_2_1(2), Points_2_1(1), :);
    
        end
    end
    for x=1:size(Img,2)
        for y=1:size(Img,1)
            if x>offset_img2_x+fuse_margin && x<offset_img2_x+size(Img3,2)-fuse_margin && y>offset_img2_y && y<offset_img2_y+size(Img3,1)
                continue
            end
            Points_3_1 = ceil(ComputeH([x-offset_img2_x;y-offset_img2_y;1], inv(H32)));
    
            if Points_3_1(2)>size(Img3,1) || Points_3_1(1)>size(Img3,2) || Points_3_1(2)<1 || Points_3_1(1)<1
                continue
            end
    
            Img(y,x, :) = Img3_color(Points_3_1(2), Points_3_1(1), :);
        end
    end

end