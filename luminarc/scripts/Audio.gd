extends Node

var banks := Array()


func _ready() -> void:
	self.process_mode = Node.PROCESS_MODE_ALWAYS
	
	banks.append(
		FmodServer.load_bank(
			"res://audio/fmod_banks/Desktop/Master.bank", FmodServer.FMOD_STUDIO_LOAD_BANK_NORMAL
		)
	)
	
	banks.append(
		FmodServer.load_bank(
			"res://audio/fmod_banks/Desktop/Master.strings.bank", FmodServer.FMOD_STUDIO_LOAD_BANK_NORMAL
		)
	)
	
	banks.append(
		FmodServer.load_bank(
			"res://audio/fmod_banks/Desktop/sfx.bank", FmodServer.FMOD_STUDIO_LOAD_BANK_NORMAL
		)
	)

	banks.append(
		FmodServer.load_bank(
			"res://audio/fmod_banks/Desktop/MUSIC.bank", FmodServer.FMOD_STUDIO_LOAD_BANK_NORMAL
		)
	)


func play_event(event_name: String):
	var event_path = "event:/SFX/" + event_name
	if not FmodServer.check_event_path(event_path):
		print("FMOD: invalid event path " + event_path)
		return
	var event = FmodServer.create_event_instance(event_path)
	event.start()


func start_song(event_name: String):
	var event_path = "event:/MUSIC/" + event_name
	if not FmodServer.check_event_path(event_path):
		print("FMOD: invalid event path " + event_path)
		return
	var event = FmodServer.create_event_instance(event_path)
	event.start()
