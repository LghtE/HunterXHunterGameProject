extends FSMState
class_name PlayerRunning

@export var player : CharacterBody3D
@export var SPEED = 30.0
@export var run1 : AudioStreamWAV
@export var run2 : AudioStreamWAV

var S_MULT = 1.65

func enter():
	%Shadow.position.y = player.position.y + 0.7
	#%RunDust.emitting = true

func exit():
	pass
	#%RunDust.emitting = false
func update(_delta: float):
	pass

func physics_update(_delta:float):
	var input_dir
	
	input_dir = Vector2(
	Input.get_action_strength("D") - Input.get_action_strength("A"),
	Input.get_action_strength("S") - Input.get_action_strength("W")).normalized()
	
	
	
	if input_dir != Vector2.ZERO:
		player.facing = (input_dir)

	

	var anim = "movementAnims/run_" + vecToDir(input_dir)
	if anim != "movementAnims/run_":
		
		%MovementAnims.play(anim)
	
	var player_direction := (player.transform.basis * Vector3(input_dir.x, 0, input_dir.y))
	
	
	# Normalzing the run speed
	if anim == "movementAnims/run_upleft" or anim == "movementAnims/run_upright":
		SPEED = 25 * S_MULT
	elif  anim == "movementAnims/run_downleft" or anim == "movementAnims/run_downright":
		SPEED = 25 * S_MULT
	elif anim == "movementAnims/run_left" or anim == "movementAnims/run_right":
		SPEED = 20.0 * S_MULT
	else:
		SPEED = 30.0 * S_MULT
	
	
	
	
	
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
	if input_dir == Vector2.ZERO and %StateMachine.current_state.name != "PlayerMelee":
		Transitioned.emit(self, "PlayerIdle")
	
	#if Input.is_action_just_pressed("Y"):
		#if player.aura_amount >= (20.0 * 3):
			#Transitioned.emit(self, "PlayerHealing")
		
	if Input.is_action_just_pressed("Jump") and player.is_on_floor():
		Transitioned.emit(self, "PlayerJump")
	
	
	if player.velocity.y <= 0 and !player.is_on_floor():
		Transitioned.emit(self, "PlayerFall")
		
	#Add Gravity
	player.velocity += Vector3(0, -98, 0) * _delta
	
	player.move_and_slide()




func runSound1():
	GameAudioManager.playSFX(player.global_position, run1, 0, true)
func runSound2():
	GameAudioManager.playSFX(player.global_position, run2, 0, true)
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
