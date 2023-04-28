extends CharacterBody3D

const EXPLOSION_SCENE := preload("res://explosion.tscn")

@export var acceleration = 10.0
@export var max_speed = 100.0
@export var turn_speed = 2.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var local_velocity = Vector3.ZERO

@onready var front_wheel_ray = $FrontWheelRay
@onready var rear_wheel_ray = $RearWheelRay

func _physics_process(delta: float) -> void:
	var forward = int(Input.is_action_pressed("move_backward")) - int(Input.is_action_pressed("move_forward"))
	var direction = int(Input.is_action_pressed("turn_right")) - int(Input.is_action_pressed("turn_left"))
	local_velocity.z += acceleration * forward * delta
	local_velocity.z = clamp(local_velocity.z, -max_speed, max_speed)
	
	var turn_amount = turn_speed * direction * delta
	rotate_y(turn_amount)
	
	var wheel_collision_info = check_wheels_collision()
	if wheel_collision_info.is_colliding:
		local_velocity.y = wheel_collision_info.distance
		
#		align_with_ground(wheel_collision_info)
	else:
		local_velocity.y -= gravity * delta  # Apply gravity if not on the ground
	
	
	velocity = global_transform.basis * local_velocity
	
	move_and_slide()
	
	if Input.is_action_just_pressed("explode"):
		spawn_explosion(global_position + (global_transform.basis * Vector3.FORWARD * 3.0))
	
	if forward == 0:
		local_velocity.z = lerp(local_velocity.z, 0.0, 0.1)

func check_wheels_collision():
	var front_colliding = front_wheel_ray.is_colliding()
	var rear_colliding = rear_wheel_ray.is_colliding()
	var result = {
		"is_colliding": false,
		"distance": 0.0,
		"ground_normal": Vector3.ZERO
	}
	
	if front_colliding or rear_colliding:
		result.is_colliding = true
		if front_colliding and rear_colliding:
			result.distance = min(front_wheel_ray.get_collision_point().y, rear_wheel_ray.get_collision_point().y)
			result.ground_normal = (front_wheel_ray.get_collision_normal() + rear_wheel_ray.get_collision_normal()).normalized()
		elif front_colliding:
			result.distance = front_wheel_ray.get_collision_point().y
			result.ground_normal = front_wheel_ray.get_collision_normal()
		else:
			result.distance = rear_wheel_ray.get_collision_point().y
			result.ground_normal = rear_wheel_ray.get_collision_normal()
	
	return result

func align_with_ground(wheel_collision_info):
	var target_up = wheel_collision_info.ground_normal
	var current_up = global_transform.basis.y
	var rotation_axis = current_up.cross(target_up).normalized()
	var rotation_angle = acos(current_up.dot(target_up))

	# Apply rotation to align with the ground
	rotate(rotation_axis.normalized(), rotation_angle * 0.1)

func spawn_explosion(position: Vector3) -> void:
	var explosion := EXPLOSION_SCENE.instantiate()
	add_child(explosion)
	explosion.global_position = position
