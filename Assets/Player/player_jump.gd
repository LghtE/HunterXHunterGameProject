extends FSMState
class_name PlayerJump

@export var player : CharacterBody3D

@export var JUMP_VELOCITY = 45.0

@export var jump_move_speed = 10.0



@export var jumpSFX1 : AudioStreamWAV
@export var jumpSFX2 : AudioStreamWAV

@export var special_jumpSFX : AudioStreamWAV
var current_jump_velocity = 0.0

var dir : Vector2

var jump_hold_time := 0.0
const MAX_JUMP_HOLD_TIME := 0.3  # seconds
const EXTRA_JUMP_FORCE := 200.0

var jump_released := false
const CUT_JUMP_MULTIPLIER := 0.5  # How much velocity remains when jump is released

var wall_jump = false
@export var WALL_JUMP_MULTIPLIER = 1.1
func enter():
	
	%AimingCrosshair.hide()
	
	Fx.dustParticleFx(player.global_position + Vector3(0, 0, 0), 1)
	
	if wall_jump:
		player.velocity.y = JUMP_VELOCITY * WALL_JUMP_MULTIPLIER
	else:
		player.velocity.y = JUMP_VELOCITY
	
	
	jump_released = false
	
	
	if wall_jump:
		GameAudioManager.playSFX(player.global_position, special_jumpSFX, 0 , true)
	else:
		if randf() >= 0.5:
			GameAudioManager.playSFX(player.global_position, jumpSFX1, 0, true)
		else:
			GameAudioManager.playSFX(player.global_position, jumpSFX2, 0 , true)
	
	
	playDirectionalAnim()
	
func exit():
	wall_jump = false

func physics_update(_delta: float):
	player.velocity.x = move_toward(player.velocity.x, 0, 3)
	player.velocity.z = move_toward(player.velocity.z, 0, 3)
	
	# CUT jump if player releases the jump button while still going up
	if wall_jump == false:
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
	
	if player.velocity.y <= 0 and wall_jump == false:
		Transitioned.emit(self, "PlayerFall")
	
	
	
	checkForWalls()
	player.move_and_slide()


func playDirectionalAnim():
	
	if wall_jump:
		if %MovementAnims.current_animation != "movementAnims/jump_special":
			
			if randf() >= 0.5:
				%SkinSuit.flip_h = true
			%MovementAnims.play("movementAnims/jump_special")
			$JumpSpecialTimer.start()
		return
	
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


func _on_jump_special_timer_timeout() -> void:
	wall_jump = false

func checkForWalls():
	if %StateMachine.current_state.name == "PlayerWallGrab":
		return
	
	for child : RayCast3D in %WallRaycasts.get_children():
		if child.is_colliding():
			%PlayerWallGrab.collided_raycast = child
			Transitioned.emit(self, "PlayerWallGrab")
			
			return
