function [Mij] = PhiMatrix(i,j,E,A,B,mu,Pbar,X,Y)
    Mij = blkvar;

    Mij(1,1) = A{i}*X + X'*A{i}' + B{i}*Y{j} + Y{j}'*B{i}';
    Mij(1,2) =  Pbar- E{i}*X + mu*(X'*A{i}'+ Y{j}'*B{i}');
    Mij(2,2) = -mu*(E{i}*X + X'*E{i}');
end

