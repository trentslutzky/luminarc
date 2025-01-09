extends Node

signal signal_column_hit(idx: int)
signal signal_game_over
signal signal_start_game
signal signal_score_changed(score: int)
signal signal_column_focused()
signal signal_blocks_placed
signal signal_colorscheme_changed(scheme: ColorScheme)
signal signal_combo_increased(current: int)
signal signal_combo_reset
signal signal_reset_game

var score: int = 0
var gameover: bool = false
var paused: bool = false
var columns_generated: bool = false
var starting: bool = false
var started: bool = false
var circle: Node2D
var current_column_index: int = 0
var focused_blocks: Array[Block]
var focused_columns: Array[int]
var next_block = []
var upcoming_blocks = []
var consecutive_score: float = 0
var combo: int = 0
var block_nodes = [[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[]]

var block_colors: Array[Color] = [Color(0.0, 0.5, 1.0, 0.5), Color(0.0, 1.0, 0.0, 0.5)]
var grouped_block_colors: Array[Color] = [Color(0.0, 0.5, 1.0, 1.0), Color(0.0, 1.0, 0.0, 1.0)]
var warning_color: Color
var background_color: Color

var music_filter: float = 1.0
var target_music_filter: float = 1.0
var music_pitch: float = 1.0
var target_music_pitch: float = 1.0

var force_timer: Timer
var force_time: float = 3.0

func _ready() -> void:
	force_timer = Timer.new()
	add_child(force_timer)
	force_timer.one_shot = true
	force_timer.timeout.connect(_on_force_timer_timeout)


func _on_force_timer_timeout():
	if not started or gameover:
		return
	lock_in_blocks()


func start() -> void:
	FmodServer.pause_all_events()
	upcoming_blocks = [
		[randi_range(0, 1), randi_range(0, 1)],
		[randi_range(0, 1), randi_range(0, 1)],
		[randi_range(0, 1), randi_range(0, 1)],
		[randi_range(0, 1), randi_range(0, 1)]
	]
	target_music_filter = 1.0
	target_music_pitch = 1.0
	Audio.play_event("start_game")
	Audio.start_song("soundtrack")
	score = 0
	started = false
	gameover = false
	starting = true
	signal_score_changed.emit(0)
	signal_start_game.emit()
	select_next_block()
	determine_focused_blocks()


func select_next_block():
	var new_block = [randi_range(0, 1), randi_range(0, 1)]
	next_block = upcoming_blocks[0]
	upcoming_blocks.remove_at(0)
	upcoming_blocks.append(new_block)


func _process(_delta: float) -> void:
	
	music_pitch = lerp(music_pitch, target_music_pitch, 0.05)
	music_filter = lerp(music_filter, target_music_filter, 0.005)
	
	FmodServer.set_global_parameter_by_name("music_filter", music_filter)
	FmodServer.set_global_parameter_by_name("music_pitch", music_pitch)
	
	if starting and columns_generated and circle != null and !started:
		started = true
		force_timer.start(force_time)
	
	if Input.is_action_just_pressed("start") and not starting and not started:
		start()
	
	if not started:
		return
	
	if gameover:
		if Input.is_action_just_pressed("start"):
			reset_game()
		return
	
	if not paused:
		if Input.is_action_just_pressed("next_column"):
			Audio.play_event("right_click")
			prev_column()
		if Input.is_action_just_pressed("prev_column"):
			Audio.play_event("left_click")
			next_column()
		if Input.is_action_just_pressed("place_blocks"):
			lock_in_blocks()


func prev_column():
	var next_index = current_column_index + 1
	if next_index > 17:
		next_index = 0
	current_column_index = next_index
	determine_focused_blocks()
	signal_column_focused.emit()


func next_column():
	var next_index = current_column_index - 1
	if next_index < 0:
		next_index = 17
	current_column_index = next_index
	determine_focused_blocks()
	signal_column_focused.emit()


func get_available_block_in_column(col_idx) -> Block:
	for block in block_nodes[col_idx]:
		if block.filled == -1:
			return block
	return null


func get_block(idx: Vector2i):
	if idx.y in [-1, 5]:
		return null
	if idx.x == -1:
		idx.x = 17
	if idx.x == 18:
		idx.x = 0
	return block_nodes[idx.x][idx.y]


func determine_focused_blocks():
	var neighbor_column_index = current_column_index + 1
	if neighbor_column_index == 18:
		neighbor_column_index = 0
	focused_columns = [current_column_index, neighbor_column_index]
	focused_blocks = [
		get_available_block_in_column(current_column_index),
		get_available_block_in_column(neighbor_column_index)
	]


func valid_placement(col_idx = null):
	if not focused_blocks:
		return false
	if col_idx == null:
		if null in focused_blocks:
			return false
	if col_idx == 1:
		if focused_blocks[1] == null:
			return false
	if col_idx == 0:
		if focused_blocks[0] == null:
			return false
	return true


func lock_in_blocks():
	if not valid_placement():
		end_game()
		return
	Audio.play_event("place_blocks")
	for i in range(2):
		focused_blocks[i].filled = next_block[i]
	select_next_block()
	determine_focused_blocks()
	signal_blocks_placed.emit()
	force_timer.start(force_time)


func end_game():
	target_music_filter = 0.0
	target_music_pitch = 0.75
	gameover = true
	Audio.play_event("game_over")
	signal_game_over.emit()


func reset_game():
	FmodServer.pause_all_events()
	score = 0
	gameover = false
	paused = false
	columns_generated = false
	starting = false
	started = false
	current_column_index = 0
	focused_blocks = []
	focused_columns = []
	next_block = []
	upcoming_blocks = []
	consecutive_score = 0
	combo = 0
	block_nodes = [[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[]]
	signal_reset_game.emit()


func is_valid_block_place(c, b):
	if c < 0 or c > 17:
		return false
	if b < 0 or b > 4:
		return false
	return true


func line_over_column(col_idx: int):
	signal_column_hit.emit(col_idx)
	Audio.play_event("scan_column")
	determine_focused_blocks()


func score_block(block: Block):
	score += 1 * (combo if combo > 2 else 1)
	signal_score_changed.emit(score)


func set_colors(scheme: ColorScheme):
	block_colors[0] = scheme.block_a
	block_colors[1] = scheme.block_b
	grouped_block_colors[0] = scheme.block_a_grouped
	grouped_block_colors[1] = scheme.block_b_grouped
	background_color = scheme.background
	signal_colorscheme_changed.emit(scheme)


func increment_combo():
	combo += 1
	signal_combo_increased.emit(combo)


func reset_combo():
	combo = 0
	signal_combo_reset.emit()
