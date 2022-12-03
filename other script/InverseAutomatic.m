%This script solve inverse DOT problem automatically
%By Anis Maysami
%28 september
  %--------------------------------------------------------%
   %------------------------------------------------------%
x=1;   
%addpath('F:/dars/master project/CreateDataset/Mesh/'); 
% addpath('F:/dars/master project/CreateDataset/Vol/');

%dir_msh='F:/dars/master project/CreateDataset/Mesh/';
%dir_vol='F:/dars/master project/CreateDataset/Vol/';

%invmesh=[dir_msh,'inv_new_benign _mask(',num2str(x) ,').msh'];
%forwmesh=[dir_msh,'inv_new_benign _mask(',num2str(x) ,').msh'];
%input_geo=[dir_vol,'new_benign _mask(',num2str(x) ,').mat'];
% img_A='new_mamography (59).png';
% I=imread(img_A);
% vol=zeros(64,64,21);
% vol(:,:,22:42)=repmat(I,1,1,21);
% B=zeros(64,64,22);
% vol=cat(3,vol,B);
%%
[vtx,~,idx]=meshabox([0,0,0],[64,64,64],3,1);
eltp=3*ones(length(idx),1);
hmesh=toastMesh(vtx,idx,eltp);
forwmesh=hmesh;
invmesh=hmesh;
input_geo='F:\dars\master project\aa comparison\vol\Vol (09117 ).mat';
mua_bkg=0.05;
mus_bkg=1;
ref_bkg=1.4;
tau=1e-3;
itrmax=150;
grd=[64,64,64];
freq=0;
%%
ForwardDataset(hmesh,input_geo,ref_bkg,mua_bkg,mus_bkg,freq);
%%

[muarec] =CgInverseProblem(invmesh,forwmesh,input_geo,mua_bkg,mus_bkg,ref_bkg,tau,itrmax,grd,freq);
mua_rec_file='F:\dars\master project\aa comparison\mua_rec_H.mat';
save(mua_rec_file,'muarec');


