extends Node2D


var initial_scale: Vector2


func _ready() -> void:
	initial_scale = self.scale
	GameState.signal_score_changed.connect(score_changed)
	

func score_changed(score: int):
	self.scale = initial_scale + Vector2(0.02, 0.02)


func _process(delta: float) -> void:
	self.visible = GameState.started or GameState.starting
	self.scale = lerp(self.scale, initial_scale, 0.1)
