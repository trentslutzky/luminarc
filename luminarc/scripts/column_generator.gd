extends Node2D

var initial_startup: bool = false

@export var column_scene: PackedScene

func _ready() -> void:
	GameState.signal_start_game.connect(generate_columns)
	GameState.signal_reset_game.connect(clear_columns)


func generate_columns():
	if initial_startup:
		return
	for i in range(18):
		var new_child = column_scene.instantiate()
		new_child.name = "column " + str(i)
		new_child.column_index = i
		add_child(new_child)
		new_child.rotation_degrees = 20.0 * (i)
		Audio.play_event("quick_click")
		await get_tree().create_timer(0.05).timeout
	initial_startup = true
	GameState.columns_generated = true


func clear_columns():
	initial_startup = false
	for child in get_children():
		child.queue_free()


func _process(_delta: float) -> void:
	pass
