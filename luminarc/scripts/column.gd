class_name Column
extends Node2D

var column_index: int = 0
var blocks: Array[Block]
@onready var column_area: Area2D = $column_area
@onready var column_label: RichTextLabel = $column_label

func _ready() -> void:
	column_area.column_index = column_index
	column_label.text = "[center]"+str(column_index)
	for i in range(5):
		GameState.block_nodes[column_index].append(get_child(i))
		blocks.append(get_child(i))
	self.visible = false
	GameState.signal_column_hit.connect(_column_hit)


func _column_hit(col_idx: int):
	var scored: bool = false
	if col_idx != column_index:
		return
	for block in blocks:
		if block.grouped:
			block.score_block()
			scored = true
	if scored:
		Audio.play_event("collect_block")
		FmodServer.set_global_parameter_by_name("score_pitch", FmodServer.get_global_parameter_by_name("score_pitch") + 0.1)
		GameState.increment_combo()
	else:
		FmodServer.set_global_parameter_by_name("score_pitch", 0.0)
		GameState.reset_combo()

func _process(_delta: float) -> void:
	if GameState.started:
		return
	self.visible = true
