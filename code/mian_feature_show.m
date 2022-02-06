clc;
clear;
rng(1);
MU = 10;
SIGMA = 1;
R = normrnd(MU,SIGMA,4,70);
for i = 1:4
    figure;
    imagesc(R(i,:));
    axis off;
end
