function [Accuracy, Precision, Recall] = Show_metrics(img1, img2, Points1, Points2, Match_index, H, Threshold)
    %This function is responsable for calculating the used metrics and show
    %the resultant matches
    
    %Check if there is a match or not
    if ~isempty(Match_index)
        %Create the list of points that are matched
        Valid_points1 = Points1(Match_index(:,1));
        Valid_points2 = Points2(Match_index(:,2));
        MatchList = [ceil(flip(Valid_points1.Location,2)) ceil(flip(Valid_points2.Location,2))];

        %Check for the correct matched points, creating a checklist to be
        %used for showing the correct matches and calculating the metrics
        if ~isempty(H)
            Pts1=[MatchList(:,2) MatchList(:,1)];
            Pts2=[MatchList(:,4) MatchList(:,3)];
        
            Label = ComputeH(Pts1,H);
        
            Distance = sqrt( (Pts2(:,1)-Label(:,1)).^2 + (Pts2(:,2)-Label(:,2)).^2);
        
            CheckList = Distance<=Threshold;
        end
        
        %Case images have a diferent number of rows and the diference
        %between sizes is just 1
        if rem(size(img2,1),2)~=0
            img2=img2(2:size(img2,1),:);
        end
        if rem(size(img2,2),2)~=0
            img2=img2(:,2:size(img2,2));
        end
        if rem(size(img1,1),2)~=0
            img1=img1(2:size(img1,1),:);
        end
        if rem(size(img1,2),2)~=0
            img1=img1(:,2:size(img1,2));
        end
        
        %image size diferences are taken care here
        auxl=(size(img1,1)-size(img2,1))/2;
        auxc=(size(img1,2)-size(img2,2))/2;
        
        auxl2=0;
        auxc2=0;
        
        %adaptative padding
        if auxl>0
            img2=padarray(img2,[abs(auxl),0]);
        else
            img1=padarray(img1,[abs(auxl),0]);
            auxl2=abs(auxl);
            auxl=0;
        end
        if auxc>0
            img2=padarray(img2,[0,abs(auxc)]);
        else
            img1=padarray(img1,[0,abs(auxc)]);
            auxc2=abs(auxc);
            auxc=0;
        end
        
        %Join both images
        IMGEXT=[img1 img2];
        
        %Scatterplot of the keypoints
        scatter(MatchList(:,2)+auxc2 ,MatchList(:,1)+auxl2)
        hold on
        scatter(size(img1,2)+auxc+MatchList(:,4) ,auxl+MatchList(:,3))
        hold on
        
        %Lines and points plot
        for i=1:size(MatchList,1)
            if ~isempty(H)
                if CheckList(i)==1
                    plot([MatchList(i,2)+auxc2 size(img1,2)+auxc+MatchList(i,4)],[MatchList(i,1)+auxl2 MatchList(i,3)+auxl],'g','LineWidth',1.2);
                else
                    plot([MatchList(i,2)+auxc2 size(img1,2)+auxc+MatchList(i,4)],[MatchList(i,1)+auxl2 MatchList(i,3)+auxl],'r','LineWidth',1.2);
                end
            else
                plot([MatchList(i,2)+auxc2 size(img1,2)+auxc+MatchList(i,4)],[MatchList(i,1)+auxl2 MatchList(i,3)+auxl],'y','LineWidth',1.2);
            end
            hold on
        end
        Pimg=imshow(IMGEXT);
        uistack(Pimg, 'bottom');
        
        %Here the metrics are calculated without the use of any loop
        TP = sum(CheckList);
        FP = sum(CheckList==0);
        
        unMatch_index1 = setdiff(1:size(Points1), Match_index(:,1));
        unMatch_index2 = setdiff(1:size(Points2), Match_index(:,2));
        
        unMatched_points1 = Points1.Location(unMatch_index1,:);
        unMatched_points2 = Points2.Location(unMatch_index2,:);
    
        %Calculate the location of the points that were not matched
        Calculated_unMatched_points2 = ComputeH(unMatched_points1, H);
        mask1 = Calculated_unMatched_points2(:,1)>size(img2,2);
        mask2 = Calculated_unMatched_points2(:,1)<1;
        mask3 = Calculated_unMatched_points2(:,2)>size(img2,1);
        mask4 = Calculated_unMatched_points2(:,2)<1;
        mask = mask1 | mask2 | mask3 | mask4;
        
        TN = sum(mask);
        FN = length(unMatched_points1)-TN;
    
        %Metric calculation
        Accuracy = (TP + TN) / (TP + FP + TN +FN);
        Precision = TP/(TP + FP);
        Recall = TP/(TP+FN);
    else
        %If theres no matches, the metrics are 0
        Accuracy=0;
        Precision=0;
        Recall=0;
    end
end