shader_type canvas_item;

uniform sampler2D texture_image : source_color;

void fragment() {
    COLOR = texture(texture_image, UV);
}
