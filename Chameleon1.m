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
load('iris.mat');
% load('DS3.mat');
% data = DS3;
data = X;
k=10;
npart = 10;
alpha = 2.0;
minMatrix = 0.000005;
numNode = size(data,1);              % number of the nodes
Weight = zeros(numNode,numNode);     % Weight Matrix
% Ajacent Matrix
partCluster = cell(npart, 1);        % initialize the small cluster after
                                     % partition the graph


%% Set up weight(distance) matrix
dist = dis2(data,data);
dist = dist - diag(diag(dist));
tempWeight = 1./(dist);
tempWeight(isinf(tempWeight))=0;
tempWeight = floor(tempWeight*10000);

%% Connect the nearest k node
[~,index] = sort(tempWeight,2,'descend');                      % sort the Weight
for p=1:numNode
    for q=1:k                                              % the nearest k node
        Weight(p,index(p,q))=tempWeight(p,index(p,q));     % assign edges
    end
end
Weight= max(Weight, Weight');
%% Partition the Graph according to METIS
hypInput = Hypinputfile(Weight, k);              % build the input file of the gpmetis
ExeFileName = 'gpmetis.exe';                
param1 = ['hypInput.txt'];
param2 = num2str(npart); 
Cmd=[ExeFileName,' ',param1,' ', param2];               % command line
system(Cmd);                                            % call gpmetis function
FileName = ['hypinput.txt.part','.',num2str(npart)];    
load(FileName);                                         % import the output file 
                                                        % of the gpmetis
for r=1:numNode
    partCluster{hypinput_txt_part(r)+1}=[partCluster{hypinput_txt_part(r)+1} r];
end

%% Merge the similar cluster
mergeCluster = partCluster;
change = true;
while change
    change = false;
    for i=1:npart-1
        if isempty(mergeCluster{i})
                continue;
        end
        for j=i+1:npart
            if isempty(mergeCluster{j})
                continue;
            end
            EC_i = calculEC(mergeCluster{i}, Weight);
            EC_j = calculEC(mergeCluster{j}, Weight);
            ri = calculRI(mergeCluster{i}, mergeCluster{j}, EC_i, EC_j, Weight);
            rc = calculRC(mergeCluster{i}, mergeCluster{j}, EC_i, EC_j, Weight);
            if ri*(rc^alpha) > minMatrix
                mergeCluster{i} = [mergeCluster{i} mergeCluster{j}];
                mergeCluster{j} = [];
                change = true;
            end
        end
    end
end

%% show the results
showGraph(Weight,data, partCluster);   % show the knn graph and partition
                                       % graph
showClusterGraph(data, mergeCluster);  % show the result of the clustering