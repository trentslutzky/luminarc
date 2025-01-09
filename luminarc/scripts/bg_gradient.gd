extends ColorRect

func _ready() -> void:
	GameState.signal_colorscheme_changed.connect(colorscheme_change)
	material = material.duplicate()

func colorscheme_change(scheme: ColorScheme):
	material.set_shader_parameter("start_color", scheme.background)
	material.set_shader_parameter("end_color", scheme.background_gradient_other)
