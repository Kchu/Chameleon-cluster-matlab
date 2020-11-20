function RC = calculRC(Cluster1, Cluster2, Weight)
num1 = size(Cluster1,2);
num2 = size(Cluster2,2);

EC_1 = calculEC(Cluster1, Weight);
EC_2 = calculEC(Cluster2, Weight);

EC_12 =  sum(sum(Weight(Cluster1,Cluster2)));
EC_12 = (EC_12)/2;
RC = ((num1+num2) * EC_12) / (num1 * EC_1 + num1 * EC_2);