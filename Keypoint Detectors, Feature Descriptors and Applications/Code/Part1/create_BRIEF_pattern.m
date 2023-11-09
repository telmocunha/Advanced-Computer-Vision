function [pattern] = create_BRIEF_pattern(flag_method, patch_size, N_pairs)
    % pattern is a matrix size (N_pairs)x4.
    % a line of the matrix pattern has the following format: [x1 y1 x2 y2]
    
    %Error checking
    if isempty(flag_method) || isempty(patch_size) || isempty(N_pairs)
        error("One of the variables is empty!")
    end
    if ~isnumeric(flag_method) || ~isnumeric(patch_size) || ~isnumeric(N_pairs)
        error("One of the variables type doesn't match a number!")
    end

    if flag_method<1 || flag_method>5
        error("flag_method variable doesn't have a valid value!")
    end
    if patch_size<1 || patch_size>1000
        error("patch_size variable doesn't have a valid value!")
    end
    if N_pairs<2 || N_pairs>1000
        error("N_pairs variable doesn't have a valid value!")
    end
    
    %Define pattern as zeros
    pattern = zeros(N_pairs,4);

    %first method, random sampling
    if flag_method == 1
        rng('shuffle', 'multFibonacci');
        pattern = randi([1 patch_size], [N_pairs 4]);
    end
    
    %Second method, gaussian sampling
    if flag_method == 2
        pattern = round(normrnd(patch_size/2,sqrt(0.04*patch_size^2),[N_pairs 4]));
    end
    
    %Third method, gaussian of a gaussian sampling
    if flag_method == 3
        pattern(:,1:2) = round(normrnd(patch_size/2,sqrt(0.04*patch_size^2),[N_pairs 2]));
        
        for i=1:N_pairs
            pattern(i,3) = round(normrnd(pattern(i,1),sqrt(0.01*patch_size^2),1));
            pattern(i,4) = round(normrnd(pattern(i,2),sqrt(0.01*patch_size^2),1));
        end
    end
    
    %Fouth method, polar random sampling
    if flag_method == 4
        rho = (patch_size/2)*rand([N_pairs 2]);
        theta = rand([N_pairs 2])*2*pi;
        
        pattern(:,1) = round((patch_size/2)+rho(:,1).*cos(theta(:,1)));
        pattern(:,2) = round((patch_size/2)+rho(:,1).*sin(theta(:,1)));
        pattern(:,3) = round((patch_size/2)+rho(:,2).*cos(theta(:,2)));
        pattern(:,4) = round((patch_size/2)+rho(:,2).*sin(theta(:,2)));
    end
    
    %Fifth method, uniform polar sampling
    if flag_method == 5
        rho = (patch_size/2)*rand([N_pairs 1]);
        theta = (linspace(0,2*pi,N_pairs))';
        
        pattern(:,1:2) = ceil(patch_size/2);

        pattern(:,3) = round((patch_size/2)+rho.*cos(theta));
        pattern(:,4) = round((patch_size/2)+rho.*sin(theta));
    end
    
    %returns the pattern
    pattern(pattern>patch_size) = patch_size;
    pattern(pattern<1) = 1;
end