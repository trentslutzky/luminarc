@tool
extends Sprite2D

@export var arc_radius: float = 0.0

func _process(delta: float) -> void:
	material.set_shader_parameter("radius", arc_radius)
