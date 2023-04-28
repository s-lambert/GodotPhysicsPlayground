shader_type spatial;

uniform vec3 screen_color : source_color = vec3(1.0);
uniform sampler2D cross_sprite : source_color, filter_nearest;

void fragment() {
	float res = 20.0;
		
	vec2 g_2 = round(UV * res) / res;
	float truc = g_2.x * g_2.y;
	
	float dist = distance(vec2(0.5), g_2);
	float waves = (1.0 + sin((dist - TIME * 4.0) * 10.0)) / 2.0;
	
	vec2 grid_2d = cos(fract(UV * res + 0.5) * 3.14);
	float grid = grid_2d.x * grid_2d.y;
	grid = grid * 0.8 + 0.2;
	
	float cross_shape = 0.0; 1.0 - round(texture(cross_sprite, g_2 * vec2(0.5, 1.0)
		+ vec2(mod(round(TIME) * 0.5, 1.0), 0.0)
	).x);
	
	vec3 color = vec3(cos(TIME), atan(TIME), sin(TIME));
	ALBEDO = 1.0 - (color * ((waves * 10.0) + cross_shape) * grid * 10.0);
	EMISSION = 1.0 - (color * ((waves * 10.0) + cross_shape) * grid * 10.0);
}
