class_name TelloMoveLerpCharacter
extends CharacterBody3D

@export var distance_in_meter_per_seconds: Vector3 = Vector3(0.5, 0.2, 0.8)
@export var horizontal_angle_per_seconds: float = 90.0

@export var direction_user: Vector3 = Vector3.ZERO
@export var  rotate_left_right_user: float = 0.0

var direction_user_previous: Vector3 = Vector3.ZERO
var rotate_left_right_user_previous: float = 0.0

@export var lerp_rotation: float = 1.0
@export var lerp_move: float = 1.0


func _physics_process(delta: float) -> void:
	# Smooth input
	rotate_left_right_user_previous = lerp(
		rotate_left_right_user_previous,
		rotate_left_right_user,
		lerp_rotation * delta
	)

	direction_user_previous = direction_user_previous.lerp(
		direction_user,
		lerp_move * delta
	)

	# Ignore pitch for movement direction
	var drone_rot: Vector3 = rotation_degrees
	drone_rot.x = 0.0
	var drone_basis: Basis = Basis.from_euler(drone_rot * PI / 180.0)

	# Build velocity (Godot wants velocity, not position delta)
	var move: Vector3 = Vector3.ZERO
	move += Vector3.FORWARD * distance_in_meter_per_seconds.z * direction_user_previous.z
	move += Vector3.UP * distance_in_meter_per_seconds.y * direction_user_previous.y
	move += Vector3.RIGHT * distance_in_meter_per_seconds.x * direction_user_previous.x

	move = drone_basis * move

	velocity = move

	# Apply movement with collision
	move_and_slide()

	# Rotate
	rotation_degrees.y += -horizontal_angle_per_seconds * delta * rotate_left_right_user_previous


func set_frontal_move(back_forward: float) -> void:
	direction_user.z = clamp(back_forward, -1.0, 1.0)


func set_horizontal_rotation(rotate_left_right: float) -> void:
	rotate_left_right_user = clamp(rotate_left_right, -1.0, 1.0)


func set_horizontal_move(left_right: float) -> void:
	direction_user.x = clamp(left_right, -1.0, 1.0)


func set_vertical_move(down_up: float) -> void:
	direction_user.y = clamp(down_up, -1.0, 1.0)
