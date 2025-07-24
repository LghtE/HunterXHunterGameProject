extends FSMState
class_name PlayerIdle

@export var player: CharacterBody3D



func enter():
	%SkinSuit.scale = Vector3(10, 10, 10)
	%Shadow.position.y = player.position.y + 0.7
	#%AimingCrosshair.visible = false
	
	#if !player.in_dialogue and player.cam_override:
		#player.bbClose()
	player.resetCam()
	
	var anim = "movementAnims/idle_" + vecToDir(player.facing)
	
	if anim != "idle_":
		%Animations.stopAllAnims()
		%MovementAnims.play(anim)
	

func physics_update(_delta: float):
	player.velocity.x = move_toward(player.velocity.x, 0, 3)
	player.velocity.z = move_toward(player.velocity.z, 0, 3)
	
	
	var direction = Vector2(
	Input.get_action_strength("D") - Input.get_action_strength("A"),
	Input.get_action_strength("S") - Input.get_action_strength("W")).normalized()
	
	
	if GameGlobals.player_can_move:
		if direction != Vector2.ZERO:
			player.facing = direction
			Transitioned.emit(self, "PlayerRunning")
	
	
	if Input.is_action_just_pressed("Jump") and player.is_on_floor():
		Transitioned.emit(self, "PlayerJump")
	
	
	if Input.is_action_just_pressed("J"):
		Transitioned.emit(self, "PlayerMelee")
	#
	#
	if Input.is_action_just_pressed("Dash") and player.can_dash:
		Transitioned.emit(self, "PlayerDash")
	#
	#
	if player.joy_dir != Vector2.ZERO or Input.is_action_pressed("rightClick"):
		Transitioned.emit(self, "PlayerAiming")
	
	#if Input.is_action_just_pressed("Y"):
		#if player.aura_amount >= (20.0 * 3):
			#Transitioned.emit(self, "PlayerHealing")
#
	
	#Add Gravity
	player.velocity += Vector3(0, -98, 0) * _delta
	
	if player.velocity.y <= 0 and !player.is_on_floor():
		Transitioned.emit(self, "PlayerFall")
	
	player.move_and_slide()




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
