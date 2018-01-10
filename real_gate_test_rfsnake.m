close all;
clear all


% start = 1;%15;%38;%15
% stop  = 36;%38;%32
start = 32;%15;%38;%15
stop  = 32;%38;%32
n = stop - start + 1

pose_x = zeros(n,1);
pose_y = zeros(n,1);
pose_z = zeros(n,1);

gate_pos = [4.2 0.8 -1.4];
%5 ground 20interesting 28ok 32close 15ok 30good?

calc_pose = false;

%ground truth axis system
% --->160x
% |
% |
% |
% |
% 315y

%processing axis system
%------------>315 x
%|
%|
%160 y


load('gt_labels_base_2_1');
%test = gTruth_gate.LabelData.label{3,1}{1}

errors = 0;

n_iterations = 1;%100;

for i = 1:n_iterations
i
for c = start:stop
[image_points_x,image_points_y] = run_detection_corner_refine_img('Data_set_base_2', c);
temp = gTruth_gate.LabelData.label{c,1}{1};
gt_points_x = temp(:,2);%ygt
gt_points_y = 160 - temp(:,1);%xgt

dist_norm = ((image_points_x'-gt_points_x).^2+(image_points_y'-gt_points_y).^2).^(0.5);

av_norm = mean(dist_norm);
max_norm = max(dist_norm);

if(max_norm < 30)
    errors = [errors ; dist_norm];
end

%     color = [0 1 0];
%     plot([Q1(1) Q2(1)], [Q1(2), Q2(2)], 'Color', color, 'LineWidth', 5);
%     plot([Q2(1) Q3(1)], [Q2(2), Q3(2)], 'Color', color, 'LineWidth', 5);
%     plot([Q3(1) Q4(1)], [Q3(2), Q4(2)], 'Color', color, 'LineWidth', 5);
%     plot([Q4(1) Q1(1)], [Q4(2), Q1(2)], 'Color', color, 'LineWidth', 5);

if(calc_pose)
[ selected_pose_av, res_u, res_v ] = pos_p3p_ransac_2(gate_pos, image_points_x, image_points_y,cameraParams_1 )

% pose_x(c) = selected_pose_av(1);
% pose_y(c) = selected_pose_av(2);
% pose_z(c) = -selected_pose_av(3);
end
%waitforbuttonpress;
if(n>1)
close all;
end

end

end

variance = var(errors)
standarddeviation = std(errors)

% figure()
% plot3(pose_x,pose_y,pose_z,'*')
% hold on
% plot3(pos_x,pos_y,-pos_z)
% grid on

