extends State

@export_group("Camera")
@export_range(0.0, 1.0) var mouse_sensitivity := 0.25

@export_group("Movement")
@export var move_speed := 35.0
@export var acceleration := 150
@export var rotation_speed := 10.0
@export var blend_speed := 15
@export var jump_impulse := 12.0
@export var _gravity := -30.0

@onready var _player_pcam: PhantomCamera3D = %PhantomCamera3D

var _cam_input_dir := Vector2.ZERO
var _last_movement_direction := Vector3.BACK
var move_direction


@onready var _rootNode : CharacterBody3D = get_parent().get_parent()
@onready var _cam : Camera3D = %Camera3D
@onready var _baseHunter : Node3D = %Armature

var run_value = 0.0
var player_movement_in_control = true
var raw_input = Vector2.ZERO
@export var min_pitch: float = -89.9
@export var max_pitch: float = 50

@export var min_yaw: float = 0
@export var max_yaw: float = 360


var targeting = false
func _unhandled_input(event: InputEvent) -> void:
	
	_set_pcam_rotation(_player_pcam, event)
	
	
	var _is_cam_motion := (event is InputEventMouseMotion and 
						Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED)
						
	
	if _is_cam_motion:
		_cam_input_dir = event.screen_relative * mouse_sensitivity
		
	if event.is_action_pressed("Target"):
		targeting = !targeting


func onEnter():
	pass
func onExit():
	pass
	
func do(delta : float):
	baseMovement(delta)

	if targeting:
		get_node("TargetedMovement").do(delta)
	else:
		get_node("Untargeted Movement").do(delta)



func baseMovement(delta):
	
	
	# Movement #
	_cam_input_dir = Vector2.ZERO
	if player_movement_in_control:
		raw_input = Input.get_vector("Left", "Right", "Forward", "Back")
	var forward := _player_pcam.global_basis.z
	var right := _player_pcam.global_basis.x
	move_direction = forward * raw_input.y + right* raw_input.x
	move_direction.y = 0.0
	move_direction = move_direction.normalized()
	
	var y_velocity := _rootNode.velocity.y
	_rootNode.velocity.y = 0.0
	
	
	_rootNode.velocity = _rootNode.velocity.move_toward(move_direction * move_speed, acceleration * delta)
	_rootNode.velocity.y = y_velocity + _gravity * delta
	_rootNode.move_and_slide()
	
	if move_direction.length() > 0.2:
		_last_movement_direction = move_direction
		
	# Rotating the player #
	if player_movement_in_control:
		var target_angle := Vector3.BACK.signed_angle_to(_last_movement_direction, Vector3.UP)
		_baseHunter.global_rotation.y = lerp_angle(_baseHunter.global_rotation.y, target_angle, rotation_speed * delta)

func _set_pcam_rotation(pcam: PhantomCamera3D, event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var pcam_rotation_degrees: Vector3

		# Assigns the current 3D rotation of the SpringArm3D node - so it starts off where it is in the editor
		pcam_rotation_degrees = pcam.get_third_person_rotation_degrees()

		# Change the X rotation
		pcam_rotation_degrees.x -= event.relative.y * mouse_sensitivity

		# Clamp the rotation in the X axis so it go over or under the target
		pcam_rotation_degrees.x = clampf(pcam_rotation_degrees.x, min_pitch, max_pitch)

		# Change the Y rotation value
		pcam_rotation_degrees.y -= event.relative.x * mouse_sensitivity

		# Sets the rotation to fully loop around its target, but witout going below or exceeding 0 and 360 degrees respectively
		pcam_rotation_degrees.y = wrapf(pcam_rotation_degrees.y, min_yaw, max_yaw)

		# Change the SpringArm3D node's rotation and rotate around its target
		pcam.set_third_person_rotation_degrees(pcam_rotation_degrees)
