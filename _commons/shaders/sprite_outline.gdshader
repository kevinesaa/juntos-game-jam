shader_type canvas_item;

uniform bool enabled = false;
uniform vec4 outline_color : source_color = vec4(1.0, 0.9, 0.2, 1.0);
uniform float outline_width : hint_range(0.5, 4.0) = 1.5;

void fragment() {
	vec4 tex_color = texture(TEXTURE, UV);
	COLOR = tex_color;
	if (enabled && tex_color.a <= 0.5) {
		vec2 texel_size = outline_width / vec2(textureSize(TEXTURE, 0));
		float neighbor_alpha = 0.0;
		neighbor_alpha += texture(TEXTURE, UV + vec2(texel_size.x, 0.0)).a;
		neighbor_alpha += texture(TEXTURE, UV + vec2(-texel_size.x, 0.0)).a;
		neighbor_alpha += texture(TEXTURE, UV + vec2(0.0, texel_size.y)).a;
		neighbor_alpha += texture(TEXTURE, UV + vec2(0.0, -texel_size.y)).a;
		neighbor_alpha += texture(TEXTURE, UV + vec2(texel_size.x, texel_size.y)).a;
		neighbor_alpha += texture(TEXTURE, UV + vec2(-texel_size.x, texel_size.y)).a;
		neighbor_alpha += texture(TEXTURE, UV + vec2(texel_size.x, -texel_size.y)).a;
		neighbor_alpha += texture(TEXTURE, UV + vec2(-texel_size.x, -texel_size.y)).a;
		if (neighbor_alpha > 0.0) {
			COLOR = outline_color;
		}
	}
}
