extends Node3D

@onready var shader_material = $MeshInstance3D.get_active_material(0)

func _ready() -> void:
	shader_material.set("shader_param/start_time", Time.get_ticks_usec())
	get_tree()
