%This function create 3D volumetric mesh
%by Anis Maysami
%Bio-optical imaging laboratory
%Shahid Beheshti University

function MakeMesh(x,img,maxvol,problem_type,volin,outmesh)
%% 
%the first step is to load a binary or gray-scale image
I=imread(img);
%I= imbinarize(I,'adaptive');        %In case of gray scale image,segment
                                     %image
%Ifill = imfill(I,'holes');
%figure()
%imshow(I) 
vol=repmat(I,1,1,21);
vol(:,:,22:42)=repmat(zeros(size(I)),[1,1,21]);
B=zeros(64,64,22);
vol=cat(3,B,vol);

% 
% vol=repmat(I,1,1,21);
% vol(:,:,22:54)=repmat(zeros(size(I)),[1,1,33]);
% B=zeros(64,64,10);
% vol=cat(3,B,vol);

%%
%Generating volumetric mesh
clear opt
opt.radbound=4;       % set surface triangle maximum size
opt.distbound=0.2;    % set max distance that deviates from the level-set
%opt.autoregion=1;

%==Configuring parameters
ix = 1:size(vol,1);
iy = 1:size(vol,2);
iz = 1:size(vol,3);
%maxvol='1=3:2=2';
[node,elem,~]=vol2mesh(uint8(vol+1),ix,iy,iz,opt,maxvol,1,'cgalmesh');
[no,el]=removeisolatednode(node,elem);                                             
%%
%plot mesh
% figure;
% plotmesh(node,elem,'x>30');
% figure;
% plotmesh(node,elem(elem(:,5)==2,:));
figure(x);
plotmesh(no,el,'z < 25');
figure;
plotmesh(node,elem);

%calculate mesh quality
% figure
% q=meshquality(node(:,1:3),elem(:,1:4));
% histogram(q,100);
%%
%problem_type=1 indicated which forward problem needed
%problem_type=2 indicated which inverse problem needed

% if problem_type==1
%    save(volin,'vol');
%    savemsh(no(:,1:3),el(:,1:5),outmesh);
% 
% elseif problem_type==2
%      savemsh(no(:,1:3),el(:,1:5),outmesh);
% end
%         

end


