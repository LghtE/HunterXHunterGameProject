shader_type spatial;
render_mode unshaded, cull_disabled, depth_draw_opaque;

uniform sampler2D albedo_texture: filter_nearest, source_color;
uniform bool flash_active = false;
uniform vec4 flash_color = vec4(1.0, 1.0, 1.0, 1.0); // Flash color (white by default)

void fragment() {
    vec4 tex_color = texture(albedo_texture, UV);

    vec4 final_color = tex_color;
    if (flash_active) {
        final_color.rgb = flash_color.rgb;
        final_color.a *= flash_color.a;
    }

    ALBEDO = final_color.rgb;
    ALPHA = final_color.a;
}
