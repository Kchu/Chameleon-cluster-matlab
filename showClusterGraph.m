function showClusterGraph(data, partCluster)
npart = size(partCluster,1);
Colors = hsv(npart);
figure,plot(data(:,1),data(:,2),'.');
figure,
for t=1:npart
    numnode = size(partCluster{t},2);
    colormap = Colors(t,:);
    for i=1:numnode
        plot(data(partCluster{t}(i),1),data(partCluster{t}(i),2),'*','color',colormap),hold on;
    end
end