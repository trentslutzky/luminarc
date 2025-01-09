extends ColorRect

func _process(delta: float) -> void:
	self.visible = GameState.paused
