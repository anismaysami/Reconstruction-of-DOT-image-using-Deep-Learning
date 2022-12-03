

function [muarec] =classic_optimization(invmesh,data,mua_bkg,mus_bkg,ref_bkg,tau,itrmax,grd,freq)
%Inverse solver
c0=0.3;                       %speed of light in vacume[mm/ps]
cm=c0/ref_bkg;                %speed of light in medum [mm/ps]
%tau = 1e-3;                            % regularisation parameter
beta = 0.01;                            % TV regularisation parameter
tolCG = 1e-6;                           % Gauss-Newton convergence criterion
resetCG = 10;                           % PCG reset interval
itrmax = 100;                          % Gauss-Newton max. iterations
%cmap = 'gray';
verbosity = 1;                          
% tolGN = 1e-7;                           % Gauss-Newton convergence criterion
% tolKrylov = 1e-2;                       % Krylov convergence criterion
% Himplicit = true; 

%Read a TOAST mesh definition from file.
%invmesh = toastMesh (invmesh,'gmsh');            %read inverse solver mesh
[Q,M] = make_QM_AM();
invmesh.SetQM(Q,M);
n =invmesh.NodeCount();                          %number of nodes
dmask = invmesh.DataLinkList (); 

mua = ones(n,1) * mua_bkg;                       %initial mua estimate
mus = ones(n,1) * mus_bkg;                       %initial mus estimate
ref = ones(n,1) * ref_bkg;                       %refractive index estimate
%kap = 1./(3*(mua+mus));

%Create the source and boundary projection vectors
qvec = invmesh.Qvec ('Neumann','Gaussian', 2);
mvec = invmesh.Mvec ('Gaussian',2, ref);

%Set up the mapper between FEM and solution bases
hbasis = toastBasis (invmesh, grd);                 % maps between mesh and reconstruction basis
smat = dotSysmat (invmesh, mua, mus, ref);          % FEM system matrix
lgamma = reshape (log(mvec.' * (smat\qvec)), [], 1);% solve for photon density and map to boundary measurements
lgamma = lgamma(dmask);                             % remove unused source-detector combinations
mproj = real(lgamma);                               % log amplitude data
%pproj = imag(lgamma);                              % phase data
proj = mproj;                                       % linear measurement vector

%data scaling
msd = ones(size(lgamma)) * norm(data-mproj);       % scale log amp data with data difference
%psd = ones(size(lgamma)) * norm(pdata-pproj);      % scale phase data with data difference
sd =msd;%;psd];                                     % linear scaling vector

%map initial parameter estimates to solution basis
bmua = hbasis.Map ('M->B', mua);                    % mua mapped to full grid
%bmus = hbasis.Map ('M->B', mus);                   % mus mapped to full grid
%bkap = hbasis.Map ('M->B', kap);                   % kap mapped to full grid
bcmua = bmua*cm;                                    % scale parameters with speed of light
%bckap = bkap*cm;                                   % scale parameters with speed of light
scmua = hbasis.Map ('B->S', bcmua);                 % map to solution basis
%sckap = hbasis.Map ('B->S', bckap);                % map to solution basis

% solution vector
x = scmua;%;sckap];                                 % linea solution vector
logx = log(x);                                      % transform to log
slen = length(x);

% Initialise regularisation
hreg = toastRegul ('TV', hbasis, logx, tau, 'Beta', beta);
%hreg = toastRegul('MRF',hbasis,logx,tau);

toastSetVerbosity(verbosity);                       % output verbosity level

% initial data error (=2 due to data scaling)
err0 = toastObjective (proj, data, sd, hreg, logx); %initial error
err = err0;                                         % current error
errp = inf;                                         % previous error
erri=zeros(itrmax,1);
erri(1)=err0;
itr = 1;                                            % iteration counter
fprintf (1, '\n**** INITIAL ERROR %f\n\n', err);
step = 1.0;                                         % initial step length for line search

