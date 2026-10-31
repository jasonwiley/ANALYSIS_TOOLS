clear all
close all
system = Extract_XML_DCD('Make_PCNDNano110_r2_N20NA4_nG60_AfterPCND2final.xml','Make_PCNDNano110_r2_N20NA4_nG60_AfterPCND1traj.dcd','system_0p6',-1);
A_ind=find(system.attype=='A');
A_pos=system.pos(A_ind,:);
% scatter3(A_pos(:,1),A_pos(:,2),A_pos(:,3))
% xlabel('x')
% ylabel('y')
% zlabel('z')
% ---------- INPUTS ----------
idx = 65;                        % index of the reference point
cutoffs = [4.75 5.5 6.5 7];            % your 4 distances (any order; sorted below)

% ----------------------------
 
cutoffs = sort(cutoffs(:))';
 
ref = A_pos(idx, :);
d = sqrt(sum((A_pos - ref).^2, 2));     % distance from ref to every point
others = true(size(d));  others(idx) = false;
 
% Band 1: d <= c1, band 2: c1 < d <= c2, ... band 4: c3 < d <= c4, band 5: beyond c4
band = 1 + sum(d > cutoffs, 2);         % N x 1, values 1..5
 
colors = [0.85 0.10 0.10;    % <= c1   red
          0.95 0.55 0.10;    % <= c2   orange
          0.20 0.70 0.30;    % <= c3   green
          0.15 0.40 0.85;    % <= c4   blue
          0.75 0.75 0.75];   % beyond  gray
 
labels = { sprintf('d \\leq %g', cutoffs(1)), ...
           sprintf('%g < d \\leq %g', cutoffs(1), cutoffs(2)), ...
           sprintf('%g < d \\leq %g', cutoffs(2), cutoffs(3)), ...
           sprintf('%g < d \\leq %g', cutoffs(3), cutoffs(4)), ...
           sprintf('d > %g', cutoffs(4)) };
 
% Shared axis limits (from ALL points) so both figures have identical axes
lo = min(A_pos, [], 1);  hi = max(A_pos, [], 1);
pad = 0.05 * max(hi - lo);  if pad == 0, pad = 1; end
lims = [lo - pad; hi + pad];            % row 1 = min, row 2 = max, cols = x y z
 
% ---------- Figure 1: all points ----------
figure; hold on; grid on; axis equal; view(3);
for b = 1:5
    m = others & (band == b);
    if any(m)
        scatter3(A_pos(m,1), A_pos(m,2), A_pos(m,3), 40, colors(b,:), ...
                 'filled', 'DisplayName', labels{b});
    end
end
scatter3(ref(1), ref(2), ref(3), 150, 'k', 'p', 'filled', ...
         'DisplayName', sprintf('A\\_pos(%d)', idx));
xlabel('x'); ylabel('y'); zlabel('z');
xlim(lims(:,1)); ylim(lims(:,2)); zlim(lims(:,3));
title(sprintf('All positions colored by distance from A\\_pos(%d)', idx));
legend('Location', 'bestoutside');
hold off;
 
% ---------- Figure 2: only points within the final cutoff ----------
figure; hold on; grid on; axis equal; view(3);
for b = 1:4
    m = others & (band == b);
    if any(m)
        scatter3(A_pos(m,1), A_pos(m,2), A_pos(m,3), 40, colors(b,:), ...
                 'filled', 'DisplayName', labels{b});
    end
end
scatter3(ref(1), ref(2), ref(3), 150, 'k', 'p', 'filled', ...
         'DisplayName', sprintf('A\\_pos(%d)', idx));
xlabel('x'); ylabel('y'); zlabel('z');
xlim(lims(:,1)); ylim(lims(:,2)); zlim(lims(:,3));
title(sprintf('Positions within d \\leq %g of A\\_pos(%d)', cutoffs(4), idx));
legend('Location', 'bestoutside');
hold off;