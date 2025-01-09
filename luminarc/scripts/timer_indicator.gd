extends Sprite2D

var max_arc_angle: float

var initial_color_1: Color
var initial_color_2: Color

func _ready() -> void:
	max_arc_angle = self.material.get_shader_parameter("arc_angle")
	
	var current_shader_color_1 = self.material.get_shader_parameter("color1")
	if typeof(current_shader_color_1) == TYPE_COLOR:
		initial_color_1 = current_shader_color_1
	else:
		var initial_color_1_vec4: Vector4 = self.material.get_shader_parameter("color1")
		initial_color_1 = Color(initial_color_1_vec4.x, initial_color_1_vec4.y, initial_color_1_vec4.z, initial_color_1_vec4.w)
	
	var current_shader_color_2 = self.material.get_shader_parameter("color2")
	if typeof(current_shader_color_2) == TYPE_COLOR:
		initial_color_2 = current_shader_color_2
	else:
		var initial_color_2_vec4: Vector4 = self.material.get_shader_parameter("color2")
		initial_color_2 = Color(initial_color_2_vec4.x, initial_color_2_vec4.y, initial_color_2_vec4.z, initial_color_2_vec4.w)


func _process(delta: float) -> void:
	var color_1 = initial_color_1
	var color_2 = initial_color_2
	var time_ratio = GameState.force_timer.time_left / GameState.force_time
	self.material.set_shader_parameter("arc_angle", max_arc_angle * time_ratio)

	if time_ratio < 0.25:
		color_1 = Color(0.5, 0.1, 0.1, 1)
		color_2 = Color(0.3, 0.1, 0.1, 1)
		
	self.material.set_shader_parameter("color1", color_1)
	self.material.set_shader_parameter("color2", color_2)
