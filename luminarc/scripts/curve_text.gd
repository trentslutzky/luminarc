class_name TextEffectCurve
extends RichTextEffect

# Parameters for the effect
var radius = 100
var center_offset = Vector2.ZERO

func _process_custom_fx(char_fx):
	# Position the characters in a circular path
	var angle_step = 2.0 * PI / char_fx.total
	var angle = angle_step * char_fx.index
	
	# Compute character position
	var x = center_offset.x + radius * cos(angle)
	var y = center_offset.y + radius * sin(angle)
	
	# Adjust character positioning
	char_fx.offset = Vector2(x, y)
	return char_fx
