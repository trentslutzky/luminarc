extends Node2D

var target_scale: float = 1.0


func _ready() -> void:
	GameState.signal_start_game.connect(_on_start_game)
	GameState.signal_reset_game.connect(_on_game_reset)


func _process(delta: float) -> void:
	rotation_degrees += 10.0 * delta
	self.scale = lerp(self.scale, Vector2(target_scale, target_scale), 0.1)


func _on_start_game():
	target_scale = 1.676


func _on_game_reset():
	target_scale = 1
