
%This function Solves Forward Problem of  CWDOT
%By Anis Maysami
%31 July 2021
%Bio-optical imaging Laboratory 
%Shahid Beheshti University
function ForwardDataset(hmesh,input_geo,ref_bkg,mua_bkg,mus_bkg,freq,mua_file,data_file)
%ref_bkg:                    refractive index
%freq:                       frequency [1/s]
%mua_bkg:                    background absorption [1/mm]
%mus_bkg:                    background scattering [1/mm]
%input_geo:                  input volumeteric geometry
close all

%Create the mesh
%addpath('F:\dars\master project');
% [vtx,idx,eltp] = mkslab([0, 0, 0; 64, 64, 64],[35 35 35]);
% hmesh=toastMesh(vtx,idx,eltp);
nd=hmesh.NodeCount();
%hmesh=toastMesh(mesh,'gmsh');

% get mesh geometry
%nnd = size(nd,1);             % node count
%nel = mesh.ElementCount;     % element count

% toastShowMesh(hmesh);
% hmesh.Display;
%%
%Initaialize Parameters
c0=0.3;                       %speed of light in vacume[mm/ps]
cm=c0/ref_bkg;                %speed of light in medum [mm/ps]

volume=load(input_geo);
vol=volume.vol;

noiselevel = 0.01;             % additive data noise level

%Volumes are scaled to the desired optical parameter values:
bmua=double(vol)*0.01+mua_bkg;
bmus=ones(size(vol))*mus_bkg;                   %CW mode
%bmus = double(vol).*1.0 + mus_bkg;             %Frequency domain mode
ref=ones(nd,1)*ref_bkg;

% Map to mesh basis
grd = size(vol);
basis = toastBasis (hmesh,grd);
mua = basis.Map ('B->M',bmua);
mus = basis.Map ('B->M',bmus); 


% Initialize the source and detector positions
[Q,M]=make_QM_AM();
hmesh.SetQM(Q,M);
dmask = hmesh.DataLinkList ();
nq=length(Q);              %number of sources
nm=length(M);              %number of detectors
%%
%Display 3D distribution of mua and mus
%  figure;
% subplot(2,1,1);
% hmesh.Display(mua,'range',[0.01,0.08]);
% hold on
%  plot3(Q(:,1),Q(:,2),Q(:,3),'ro','MarkerFaceColor','r');
%  plot3(M(:,1),M(:,2),M(:,3),'bs','MarkerFaceColor','b');
%  axis on;
 %title('Distribution of \mu_a ');
% subplot(2,2,2); hmesh.Display(mus,'range',[1.0,2.0]);
% hold on
% plot3(Q(:,1),Q(:,2),Q(:,3),'ro','MarkerFaceColor','r');
% plot3(M(:,1),M(:,2),M(:,3),'bs','MarkerFaceColor','b');
%legend('','source','detector')
% axis off; title('Distribution of \mu_s ');
% % 
% % %Display 2D distribution of mua and mus
% bmus = reshape(basis.Map('M->B',mus),grd); 
 %mua_tgt=bmua(:,:,20);
% %bmus_tgt=bmus(:,:,40);
%subplot(2,1,1);
 %imagesc(mua_tgt);
 %axis equal tight off; colorbar; title('cut in Z=26 ');
% subplot(2,2,4);imagesc(bmus_tgt);
% axis equal tight off;colorbar; title('\mu_s cut in Z=40  ');
%%
% Create the source and boundary projection vectors
qvec = hmesh.Qvec ('Neumann', 'Gaussian', 2);
mvec = hmesh.Mvec ('Gaussian', 2);

% Solve the FEM linear system
smat = dotSysmat(hmesh,mua,mus,ref);
phi = full (smat\qvec);
lgamma = reshape (log(mvec.' * phi), [], 1);  % map to measurements
lgamma = lgamma(dmask);                       % remove unused source-detector combinations
mdata = real(lgamma);                         % log amplitude data
%pdata = imag(lgamma);                        % phase data

mdata = mdata + mdata.*noiselevel.*randn(size(mdata));
%pdata = pdata + pdata.*noiselevel.*randn(size(pdata));
data = mdata;                                 % linear data vector


%In case of complex geometry
%nq = size(qvec,2); % number of sources       
%phi = zeros(nnd,nq);
% q=1:nq
%qq = qvec(:,q);
%phi(:,q) = gmres(smat,qq,20,1e-10,1000);
%end
%%
%Display The sinogram of measurement
%   inhomog_data=reshape(data,nq,nm);
%  figure;
% % % %subplot(1,2,1);
% imagesc(inhomog_data);%colorbar
% % title('forward data');
%  xlabel('source index q');
%   ylabel('detector index m');

% for reference, also solve the homogeneous problem
% homog_mua=ones(nnd,1)*mua_bkg;
% smat = dotSysmat(hmesh, homog_mua, mus, ref);
% homog_data = log(mvec' * (smat\qvec));
% subplot(1,2,2);
% imagesc(inhomog_data-homog_data);colorbar
% title('differnce forward data');
% xlabel('source index q');
% ylabel('detector index m');
%%
%save mua
remua=basis.Map ('B<-M',mua);
mua_save=reshape(remua,64,4096);
save(mua_file,'mua_save');
% %save data
save(data_file,'data');


end
