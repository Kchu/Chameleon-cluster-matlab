function showClusterGraph(data, partCluster)
npart = size(partCluster,1);
Colors = hsv(npart);
figure,
subplot(1,2,1);
plot(data(:,1),data(:,2),'.');
subplot(1,2,2);
% Legends = {};
for t=1:npart
    numnode = size(partCluster{t},2);
    colormap = Colors(t,:);
    for i=1:numnode
        plot(data(partCluster{t}(i),1),data(partCluster{t}(i),2),'.','color',colormap),hold on;
    end
%     Legends{t} = ['Cluster ' num2str(t)];
end
% legend(Legends);