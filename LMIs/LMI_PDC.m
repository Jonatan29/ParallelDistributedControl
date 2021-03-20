function [K, diagnostic, primal] = LMI_PDC(E,A,Bu,Ba,mu,vertices)

N = vertices; % Numero de "Vértices"
disp('O numero de "vértices" é:')
disp(N)
    nx = size(A{1},2);
    nu = size(Bu{1},2);
    nba = size(Ba{1},2);
% Define Decision Variables
Pbar = sdpvar(nx,nx,'symmetric');
Y = cell(N,1);
for i =1:N
   Y{i} = sdpvar(nu,nx); 
end
 X= sdpvar(nx,nx,'full');

LMIs = [];
for i=1:N
       
   LMIs = LMIs + (Pbar >= 0);

A{i} = double(A{i});
Bu{i} = double(Bu{i});
E{i} = double(E{i});

    Qii = PhiMatrix(i,i,E,A,Bu,mu,Pbar,X,Y);
     LMIs = LMIs + (Qii <= 0);

end

for i =1:N-1
    for j=i+1:N
        A{i} = double(A{i});
Bu{i} = double(Bu{i});
E{i} = double(E{i});
        Qij = PhiMatrix(i,j,E,A,Bu,mu,Pbar,X,Y);
        Qji = PhiMatrix(j,i,E,A,Bu,mu,Pbar,X,Y);
        LMIs = LMIs + (Qij + Qji <= 0);
    end
end
%% Resolve o Problema de Otimização 
diagnostic = optimize(LMIs);
checkset(LMIs);
primal = checkset(LMIs);
K = cell(N,1);
X = double(X);

for i =1:N
    K{i} = double(Y{i})*inv(X); 
end
end

