function hypInput = Hypinputfile(Weight, k)
%    converting adjacency matrix to hMETIS input file format
%    Written by Kun Chu (kun_chu@outlook.com), June 8th, 2018
%
%%%%%%%%%%%%%%%%%%%%%%%%%%   Input   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Weight:  Weight matrix (n*n), mutual weight between n points
% Weight:  Adjacency matrix (n*n), mutual weight between n points       
% k:     the parameter of the Knn graph
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%   Output   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% labels: clustering labels
% centroids: clustering centroids

%% 预处理Weight矩阵
numNode = size(Weight,1);       % get the number of nodes
intWeight = floor(Weight);      % round the weight matrix

%% 建立输入矩阵
hypInput = zeros(numNode+1, numNode);
hypInput(1,1) = numNode; 
hypInput(1,2) = sum(sum(Weight>0))/2; 
for p=1:numNode
    pos=1;
    for q=1:numNode
        if intWeight(p,q)>0
            hypInput(p+1,pos)=q;
            hypInput(p+1,pos+1)=intWeight(p,q);
            pos=pos+2;
        end
    end
end

%% 将矩阵写入txt文件
fid = fopen('hypInput.txt','wt');
fprintf(fid,'%c',num2str(hypInput(1,1)),' ');
fprintf(fid,'%c',num2str(hypInput(1,2)),' ');
fprintf(fid,'001');             % the standard flag of the input file
fprintf(fid,'%c\n','');

for x=2:numNode+1
    for y=1:length(find(hypInput(x,:)>0))
        p=num2str(hypInput(x,y));
        if y==length(find(hypInput(x,:)>0))
            fprintf(fid,'%c',' ',p);
            fprintf(fid,'%c\n','');
        else
            fprintf(fid,'%c',' ',p);
        end
    end
end
fclose(fid);