
addpath('../../LMIs')
addpath('../../Functions')
%% Global Fuzzy Descriptor System
 global DescriptorSystemDynamics


E_ = DescriptorSystemDynamics.E;
A_ = DescriptorSystemDynamics.A ;
Bu_ = DescriptorSystemDynamics.Bu;
Ba_ = DescriptorSystemDynamics.Ba;
C_ = DescriptorSystemDynamics.C;

%% To find which mu to use
disp('++++++++++++++++++++++++++++++++++++++++++++++++++')
disp('Now chosse the values for a linear search of which scalar Mu to use')
disp('This scalar must be greater than zero!')
Mumin = input('Choose the minimum value of mu:')
Mumax = input('Choose the maximum value of mu:')
deltaMu = input('Choose the fixed step for the search:')
disp('++++++++++++++++++++++++++++++++++++++++++++++++++')
% Mumax = 0.6;
% Mumin = 0.1;
% deltaMu = 0.1;
 muvec = Mumin:deltaMu:Mumax; % Mu it's a scalar greater than zero
 for i =1:length(muvec) 
     mu =muvec(i);
  [gamma{i}, K{i}, diagnostic{i}, primalhinf{i}] = LMI_HinfPDC(E_,A_,Bu_,Ba_,C_,mu,vertices);
end


 for i =1:length(K)
     for j =1:1:8
    k1vec(i,j) = K{i}{j}(1,1);
    k2vec(i,j) = K{i}{j}(1,2); 
    k3vec(i,j) = K{i}{j}(1,3); 
    k4vec(i,j) = K{i}{j}(1,4);
     end
end
%% Check for Feasibility
disp('+++++++++++++++++++++++++++++++++++++++++++++++++++')
disp('[TEST!]Testing for Feasibility[TEST!]')
 for i =1:length(muvec) 
    if strcmp(diagnostic{i}.info,'Infeasible problem (SeDuMi-1.3)') 
        warning('Solver Says it is Infeasible')
    else 
        disp('Feasible Solution')        
    end
 end
disp('+++++++++++++++++++++++++++++++++++++++++++++++++++')


%% Plot Results to Evaluate Scalar Mu

disp('++++++++++++++++++++++++++++++++++++++++++')
PlotMuInfluence(k1vec,vertices)
ylabel('k_1')
PlotMuInfluence(k2vec,vertices)
ylabel('k_2')
PlotMuInfluence(k3vec,vertices)
ylabel('k_3')
PlotMuInfluence(k4vec,vertices)
ylabel('k_4')

disp('-->This is how the scalar mu influences the behavior of the Controller')
disp('++++++++++++++++++++++++++++++++++++++++++')
  
%% Optimization process after choosing mu
% mu = muvec(3);
disp('-->The tested values of mu are stacked in a vector "muvec"')
disp('-->Choose the index which corresponds to the desired mu')
muIndex = input('-->Index for "muvec":')
if floor(muIndex) ~= muIndex
   error('[Error!]The Index Must be a Integer![Error!]') 
end
disp('--> The selected scalar mu is:')
mu = muvec(muIndex);
disp(mu)
[gamma, K, diagnostic, primalhinf] = LMI_HinfPDC(E_,A_,Bu_,Ba_,C_,mu,vertices);

global PertinenciaNormalizada
h = PertinenciaNormalizada.h;
fuzzyK = 0;
for i=1:vertices
    fuzzyK = fuzzyK + simplify(h(i)*K{i});
end
dlmwrite('../OutControllerGains/outK.txt',char(simplify(fuzzyK)),'delimiter','')



