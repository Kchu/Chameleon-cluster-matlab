function [Branches,numBranch]=Net_Branches(ConnectMatrix) 
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% This program is designed to count the calculate connected components in networks.
% Usage [Cp_Average, Cp_Nodal] = Net_ClusteringCoefficients(ConnectMatrix,Type)
% Input:
% ConnectMatrix --- The connect matrix without self-edges.
% Output:
% Branches --- A matrix, each rows of which represents the
% different connected components. 
% numBranch --- The numbers of connected
% components in network 
%
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
% Refer: 
% Ulrik Barandes <A faster algorithm for betweennes centrality> 
% Written by Hu Yong, Nov,2010 
% E-mail: carrot.hy2010@gmail.com 
% based on Matlab 2008a 
% Version (1.0),Copywrite (c) 2010 
% Input check-------------------------------------------------------------%
[numNode,I] = size(ConnectMatrix); 
if numNode ~= I; error('Pls check your connect matrix'); end
% End check---------------------------------------------------------------% 
Node = (1:numNode); Branches = []; 
while any(Node)
    Quence = find(Node,1); %find a non-zero number in Node set 
    subField=[]; %one component 
    % start search
    while ~isempty(Quence) 
        currentNode = Quence(1); Quence(1) = []; %dequeue 
        subField=[subField,currentNode];
        Node(currentNode)=0; 
        neighborNode=find(ConnectMatrix(currentNode,:));
        for i=neighborNode 
            if Node(i) ~= 0 %first found 
                Quence=[Quence,i]; 
                Node(i)=0; 
            end
        end
    end
    subField = [subField,zeros(1,numNode-length(subField))]; 
    Branches = [Branches;subField]; %save 
end
numBranch = size(Branches,1);