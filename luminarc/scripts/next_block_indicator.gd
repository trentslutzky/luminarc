extends Sprite2D

@export var block_index: int = 0
@export var queue_number: int = 0

func _ready() -> void:	
	self.material = self.material.duplicate()


func _process(_delta: float) -> void:
	self.visible = (GameState.starting or GameState.started)
	var color_1: Color = Color(0.1, 0.1, 0.1, 0.6)
	var color_2: Color = Color(0.1, 0.1, 0.1, 0.5)

	if not GameState.started:
		self.material.set_shader_parameter("color1", color_1)
		self.material.set_shader_parameter("color2", color_2)
		return
	
	if GameState.next_block == null:
		return
	
	color_1 = GameState.block_colors[GameState.next_block[block_index]]
	color_2 = GameState.block_colors[GameState.next_block[block_index]]
	
	if queue_number > 0:
		color_1 = GameState.block_colors[GameState.upcoming_blocks[queue_number - 1][block_index]]
		color_2 = GameState.block_colors[GameState.upcoming_blocks[queue_number - 1][block_index]]
	else:
		if not GameState.valid_placement(block_index):
			color_1 = Color(0.5, 0.1, 0.1, 1)
			color_2 = Color(0.3, 0.1, 0.1, 1)
	
	self.material.set_shader_parameter("color1", color_1)
	self.material.set_shader_parameter("color2", color_2)
