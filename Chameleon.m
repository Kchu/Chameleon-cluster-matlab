%function [labels, centroids] = Chameleon(data, k, alpha, minMatrix)
%
%                    Matlab code for Chameleon algorithm
%                    Written by Lab of GRC & AI
%
%%%%%%%%%%%%%%%%%%%%%%%%%%   Input   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% data:  data matrix (n*d), the ith instance of training instance is
%        stored in train_data(i,:)
% k:     the parameter of the Knn graph
% alpha:
%%%%%%%%%%%%%%%%%%%%%%%%%%   Output   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% labels: clustering labels
% centroids: clustering centroidsssss

%%%%%%%%%%%%%%%% phase 1%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Initialization
clear all;
load('t4_8k.mat') %k = 10 a = 1 ClusterNumber = 25 alpha = 2
%load('Aggregation.mat') %k = 10 a = 1 ClusterNumber = 7 alpha = 2
%load('three_cluster.mat') k = 10 a = 1 ClusterNumber = 3 alpha = 2
%load('iris.mat') k = 10 a = 1 ClusterNumber = 2 alpha = 2
data = X;
k = 10;
alpha = 2;
a = 1;
numCluster = 25;                     % number of the cluster
numNode = size(data,1);              % number of the nodes
Weight = zeros(numNode,numNode);     % Weight Matrix
%partCluster = cell(npart, 1);       % initialize the small cluster after

%% Set up weight(distance) matrix
dist = dis2(data,data);              %
dist = dist - diag(diag(dist));      %
% tempWeight = 10000 ./ dist;
% tempWeight(tempWeight == inf) = 0;
% %% Connect the nearest k node
% [~,index] = sort(tempWeight,2,'descend');                      % sort the Weight
% for p=1:numNode
%     for q=1:k                                              % the nearest k node
%         Weight(p,index(p,q))=tempWeight(p,index(p,q));     % assign edges
%         %Weight(index(p,q),p)=sortWeight(p,index(p,q));     % assign the symmetric one
%     end
% end
% Weight = max(Weight,Weight');

%% Partition the Graph according to METIS
% hypInput = Hypinputfile(Weight, k);              % build the input file of the gpmetis
% ExeFileName = 'gpmetis.exe';                
% param1 = ['hypInput.txt'];
% param2 = num2str(npart); 
% %Cmd=[ExeFileName,' ','-contig',' ',param1,' ', param2];   
% Cmd=[ExeFileName,' ',param1,' ', param2];
% system(Cmd);                                            % call gpmetis function
% FileName = ['hypinput.txt.part','.',num2str(npart)];    
% load(FileName);                                         % import the output file 
%                                                         % of the gpmetis
% for r=1:numNode
%     partCluster{hypinput_txt_part(r)+1}=[partCluster{hypinput_txt_part(r)+1} r];
% end
[graphW, NNIndex] = gacBuildDigraph(dist, k, a);   
partCluster = gacNNMerge(dist, NNIndex);
[ClusterLabels, FinalClusters] = AgglomerativeClustering(data, partCluster,numCluster, graphW, alpha);

%% show the results
%showGraph(Weight,data, partCluster);    % show the knn graph and partition graph 
PlotClusterinResult(data, ClusterLabels) % show the result of the clustering