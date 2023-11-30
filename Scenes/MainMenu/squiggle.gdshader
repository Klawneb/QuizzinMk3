shader_type canvas_item;

uniform float scroll_speed = 0.1;

void fragment()
{
	vec2 uv_scroll = UV + vec2(-scroll_speed * sin(TIME), -scroll_speed * cos(TIME)) + TIME/15.;
    COLOR = texture(TEXTURE, uv_scroll);
}

