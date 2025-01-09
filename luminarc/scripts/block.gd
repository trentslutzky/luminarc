class_name Block
extends Node2D

var SHADER_ARC_ANGLE = 0.336

var block_index: Vector2i = Vector2i(0, 0)

@onready var particles: GPUParticles2D = $particles
@onready var sprite: Sprite2D = $arc

var filled: int = -1
var grouped: bool = false

var color_1: Color =  Color(1.0, 1.0, 1.0, 0.1)
var color_2: Color = Color(1.0, 1.0, 1.0, 0.1)
var target_color_1: Color =  Color(1.0, 1.0, 1.0, 0.1)
var target_color_2: Color = Color(1.0, 1.0, 1.0, 0.1)

var neighbors: Array[Block]

func _ready() -> void:
	self.block_index = Vector2i(get_parent().column_index, self.get_index())
	self.name = "block (" + str(block_index.x) + "," + str(block_index.y) + ")"
	GameState.signal_column_hit.connect(flash_column)
	GameState.signal_game_over.connect(_on_game_over)
	GameState.signal_blocks_placed.connect(_blocks_placed)
	GameState.signal_start_game.connect(_clear_self)
	sprite.material = sprite.material.duplicate()
	sprite.material.set_shader_parameter("arc_angle", SHADER_ARC_ANGLE)
	sprite.material.set_shader_parameter("checker_size", 0.01)
	target_color_1 = Color(0.1, 0.1, 0.1, 0.6)
	target_color_2 = Color(0.1, 0.1, 0.1, 0.2)
	color_1 = Color(0.1, 0.1, 0.1, 0.6)
	color_2 = Color(0.1, 0.1, 0.1, 0.2)
	sprite.material.set_shader_parameter("color1", color_1)
	sprite.material.set_shader_parameter("color2", color_2)


func _process(_delta: float) -> void:
	if not GameState.focused_blocks or not GameState.started:
		return
	
	if neighbors.size() == 0:
		calculate_neighbors()

	target_color_1 = Color(0.1, 0.1, 0.1, 0.6)
	target_color_2 = Color(0.1, 0.1, 0.1, 0.5)

	for i in range(2):
		if GameState.focused_blocks[i] == self:
			target_color_1 = GameState.block_colors[GameState.next_block[i]]
			target_color_2 = GameState.block_colors[GameState.next_block[i]]
			target_color_2.a = 0.0
	
	if filled != -1:
		target_color_2 = GameState.grouped_block_colors[filled] if grouped else GameState.block_colors[filled]
		target_color_1 = GameState.grouped_block_colors[filled] if grouped else GameState.block_colors[filled]
	
	if grouped:
		target_color_1 = GameState.grouped_block_colors[filled]
	
	color_1 = lerp(color_1, target_color_1, 0.4)
	color_2 = lerp(color_2, target_color_2, 0.4)
	
	sprite.material.set_shader_parameter("color1", color_1)
	sprite.material.set_shader_parameter("color2", color_2)


func flash_column(idx: int):
	if idx == self.block_index.x:
		color_1 = Color(1.0, 1.0, 1.0, 0.001)


func _on_game_over():
	pass


func calculate_neighbors():
	var dirs = [
		Vector2i(0, -1),
		Vector2i(1, -1),
		Vector2i(1, 0),
		Vector2i(1, 1),
		Vector2i(0, 1),
		Vector2i(-1, 1),
		Vector2i(-1, 0),
		Vector2i(-1, -1),
	]
	for dir in dirs:
		var block_dir = dir + block_index
		neighbors.append(GameState.get_block(block_dir))


func get_neighbor_fill(block: Block):
	return block.filled if block else -1


func calculate_grouping() -> bool:
	if filled == -1:
		return false
	var neighbor_groups = [
		[get_neighbor_fill(neighbors[0]), get_neighbor_fill(neighbors[1]), get_neighbor_fill(neighbors[2])],
		[get_neighbor_fill(neighbors[2]), get_neighbor_fill(neighbors[3]), get_neighbor_fill(neighbors[4])],
		[get_neighbor_fill(neighbors[4]), get_neighbor_fill(neighbors[5]), get_neighbor_fill(neighbors[6])],
		[get_neighbor_fill(neighbors[6]), get_neighbor_fill(neighbors[7]), get_neighbor_fill(neighbors[0])],
	]
	for group in neighbor_groups:
		if group == [filled, filled, filled]:
			return true
	return false


func _blocks_placed():
	if not grouped:
		grouped = calculate_grouping()
		if grouped:
			Audio.play_event("block_grouped")


func score_block():
	particles.process_material.color = GameState.grouped_block_colors[filled]
	if grouped:
		filled = -1
		grouped = false
		GameState.score_block(self)
		particles.emitting = true


func _clear_self():
	filled = -1
	grouped = false
