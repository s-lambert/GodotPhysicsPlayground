shader_type spatial;
render_mode unshaded;

uniform float radar_radius : hint_range(0, 1) = 0.9;
uniform float radar_width : hint_range(0, 1) = 0.9;
uniform float radar_speed : hint_range(0, 10) = 9.0;
uniform vec4 radar_color : source_color = vec4(1, 1, 1, 1);

uniform sampler2D DEPTH_TEXTURE : hint_depth_texture, filter_linear_mipmap;

varying vec4 world_pos;

float depth_to_z(float depth) {
    float z_near = 0.01;
    float z_far = 100.0;
    return (2.0 * z_near) / (z_far + z_near - depth * (z_far - z_near));
}

void vertex() {
    world_pos = MODEL_MATRIX * vec4(VERTEX, 1.0);
}

void fragment() {
	float depth = texture(DEPTH_TEXTURE, SCREEN_UV).x;

    float z = depth_to_z(depth);
    
    // Calculate the distance from the player (the camera's near plane)
    float distance_from_player = (world_pos.z - 0.01) / (100.0 - 0.01);
    float distance_from_depth = (z - 0.01) / (100.0 - 0.01);

    // Calculate the radar effect
    float time = 0.0;
    float radar_effect = smoothstep(radar_radius - radar_width, radar_radius, distance_from_player - time) - smoothstep(radar_radius, radar_radius + radar_width, distance_from_player - time);
    
    // Occlusion check
    bool is_occluded = distance_from_player > distance_from_depth + 0.05;
    if (is_occluded) {
        radar_effect = 0.0;
    }
    
    // Apply the radar effect to the color
    ALBEDO = mix(vec3(0), radar_color.rgb, radar_effect);
    ALPHA = 0.5;
}