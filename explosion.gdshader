shader_type spatial;
uniform float duration = 0.3; // Duration for the entire color transition
uniform vec3 color_1 = vec3(1, 0, 0); // First color (red)
uniform vec3 color_2 = vec3(0, 1, 0); // Second color (green)
uniform vec3 color_3 = vec3(0, 0, 1); // Third color (blue)

varying float random_seed;

void vertex() {
    // Generate a random seed based on the vertex position
    random_seed = fract(sin(dot(VERTEX, vec3(12.9898, 78.233, 37.719))) * 43758.5453);

    // Calculate the time offset for each explosion using the random seed
    float time_offset = mod(random_seed * duration, duration);

    // Calculate the time since the start of the explosion
    float explosion_time = mod(TIME + time_offset, duration);

    // Determine the color transition progress
    float progress = explosion_time / duration;

    // Pass the progress to the fragment function
    UV.x = progress;
}

void fragment() {
    float progress = UV.x;

    // Calculate the color of the explosion based on the progress
    vec3 final_color;
    if (progress < 0.333) {
        // Mix between color_1 and color_2
        final_color = mix(color_1, color_2, progress * 3.0);
    } else if (progress < 0.666) {
        // Mix between color_2 and color_3
        final_color = mix(color_2, color_3, (progress - 0.333) * 3.0);
    } else {
        // Mix between color_3 and color_1
        final_color = mix(color_3, color_1, (progress - 0.666) * 3.0);
    }

    // Assign the final color to the ALBEDO built-in variable
    ALBEDO = final_color;
}
