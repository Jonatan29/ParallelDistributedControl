clear
clc

syms M m l g kv real
syms z1 z2 z3 real

Ez = [1 0 0 0;...
    0 1 0 0;...
    0  0 M+m -m*l*z1;...
    0  0 -m*l*z1 m*l^2]; 

Az = [0 0 1 0;...
      0 0 0 1;...
      0 0 -kv -m*l*z2;...
      0 m*g*l*z3 0 0];
  
  Bz = [0;0;1;0];
  
  Baz = [0;0; -(M+m)*g;m*g*l*z1];
  
  syms s theta v omega alfa sinctheta real
  
  
  
%% Define Function sinc(x) = sin(x)/x  
  sinceq = @(x) sin(x)/x;
 %% Implementa Função para Pegar Pertencimento da Regra
  getw = @(gx,max,min) (gx-min)/(max - min);
%% Sector Non Linearities 
  Z1 = subs(z1,cos(theta));
  Z2 = subs(z2,sin(theta)*omega);
  Z3 = subs(z3,cos(alfa)*sinctheta);
  Z = [Z1;Z2;Z3];

  
  az1max = 1;
  az1min = cos(pi/4);
  wz1max = getw(Z1,az1max,az1min);
  wz1min = 1 - wz1max;
  
  
    %% Acha o Minimo de Z2
  it =1;
  minZ2= 100;
  maxZ2 =0;
  IntervalTheta = [-pi/2 pi/2];
  IntervalOmega = [-pi/6 pi/6];
 for th = IntervalTheta(1):0.0175:IntervalTheta(2)
    for om = IntervalOmega(1):0.0175:IntervalOmega(2)
        teste(it) = sin(th)*om;
        if teste(it) < minZ2
            minZ2 = teste(it);
        end
        if teste(it) > maxZ2
            maxZ2 = teste(it);
        end
        it = it+1;
    end
end
  
  
  az2max = maxZ2;
  az2min = minZ2;
  wz2max = getw(Z2,az2max,az2min);
  wz2min = 1 - wz2max; 
  
  
  %% Acha o Minimo de Z3
  it =1;
  minZ3= 100;
  maxZ3 =0;
  IntervalAlfa = [-0.1745 0.1745];
   for th = IntervalTheta(1):0.0175:IntervalTheta(2)
    for al = IntervalAlfa(1):0.0175:IntervalAlfa(2)
        teste(it) = cos(al)*sinceq(th);
        if teste(it) < minZ3
            minZ3 = teste(it);
        end
        if teste(it) > maxZ3
            maxZ3 = teste(it);
        end
        it = it+1;
    end
end
  
  
  az3max = maxZ3;
  az3min = minZ3;
  wz3max = getw(Z3,az3max,az3min);
  wz3min = 1 - wz3max ;
  
  %% Define Vértices
  vertices = 2^(length(Z))
  E_ = cell(vertices,1);
  A_ = cell(vertices,1);
  Bu_ = cell(vertices,1);
  Ba_ = cell(vertices,1);
