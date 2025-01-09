extends Node2D

@export var bpm: float = 160.0 # Beats per minute
@export var beats_per_rotation: float = 18.0 # Number of beats for a full rotation

@onready var scan_area: Area2D = $scan_area

var last_column_detected: int = -1


func _ready() -> void:
	GameState.signal_game_over.connect(_on_game_over)


func _process(delta: float) -> void:
	if not GameState.started:
		self.visible = false
		return

	self.visible = true

	if GameState.gameover or GameState.paused:
		return

	# Calculate the time for one full rotation (in seconds)
	var rotation_time = 60.0 / bpm * beats_per_rotation
	# Calculate the rotation speed (radians per second)
	var rotation_speed = TAU / rotation_time # TAU is 2 * PI
	# Increment the rotation based on speed and delta
	rotation += rotation_speed * delta

	var bodies = scan_area.get_overlapping_areas()
	if bodies:
		var detected_index = bodies[0].column_index
		if detected_index != last_column_detected:
			last_column_detected = detected_index
			GameState.line_over_column(detected_index)


func _on_game_over():
	self.visible = false
