extends Sprite2D

func _ready() -> void:
	GameState.signal_colorscheme_changed.connect(colorscheme_change)
	material = material.duplicate()

func colorscheme_change(scheme: ColorScheme):
	material.set_shader_parameter("color1", scheme.background)
	material.set_shader_parameter("color2", scheme.background)