%   h = cell(vertices,1);
%% Regra 1 max max max
E_{1} = subs(Ez,z1,az1max);
A_{1} = subs(Az,[z2 z3],[az2max az3max ]);
Bu_{1} = Bz;
Ba_{1} = subs(Baz,z1,az1max);
h(1) = wz1max*wz2max*wz3max;
%% Regra 2 max max min
E_{2} = subs(Ez,z1,az1max);
A_{2} = subs(Az,[z2 z3],[az2max az3min ]);
Bu_{2} = Bz;
Ba_{2} = subs(Baz,z1,az1max);
h(2) = wz1max*wz2max*wz3min;
%% Regra 3 max min max
E_{3} = subs(Ez,z1,az1max);
A_{3} = subs(Az,[z2 z3],[az2min az3max ]);
Bu_{3} = Bz;
Ba_{3} = subs(Baz,z1,az1max);
h(3) = wz1max*wz2min*wz3max;
%% Regra 4 max min min
E_{4} = subs(Ez,z1,az1max);
A_{4} = subs(Az,[z2 z3],[az2min az3min ]);
Bu_{4} = Bz;
Ba_{4} = subs(Baz,z1,az1max);   
h(4) = wz1max*wz2min*wz3min;
%% Regra 5 min max max
E_{5} = subs(Ez,z1,az1min);
A_{5} = subs(Az,[z2 z3],[az2max az3max ]);
Bu_{5} = Bz;
Ba_{5} = subs(Baz,z1,az1min);  
h(5) = wz1min*wz2max*wz3max;
%% Regra 6 min max min
E_{6} = subs(Ez,z1,az1min);
A_{6} = subs(Az,[z2 z3],[az2max az3min ]);
Bu_{6} = Bz;
Ba_{6} = subs(Baz,z1,az1min);  
h(6) = wz1min*wz2max*wz3min;
%% Regra 7 min min max
E_{7} = subs(Ez,z1,az1min);
A_{7} = subs(Az,[z2 z3],[az2min az3max ]);
Bu_{7} = Bz;
Ba_{7} = subs(Baz,z1,az1min); 
h(7) = wz1min*wz2min*wz3max;
%% Regra 8 min min min
E_{8} = subs(Ez,z1,az1min);
A_{8} = subs(Az,[z2 z3],[az2min az3min ]);
Bu_{8} = Bz;
Ba_{8} = subs(Baz,z1,az1min); 
h(8) = wz1min*wz2min*wz3min;

%% check if h belongs to unitary simplex
test = simplify(sum(h))
if test == 1
    disp('--> h belogs to the unitary simplex')
else
    error('h doesnt belong to the unitary simplex')
end


%% Global Descriptor System
vertices = 8;
subvecParam = [M m l g kv];
subvecValues = [1.5 0.3 0.3 9.78 1];

for i =1:vertices
E_{i} = subs(E_{i},subvecParam,subvecValues);
A_{i} = subs(A_{i},subvecParam,subvecValues);
Bu_{i} = subs(Bu_{i},subvecParam,subvecValues);
Ba_{i} = subs(Ba_{i},subvecParam,subvecValues);
% C_{i} = [0 0 1 0; 0 0 0 1];
C_{i} = eye(4);
end


global PertinenciaNormalizada
PertinenciaNormalizada.h = h;
 global DescriptorSystemDynamics

 DescriptorSystemDynamics.E = E_;
 DescriptorSystemDynamics.A = A_;
 DescriptorSystemDynamics.Bu = Bu_;
 DescriptorSystemDynamics.Ba = Ba_;
 DescriptorSystemDynamics.C = C_;

%% Fuzzy Descriptor System

fuzzyE = 0;
fuzzyA = 0;
fuzzyBu = 0;
fuzzyBa = 0;
fuzzyC = 0;
for i=1:vertices
    fuzzyE = fuzzyE + simplify(h(i)*E_{i});
    fuzzyA = fuzzyA + simplify(h(i)*A_{i});
    fuzzyBu = fuzzyBu + simplify(h(i)*Bu_{i});
    fuzzyBa = fuzzyBa + simplify(h(i)*Ba_{i});
    fuzzyC = fuzzyC + simplify(h(i)*C_{i});
end


dlmwrite('../OutDynamics/outE.txt',char(simplify(fuzzyE)),'delimiter','')
dlmwrite('../OutDynamics/outA.txt',char(simplify(fuzzyA)),'delimiter','')
dlmwrite('../OutDynamics/outBu.txt',char(simplify(fuzzyBu)),'delimiter','')
dlmwrite('../OutDynamics/outBa.txt',char(simplify(fuzzyBa)),'delimiter','')
dlmwrite('../OutDynamics/outC.txt',char(simplify(fuzzyC)),'delimiter','')


