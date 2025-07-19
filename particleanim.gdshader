shader_type spatial;

render_mode unshaded, cull_disabled, blend_mix;

uniform sampler2D sprite_sheet : source_color;
uniform int h_frames = 4;
uniform int v_frames = 4;
uniform float fps = 12.0;
uniform float total_frames = 16.0;

void fragment() {
    float time = TIME;
    float frame = mod(floor(time * fps), total_frames);

    float frame_u = mod(frame, float(h_frames));
    float frame_v = floor(frame / float(h_frames));

    vec2 frame_size = vec2(1.0 / float(h_frames), 1.0 / float(v_frames));
    vec2 uv = UV * frame_size + vec2(frame_u, frame_v) * frame_size;

    vec4 tex = texture(sprite_sheet, uv);
    ALBEDO = tex.rgb;
    ALPHA = tex.a;
}
