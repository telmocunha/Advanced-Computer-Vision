from cmath import sqrt
from re import M
from select import select
from turtle import shape
import cv2 as cv
import numpy as np
import glob
import os
import time
from os import system, name
from matplotlib import pyplot as plt
from numpy import linalg as LA

#function that calculate the metrics Accuracy, Precision and Recall
def metrics(Points_1, Points_2, good, H, img1_size, img2_size, Threshold):
    
    if len(Points_1)>len(Points_2):
        aux = Points_1
        Points_1 = Points_2
        Points_2 = aux

        aux = img1_size
        img1_size = img2_size
        img2_size = aux
    
    #Point object to point coordinates
    Points_1 = cv.KeyPoint_convert(Points_1)
    Points_2 = cv.KeyPoint_convert(Points_2)
   
    selected = np.zeros(shape=(1,2))

    TP = 0
    FP = 0
    TN = 0
    FN = 0

    Points1_used_index = []
    Points2_used_index = []

    #Loop to calculate TP's and FP's
    for m in good:
        point1_original = Points_1[m[0].queryIdx,:]
        point2_original = Points_2[m[0].trainIdx,:]

        aux = np.transpose(np.append(point1_original,1).reshape(1,3))
        aux = np.matmul(H, aux)

        point2_calculated = [aux[0][0]/aux[2][0], aux[1][0]/aux[2][0]]

        diff_x = (point2_calculated[0] - point2_original[0])
        diff_y = (point2_calculated[1] - point2_original[1])
       
        dist = sqrt(pow(diff_x,2) + pow(diff_y,2))

        if LA.norm(dist) < Threshold:
            TP= TP + 1
        else:
            FP = FP + 1

        Points1_used_index.append(m[0].queryIdx) 
        Points2_used_index.append(m[0].trainIdx)
    
    H_inv = np.linalg.inv(H)
    counter = 1
    #Loop to calculate TN's and FN's
    for i in range(len(Points_2)):
        if i in Points2_used_index:
            continue
        
        point2_original = Points_2[i,:]
        aux = np.transpose(np.append(point2_original,1).reshape(1,3))
        aux = np.matmul(H_inv, aux)

        point1_calculated = [aux[0][0]/aux[2][0], aux[1][0]/aux[2][0]]

        if point1_calculated[0] < 0 or point1_calculated[1] < 0 or point1_calculated[0]>img1_size[1] or point1_calculated[0]>img1_size[0]:
            TN = TN + 1
        else:
            FN = FN + 1

    #Metric calculation
    Accuracy = (TP + TN) / (TP + FP + TN + FN)
    Precision = TP / (TP + FP)
    Recall = TP/(TP+FN)

    metrics_eval = [Accuracy,Precision,Recall]
    return metrics_eval

system('cls')
N_plot_points = 100 

#Image paths with respective extension
dir_path_png = "../../graf/*.png"
dir_path_jpg = "../../graf/*.jpg"
dir_path_ppm = "../../graf/*.ppm"

png_files = glob.glob(dir_path_png)
jpg_files = glob.glob(dir_path_jpg)
ppm_files = glob.glob(dir_path_ppm)

path_list = []
name_list = []

#Check all the files in the directory for those 3 extensions
i = 0
j = 0
while j < len(ppm_files):
    path_list.append(ppm_files[j])
    name_list.append(os.path.basename(ppm_files[j]))
    i = i + 1
    j = j + 1

j = 0
while j < len(png_files):
    path_list.append(png_files[j])
    name_list.append(os.path.basename(png_files[j]))
    i = i + 1
    j = j + 1

j = 0
while j < len(jpg_files):
    path_list.append(jpg_files[j])
    name_list.append(os.path.basename(jpg_files[j]))
    i = i + 1
    j = j + 1

print("=======================================DETECTORS=======================================")

agast = cv.AgastFeatureDetector_create() #AGAST detector object

#load txt metrics for update
metrics_matrix = np.loadtxt('..\..\Data\Points_extraction_metrics.txt', delimiter=",")

#Run the detector on all the images inserted
for i in range(len(path_list)):
    img = cv.imread(path_list[i])
    gray_img = cv.cvtColor(img, cv.COLOR_BGR2GRAY)

    start_time = time.time()
    points = agast.detect(gray_img, None)
    computation_time = time.time() - start_time

    #save computation time and number of points calculated
    metrics_matrix[-2,i] = round(computation_time,7)
    metrics_matrix[-1,i] = len(points)

    image_with_points = cv.drawKeypoints(gray_img, points[::round(len(points)/100)], None, color=(0, 255, 0)) #insert points in the image

    aux= name_list[i].split('.')
    img_name = aux[0]
    cv.imwrite('..\..\Results\Point Extraction\AGAST_'+img_name+'.png', image_with_points) #save iamge
    cv.imshow(os.path.basename(path_list[i]), image_with_points) 

    print("Image",i + 1, "-" , os.path.basename(path_list[i]))
    print("Computation time:",computation_time)
    print("Number of points:", len(points))
    print()

np.savetxt("..\..\Data\Points_extraction_metrics_py.txt",metrics_matrix, delimiter=",") #update the matrix

