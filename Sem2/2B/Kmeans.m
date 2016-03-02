filename='faithful.txt';
delimiterIn='\t';
headerlinesIn=1;   %skip the first ones
file_data=importdata(filename,delimiterIn,headerlinesIn);
A=file_data.data;
% K-means algorithm
centres=[2 90; 5 50];  %pick random  points
K=size(centres,1); %number of clusers
[N, dim]=size(A);
maxiter=100; %maximum number of iterations
D=zeros(K,N); %KxN matrix for storing distance between
              % cluster centres and observations


fprintf('[0] Iteration: ')
centres     %show cluster centres at each iteration

%Iterate 'maxiter' times
for i=1:maxiter
    %Compute Squared Euclidean distance(
    
    for c=1:K
        D(c,:)=square_dist(A,centres(c,:));
    end
    
    % Assign data to clusters
    % Ds are the actual distances and 
    [Ds, idx]=min(D);
    
    %update cluster centres
    for c=1:K
        %check the number of samples assigned to this cluster
        if(sum(idx==c)==0)
            warn('k-means: cluster %d is empty,c');
        else
            centres(c,:)=mean(A(idx==c,:));
        end
    end
    
    fprintf('[%d] Iteration: ',i)
    centres
end
