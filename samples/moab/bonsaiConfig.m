
function config = BonsaiConfig()
    config = BonsaiConfiguration();
    config.url = "https://api.bons.ai";
    config.name = "Simulink - Moab";
    
    %system performance and connection speeds vary. If you receive timeout
    %errors, please increase up to 300
    config.timeout = 180;
    
    % bonsai workspace
    config.workspace = "<your workspace here>";

    % access key, generated from https://beta.bons.ai/brains/accounts/settings
    config.accessKey = "<your access key here>";

    config.outputCSV = "moab_log.csv";
    
    %these are in the order of the inport
    config.stateSchema = ["pitch", ...
                          "roll", ...
                          "ball_noise","plate_noise", ...
                          "plate_pos_x","plate_pos_y","plate_pos_z", ...
                          "plate_nor_x","plate_nor_y","plate_nor_z", ...
                          "ball_x","ball_y","ball_z", ...
                          "ball_vel_x","ball_vel_y","ball_vel_z", ...
                          "estimated_x","estimated_y", ...
                          "estimated_radius", ...
                          "estimated_vel_x","estimated_vel_y", ...
                          "ball_qat_x","ball_qat_y","ball_qat_z","ball_qat_w", ...
                          "ball_fell_off", ...
                          "iteration_count", ...
                          "ball_mass","ball_radius","ball_shell", ...
                          "target_x","target_y", ...
                          "obstacle_radius","obstacle_distance", "obstacle_direction","obstacle_x", "obstacle_y", ...
                          "ball_on_plate_x","ball_on_plate_y","ball_on_plate_z", ...
                          "plate_theta_x","plate_theta_y", "plate_theta_acc", "plate_theta_limit","plate_theta_vel_limit", ...
                          "time_delta"];
    config.actionSchema = ["input_pitch","input_roll"];
    config.configSchema = ["initial_x","initial_y","initial_pitch","initial_roll","initial_vel_x","initial_vel_y", ...
                           "ball_radius", ...
                           "obstacle_x","obstacle_y","obstacle_radius"];
    config.verbose = true;
end