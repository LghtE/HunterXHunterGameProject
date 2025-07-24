extends FSMState
class_name PlayerAiming

@export var aimSFX1 : AudioStreamWAV
@export var aimSFX2 : AudioStreamWAV
@export var aimEnd : AudioStreamWAV


@export var player : CharacterBody3D
var moving = false
var shooting = false
var offset = Vector3(0,-30, 0) # Offset from origin to mid of player body

var cam_tw : Tween
var AIMING_WALK_SPEED = 0.35 * 25

func enter():
	randomize()
	#%AimAssist.onEnable()
	
	if cam_tw:
		if cam_tw.is_running():
			cam_tw.stop()
			
	cam_tw = get_tree().create_tween()
	cam_tw.tween_property(%Pivot, "rotation_degrees:x", -7, 0.15).set_ease(Tween.EASE_OUT)
	
	%AimingCrosshair.size()
	
	# Don't play aiming sound if we were shooting
	#if !(get_parent().current_state == get_parent().get_node("PlayerShooting")):
	randomize()
	if randf() >= 0.5:
		GameAudioManager.playSFX(player.global_position, aimSFX1)
	else:
		GameAudioManager.playSFX(player.global_position, aimSFX2)
	
	%AimingCrosshair.position = Vector3.ZERO
	
	if GameGlobals.mouse_mode:
		%AimingCrosshair.global_position = Vector3(GameGlobals.returnMousePos().x, GameGlobals.returnMousePos().y, 0)
	else:
		%AimingCrosshair.global_position = player.global_position
	
	
	await get_tree().process_frame
	%AimingCrosshair.idle()
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame

	%AimingCrosshair.visible = true

func exit():
	#%AimAssist.onDisable()
	
	if cam_tw:
		if cam_tw.is_running():
			cam_tw.stop()
	
	cam_tw = get_tree().create_tween()
	cam_tw.tween_property(%Pivot, "rotation_degrees:x", 0.0, 0.15).set_ease(Tween.EASE_IN)
	
	
	
	
	%Animations.stopAllAnims()
	%AimingCrosshair.visible = false
	
	await get_tree().process_frame
	
	#%AimingCrosshair.position = Vector2.ZERO
	
	if !GameGlobals.mouse_mode:
		%AimingCrosshair.global_position = player.global_position
	
	#if player.cam_override:
		#player.resetCam()



func physics_update(_delta: float):
	
	
	# Tween position to joystick direction; We added offset so that crosshair starts from mid of player body
	
	if GameGlobals.mouse_mode:
		%AimingCrosshair.global_position = Vector3(GameGlobals.returnMousePos().x, GameGlobals.returnMousePos().y, 0)
		#%AimingCrosshair.position.x = clamp(%AimingCrosshair.position.x, -220, 220)
		#%AimingCrosshair.position.y = clamp(%AimingCrosshair.position.y, -220, 220)
	else:
		var tween = get_tree().create_tween()
		tween.tween_property(%AimingCrosshair, "position", (Vector3(player.joy_dir.x,0.12,player.joy_dir.y) * 25.0 ), 0.15)

	%CamFollow.position = player.to_local((player.global_position + %AimingCrosshair.global_position) / 2)
	
	
	var direction = Vector2(
	Input.get_action_strength("D") - Input.get_action_strength("A"),
	Input.get_action_strength("S") - Input.get_action_strength("W")).normalized()
	#
	if direction != Vector2.ZERO:
		moving = true
		player.velocity = Vector3(direction.x, 0, direction.y) * AIMING_WALK_SPEED
	else:
		moving = false
		player.velocity.x = move_toward(player.velocity.x, 0, 1)
		player.velocity.z = move_toward(player.velocity.z, 0, 1)
		
	
	
	var anim_name
	if GameGlobals.mouse_mode:
		anim_name = "aiming_" + vecToDir((GameGlobals.returnMousePos() - player.global_position).normalized())
	else:
		anim_name = "aiming_" + vecToDir(player.joy_dir)
	
	if anim_name =="aiming_downleft" or anim_name == "aiming_downright":
		anim_name = "aiming_down"
		
	if anim_name =="aiming_upleft" or anim_name == "aiming_upright":
		anim_name = "aiming_up"
		
	if anim_name != "aiming_":
		var nam = "movementAnims/" + anim_name
		%MovementAnims.play(nam)
	
	
	
	if player.joy_dir == Vector2.ZERO and !Input.is_action_pressed("rightClick"):
		Transitioned.emit(self, "PlayerIdle")
	#
	if Input.is_action_just_pressed("rightShoulderButton") or Input.is_action_just_pressed("leftClick"):
		Transitioned.emit(self, "PlayerShooting")
	#
	#if Input.is_action_pressed("leftTrigger"):
		#Transitioned.emit(self, "PlayerChoosingSkill")
	
	if player.velocity.y <= 0 and !player.is_on_floor():
		Transitioned.emit(self, "PlayerFall")
		
	#Add Gravity
	player.velocity += Vector3(0, -98, 0) * _delta
	
	player.move_and_slide()



func shoot():
	pass



func vecToDir(v : Vector2):
	if !v || v == Vector2.ZERO:
		return ""
	
	if v.x >= -0.7 and v.x <= 0.7:
		if v.y > 0:
			return "down"
		elif v.y < 0:
			return "up"
	if v.y >= -0.7 and v.y <= 0.7:
		if v.x > 0:
			return "right"
		elif v.x < 0:
			return "left"
	
	
	if v.x > 0.7 and v.y < -0.7:
		return "upright"
	elif v.x < -0.7 and v.y < 0:
		return "upleft"
	elif v.x > 0 and v.y > 0:
		return "downright"
	elif v.x < 0 and v.y > 0:
		return "downleft"
