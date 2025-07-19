extends CharacterBody3D

var  SPEED = 30.0
var S_MULT = 1.65
const JUMP_VELOCITY = 10.0 * 4.0
var moving = false
var facing = Vector2.DOWN

var idx = 0
var in_air = false
var f_idx = 0

var joypad_sensitivity = 5.0
@onready var _camPivot = $Pivot


@export var current_health : float = 100.0
@export var max_health : float = 100.0

@export var id = "Fos"






func _input(event: InputEvent) -> void:
	if event.is_action_pressed("F"):
		if f_idx == 0:
			f_idx = 1
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
		else:
			f_idx = 0
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)



func _ready() -> void:
	pass

func _process(delta: float) -> void:
	var cam_tw = get_tree().create_tween()
	cam_tw.tween_property($Pivot, "global_position", $CamFollow.global_position, 0.3).set_ease(Tween.EASE_OUT)


func _physics_process(delta: float) -> void:
	
	if current_health <= 0:
		get_tree().quit()
	
	$Shadow.position.x = position.x 
	$Shadow.position.z = position.z - 1
	
	if is_on_floor() and in_air:
		in_air = false
		$Shadow.position.y = position.y + 0.25

	
	# Add the gravity.
	if not is_on_floor():
		in_air = true
		velocity += Vector3(0, -98, 0) * delta
	
	# Handle jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		in_air = true

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down").normalized()
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y))
	
	if input_dir:
		facing = input_dir
	
	if input_dir:
		moving = true
	else:
		moving = false
	
	if moving:
		idx = 1
		var anim = "movementAnims/run_" + vecToDir(facing)
		
		if anim == "movementAnims/run_upleft" or anim == "movementAnims/run_upright":
			SPEED = 25 * S_MULT
		elif  anim == "movementAnims/run_downleft" or anim == "movementAnims/run_downright":
			SPEED = 25 * S_MULT
			
		elif anim == "movementAnims/run_left" or anim == "movementAnims/run_right":
			SPEED = 20.0 * S_MULT
		else:
			SPEED = 30.0 * S_MULT
		%AnimationPlayer.play(anim)
	else:
		var anim = "movementAnims/idle_" + vecToDir(facing)
		
		
		if idx == 1:
			idx = 0
			%AnimationPlayer.play(anim)
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, 30)
		velocity.z = move_toward(velocity.z, 0, 30)
	
	move_and_slide()
	
	
	
	var stick_vector = Input.get_vector("joy_left", "joy_right", "joy_up", "joy_down")
	# Cam rotate 
	_camPivot.rotation.x += stick_vector.y * delta * joypad_sensitivity
	_camPivot.rotation.x = clamp(_camPivot.rotation.x, -PI / 6.0, PI / 6.0)
	_camPivot.rotation.y -= stick_vector.x * delta * joypad_sensitivity

func vecToDir(v : Vector2):
	if !v || v == Vector2.ZERO:
		return ""
	
	if v.x >= -0.5 and v.x <= 0.5:
		if v.y > 0:
			return "down"
		elif v.y < 0:
			return "up"
	if v.y >= -0.7 and v.y <= 0.7:
		if v.x > 0:
			return "right"
		elif v.x < 0:
			return "left"
	
	
	if v.x > 0.5 and v.y < -0.7:
		return "upright"
	elif v.x < -0.5 and v.y < 0:
		return "upleft"
	elif v.x > 0 and v.y > 0:
		return "downright"
	elif v.x < 0 and v.y > 0:
		return "downleft"
