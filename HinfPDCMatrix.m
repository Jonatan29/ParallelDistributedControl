function [Mij] = HinfPDCMatrix(i,j,E,A,B,C,mu,Pbar,X,Y,nx,nz,nba,gamma)
    Mij = blkvar;

     Mij(1,1) = A{i}*X + X'*A{i}' + B{i}*Y{j} + Y{j}'*B{i}';
     Mij(1,2) =  Pbar- E{i}*X + mu*(X'*A{i}'+ Y{j}'*B{i}');
     Mij(1,3) = zeros(nx,nba);
     Mij(1,4) = X'*C{i}';
     
     Mij(2,2) = -mu*(E{i}*X + X'*E{i}');
     Mij(2,3) = zeros(nx,nba);
     Mij(2,4) = zeros(nx,nz);
     
     Mij(3,3) = zeros(nba,nba);
     Mij(3,4) = zeros(nba,nz);
     
     Mij(4,4) = -gamma*eye(nz);

end

