extends AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameState.signal_game_over.connect(_on_game_over)
	GameState.signal_start_game.connect(_on_game_start)


func _on_game_over():
	self.play("game_over")


func _on_game_start():
	self.play("game_start")
