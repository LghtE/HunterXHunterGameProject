extends State

@export_group("Camera")
@export_range(0.0, 1.0) var mouse_sensitivity := 0.25

@export_group("Movement")
@export var move_speed := 35.0
@export var acceleration := 150
@export var rotation_speed := 10.0
@export var blend_speed := 15
@export var jump_impulse := 12.0
@export var dash_impulse := 80.0
@export var _gravity := -30.0


var _cam_input_dir := Vector2.ZERO
var _last_movement_direction := Vector3.BACK
var move_direction


@onready var _rootNode : CharacterBody3D = get_parent().get_parent()
@onready var _cam : Camera3D = %Camera3D
@onready var _camPivot : Node3D = %CamPivot
@onready var _baseHunter : Node3D = %Armature

var run_value = 0.0
var player_movement_in_control = true
var raw_input = Vector2.ZERO



var targeting = false
func _unhandled_input(event: InputEvent) -> void:
	
	
	
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
		get_node("Aiming").do(delta)
	else:
		get_node("NotAiming").do(delta)



func baseMovement(delta):
	
	#Rotating the Cam
	_camPivot.rotation.x +=_cam_input_dir.y * delta
	_camPivot.rotation.x = clamp(_camPivot.rotation.x, -PI / 6.0, PI / 6.0)
	_camPivot.rotation.y -=_cam_input_dir.x * delta
	
	
	# Movement #
	_cam_input_dir = Vector2.ZERO
	if player_movement_in_control:
		raw_input = Input.get_vector("Left", "Right", "Forward", "Back")
	var forward := _cam.global_basis.z
	var right := _cam.global_basis.x
	move_direction = forward * raw_input.y + right* raw_input.x
	move_direction.y = 0.0
	move_direction = move_direction.normalized()
	print(%CameraTarget.position)
	var y_velocity := _rootNode.velocity.y
	_rootNode.velocity.y = 0.0
	
	
	_rootNode.velocity = _rootNode.velocity.move_toward(move_direction * move_speed, acceleration * delta)
	_rootNode.velocity.y = y_velocity + _gravity * delta
	_rootNode.move_and_slide()
	
	if move_direction.length() > 0.2:
		_last_movement_direction = move_direction
	
	%CamPivot.position = lerp(%CamPivot.position, _rootNode.position + Vector3(0,-1,0), 0.2)
	# Rotating the player #

	var target_angle := Vector3.BACK.signed_angle_to(_last_movement_direction, Vector3.UP)
	_baseHunter.global_rotation.y = lerp_angle(_baseHunter.global_rotation.y, target_angle, rotation_speed * delta)
	%Raycasts.global_rotation.y = lerp_angle(%Raycasts.global_rotation.y, target_angle, rotation_speed * delta)
