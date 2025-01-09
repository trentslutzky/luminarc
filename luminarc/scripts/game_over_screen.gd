extends Node2D


func _process(delta: float) -> void:
	self.visible = GameState.gameover
