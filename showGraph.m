function showGraph(Weight,data,partCluster)
npart = size(partCluster);
pointNum = size(data,1);
figure,plot(data(:,1),data(:,2),'.');
figure,
for i=1:pointNum
    for j=1:pointNum
        if Weight(i,j)>0
            plot([data(i,1),data(j,1)],[data(i,2),data(j,2)],'b-.'),hold on;
        end
    end
end
figure,
for t=1:npart
    numnode = size(partCluster{t},2);
    for i=1:numnode
        for j=1:numnode
            if Weight(partCluster{t}(i),partCluster{t}(j))>0
                plot([data(partCluster{t}(i),1),data(partCluster{t}(j),1)],[data(partCluster{t}(i),2),data(partCluster{t}(j),2)],'b-.'),
                hold on;
            end
        end
    end
end