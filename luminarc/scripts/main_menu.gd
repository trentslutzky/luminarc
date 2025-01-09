extends Node2D

@export var title: RichTextLabel
@export var prompt: RichTextLabel

var prompt_initial_y_pos: float

func _ready() -> void:
	GameState.signal_start_game.connect(_on_game_start)
	GameState.signal_reset_game.connect(_on_game_reset)
	prompt_initial_y_pos = prompt.position.y
	self.visible = true


func _on_game_start():
	var tween = get_tree().create_tween()
	tween.set_parallel()
	tween.tween_property(prompt, "position", Vector2(prompt.position.x, 520), 0.1).set_ease(Tween.EASE_OUT)


func _on_game_reset():
	var tween = get_tree().create_tween()
	tween.set_parallel()
	tween.tween_property(prompt, "position", Vector2(prompt.position.x, prompt_initial_y_pos), 0.1).set_ease(Tween.EASE_OUT)
