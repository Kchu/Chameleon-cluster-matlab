function RI = calculRI(Cluster1, Cluster2, Weight)
EC_12 =  sum(sum(Weight(Cluster1,Cluster2)));
EC_1 = calculEC(Cluster1, Weight);
EC_2 = calculEC(Cluster2, Weight);
RI = 2*(EC_12)/(EC_1+EC_2);