% Nonlinear conjugate gradient loop
while (itr <= itrmax) && (err > tolCG*err0) && (errp-err > tolCG)
    errp = err;
    % Gradient of cost function
    r = -toastGradient (invmesh, hbasis, qvec, mvec, mua, mus, ref,freq,...
                       data, sd,'method','cg','tolerance', 1e-12);
    r = r(1:slen);                % drop mus gradient
               
    r = r .* x;                   % parameter scaling
    r = r - hreg.Gradient (logx); % regularisation contribution
    % CG search direction update
    if itr > 1
        delta_old = delta_new;
        delta_mid = r' * s;
    end
     % Apply PCG preconditioner
    s = r; % dummy for now
    
    if itr == 1
        d = s;
        delta_new = r' * d;
    else
        delta_new = r' * s;
        beta = (delta_new - delta_mid) / delta_old;
        if mod (itr, resetCG) == 0 || beta <= 0
            d = s;  % reset CG
        else
            d = s + d*beta;
        end
    end

    % Line search
    fprintf (1, 'Line search:\n');
    step = toastLineSearch (logx, d, step, err, @objective);
    
    % Add update to solution estimate
    logx = logx + d*step;
    x = exp(logx);
    
    % Map parameters back to mesh
    scmua = x(1:size(x));
    %sckap = x(size(x)/2+1:size(x));
    smua = scmua/cm;
    %skap = sckap/cm;
    %smus = 1./(3*skap) - smua;
    mua = hbasis.Map ('S->M', smua);
    %mus = mus;
    bmua = hbasis.Map ('S->B', smua);
    muarec=bmua;
    %bmus = bmus;
    
    %Display reconstructed mua and mus
    figure(1);
%     subplot(2,2,1);
    muarec= reshape(bmua,grd);
    muarec_img=muarec(:,:,26);
    imagesc(muarec_img);colorbar;
    axis equal tight off
    title ('reconstructed \mu_a Z=26mm ');
    
%     subplot(2,2,3);
%     x_axis=1:1:64;
%     y_fwd=reshape(muatru(20,20,1:64),[],1);
%     y_recon=reshape(muarec(20,20,1:64),[],1);
%     plot(x_axis,y_fwd,'b',x_axis,y_recon,'r');
%     plot(x_axis,y_recon,'r');
%     xlabel('\mu_a mm^-1');
%     ylabel('Z');
%     legend('true','reconstructed');
%     title ('distribution of \mu_a in x,y=20 ');
    
    
    %subplot(1,2,2);
%     musrec= reshape(bmus,grd);
%     musrec_img=musrec(:,:,40);
%     imagesc(musrec_img); 
%     colorbar; axis equal tight off
%     title ('\mu_s tgt, recon');

    
    % update projection from current parameter estimate
    mproj = toastProject (invmesh, mua, mus, ref,freq, qvec, mvec);
    %pproj = zeros(size(mproj));
    proj = mproj;
    % update objective function
    err = toastObjective (proj, data, sd, hreg, logx);
    fprintf ('GN iteration %d\n', itr);
    fprintf ('--> Objective: %f\n', err);
    
    itr = itr+1;
    erri(itr) = err;
    
        %show objective function
%         subplot(2,2,[2 4]);
%         semilogy(erri);
%         axis([1 itr 1e-2 2])
%         xlabel('iteration');
%         ylabel('objective function');
        %xticks([1:itrmax+1]);
        drawnow
    
end
% subplot(2,2,3);
% x_axis=1:1:64;
% y_fwd=reshape(muatru(32,32,1:64),[],1);
% y_recon=reshape(muarec(32,32,1:64),[],1);
% plot(x_axis,y_fwd,'b',x_axis,y_recon,'r');
% xlabel('\mu_a mm^(-1)');
% ylabel('Z');
% xlim([1 64]);
% ylim([0 0.03]);
% legend('true','reconstructed');
% title ('distribution of \mu_a in x,y=20 ');


% ssimval=ssim(muarec,muatru);
% peaksnr=psnr(muarec,muatru);
% mseval=immse(muarec,muatru);
% maeval=calMAE(muarec,muatru);

    
disp('recon1: finished')

    % =====================================================================
    % Callback function for objective evaluation (called by toastLineSearch)
    function p = objective(x)
        [mua,mus] = dotX_ToMuaMus (hbasis, exp(x), ref,mus);
        mproj = toastProject (invmesh, mua, mus, ref,freq, qvec, mvec);
        %pproj = zeros(size(mproj));
        proj = mproj;
        [p, p_data, p_prior] = toastObjective (proj, data, sd, hreg, x);
        if verbosity > 0
            fprintf (1, '--> LH: %f, PR: %f\n', p_data, p_prior);
        end
    end 
toc
end
