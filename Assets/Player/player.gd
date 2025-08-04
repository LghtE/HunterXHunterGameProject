extends CharacterBody3D


signal enemy_hit(enemy)
var facing = Vector2.DOWN
var joy_dir = Vector2.ZERO

var joypad_sensitivity = 1.0
var aura_amount = 0
var aura_segments = 0

@export var current_health : float = 100.0
@export var max_health : float = 100.0

@export var id = "Fos"
@export var dialogue_offset = Vector2(0, -65)

@export var knockback_multiplier = 1.5

var stun_lockable = true

var in_dialogue = false

var invulnerable : bool = false

var sum: Vector3 = Vector3.ZERO
var num = 0

var can_dash : bool = true

var current_skill_running : String

var in_break : bool = false

var idx = 0
var isAuraIncrease  = false

var cam_tween : Tween

var cam_override = true

var rotation_speed = 5.0  # radians per second

var cam_follow_orig_vec : Vector3

var default_rotation = -4.0
var aiming_rotation = -10

func _process(delta: float) -> void:
	
	# Smoothing the Camera
	var cam_tw = get_tree().create_tween()
	cam_tw.tween_property($Pivot, "global_position", $CamFollow.global_position, 0.3).set_ease(Tween.EASE_OUT)


func _ready() -> void:
	
	cam_follow_orig_vec = $CamFollow.position
	%ProceduralSlash.material_override.set_shader_parameter("progress", 0.0)
	$Shadow.position.y = position.y 
	#Input.mouse_mode = Input.MOUSE_MODE_CONFINED
	
	#$CanvasLayer/HealthBarComponent.hide()
	
	#for child in %MeleeHurtboxes.get_children():
		#child.knockback_strength *= knockback_multiplier
	
	SignalBus.connect("onEnemyBreak", %Camera3D.onEnemyBreak)
	SignalBus.connect("onEnemyDied", enemyDead)
	#SignalBus.connect("auraBarChanged", onAuraBarChange)
	#SignalBus.connect("auraIncrease", onAuraIncrease)
	#
	#SignalBus.connect("skillComplete", %PlayerSkill.endSkill)
	#
	#SignalBus.connect("convoStarted", convoStarted)
	#SignalBus.connect("convoEnded", convoEnded)

func _physics_process(_delta: float) -> void:
	if current_health <= 0:
		get_tree().quit()
	
	
	
	$Shadow.position.x = position.x 
	$Shadow.position.z = position.z - 0.25
	
	if get_tree().get_nodes_in_group("enemy") != []:
		idx = 0
		sum = Vector3.ZERO
		num = 0
		
		for enemy in get_tree().get_nodes_in_group("enemy"):
			if enemy.processing:
				sum.x += enemy.global_position.x
				sum.y += enemy.global_position.y
				sum.z += enemy.global_position.z
				num += 1
		
		if num > 0:
			cam_tween = get_tree().create_tween()
			var final_pos = global_position * 0.65 + Vector3(sum.x/num, sum.y/num, sum.z/num) * (1 - 0.65)
			cam_tween.tween_property($CamFollow, "position", to_local(final_pos), 0.1)
	else:
		if idx == 0:
			resetCam()
			idx = 1
	
	
	
	$StateNameDebug.text = "State: "+ $StateMachine.current_state.name
		
	#var stick_vector = Input.get_vector("joy_L", "joy_R", "joy_U", "joy_D")
	# Cam rotate 
	#self.rotation.x += stick_vector.y * _delta * joypad_sensitivity
	#self.rotation.x = clamp($Pivot.rotation.x, -PI / 6.0, PI / 6.0)
	#self.rotation.y -= stick_vector.x * _delta * joypad_sensitivity
	#
	#%MeleeHurtboxes.rotation.x -= stick_vector.y * _delta * joypad_sensitivity
	#%MeleeHurtboxes.rotation.x = clamp(%MeleeHurtboxes.rotation.x, -PI / 6.0, PI / 6.0)
	#%MeleeHurtboxes.rotation.y -= stick_vector.x * _delta * joypad_sensitivity
	#$RichTextLabel2.text = "Velocity: "+ str(round(velocity.x)) + "," + str(round(velocity.y))
	
	joy_dir = Vector2(
		Input.get_action_strength("joy_R") - Input.get_action_strength("joy_L"),
		Input.get_action_strength("joy_D") - Input.get_action_strength("joy_U")
	)
	
	
	if Input.is_action_just_pressed("1"):
		Engine.time_scale = 0.02


#func _on_melee_hurtboxes_area_entered(area: Area2D) -> void:
	#
	#if !area.owner.is_in_group("enemy"):
		#return
	#
	#for child in %MeleeHurtboxes.get_children():
		#if !child.disabled:
			#
			#if !area.owner.invulnerable:
				#enemy_hit.emit(area.owner)
				#
				##Fx.hitFx(child.global_position, 0)
				#isAuraIncrease = false
				#
				#if child.isHitstop:
					#GameGlobals.setProcessOff([%Cam])
					#var tw = get_tree().create_timer(child.hitstopTime)
					#await tw.timeout
					#GameGlobals.resetProcess()
					##GameGlobals.hitStop(child.hitstopTime)
			#
				#if area.owner.has_node("DamageComponent"):
					#if area.owner.in_break:
						#area.owner.get_node("DamageComponent").damage(child.damage_amount * 1.5, child.knockback_strength, child.knockback_direction)
					#else:
						#if !area.owner.stun_lockable:
							#velocity = -facing.normalized() * 140
						#area.owner.get_node("DamageComponent").damage(child.damage_amount, child.knockback_strength, child.knockback_direction)
				#else:
					#print("Hit entity has no damage component")


