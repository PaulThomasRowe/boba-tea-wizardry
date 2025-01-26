shader_type canvas_item;

uniform float fill_amount : hint_range(0.0, 1.0) = 1.0;
uniform float top_width : hint_range(0.0, 1.0) = 1.0;
uniform float bottom_width : hint_range(0.0, 1.0) = 0.67;

void fragment() {
    vec2 uv = vec2(UV.x, 1.0 - UV.y);
    float aspect = TEXTURE_PIXEL_SIZE.y / TEXTURE_PIXEL_SIZE.x;
    float width = mix(bottom_width, top_width, uv.y);
    float x_offset = (1.0 - width) / 2.0;
    
    // Create the trapezoid shape
    float alpha = 1.0;
    if (uv.x < x_offset || uv.x > x_offset + width) {
        alpha = 0.0;
    }
    
    // Apply the fill amount
    if (uv.y > fill_amount) {
        alpha = 0.0;
    }
    
    COLOR.a *= alpha;
}
