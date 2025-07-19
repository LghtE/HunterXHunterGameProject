shader_type spatial;

render_mode blend_mix, cull_disabled, depth_draw_opaque, unshaded;

uniform sampler2D albedo_texture : source_color;

uniform float opacity : hint_range(0.0, 1.0) = 1.0;
uniform float r : hint_range(0.0, 1.0) = 1.0;
uniform float g : hint_range(0.0, 1.0) = 1.0;
uniform float b : hint_range(0.0, 1.0) = 1.0;
uniform float mix_color : hint_range(0.0, 1.0) = 0.0;

void fragment() {
    vec4 tex_color = texture(albedo_texture, UV);

    if (tex_color.a < 0.01) {
        discard;
    }

    vec3 mixed_rgb = mix(tex_color.rgb, vec3(r, g, b), mix_color);

    ALBEDO = mixed_rgb;
    ALPHA = tex_color.a * opacity;
}
