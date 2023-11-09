function [descriptors, point_location] = extract_BRIEF_features(points, bit_flag, pattern, img, patch_size, N_pairs)
    
    %Error checking
    if rem(N_pairs,8)~=0 && bit_flag == 0
        error("Variable N_pairs has to be divisible by 8, to enable conversion from bit to byte!")
    end
    
    side = floor(patch_size/2);
    point_location = ceil(points.Location); %From point object to point coordinates
    
    %check for points that are too close of the image margin
    mask1 = (point_location-floor(patch_size/2))<1;
    mask2 = (point_location(:,1)+side)>size(img,2);
    mask3 = (point_location(:,2)+side)>size(img,1);
    mask = mask1(:,1) | mask1(:,2) | mask2 | mask3;
    point_location(mask,:) = [];
    descriptors = zeros([length(point_location) N_pairs]);
    
    %Gaussian bluring
    sigma = 2;
    hsize = 2 * ceil(3 * sigma) + 1;
    h = fspecial('gaussian',hsize,sigma);
    img_blur = imfilter(img,h,'replicate');
    
    %Select multiple patches
    for i = 1:size(point_location)
        patch=img_blur(point_location(i,2)-side:point_location(i,2)+side,point_location(i,1)-side:point_location(i,1)+side);   
        for j =1:N_pairs %Create all the pairs for the given patch, keypoint
            descriptors(i,j) = (patch(pattern(j,1),pattern(j,2))>patch(pattern(j,3),pattern(j,4)));
        end
    end
    
    %Because its a bineary number 1 or 0, the descriptor result can be
    %stored a bytes and not bits, depends of the flag "bit_flag" to execute
    %the operation
    if bit_flag == 0
        features_byte = zeros([length(descriptors) N_pairs/8]);
    
        for i = 1:size(descriptors,1)
            N_byte=1;
            for j=1:8:size(descriptors,2)
                x = descriptors(i,j:j+7);
                x_str = num2str(x);
                features_byte(i,N_byte) = bin2dec(x_str);
                N_byte=N_byte+1;
            end
        end
        features_byte = uint8(features_byte);
        
        descriptors = binaryFeatures(features_byte);
    end
    
    %Matlab algorithms work with cornerPoints object, so we make the
    %conversion
    point_location = cornerPoints(point_location);
end