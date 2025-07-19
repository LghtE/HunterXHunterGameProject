extends FSMState
class_name PlayerDash

@export var player : CharacterBody3D
@export var DASH_SPEED = 200.0
@export var dashSFX1 : AudioStreamWAV
@export var dashSFX2 : AudioStreamWAV
@export var Slow_down_speed = 3

var dash_multiplier = 1.0

func enter():
	#%EyeTrail.start()
	player.velocity = Vector3.ZERO
	#$DustTimer.start()
	#%RunDust.emitting = true
	#%RunDust.process_material.scale = Vector2(2,2)
	
	#%DashSquareParticle.global_position = player.global_position + Vector2(0, -33)
	#%DashSquareParticle.emitting = true
	%AfterImageComponent.AiStart(%SkinSuit)
	
	
	randomize()
	
	#if randf() >= 0.5:
		#GameAudioManager.playSFX(player.global_position, dashSFX1, 3, true)
	#else:
		#GameAudioManager.playSFX(player.global_position, dashSFX2, 3 , true)
		#
	
	var anim_name = "movementAnims/dash_" + vecToDir(player.facing)
	
	if anim_name =="movementAnims/dash_downleft" or anim_name == "movementAnims/dash_downright":
		anim_name = "movementAnims/dash_down"
		
		
	if anim_name =="movementAnims/dash_upleft" or anim_name == "movementAnims/dash_upright":
		anim_name = "movementAnims/dash_up"
		
	if anim_name != "movementAnims/dash_":
		%MovementAnims.play(anim_name)
	
	#Normalizng
	if (player.facing).x > 0.5 and (player.facing.y < -0.2 and player.facing.y > -0.8):
		dash_multiplier = 1.2
	elif (player.facing).x < -0.5 and (player.facing.y < -0.2 and player.facing.y > -0.8):
		dash_multiplier = 1.2
	elif (player.facing).x > 0.5 and (player.facing.y > 0.4 and player.facing.y < 0.8):
		dash_multiplier = 1.2
	elif (player.facing).x < -0.5 and (player.facing.y > 0.4 and player.facing.y < 0.8):
		dash_multiplier = 1.2
	elif player.facing.x == 0 and player.facing.y > 0:
		dash_multiplier = 1.2
	elif player.facing.x == 0 and player.facing.y <= 0:
		dash_multiplier = 1.2
	elif player.facing.x > 0 and player.facing.y == 0:
		dash_multiplier = 1
	elif player.facing.x <= 0 and player.facing.y == 0:
		dash_multiplier = 1
	else:
		dash_multiplier = 1.1
		
		
		
	$DashTimer.start()
	
	var player_direction := (player.transform.basis * Vector3(player.facing.x, 0, player.facing.y))
	player.velocity.x = player_direction.normalized().x * DASH_SPEED * dash_multiplier
	player.velocity.z = player_direction.normalized().z * DASH_SPEED * dash_multiplier
	#Fx.dustFx(player.global_position, -player.facing, 0)

func exit():
	#%SkinSuit.scale = Vector2(1,1)
	#%EyeTrail.end()
	

	#%DashSquareParticle.emitting = false
	%AfterImageComponent.AiStop()
	#
	#for child in %MeleeHurtboxes.get_children():
		#child.set_deferred("disabled", true)
		
	dash_multiplier = 1.0
	$DashCooldown.start()
	player.can_dash = false

func physics_update(_delta: float):
	player.velocity.x = move_toward(player.velocity.x, 0, Slow_down_speed)
	player.velocity.z = move_toward(player.velocity.z, 0, Slow_down_speed)
	
	
	
	
	
	#%DashSquareParticle.global_position = player.global_position + Vector2(0, -33)
	player.move_and_slide()



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


func _on_dash_cooldown_timeout() -> void:
	player.can_dash = true


func _on_dust_timer_timeout() -> void:
	%RunDust.emitting = false
	%RunDust.process_material.scale = Vector2(1,1)


func _on_dash_timer_timeout() -> void:
	if %StateMachine.current_state.name != "PlayerHurt":
		Transitioned.emit(self, "PlayerIdle")