cv.waitKey(0)
cv.destroyAllWindows()

print("======================================DESCRIPTORS======================================")
print()

#get homography matrixes
homografy_paths = ['../../graf/H1to2p.txt','../../graf/H1to2p.txt']

#create descriptor objects
BRIEF = cv.xfeatures2d.BriefDescriptorExtractor_create()
FREAK = cv.xfeatures2d.FREAK_create()
BRISK = cv.BRISK_create()

bf = cv.BFMatcher() #create brute force matcher object

img = cv.imread(path_list[0])
Image1 = cv.cvtColor(img, cv.COLOR_BGR2GRAY)

#get descriptors of the first image
AGAST_points_1 = agast.detect(Image1, None)
BRIEF_points_1, BRIEF_Desc_1 = BRIEF.compute(Image1, AGAST_points_1)
FREAK_points_1, FREAK_Desc_1 = FREAK.compute(Image1, AGAST_points_1)
BRISK_points_1, BRISK_Desc_1 = BRISK.compute(Image1, AGAST_points_1)

#get descriptors of the other images and match them with the fist image
for i in range(1,len(path_list)):
    homography = np.loadtxt(homografy_paths[i-1])

    img = cv.imread(path_list[i])
    Image2 = cv.cvtColor(img, cv.COLOR_BGR2GRAY)

    AGAST_points_2 = agast.detect(Image2, None)

    #get descriptor of the image
    BRIEF_points_2, BRIEF_Desc_2 = BRIEF.compute(Image2, AGAST_points_2)
    FREAK_points_2, FREAK_Desc_2 = FREAK.compute(Image2, AGAST_points_2)
    BRISK_points_2, BRISK_Desc_2 = BRISK.compute(Image2, AGAST_points_2)

    #Match this loop image with the first image
    BRIEF_matches = bf.knnMatch(BRIEF_Desc_1, BRIEF_Desc_2, k=2)
    FREAK_matches = bf.knnMatch(FREAK_Desc_1, FREAK_Desc_2, k=2)
    BRISK_matches = bf.knnMatch(BRISK_Desc_1, BRISK_Desc_2, k=2)
    
    #Ratio test to get the best matches
    good_BRIEF = []
    good_FREAK = []
    good_BRISK = []

    for m, n in BRIEF_matches:
        if m.distance < 0.7 * n.distance:
            good_BRIEF.append([m])
    for m, n in FREAK_matches:
        if m.distance < 0.7 * n.distance:
            good_FREAK.append([m])   
 
    for m, n in BRISK_matches:
        if m.distance < 0.7 * n.distance:
            good_BRISK.append([m])

    #draw the best matches obtain by the matcher
    img_BRIEF = cv.drawMatchesKnn(Image1, BRIEF_points_1, Image2, BRIEF_points_2, good_BRIEF, None, flags=cv.DrawMatchesFlags_NOT_DRAW_SINGLE_POINTS)
    img_FREAK = cv.drawMatchesKnn(Image1, FREAK_points_1, Image2, FREAK_points_2, good_FREAK, None, flags=cv.DrawMatchesFlags_NOT_DRAW_SINGLE_POINTS)
    img_BRISK = cv.drawMatchesKnn(Image1, BRISK_points_1, Image2, BRISK_points_2, good_BRISK, None, flags=cv.DrawMatchesFlags_NOT_DRAW_SINGLE_POINTS)

    BRIEF_fig = plt.figure(1)
    plt.imshow(img_BRIEF)
    plt.title("AGAST + BRIEF - Correspondences 1 - "+str(i+1))

    FREAK_fig = plt.figure(2)
    plt.imshow(img_FREAK)
    plt.title("AGAST + FREAK - Correspondences 1 - "+str(i+1))

    BRISK_fig = plt.figure(3)
    plt.imshow(img_BRISK)
    plt.title("AGAST + BRISK - Correspondences 1 - "+str(i+1))

    plt.show()
    cv.waitKey(0)

    #Calculate all the metrics
    eval1 = metrics(BRIEF_points_1, BRIEF_points_2, good_BRIEF, homography, Image1.shape, Image2.shape, 20)
    eval2 = metrics(FREAK_points_1, FREAK_points_2, good_FREAK, homography, Image1.shape, Image2.shape, 20)
    eval3 = metrics(BRISK_points_1, BRISK_points_2, good_BRISK, homography, Image1.shape, Image2.shape, 20)

    print("(AGAST + BRIEF) Correspondences 1 - " + str(i+1) + ":\tAccuracy:", round(eval1[0],4), "Precision:", round(eval1[1],4),"Recall:", round(eval1[2],4), "Matched points: ", len(good_BRIEF))
    print("(AGAST + FREAK) Correspondences 1 - " + str(i+1) + ":\tAccuracy:", round(eval2[0],4), "Precision:", round(eval2[1],4),"Recall:", round(eval2[2],4), "Matched points: ", len(good_FREAK))
    print("(AGAST + BRISK) Correspondences 1 - " + str(i+1) + ":\tAccuracy:", round(eval2[0],4), "Precision:", round(eval3[1],4),"Recall:", round(eval3[2],4), "Matched points: ", len(good_BRISK))

    print()
    

    
    








