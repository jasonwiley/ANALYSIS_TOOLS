
function xyz = readdcd(filename,timesteps,justnsteps)
% This software includes code developed by the Theoretical and Computational
% Biophysics Group in the Beckman Institute for Advanced Science and Technology 
% at the University of Illinois at Urbana-Champaign.

%if automated==1, the function will assume you want all atoms and
%time-steps. This is mostly intended for when I use it in other programs.

% xyz = readdcd(filename, indices)
% reads an dcd and puts the x,y,z coordinates corresponding to indices 
% in the rows of x,y,z

h = read_dcdheader(filename);
nsets = h.NSET;
natoms = h.N;

if exist('justnsteps','var')
    if justnsteps==1
        xyz=nsets;
        return
    end
end


steps=timesteps;
if length(steps)==1
    if steps==0
        steps=1:nsets;
    end
else
     if max(steps)>nsets
        steps=1:nsets;% if k>30% if k>30
%     close all
%     [A,bins]=hist(Nr./N);
%     [B,bins2]=hist(Nr2./N)
%     bar(bins,[A;B]')
% end

%     close all
%     [A,bins]=hist(Nr./N);
%     [B,bins2]=hist(Nr2./N)
%     bar(bins,[A;B]')
% end

    end
end

numsteps=length(steps);

x = zeros(natoms,1);
y = zeros(natoms,1);
z = zeros(natoms,1);

if nsets == 0
  xyz = zeros(natoms,3,numsteps);
  nsets = 99999;
else
  xyz = zeros(natoms,3,numsteps);
end

n=0;
k=1;
for i=steps
    if mod(i,1000)==0
        i
    end
    if n==0 && i~=1;
        totalskipped=donotread_dcdstep(h);
        k=2;
    end
    skip=i-k;
    if skip~=0
        fseek(h.fid,totalskipped*skip,0);
    end
    [x,y,z,totalskipped] = read_dcdstep(h);
    n=n+1;
    xyz(:,1,n) = x;
    xyz(:,2,n) = y;
    xyz(:,3,n) = z;
    k=i+1;
end

close_dcd(h);

end