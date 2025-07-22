extends FSMState
class_name PlayerLand

@export var player : CharacterBody3D

@export var SPEED = 30.0
var S_MULT = 1.65

@export var landSFX1 : AudioStreamWAV
@export var landSFX2 : AudioStreamWAV


func enter():
	for child in %WallRaycasts.get_children():
		child.enabled = true
		
	if randf() >= 0.5:
		GameAudioManager.playSFX(player.global_position, landSFX1, 0, true)
	else:
		GameAudioManager.playSFX(player.global_position, landSFX2, 0 , true)
		#
	playDirectionalAnim()
	Fx.dustParticleFx(player.global_position + Vector3(0, 1.5, 1.5), 0)
	await get_tree().create_timer(0.15).timeout
	if %StateMachine.current_state.name == "PlayerLand":
		Transitioned.emit(self, "PlayerIdle")
	
	

func exit():
	pass
	

func physics_update(_delta:float):
	var input_dir
	
	input_dir = Vector2(
	Input.get_action_strength("D") - Input.get_action_strength("A"),
	Input.get_action_strength("S") - Input.get_action_strength("W")).normalized()
	
	
	
	if input_dir != Vector2.ZERO:
		player.facing = (input_dir)

	
	var player_direction := (player.transform.basis * Vector3(input_dir.x, 0, input_dir.y))
	
	
	## Normalzing the run speed
	#if anim == "movementAnims/land_upleft" or anim == "movementAnims/run_upright":
		#SPEED = 25 * S_MULT
	#elif  anim == "movementAnims/run_downleft" or anim == "movementAnims/run_downright":
		#SPEED = 25 * S_MULT
	#elif anim == "movementAnims/run_left" or anim == "movementAnims/run_right":
		#SPEED = 20.0 * S_MULT
	#else:
		#SPEED = 30.0 * S_MULT
	#
	
	
	
	
	if player_direction != Vector3.ZERO:
		
		player.velocity.x = player_direction.normalized().x * SPEED
		player.velocity.z = player_direction.normalized().z * SPEED
	#
	#if Input.is_action_pressed("rightShoulderButton"):
		#SPEED = 325
	#else :
		#SPEED = 250
	#
	
	#if Input.is_action_just_pressed("J"):
		#Transitioned.emit(self, "PlayerMelee")
	#
	
	if Input.is_action_just_pressed("Dash") and player.can_dash:
		Transitioned.emit(self, "PlayerDash")
		#
	#if player.joy_dir != Vector2.ZERO or Input.is_action_pressed("rightClick"):
		#Transitioned.emit(self, "PlayerAiming")
	#
	
	if Input.is_action_just_pressed("J"):
		Transitioned.emit(self, "PlayerMelee")
		
	if Input.is_action_just_pressed("Jump") and player.is_on_floor():
		Transitioned.emit(self, "PlayerJump")
	
	
	if player.velocity.y <= 0 and !player.is_on_floor():
		Transitioned.emit(self, "PlayerFall")
		
	#Add Gravity
	player.velocity += Vector3(0, -98, 0) * _delta
	
	player.move_and_slide()



func playDirectionalAnim():
	var anim_name = "movementAnims/land_" + vecToDir(player.facing)
	
	if anim_name =="movementAnims/land_downleft" or anim_name == "movementAnims/land_downright":
		anim_name = "movementAnims/land_down"
		
		
	if anim_name =="movementAnims/land_upleft" or anim_name == "movementAnims/land_upright":
		anim_name = "movementAnims/land_up"
	
	
	if anim_name != "movementAnims/land":
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
