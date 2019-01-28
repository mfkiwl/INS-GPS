
clear; clc;

%% decreasing separation on landmarks in y-coordinate
s_0= 30; % x-coordinate of the first pair of landmarks
s_step= 15; % x-coordinate separation
t_0= 20; % y-coordinate of the first pair of landmarks
t_step= 0.2; % y-coordinate step closer
t_threshold= 1; % y-coordinate minimum distance

% place first pair of landmarks
landmark_map= [s_0, t_0; s_0, -t_0];

s= s_0;
t= t_0;
while t > t_threshold
    
    s= s + s_step;
    t= t - t_step;
    
    landmarks= [s, t; s, -t];
    landmark_map= [landmark_map; landmarks];
end

%% decreasing separation on landmarks in x-coordinate

s_0= 30; % x-coordinate of the first pair of landmarks
s_step= 15; % x-coordinate separation
s_step_decrement= 1; % x-coordinate separation difference
t_0= 20; % y-coordinate of the first pair of landmarks
s_threshold= 1; % x-coordinate minimum distance

% place first pair of landmarks
landmark_map= [s_0, t_0; s_0, -t_0];

s= s_0;
t= t_0;
while s_step > s_threshold
    
    
    s= s + s_step;
    s_step= s_step - s_step_decrement;
        
    landmarks= [s, t_0; s, -t_0];
    landmark_map= [landmark_map; landmarks];
end

%%

landmark_map=...
    [20, 8;...
     20, 12;...
     25, 8;...
     25, 12;...
     -20, 8;...
     -20, 12;...
     -25, 8;...
     -25, 12;...
     ];
     
%%    
landmark_map=...
    [50, 5;...
     60, 5;...
     -50, 5;...
     -60, 5;...
    ];

%%

landmark_map=...
    [100, 0;...
     105, 0;...
     -100, 0;...
     -105, 0;...
     ];
    

