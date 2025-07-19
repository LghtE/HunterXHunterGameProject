extends FSMState
class_name PlayerJump

@export var player : CharacterBody3D

@export var JUMP_VELOCITY = 45.0

@export var jump_move_speed = 10.0


var current_jump_velocity = 0.0

var dir : Vector2

var jump_hold_time := 0.0
const MAX_JUMP_HOLD_TIME := 0.3  # seconds
const EXTRA_JUMP_FORCE := 200.0

var jump_released := false
const CUT_JUMP_MULTIPLIER := 0.5  # How much velocity remains when jump is released

func enter():
	Fx.dustParticleFx(player.global_position + Vector3(0, 1.5, 1.5), 0)
	player.velocity.y = JUMP_VELOCITY
	jump_released = false
	
	playDirectionalAnim()
	
func exit():
	pass

func physics_update(_delta: float):
	player.checkForWalls()
	player.velocity.x = move_toward(player.velocity.x, 0, 3)
	player.velocity.z = move_toward(player.velocity.z, 0, 3)
	
	# CUT jump if player releases the jump button while still going up
	if not Input.is_action_pressed("Jump") and not jump_released:
		if player.velocity.y > 0:
			player.velocity.y *= CUT_JUMP_MULTIPLIER
		jump_released = true
	
	
	# Movement
	var input_dir
	
	input_dir = Vector2(
	Input.get_action_strength("D") - Input.get_action_strength("A"),
	Input.get_action_strength("S") - Input.get_action_strength("W")).normalized()
	
	if input_dir != Vector2.ZERO:
		player.facing = (input_dir)
		playDirectionalAnim()

	
	var player_direction := (player.transform.basis * Vector3(input_dir.x, 0, input_dir.y))
	
	if player_direction != Vector3.ZERO:
		player.velocity.x = player_direction.normalized().x * jump_move_speed
		player.velocity.z = player_direction.normalized().z * jump_move_speed
	
	
	#Add Gravity
	player.velocity += Vector3(0, -98, 0) * _delta
	
	if player.velocity.y <= 0:
		Transitioned.emit(self, "PlayerFall")
	
	if Input.is_action_just_pressed("Dash") and player.can_dash:
		Transitioned.emit(self, "PlayerDash")
	
	player.move_and_slide()


func playDirectionalAnim():
	var anim_name = "movementAnims/jump_" + vecToDir(player.facing)
	
	if anim_name =="movementAnims/jump_downleft" or anim_name == "movementAnims/jump_downright":
		anim_name = "movementAnims/jump_down"
		
		
	if anim_name =="movementAnims/jump_upleft" or anim_name == "movementAnims/jump_upright":
		anim_name = "movementAnims/jump_up"
	
	
	if anim_name != "movementAnims/jump":
		%MovementAnims.play(anim_name)


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
