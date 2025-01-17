extends State

@export_group("Camera")
@export_range(0.0, 1.0) var mouse_sensitivity := 0.25

@export_group("Movement")
@export var move_speed := 35.0
@export var acceleration := 150
@export var rotation_speed := 10.0
@export var blend_speed := 15

var _cam_input_dir := Vector2.ZERO
var _last_movement_direction := Vector3.BACK


@onready var _cam_pivot : Node3D = %CameraPivot
@onready var _cam : Camera3D = %Camera3D
@onready var _baseHunter : Node3D = %Armature
@onready var _animTree: AnimationTree = $AnimationTree
var run_value = 0.0

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
		get_child(0).do(delta)
	else:
		get_child(1).do(delta)



func baseMovement(delta):
	# Pivoting the camera #
	_cam_pivot.rotation.x += _cam_input_dir.y * delta
	_cam_pivot.rotation.x = clamp(_cam_pivot.rotation.x, -PI / 6.0, PI / 3.0)
	_cam_pivot.rotation.y -= _cam_input_dir.x * delta
	
	# Movement #
	_cam_input_dir = Vector2.ZERO
	var raw_input := Input.get_vector("Left", "Right", "Forward", "Back")
	var forward := _cam.global_basis.z
	var right := _cam.global_basis.x
	var move_direction := forward * raw_input.y + right* raw_input.x
	move_direction.y = 0.0
	move_direction = move_direction.normalized()
	get_parent().get_parent().velocity = get_parent().get_parent().velocity.move_toward(move_direction * move_speed, acceleration * delta)
	get_parent().get_parent().move_and_slide()
	
	if move_direction.length() > 0.2:
		_last_movement_direction = move_direction
		
	# Rotating the player #
	var target_angle := Vector3.BACK.signed_angle_to(_last_movement_direction, Vector3.UP)
	_baseHunter.global_rotation.y = lerp_angle(_baseHunter.global_rotation.y, target_angle, rotation_speed * delta)
