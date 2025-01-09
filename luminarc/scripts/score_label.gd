extends RichTextLabel


func _ready() -> void:
	GameState.signal_score_changed.connect(score_changed)
	self.add_theme_font_size_override("normal_font_size", 120)
	

func score_changed(score: int):
	text = "[center]" + str(GameState.score).pad_zeros(2)
	self.rotation_degrees = randf_range(-10, 10)
	self.scale = Vector2(1.3, 1.3)
	if score > 99:
		self.add_theme_font_size_override("normal_font_size", 100)
	if score > 999:
		self.add_theme_font_size_override("normal_font_size", 80)


func _process(_delta: float) -> void:
	self.scale = lerp(self.scale, Vector2(1.0, 1.0), 0.1)
	self.rotation_degrees = lerp(self.rotation_degrees, 0.0, 0.1)
