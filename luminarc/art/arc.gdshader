shader_type canvas_item;

uniform vec2 center; // Arc center (normalized to UV space)
uniform float radius; // Arc radius (normalized to UV space) hint_range(0.0, 1.0);
uniform float thickness; // Arc thickness (normalized to radius) hint_range(0.0, 1.0);
uniform float start_angle; // Start angle (in radians) hint_range(0.0, 6.283);
uniform float arc_angle; // Arc angle (in radians) hint_range(0.0, 6.283);
uniform vec4 color1; // Checkerboard color 1
uniform vec4 color2; // Checkerboard color 2
uniform float checker_size : hint_range(0.0, 0.1); // Size of checkerboard squares

void fragment() {
	vec2 local_uv = UV - center; // Translate UV to center the arc
	float dist = length(local_uv); // Distance from the center
	float angle = atan(local_uv.y, local_uv.x); // Angle from the x-axis

	// Normalize angle to [0, 2*PI)
	angle = mod(angle + 6.283, 6.283);

	// Check if within radius bounds
	bool within_radius = dist >= radius - thickness && dist <= radius;

	// Check if within angle bounds
	bool within_angle = angle >= start_angle && angle <= start_angle + arc_angle;

	if (within_radius && within_angle) {
		// Create checkerboard pattern
		vec2 checker_uv = floor(local_uv / checker_size);
		bool is_checker_white = mod(checker_uv.x + checker_uv.y, 2.0) == 0.0;

		// Alternate between color1 and color2 based on the checkerboard pattern
		COLOR = is_checker_white ? color1 : color2;
	} else {
		// Transparent outside the arc
		COLOR = vec4(0.0);
	}
}
