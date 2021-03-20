function [gamma,K, diagnostic, primal] = controller_HinfPDC(E,A,Bu,Ba,C,mu,vertices)

N = vertices; % Numero de "Vértices"
disp('O numero de "vértices" é:')
disp(N)
    nx = size(A{1},2);
    nu = size(Bu{1},2);
    nba = size(Ba{1},2);
    nz = size(C{1},1);
% Define Decision Variables
Pbar = sdpvar(nx,nx,'symmetric');
Y = cell(N,1);
for i =1:N
   Y{i} = sdpvar(nu,nx); 
end
 X= sdpvar(nx,nx,'full');
% gamma = sdpvar(1,1);
gamma = 0.01;
LMIs = [];
for i=1:N
       
   LMIs = LMIs + (Pbar >= 0);

A{i} = double(A{i});
Bu{i} = double(Bu{i});
E{i} = double(E{i});

    Qii = HinfPDCMatrix(i,i,E,A,Bu,C,mu,Pbar,X,Y,nx,nz,nba,gamma);
     LMIs = LMIs + (Qii <= 0);

end

for i =1:N-1
    for j=i+1:N
        A{i} = double(A{i});
Bu{i} = double(Bu{i});
E{i} = double(E{i});
        Qij = HinfPDCMatrix(i,j,E,A,Bu,C,mu,Pbar,X,Y,nx,nz,nba,gamma);
        Qji = HinfPDCMatrix(j,i,E,A,Bu,C,mu,Pbar,X,Y,nx,nz,nba,gamma);
        LMIs = LMIs + (Qij + Qji <= 0);
    end
end
%% Resolve o Problema de Otimização 
diagnostic = optimize(LMIs,gamma);
checkset(LMIs);
primal = checkset(LMIs);
K = cell(N,1);
X = double(X);
gamma = double(gamma);
for i =1:N
    K{i} = double(Y{i})*inv(X);
end
end

