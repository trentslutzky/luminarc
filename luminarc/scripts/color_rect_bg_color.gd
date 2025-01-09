extends ColorRect

func _ready() -> void:
	GameState.signal_colorscheme_changed.connect(colorscheme_change)


func colorscheme_change(scheme: ColorScheme):
	self.color = scheme.background
