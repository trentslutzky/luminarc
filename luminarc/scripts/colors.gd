extends Node2D

@export var current_colorscheme: ColorScheme


func _ready() -> void:
	set_colors(current_colorscheme)


func set_colors(current_colorscheme):
	GameState.set_colors(current_colorscheme)
