shader_type spatial;

uniform vec4 color1 : source_color = vec4(1.0, 0.0, 0.0, 1.0);
uniform vec4 color2 : source_color = vec4(0.0, 1.0, 0.0, 1.0);
uniform vec4 color3 : source_color = vec4(0.0, 0.0, 1.0, 1.0);
uniform float speed : hint_range(0, 10) = 1.0;

void fragment() {
    float t = sin(TIME * speed) * 0.5 + 0.5;
    vec4 final_color;

    if (t < 0.333) {
        final_color = color1;
    } else if (t < 0.666) {
        final_color = color2;
    } else {
        final_color = color3;
    }

    ALBEDO = final_color.rgb;
}