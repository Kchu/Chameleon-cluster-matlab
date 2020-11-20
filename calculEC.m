function EC = calculEC(Cluster, Weight)
weight = Weight(Cluster,Cluster);
%[~,EC] = mincut(weight, 1);
EC = sum(sum(weight));

