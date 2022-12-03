%This script creates 3D mesh from binary image automatically
%By Anis Maysami
%18 september
  %--------------------------------------------------------%
   %------------------------------------------------------%
   close all
   %maxvol='1=2:2=1';   %problem_type=1
   maxvol='1=3:2=1';  %problem_type=2
   problem_type=1;     %=2 in case of inverse problem
   num=[731];

for i=1:1:length(num)

       %addpath('F:\dars\master project\CreateDataset\ModifiedMessyData\image\');
       %addpath('F:\dars\master project\CreateDataset\mask_type_one\Vol\');
       %addpath('F:\dars\master project\CreateDataset\mask_type_one\Mesh\');
       
       dir_img='F:\dars\master project\MY DATASET\my_data\new_mask_mamo1\';
       dir_vol='F:\dars\master project\CreateDataset\mask_type_two\Vol\add\';
       dir_msh='F:\dars\master project\CreateDataset\mask_type_two\Mesh\add\';
       
       img = [dir_img,'new_mamography (',num2str(num(i)) ,').png'];
       volin=[dir_vol,'mamography (',num2str(num(i)) ,').mat'];
       outmesh=[dir_msh,'mamography (',num2str(num(i)) ,').msh'];
       MakeMesh(num(i),img,maxvol,problem_type,volin,outmesh);
end
beep