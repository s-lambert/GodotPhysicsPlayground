extends Node3D

@onready var player = $%Player

func _physics_process(delta: float) -> void:
	self.global_transform = player.global_transform
	self.global_rotation.y = player.global_rotation.y
