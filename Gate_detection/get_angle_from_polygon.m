function psi_estimate = get_angle_from_polygon(s_left, s_right)
% function psi_estimate = get_angle_from_polygon(s_left, s_right)

% we need the focal length in pixels, and get it by looking at what distance the gate fills the image: 
W = 640; % width image in pixels
H = 480;
FOV = (60/180) * pi; % FOV in rad
FOV_h = (50/180) * pi;
half_gate = 0.5;
% tan(FOV/2) = half_gate / dist_at_which_gate_fills_screen
dist_at_which_gate_fills_screen = half_gate / tan(FOV/2);
f = dist_at_which_gate_fills_screen *((W/2) / half_gate);
gate_size = 2 * half_gate;

% get distances to the two poles based on their size in the image:
gamma_left = (s_left / H) * FOV_h;
d_left = (0.5 * s_left) / tan(0.5 * gamma_left);
gamma_right = (s_right / H) * FOV_h;
d_right = (0.5 * s_right) / tan(0.5 * gamma_right);

% angles seen from top:
angle_1 = acos((gate_size^2+d_right^2-d_left^2) / (2*gate_size*d_right)); % at the right pole
angle_2 = acos((gate_size^2+d_left^2-d_right^2) / (2*gate_size*d_left)); % at the left pole

if(angle_1 > angle_2)
    psi_estimate = (angle_1 - angle_2) / 2;
else
    psi_estimate = -(angle_2 - angle_1) / 2;
end