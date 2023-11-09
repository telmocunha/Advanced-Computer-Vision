% EXERCISE2: learn your own model
close all; clear; clc;

% add required search paths
setup ;

% --------------------------------------------------------------------
% Stage A: Data Preparation
% --------------------------------------------------------------------

encoding = 'fv' ;

encoder = load(sprintf('data/encoder_%s.mat',encoding)) ;

% Compute positive histograms from your own images
pos.names = getImageSet('data/myImages') ;
if numel(pos.names) == 0, error('Please add some images to data/myImages before running this exercise') ; end

%% 
pos.histograms = encodeImage(encoder, pos.names, ['data/cache_' encoding]) ;

%% 

writematrix(pos.histograms,"train_images_fv.txt", Delimiter=" ");

%% 
folderPath = "data/myImages";
files = dir(fullfile(folderPath + "/*.jpg"));
Img_num = length(files);

dim = 200;

N_classes_age = 10;

max_age = -999;
for i=1:Img_num
    label = split(files(i).name,"_");
    label = str2num(label{1});
    if label>max_age
        max_age=label;
    end
end

separation = ceil(max_age/N_classes_age);

labels=[];
for i=1:Img_num

    label = split(files(i).name,"_");
    label = str2num(label{1});

    labels(i)=floor((label+1)/separation);

end

pos.labels = labels;
%% 

test_racio = 0.25;
tes_num = ceil(size(pos.histograms,2) * test_racio);

histograms = pos.histograms(:,1:end-tes_num);
testHistograms = pos.histograms(:,1:end-tes_num);

labels = pos.labels(:,1:end-tes_num);
testLabels = pos.labels(:,1:end-tes_num);

names = pos.names(:,1:end-tes_num);
testNames = pos.names(:,1:end-tes_num);

% Hellinger's kernel
% histograms = sign(histograms).*sqrt(abs(histograms)) ;
% testHistograms = sign(testHistograms).*sqrt(abs(testHistograms)) ;

% L2 normalize the histograms before running the linear SVM
% histograms = bsxfun(@times, histograms, 1./sqrt(sum(histograms.^2,1))) ;
% testHistograms = bsxfun(@times, testHistograms, 1./sqrt(sum(testHistograms.^2,1))) ;

%% 
% --------------------------------------------------------------------
% Stage B: Training a classifier
% --------------------------------------------------------------------

% Train the linear SVM
C = 10 ;
[w, bias] = trainLinearSVM(histograms, labels, C) ;

% Evaluate the scores on the training data
scores = w' * histograms + bias ;

%%
% Visualize the ranked list of images
 figure(1) ; clf ; set(1,'name','Ranked training images (subset)') ;
 displayRankedImageList(names, scores)  ;

% Visualize the precision-recall curve
 figure(2) ; clf ; set(2,'name','Precision-recall on train data') ;
 vl_pr(labels, scores) ;

%% 

% Test the linar SVM
testScores = w' * testHistograms + bias ;

% Visualize the ranked list of images
figure(3) ; clf ; set(3,'name','Ranked test images (subset)') ;
displayRankedImageList(testNames, testScores)  ;

% Visualize the precision-recall curve
figure(4) ; clf ; set(4,'name','Precision-recall on test data') ;
vl_pr(testLabels, testScores) ;

% Print results
[drop,drop,info] = vl_pr(testLabels, testScores) ;
fprintf('Test AP: %.2f\n', info.auc) ;

[drop,perm] = sort(testScores,'descend') ;
fprintf('Correctly retrieved in the top 36: %d\n', sum(testLabels(perm(1:36)) > 0)) ;

%%
plot(histograms(:,1))
hold on
plot(histograms(:,2))
hold on
plot(histograms(:,5))

xlim([0 size(histograms,1)])




