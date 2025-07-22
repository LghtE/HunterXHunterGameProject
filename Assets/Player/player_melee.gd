extends FSMState
class_name PlayerMelee

@export var slash1 : AudioStreamWAV
@export var slash2 : AudioStreamWAV
@export var preslash3 : AudioStreamWAV
@export var slash3 : AudioStreamWAV

@export var player : CharacterBody3D
@export var melee_impulse = 60.0

var hit_connected = false
var anim_name

var t : Tween
var t2: Tween

func enter():
	GameAudioManager.playSFX(player.global_position, slash1, 0)
	#player.velocity = player.facing.normalized() * melee_impulse
	
	anim_name = "movementAnims/slash_" + vecToDir(player.facing)
	#%Animations.stopAllAnims()
	
	player.velocity = Vector3.ZERO
	applyImpulse(melee_impulse)
	Fx.dustParticleFx(player.global_position + Vector3(0, 1.5, 1.5), 0)
	%MovementAnims.play_section_with_markers(anim_name, "M1","M1_END")
	

func exit():
	%SwordFX.hide()
	%ProceduralSlash.material_override.set_shader_parameter("progress", 0.0)
	if t:
		if t.is_running():
			t.kill()
	if t2:
		if t2.is_running():
			t2.stop()
		
		
	hit_connected = false

func _ready() -> void:
	player.enemy_hit.connect(on_hit)
	
func update(_delta: float):
	pass

func physics_update(_delta: float):
	player.velocity.x = move_toward(player.velocity.x, 0, 2)
	player.velocity.z = move_toward(player.velocity.z, 0, 2)
	player.move_and_slide()

	if Input.is_action_just_pressed("J"):
		if !$M1.is_stopped() :
			hit_connected = false
			GameAudioManager.playSFX(player.global_position, slash2, 0, true)
			Fx.dustParticleFx(player.global_position + Vector3(0, 1.5, 1.5), 0)
			applyImpulse(melee_impulse)
			#%Animations.stopAllAnims()
			%MovementAnims.play_section_with_markers(anim_name, "M1_END","M2_END")
		
		elif !$M2.is_stopped() :
			
			hit_connected = false
			GameAudioManager.playSFX(player.global_position, preslash3)
			Fx.dustParticleFx(player.global_position + Vector3(0, 1.5, 1.5), 0)
			applyImpulse(melee_impulse)
			#%Animations.stopAllAnims()
			%MovementAnims.play_section_with_markers(anim_name, "M2_END")
			
	if player.velocity.y <= 0 and !player.is_on_floor():
		Transitioned.emit(self, "PlayerFall")

func M1():
	# Starts a timer, if attack button is pressed within it's lifespan : Second Melee Performed !
	$M1.start()

func M2():
	# Starts a timer, if attack button is pressed within it's lifespan : Third Melee Performed !
	$M2.start()





func vecToDir(v : Vector2):
	if !v || v == Vector2.ZERO:
		return ""
	
	if v.x == 0:
		if v.y > 0:
			return "down"
		elif v.y < 0:
			return "up"
	if v.y == 0 :
		if v.x > 0:
			return "right"
		elif v.x < 0:
			return "left"
	
	
	if v.x > 0 and v.y < 0:
		return "upright"
	elif v.x < 0 and v.y < 0:
		return "upleft"
	elif v.x > 0 and v.y > 0:
		return "downright"
	elif v.x < 0 and v.y > 0:
		return "downleft"

func shake_big():
	await get_tree().process_frame
	await get_tree().process_frame
	
	if hit_connected:
		
		#player.increaseAura(7)
		Input.start_joy_vibration(0, 0.3, 0.3, 0.15)
		#%Cam.get_node("AnimationPlayer").play("shake_big")

func shake_small():
	await get_tree().process_frame
	await get_tree().process_frame
	
	if hit_connected:
		Input.start_joy_vibration(0, 0.1, 0.1, 0.1)
		#%Cam.get_node("AnimationPlayer").play("shake_small")

func playFinalSlashSFX():
	GameAudioManager.playSFX(player.global_position, slash3)

func on_hit(enemy):
	hit_connected = true


func _on_movement_anims_animation_finished(anim_name: StringName) -> void:
	if anim_name:
		if "slash_" in anim_name:
			Transitioned.emit(self, "PlayerIdle")


func applyImpulse(imp):
	var applied_imp = imp
	anim_name
	if anim_name == "movementAnims/slash_right" or anim_name == "movementAnims/slash_left":
		applied_imp /= 1.35
	
	var player_direction := (player.transform.basis * Vector3(player.facing.x, 0, player.facing.y))
	player.velocity.x = player_direction.normalized().x * applied_imp
	player.velocity.z = player_direction.normalized().z * applied_imp

func tweenSlash():
	
	if t and t.is_running():
		t.kill()
	
	
	t = get_tree().create_tween()
	t.set_trans(Tween.TRANS_QUINT)
	
	%ProceduralSlash.material_override.set_shader_parameter("progress", 0.21)
	
	t.tween_property(%ProceduralSlash.material_override, "shader_parameter/progress", 0.82, 0.7).set_ease(Tween.EASE_OUT)

func tweenSlash2():
	if t and t.is_running():
		t.kill()
	
	t = get_tree().create_tween()
	t.set_trans(Tween.TRANS_QUINT)
	
	%ProceduralSlash.material_override.set_shader_parameter("progress", 0.21)
	
	t.tween_property(%ProceduralSlash.material_override, "shader_parameter/progress", 0.82, 0.7).set_ease(Tween.EASE_OUT)
	
