extends Sprite2D

func _ready() -> void:
	GameState.signal_colorscheme_changed.connect(set_colorscheme)


func set_colorscheme(scheme: ColorScheme):
	self.modulate = scheme.background
	self.modulate.a = 0.8
