
function association= nearest_neighbor_localization(obj, z, params)

% number of features
n_F= size(z,1);

% initialize with zero, if SLAM --> initialize with (-1)
association= zeros(n_F,1);

if n_F == 0, return, end

% initialize variables
spsi= sin(obj.XX(9));
cpsi= cos(obj.XX(9));
zHat= zeros(2,1);

% select landmarks in the field of view
obj.FoV_landmarks_at_k= zeros(n_F,1);
for i= 1:obj.num_landmarks
    
    dx= obj.landmark_map(i,1) - obj.XX(1);
    if abs(dx) > params.lidarRange, continue, end
    dy= obj.landmark_map(i,2) - obj.XX(2);
    if abs(dy) > params.lidarRange, continue, end
    
    if sqrt( dx^2 + dy^2 ) <= params.lidarRange
        obj.FoV_landmarks_at_k(i)= i;
    end
end
% remove the ones that are zeros
obj.FoV_landmarks_at_k( obj.FoV_landmarks_at_k == 0 )= [];

% Loop over extracted features
for i= 1:n_F
    min_y2= params.T_NN;
    
    % loop through landmarks
    for l= 1:length(obj.FoV_landmarks_at_k)
        lm_ind= obj.FoV_landmarks_at_k(l);
        landmark= obj.landmark_map( lm_ind,: );
        
        dx= landmark(1) - obj.XX(1);
        if abs(dx) > params.lidarRange, continue, end
        dy= landmark(2) - obj.XX(2);
        if abs(dy) > params.lidarRange, continue, end      
        
        % build innovation vector
        zHat(1)=  dx*cpsi + dy*spsi;
        zHat(2)= -dx*spsi + dy*cpsi;
        gamma= z(i,:)' - zHat;
        
        % quick check (10 m in X or Y)
        if abs(gamma(1)) > 10 || abs(gamma(2)) > 10, continue, end
        
        % Jacobian
        H= [-cpsi, -spsi, -dx*spsi + dy*cpsi;
             spsi, -cpsi, -dx*cpsi - dy*spsi ];
        
        % covariance matrix
        Y= H * obj.PX([1:2,9],[1:2,9]) * H' + params.R_lidar;
        
        % IIN squared
        y2= gamma' / Y * gamma;
        
        if y2 < min_y2
            min_y2= y2;
            association(i)= lm_ind;
        end
    end
    
    % Increase appearances counter
    if association(i) ~= 0  
        obj.appearances(association(i))= obj.appearances(association(i)) + 1;        
    end
end
end

