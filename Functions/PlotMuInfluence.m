function [] = PlotMuInfluence(kvec,vertices)
%PLOTMUINFLUENCE Summary of this function goes here
%   Detailed explanation goes here
colorvec = {'-xr','-xb','-xg','-xy'}; % define the color of the five first graphs
vertvec = linspace(1,vertices,length(kvec(1,:)));
 figure
j=1;
for i=1:size(kvec,1)
    if j < 5
        plot(vertvec,kvec(i,:),colorvec{j})
    else 
        plot(vertvec,kvec(i,:))
    end
j = j+1;
hold on
end
 grid on
 set(gcf,'color','w');
 xlim([vertvec(1) vertvec(end)])
 xlabel('Vertices')
 
end