func resetCam():
	$CamFollow.position = cam_follow_orig_vec


#==============================================================================

#func convoStarted():
	#in_dialogue = true
	#%StateMachine.on_child_transition("", "PlayerIdle")
	#
	#velocity = Vector2.ZERO
	#GameGlobals.player_can_move = false
	#bbOpen()
	


func convoEnded():
	in_dialogue = false
	bbClose()
	
	%StateMachine.on_child_transition("", "PlayerIdle")
	GameGlobals.player_can_move = true





#=============================================================================
func onAuraBarChange(aura_amt, aura_sg):
	aura_amount = aura_amt
	aura_segments = aura_sg

func onAuraIncrease():
	isAuraIncrease = true

func decreaseAura(Amount):
	SignalBus.emit_signal("decreaseAura", Amount)

func increaseAura(Amount):
	SignalBus.emit_signal("increaseAura", Amount)

func enemyDead(enemy):
	#%blurAnimPlayer.play("show")
	
	%Camera3D.get_node("AnimationPlayer").play("shake_extreme")
	
	


func blur():
	if %blurAnimPlayer.is_playing():
		%blurAnimPlayer.stop()
	%blurAnimPlayer.play("show")

func eyeTrailOn():
	%EyeTrail.start()

func eyeTrailOff():
	%EyeTrail.end()
	
func AIon(sprite):
	%AfterImageComponent.AiStart(sprite)

func AIoff():
	%AfterImageComponent.AiStop()

func zoomTween(zoom, dur, easetype):
	await %Cam.zoomTween(zoom, dur, easetype)

func singleEcho(time, sprite, offset, size):
	%AfterImageComponent.singleEchoEffect(time, sprite, offset, size)

func shakeCamBig():
	%Cam.get_node("AnimationPlayer").play("shake_big")

func shakeCamExtreme():
	%Cam.get_node("AnimationPlayer").play("shake_extreme")


func glitchSmall():
	%glitchAnimPlayer.play("glitch_small")

func bbOpen():
	%BlackBars.open()

func bbClose():
	%BlackBars.close()

func speedLines():
	if %SpeedLines.get_node("AnimationPlayer").is_playing():
		%SpeedLines.get_node("AnimationPlayer").stop()
	%SpeedLines.get_node("AnimationPlayer").play("show")

func vignette():
	if %Vignette.get_node("AnimationPlayer").is_playing():
		%Vignette.get_node("AnimationPlayer").stop()
	%Vignette.get_node("AnimationPlayer").play("show")

func dashParticleOn():
	%DashSquareParticle.emitting = true
	
func dashParticleOff():
	%DashSquareParticle.emitting = false

#func updateDashParticlePos():
	#%DashSquareParticle.global_position = global_position + Vector2(0, -33)

func enableCam():
	%Cam.enabled = true
	%Cam.make_current()


func playerHeal(frac):
	current_health += max_health * frac
	current_health = clamp(current_health, 0, max_health)
	
	var heal_tw = get_tree().create_tween()
	
	%SkinSuit.modulate = Color(1.0, 8.0, 1.0, 1.0)
	heal_tw.set_ease(Tween.EASE_OUT)
	heal_tw.tween_property(%SkinSuit, "modulate", Color.WHITE, 0.5)
	
	get_node("CanvasLayer/HealthBarComponent").hpDrop(current_health - (frac * max_health), current_health, 0.6)


# TESTSTUFF
func _on_area_3d_body_entered(body: Node3D) -> void:
	var t = get_tree().create_tween()
	t.tween_property(self, "rotation_degrees:y", 0.0, 1.0).set_ease(Tween.EASE_IN_OUT)

func _on_melee_hurtboxes_area_entered(area: Area3D) -> void:
	
	if !area.owner.is_in_group("enemy"):
		return
	
	for child in %MeleeHurtboxes.get_children():
		if !child.disabled:
			
			if !area.owner.invulnerable:
				enemy_hit.emit(area.owner)
				
				Fx.hitFx(child.global_position, 0)
				#isAuraIncrease = false
				GameGlobals.hitStop(0.008)
				
				if child.isHitstop:
					GameGlobals.setProcessOff([%Cam])
					var tw = get_tree().create_timer(child.hitstopTime)
					await tw.timeout
					GameGlobals.resetProcess()
					#GameGlobals.hitStop(child.hitstopTime)
			
				if area.owner.has_node("DamageComponent"):
					if area.owner.in_break:
						area.owner.get_node("DamageComponent").damage(child.damage_amount * 1.5, child.knockback_strength, child.knockback_direction)
					else:
						#if !area.owner.stun_lockable:
							#velocity = -child.knockback_direction * 10.0
						area.owner.get_node("DamageComponent").damage(child.damage_amount, child.knockback_strength, child.knockback_direction)
				else:
					print("Hit entity has no damage component")
