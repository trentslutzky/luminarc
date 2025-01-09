extends RichTextLabel

func _process(delta: float) -> void:
	text = format_time_to_string(GameState.force_timer.time_left)


func format_time_to_string(time_seconds: float) -> String:
	# Extract seconds
	var seconds = int(time_seconds) % 60
	
	# Extract and round milliseconds to tens
	var milliseconds = int(round((time_seconds - int(time_seconds)) * 100))
	
	# Format as "seconds:milliseconds"
	return "%02d:%02d" % [seconds, milliseconds]
