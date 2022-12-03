%Creating source and detector arrangement around Tissue
%By Anis Maysami
%29 July 2021
function [Q,M] = make_QM_AM() 
%%
%defining coordinate
X=[10 21 32 43 54];
%%
%Source and detector locations
nq=length(X);
nqx=nq.^2;
Q=zeros(nqx,3);
M=zeros(nqx,3);

for i=1:1:nq
    for j=1:1:nq
        Q(j+5*(i-1),:,:)=[X(i) X(j) 0];
        M(j+5*(i-1),:,:)=[X(i) X(j) 64];
    end
end

end




%%


        
            

