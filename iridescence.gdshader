shader_type spatial;

uniform float intensity: hint_range(0, 1) = 0.5;
uniform sampler2D iridescence_texture;

varying vec3 view_dir;

// Fresnel function
vec3 fresnel_schlick(vec3 specular_color, float v_dot_h) {
    return specular_color + (1.0 - specular_color) * pow(1.0 - v_dot_h, 5.0);
}

void vertex() {
    view_dir = normalize(INV_VIEW_MATRIX[3].xyz - (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz);
}

void fragment() {
    vec3 normal = normalize(NORMAL);
    vec3 reflect_dir = reflect(-view_dir, normal);
    float fresnel = fresnel_schlick(vec3(0.1), dot(view_dir, normal)).r;

    vec2 uv = (reflect_dir.xy / reflect_dir.z) * 0.5 + vec2(0.5);
    vec3 iridescent_color = texture(iridescence_texture, uv).rgb;

    ALBEDO = mix(ALBEDO, iridescent_color, fresnel * intensity);
}
