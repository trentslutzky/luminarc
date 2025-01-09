extends Node2D


var column_index: int = 0
var initial_scale: Vector2
@export var pulse: bool = false

func _ready() -> void:
	GameState.circle = self
	initial_scale = self.scale
	GameState.signal_score_changed.connect(score_changed)
	

func score_changed(score: int):
	if not pulse:
		return
	self.scale = initial_scale + Vector2(0.02, 0.02)


func _process(_delta: float) -> void:
	self.visible = (GameState.starting or GameState.started)
	self.rotation = lerp_angle(self.rotation, deg_to_rad((-20.0 * float(GameState.current_column_index)) - 10.0), 0.2)
	self.scale = lerp(self.scale, initial_scale, 0.1)
