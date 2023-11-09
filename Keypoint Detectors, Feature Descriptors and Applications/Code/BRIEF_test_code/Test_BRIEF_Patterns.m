close all; clear; clc;

%BRIEF parameters
patch_size = 41;
N_pairs = 512;

%Get the patterns that are going to be used
pattern1 = create_BRIEF_pattern(1, patch_size, N_pairs);
pattern2 = create_BRIEF_pattern(2, patch_size, N_pairs);
pattern3 = create_BRIEF_pattern(3, patch_size, N_pairs);
pattern4 = create_BRIEF_pattern(4, patch_size, N_pairs);
pattern5 = create_BRIEF_pattern(5, patch_size, N_pairs);

fig_handler = figure;
tiledlayout(2,6)
nexttile([1,2])

%Plot all the available methods
title("Method 1")
for i=1:length(pattern1)
    line([pattern1(i,1) pattern1(i,3)],[pattern1(i,2) pattern1(i,4)])
    hold on
end
xlim([0 patch_size+1])
ylim([0 patch_size+1])
grid on

nexttile([1,2])

title("Method 2")
for i=1:length(pattern2)
    line([pattern2(i,1) pattern2(i,3)],[pattern2(i,2) pattern2(i,4)])
    hold on
end
xlim([0 patch_size+1])
ylim([0 patch_size+1])
grid on

nexttile([1,2])

title("Method 3")
for i=1:length(pattern3)
    line([pattern3(i,1) pattern3(i,3)],[pattern3(i,2) pattern3(i,4)])
    hold on
end
xlim([0 patch_size+1])
ylim([0 patch_size+1])
grid on

nexttile([1,3])

title("Method 4")
for i=1:length(pattern4)
    line([pattern4(i,1) pattern4(i,3)],[pattern4(i,2) pattern4(i,4)])
    hold on
end
xlim([0 patch_size+1])
ylim([0 patch_size+1])
grid on

nexttile([1,3])

title("Method 5")
for i=1:length(pattern5)
    line([pattern5(i,1) pattern5(i,3)],[pattern5(i,2) pattern5(i,4)])
    hold on
end
xlim([0 patch_size+1])
ylim([0 patch_size+1])
grid on

%Print method details
fprintf("Method 1 - Random sampling\n")
fprintf("Method 2 - Gaussian sampling\n")
fprintf("Method 3 - Gaussian of a Gaussian sampling\n")
fprintf("Method 4 - Random polar grid sampling\n")
fprintf("Method 5 - Polar grid sampling\n")

%save figure
saveas(fig_handler,"../../Results/FAST_BRIEF_tests/BRIEF_patterns.png")

