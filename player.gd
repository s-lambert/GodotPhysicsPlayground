extends CharacterBody3D

@export var target: Node3D

const JUMP_VELOCITY = 4.5
const SPEED = 5.0
const ROTATION_SPEED = 5.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var ground_normal = Vector3.UP

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("move_backward", "move_forward", "strafe_left", "strafe_right")
	var direction := (Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		var towards_target = target.global_position - self.global_position
		var rotation_towards_enemy = atan2(towards_target.z, towards_target.x)
		var rotation_basis = Basis(Vector3.UP, rotation_towards_enemy)
		var rotated_direction = direction * rotation_basis
		
		velocity.x = rotated_direction.x * SPEED
		velocity.z = rotated_direction.z * SPEED
		
		var character_rotation_basis = Basis(Vector3.UP, -rotation_towards_enemy - PI / 2)
		transform.basis = character_rotation_basis
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
