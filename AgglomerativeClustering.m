function [clusterLabels, InitClusters] = AgglomerativeClustering(X, InitClusters, ClusterNumber, Weight, alpha)
%% Agglomerative clustering for chameleon.
% Inputs:
%	- X: the dataset
%   - InitClusters: a cell array of clustered vertices
%   - ClusterNumber: the final number of clusters
% Outputs:
%   - clusterLabels: 1 x m list whose i-th entry is the group assignment of
%                   the i-th data vector w_i. Groups are indexed
%                   sequentially, starting from 1. 
% by Tianyi Huang <weather33@126.com>
 

%% initialization

SampleNumber = size(X,1);
TClusterNumber = length(InitClusters); % The real-time number of the clusters.
if TClusterNumber < ClusterNumber
    error('GAC: too few initial clusters. Do not need merging!');
end

%% Compute initial  affinity table.

AffinityTabRI = zeros(TClusterNumber);
AffinityTabRC = zeros(TClusterNumber);
for j = 1 : TClusterNumber
    for i = 1 : j-1
         AffinityTabRI(i, j) = calculRC(InitClusters{i}, InitClusters{j},Weight); 
         AffinityTabRC(i, j) = calculRI(InitClusters{i}, InitClusters{j},Weight);
    end
end
AffinityTab =  AffinityTabRI .* ( AffinityTabRC .^ alpha);
%% Merge the clusters.

while TClusterNumber > ClusterNumber
    if mod( TClusterNumber, 20 ) == 0 
        disp(['   Group count: ' num2str(TClusterNumber)]);
    end
    
    % Find two clusters with the best affinity. 
    [MinAff, MinIndex1] = max(AffinityTab, [], 1);
    [~, MinIndex2] = max(MinAff);
    MinIndex1 = MinIndex1(MinIndex2);
    
    % merge the two clusters as the new cluster.
    NewCluster = unique([InitClusters{MinIndex1}; InitClusters{MinIndex2}]);
    InitClusters{MinIndex1} = NewCluster;
    InitClusters(MinIndex2) = [];
    AffinityTab(:, MinIndex2) = [];
    AffinityTab(MinIndex2, :) = [];
    TClusterNumber = TClusterNumber - 1;
    
    % Update the affinity table for the merged cluster.
    for Index = 1:MinIndex1-1
        Ri = calculRI(InitClusters{Index}, InitClusters{MinIndex1},Weight);
        Rc = calculRC(InitClusters{Index}, InitClusters{MinIndex1},Weight);
        AffinityTab(Index, MinIndex1) = Ri*(Rc.^alpha);
    end
    for Index = MinIndex1+1:TClusterNumber
        Ri = calculRI(InitClusters{Index}, InitClusters{MinIndex1},Weight);
        Rc = calculRC(InitClusters{Index}, InitClusters{MinIndex1},Weight);
        AffinityTab(MinIndex1, Index) = Ri*(Rc.^alpha);
    end
end

%% generate sample labels

clusterLabels = zeros(SampleNumber,1);
for i = 1:length(InitClusters)
    clusterLabels(InitClusters{i}) = i;
end

disp(['Final group count: ' num2str(TClusterNumber)]);

end