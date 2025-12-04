shader_type canvas_item;


// === Uniforms (editable from material / code) ===

// Turn blinking on/off from code.
uniform bool invincible = false;

// Alpha range for the blink.
uniform float min_alpha : hint_range(0.0, 1.0) = 0.2;
uniform float max_alpha : hint_range(0.0, 1.0) = 1.0;

// How fast the blink should happen.
uniform float blink_speed : hint_range(0.0, 20.0) = 6.0;


void fragment()
{
	//sample the original texture
	// TEXTURE: built-in sampler2D (the assigned sprite texture)
	// UV: built-in vec2 giving us the texture coordinates (0..1)
	vec4 base_color = texture(TEXTURE,UV);
	//start with original alpha
	float final_alpha = base_color.a;
	if (invincible){
		// TIME: built-in float, seconds since the game started.
		// sin(TIME * blink_speed) oscillates between -1 and 1.
		float raw_sin = sin(TIME * blink_speed);
		//map from [-1, 1 ] to [0, 1]
		// -1 to 0 // 0 to 0.5 // 1 to 1
		float oscillation = raw_sin * 0.5 + 0.5;
		// mix(a, b, t) = a * (1 - t) + b * t
		// This is a linear interpolation (LERP) between min_alpha and max_alpha.
		float blink_alpha = mix(min_alpha,max_alpha,oscillation);
		//combine original alpha with blink alpha
		final_alpha = base_color.a * blink_alpha;
	}
	//set final alpha
	COLOR.a   = final_alpha;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
