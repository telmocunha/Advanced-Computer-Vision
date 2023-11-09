close all; clear; clc;

side = 20; %side for patch ploting
N_points = 5;  %Number of patches to be ploted

%Folder name were user has the images
Folder_name = "graf";
cmd = append("../../",Folder_name);
cmd_png = append(cmd,"/*.png");
cmd_jpg = append(cmd,"/*.jpg");
cmd_ppm = append(cmd,"/*.ppm");

%Multiple paths for multiple extensions
Image_list_png = dir(cmd_png);
Image_list_jpg = dir(cmd_jpg);
Image_list_ppm = dir(cmd_ppm);

Image_paths = "";
Image_names = "";
i = 1;

%Searching folder for images with extension .ppm -> .png-> .jpg
j = 1;
while j <= size(Image_list_ppm,1)
    Image_names(i) = Image_list_ppm(j).name;
    Image_paths(i) = append(Image_list_ppm(j).folder , "\", Image_list_ppm(j).name);
    i = i + 1;
    j = j + 1;
end

j = 1;
while j <= size(Image_list_png,1) 
    Image_names(i) = Image_list_png(j).name;
    Image_paths(i) = append(Image_list_png(j).folder , "\", Image_list_png(j).name);
    i = i + 1;
    j = j + 1;
end

j = 1;
while j <= size(Image_list_jpg,1)
    Image_names(i) = Image_list_jpg(j).name;
    Image_paths(i) = append(Image_list_jpg(j).folder , "\", Image_list_jpg(j).name);
    i = i + 1;
    j = j + 1;
end

%Error checking
if isempty(Image_paths) || isempty(Image_names) || size(Image_names,2)~=size(Image_paths,2)
    return
end

N_images = size(Image_paths,2);

%Detectors used in this work
Keypoint_detectors = ["SIFT", "SURF", "FAST", "KAZE", "ORB", "BRISK", "AGAST"];
%Index for the matrix "Point_extraction_metrics"
Point_extraction_metrics_index=["SIFT_computation_time";"SIFT_number_of_points";
                                "SURF_computation_time";"SURF_number_of_points";
                                "FAST_computation_time";"FAST_number_of_points";
                                "KAZE_computation_time";"KAZE_number_of_points";
                                "ORB_computation_time";"ORB_number_of_points";
                                "BRISK_computation_time";"BRISK_number_of_points";
                                "AGAST_computation_time";"AGAST_number_of_points"];

Point_extraction_metrics = zeros((length(Keypoint_detectors))*2,N_images);

for i = 1:length(Image_paths)
    %Define the image for this cycle of the loop
    Gray_image=im2double(rgb2gray(imread(Image_paths(i))));

    figure_handler = figure;
    figure_handler.WindowState = "maximized";

    Layout_handler = tiledlayout(2,3);
    
    Title_name = append("Image ", num2str(i), " - ", Image_names(i), " - Strongests 100 points");
    title(Layout_handler,Title_name)

    Image = Gray_image;
    
    %Run all the detectors, getting all points generated and the time taked
    %to the function to compute
    tic
    SIFT_points = detectSIFTFeatures(Image);
    SIFT_computation_time = toc;
    
    tic
    SURF_points = detectSURFFeatures(Image);
    SURF_computation_time = toc;
    
    tic
    FAST_points = detectFASTFeatures(Image);
    FAST_computation_time = toc;
    
    tic
    KAZE_points = detectKAZEFeatures(Image);
    KAZE_computation_time = toc;
    
    tic
    ORB_points = detectORBFeatures(Image);
    ORB_computation_time = toc;
    
    tic
    BRISK_points = detectBRISKFeatures(Image);
    BRISK_computation_time = toc;
    
    %% Plotting keypoints
    fprintf("%s\n", Title_name)
    nexttile
    imshow(Image);
    hold on
    plot(SIFT_points.selectStrongest(100))
    title("SIFT")

    text_string = sprintf("SIFT computation time: %.4f\nSIFT number of points: %d\n\n", SIFT_computation_time, length(SIFT_points));
    annotation('textbox', [0.13 0.52 0.14 0.06],'String', text_string);
    fprintf(text_string);

    nexttile
    imshow(Image);
    hold on
    plot(SURF_points.selectStrongest(100))
    title("SURF")
    
    text_string = sprintf("SURF computation time: %.4f\nSURF number of points: %d\n\n", SURF_computation_time, length(SURF_points));
    annotation('textbox', [0.43 0.52 0.14 0.06],'String', text_string);
    fprintf(text_string);

    nexttile
    imshow(Image);
    hold on
    plot(FAST_points.selectStrongest(100))
    title("FAST")
    
    text_string = sprintf("FAST computation time: %.4f\nFAST number of points: %d\n\n", FAST_computation_time, length(FAST_points));
    annotation('textbox', [0.73 0.52 0.14 0.06],'String', text_string);
    fprintf(text_string);

    nexttile
    imshow(Image);
    hold on
    plot(KAZE_points.selectStrongest(100))
    title("KAZE")
    
    text_string = sprintf("KAZE computation time: %.4f\nKAZE number of points: %d\n\n", KAZE_computation_time, length(KAZE_points));
    annotation('textbox', [0.12 0.045 0.14 0.06],'String', text_string);
    fprintf(text_string);

    nexttile
    imshow(Image);
    hold on
    plot(ORB_points.selectStrongest(100))
    title("ORB")
    
    text_string = sprintf("ORB computation time: %.4f\nORB number of points: %d\n\n", ORB_computation_time, length(ORB_points));
    annotation('textbox', [0.43 0.045 0.14 0.06],'String', text_string);
    fprintf(text_string);
    
    nexttile
    imshow(Image);
    hold on
    plot(BRISK_points.selectStrongest(100))
    title("BRISK")
    
    text_string = sprintf("BRISK computation time: %.4f\nBRISK number of points: %d\n\n", BRISK_computation_time, length(BRISK_points));
    annotation('textbox', [0.73 0.045 0.14 0.06],'String', text_string);
    fprintf(text_string);

    fprintf("=======================================================\n\n")
    
    %% Saving point data
    Point_extraction_metrics(1:end-2,i)=[SIFT_computation_time;length(SIFT_points);
                                   SURF_computation_time;length(SURF_points);
                                   FAST_computation_time;length(FAST_points);
                                   KAZE_computation_time;length(KAZE_points);
                                   ORB_computation_time;length(ORB_points);
                                   BRISK_computation_time;length(BRISK_points)];


    save_name = sprintf("../../Results/Point Extraction/Extraction points metrics - Image %d ( %s).png", i, Image_names(i));
    saveas(figure_handler, save_name)
    
    Image_split = strsplit(Image_names(i),'.');
    save_name = sprintf("../../Data/%s_points.mat", Image_split(1));
    save(save_name, "SIFT_points", "SURF_points", "FAST_points", "KAZE_points", "ORB_points", "BRISK_points");
    
    
    %% Patch plotting

    %Filtering the points that are too close too the margim
    patch_points1 = select_patches(SIFT_points, side, Gray_image, N_points);
    patch_points2 = select_patches(SURF_points, side, Gray_image, N_points);
    patch_points3 = select_patches(FAST_points, side, Gray_image, N_points);
    patch_points4 = select_patches(KAZE_points, side, Gray_image, N_points);
    patch_points5 = select_patches(ORB_points, side, Gray_image, N_points);
    patch_points6 = select_patches(BRISK_points, side, Gray_image, N_points);

    patch_fig_handler = figure;
    patch_fig_handler.WindowState = "maximized";
    tiledlayout(6,N_points);
    
    for j = 1:length(patch_points1)
        nexttile
        imshow(Gray_image(patch_points1(j,2) - side : patch_points1(j,2) + side, patch_points1(j,1) - side : patch_points1(j,1) + side))
        hold on
        scatter(side,side, "g+")
        title_name = sprintf("SIFT patch %d",j);
        title(title_name);

    end
    for j = 1:length(patch_points2)
        nexttile
        imshow(Gray_image(patch_points2(j,2) - side : patch_points2(j,2) + side, patch_points2(j,1) - side : patch_points2(j,1) + side))
        hold on
        scatter(side,side, "g+")
        title_name = sprintf("SURF patch %d",j);
        title(title_name);
    end
    for j = 1:length(patch_points3)
        nexttile
        imshow(Gray_image(patch_points3(j,2) - side : patch_points3(j,2) + side, patch_points3(j,1) - side : patch_points3(j,1) + side))
        hold on
        scatter(side,side, "g+")
        title_name = sprintf("FAST patch %d",j);
        title(title_name);
    end
    for j = 1:length(patch_points4)
        nexttile
        imshow(Gray_image(patch_points4(j,2) - side : patch_points4(j,2) + side, patch_points4(j,1) - side : patch_points4(j,1) + side))
        hold on
        scatter(side,side, "g+")
        title_name = sprintf("KAZE patch %d",j);
        title(title_name);
    end
    for j = 1:length(patch_points5)
        nexttile
        imshow(Gray_image(patch_points5(j,2) - side : patch_points5(j,2) + side, patch_points5(j,1) - side : patch_points5(j,1) + side))
        hold on
        scatter(side,side, "g+")
        title_name = sprintf("ORB patch %d",j);
        title(title_name);
    end
    for j = 1:length(patch_points6)
        nexttile
        imshow(Gray_image(patch_points6(j,2) - side : patch_points6(j,2) + side, patch_points6(j,1) - side : patch_points6(j,1) + side))
        hold on
        scatter(side,side, "g+")
        title_name = sprintf("BRISK patch %d",j);
        title(title_name);
    end
    
    save_name = sprintf("../../Results/Point Extraction/Patches-Image %d ( %s).png", i, Image_names(i));
    saveas(patch_fig_handler, save_name)
end

%saving variables for future use
save("../../Data/Extracted_points_info.mat","Image_paths","Image_names","Point_extraction_metrics_index");

%saving matrix because there'ss one algorithm left, AGAST
writematrix(Point_extraction_metrics,'../../Data\Points_extraction_metrics.txt')




