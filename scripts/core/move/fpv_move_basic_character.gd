class_name FpvMoveBasicCharacter
extends CharacterBody3D

# Percent Input
@export_range(-1.0, 1.0) var rotate_left_right_percent: float = 0.0
@export_range(-1.0, 1.0) var pitch_back_forward_percent: float = 0.0
@export_range(-1.0, 1.0) var roll_left_right_percent: float = 0.0
@export_range(-1.0, 1.0) var throttle_front_percent: float = 0.0

# Speed and Angle
@export var rotate_left_right_angle: float = 180.0
@export var pitch_back_forward_angle: float = 180.0
@export var roll_left_right_angle: float = 180.0
@export var throttle_front_speed: float = 5.0
@export var throttle_back_speed: float = 2.0

# Internal velocity
var velocity_local: Vector3 = Vector3.ZERO


func set_double_joystick(left_joystick: Vector2, right_joystick: Vector2):
	throttle_front_percent = left_joystick.y
	rotate_left_right_percent = left_joystick.x
	pitch_back_forward_percent = right_joystick.y
	roll_left_right_percent = right_joystick.x


func _physics_process(delta: float) -> void:
	# --- ROTATION (local) ---
	rotate_object_local(Vector3.UP, -deg_to_rad(rotate_left_right_angle * rotate_left_right_percent * delta))
	rotate_object_local(Vector3.RIGHT, deg_to_rad(pitch_back_forward_angle * pitch_back_forward_percent * delta))
	rotate_object_local(Vector3.FORWARD, -deg_to_rad(roll_left_right_angle * roll_left_right_percent * delta))

	# --- THROTTLE ---
	var throttle_speed =  throttle_front_speed if throttle_front_percent > 0.0 else  throttle_back_speed
	var speed = throttle_front_percent * throttle_speed

	# Move in local UP direction
	var local_up = transform.basis.y
	velocity_local = local_up * speed

	# Apply to CharacterBody
	velocity = velocity_local

	# Move with collision
	move_and_slide()
