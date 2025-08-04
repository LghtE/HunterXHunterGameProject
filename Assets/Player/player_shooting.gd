extends FSMState
class_name PlayerShooting

@export var shootSFX1 :AudioStreamWAV
@export var shootSFX2 :AudioStreamWAV

@export var shootFail :AudioStreamWAV


@export var player : CharacterBody3D
@export var projectile : PackedScene

var offset = Vector2(0, -30)
var shoot_impulse = 30.0

var cam_tw : Tween

var idx = 0

func enter():
	
	if cam_tw:
		if cam_tw.is_running():
			cam_tw.stop()
			
	cam_tw = get_tree().create_tween()
	cam_tw.tween_property(%Pivot, "rotation_degrees:x", player.aiming_rotation, 0.15).set_ease(Tween.EASE_OUT)
	
	
	
	
	emitProjectile()
	#if player.aura_amount > 0.0:
		#emitProjectile()
	#else:
		# cant shoot, not enought aura
		#GameAudioManager.playSFX(player.global_position, shootFail, 0, false)
		
	playShootAnim()
	
	%AimingCrosshair.visible = true
	await get_tree().process_frame
	%AimingCrosshair.interact()
	
	
	# Player Knockback
	if GameGlobals.mouse_mode:
		player.velocity = -((GameGlobals.returnMousePos() - player.global_position).normalized() * shoot_impulse)
	else:
		player.velocity = -((Vector3(player.joy_dir.x, 0, player.joy_dir.y)).normalized() * shoot_impulse)

func exit():
	if %StateMachine.current_state.name != "PlayerAiming":
		cam_tw = get_tree().create_tween()
		cam_tw.tween_property(%Pivot, "rotation_degrees:x", player.default_rotation, 0.15).set_ease(Tween.EASE_IN)
	
	%Animations.stopAllAnims()
	await get_tree().process_frame
	%AimingCrosshair.visible = false
	await get_tree().process_frame
	#%AimingCrosshair.global_position = player.global_position

func physics_update(_delta: float):
	
	
	if GameGlobals.mouse_mode:
		%AimingCrosshair.global_position = GameGlobals.returnMousePos()
		%AimingCrosshair.position.x = clamp(%AimingCrosshair.position.x, -220, 220)
		%AimingCrosshair.position.y = clamp(%AimingCrosshair.position.y, -220, 220)
	else:
		var tween = get_tree().create_tween()
		tween.tween_property(%AimingCrosshair, "position", (Vector3(player.joy_dir.x,0.2,player.joy_dir.y) * 25.0 ), 0.15)
	
	%CamFollow.position = player.to_local((player.global_position + %AimingCrosshair.global_position) / 2)
	
	if player.joy_dir == Vector2.ZERO and !Input.is_action_pressed("rightClick"):
		Transitioned.emit(self, "PlayerIdle")
	
	player.velocity.x = move_toward(player.velocity.x, 0, 2)
	player.velocity.z = move_toward(player.velocity.z, 0, 2)
	
	if player.velocity.y <= 0 and !player.is_on_floor():
		Transitioned.emit(self, "PlayerFall")
		
	#Add Gravity
	player.velocity += Vector3(0, -98, 0) * _delta
	player.move_and_slide()
	
	if (Input.is_action_just_pressed("rightShoulderButton") or Input.is_action_just_pressed("leftClick")) and $canShoot.is_stopped():
		
		emitProjectile()
		#if player.aura_amount > 0.0:
			#emitProjectile()
		#else:
			#GameAudioManager.playSFX(player.global_position, shootFail, 0, false)
		%AimingCrosshair.interact()
		playShootAnim()
		
		# Player Knockback
		if GameGlobals.mouse_mode:
			player.velocity = -((GameGlobals.returnMousePos() - player.global_position).normalized() * shoot_impulse)
		else:
			player.velocity = -(Vector3(player.joy_dir.x, 0, player.joy_dir.y).normalized() * shoot_impulse)

func shootFinish():
	Transitioned.emit(self, "PlayerAiming")

func timerStart():
	$canShoot.start()

func playShootAnim():
	if idx == 0:
		%MovementAnims.play("movementAnims/shoot_down")
		idx = 1
	elif idx == 1:
		%MovementAnims.play("movementAnims/shoot_down_2")
		idx = 0

func emitProjectile():
	#player.decreaseAura(5)
	GameAudioManager.playSFX(player.global_position, shootSFX1, -5, true)
	var proj_instance = projectile.instantiate()
	
	
	if GameGlobals.mouse_mode:
		proj_instance.dir = (GameGlobals.returnMousePos() - player.global_position).normalized()
	else:
		proj_instance.dir = Vector3(player.joy_dir.x, 0, player.joy_dir.y).normalized()
	
	
	#if %AimAssist.current_target_enemy != null:
		#proj_instance.dir = (%AimAssist.current_target_enemy.global_position - player.global_position).normalized()
	#else:
		#if GameGlobals.mouse_mode:
			#proj_instance.dir = (GameGlobals.returnMousePos() - player.global_position).normalized()
		#else:
			#proj_instance.dir = (player.joy_dir).normalized()
		#
	
	
	proj_instance.set_deferred("global_position", player.global_position + (proj_instance.dir * 5) + Vector3(0, 2 ,0))
	proj_instance.projHit.connect(onProjHit)
	
	get_parent().get_parent().get_parent().add_child(proj_instance)


func onProjHit(enemy):
	if enemy.is_in_group("enemy"):
		#%FlowState.onProjHit(enemy)
		enemy.onProjectileHit()
