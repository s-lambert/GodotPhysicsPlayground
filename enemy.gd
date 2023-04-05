extends CharacterBody3D

@export var target: Node3D

const SPEED = 4.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	else: 
		var target_position = target.global_position
		var enemy_position = self.global_position
		var difference = target_position - enemy_position
		if difference.length() < 5.0:
			var direction = difference.normalized()
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
