shader_type canvas_item;

uniform sampler2D texture_albedo : source_color;
uniform float dither_scale = 8.0;

const float dither_threshold[16] = float[] (
    0.0, 0.5, 0.125, 0.625,
    0.75, 0.25, 0.875, 0.375,
    0.0625, 0.5625, 0.1875, 0.6875,
    0.8125, 0.3125, 0.9375, 0.4375
);
