extends RichTextLabel

func _ready():
	GameState.signal_combo_increased.connect(_on_combo_change)
	GameState.signal_combo_reset.connect(_on_combo_reset)
	self.visible = false


func _on_combo_change(combo: int):
	if combo > 2:
		self.add_theme_font_size_override("normal_font_size", 20 + (combo))
		self.visible = true
		self.text = str(combo) + "x"
		self.scale = Vector2(1.05, 1.05)
		self.rotation_degrees = [-combo, combo].pick_random()


func _on_combo_reset():
	self.visible = false
	self.text = ""
	self.add_theme_font_size_override("normal_font_size", 20) 


func _process(delta: float) -> void:
	self.scale = lerp(self.scale, Vector2(1.0, 1.0), 0.1)
	self.rotation_degrees = lerp(self.rotation_degrees, 0.0, 0.1)
