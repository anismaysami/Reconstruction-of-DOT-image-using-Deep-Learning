% This Script will create input and output of network
% input is saved as Y and output is mua distribution 
%By Anis Maysami
%19 september 2021
  %--------------------------------------------------------%
   %------------------------------------------------------%
   
   
ref_bkg=1.4;
mua_bkg=0.01;
mus_bkg=1;
freq=0;

%expected_x=zeros(625,sample_num);
%expected_y=zeros(262144,sample_num);
[vtx,~,idx]=meshabox([0,0,0],[64,64,64],3,1);
eltp=3*ones(length(idx),1);
hmesh=toastMesh(vtx,idx,eltp);
%%
num=[451:1:500];
sample_num=length(num);                      %number of example
tic
for i=1:1:sample_num
    %clear mesh
    %mesh_dir='F:\dars\master project\CreateDataset\mask_type_one\Mesh\';
    %vol_dir='F:\dars\master project\CreateDataset\mask_type_one\Vol\';
    vol_dir='F:\dars\my article\English\1\added dataset\added_vol\';
    %mua_dir='F:\dars\master project\CreateDataset\mask_type_one\Forward\mua\';
    mua_dir='F:\dars\my article\English\1\added dataset\added_mua\';
    %data_dir='F:\dars\master project\CreateDataset\mask_type_one\Forward\data\';
    data_dir='F:\dars\my article\English\1\added dataset\added_data\';
    %mesh=[mesh_dir,'MakTypeOne (',num2str(num(i)) ,').msh'];
    input_geo=[vol_dir,'augmentMaskTypeOne (',num2str(num(i)) ,').mat'];
    mua_file=[mua_dir,'augmentmuaTypeOne (',num2str(num(i)) ,').mat'];
    data_file=[data_dir,'augmentdataTypeOne (',num2str(num(i)) ,').mat'];
    ForwardDataset(hmesh,input_geo,ref_bkg,mua_bkg,mus_bkg,freq,mua_file,data_file);
%     mua=reshape(mua,64,4096);
%     data=reshape(data,[],1);
%     expected_y(:,i)=mua;
%     expected_x(:,i)=data;
%      cell_y{i}=mua;
%      cell_x{i}=data;
%      
%      writecell(cell_y);
%      type 'mua.txt';
%      writecell(cell_x);
%      type 'mua.txt';
%     
%    csvwrite('F:\dars\master project\CreateDataset\mask_type_one\Forward\Y.csv',expected_y);    %Y as mua output of neural network
%    csvwrite('F:\dars\master project\CreateDataset\mask_type_one\Forward\X.csv',expected_x);    %X as data input of neural network
end
toc    
    
    beep
