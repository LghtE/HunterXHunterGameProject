extends FSMState
class_name EnemyAttack

@export var enemy : CharacterBody3D

@export var attack_motion_strength : float = 1750
@export var tackle_sfx : AudioStreamWAV

@export var attack_anim_name := "Attack"

@export var Afterimages_enabled = true
@export var dust_fx_type= 0

@export var allow_change_dir = true

@export var predict_movement = false

var dir_to_attack = Vector3.ZERO

func enter():
	#enemy.velocity = Vector2.ZERO
	%AnimationPlayer.play(attack_anim_name)

func exit():
	allow_change_dir = true
	
	if Afterimages_enabled:
		%AfterImageComponent.AiStop()
	
	
	for box in %HurtBox.get_children():
		box.set_deferred("disabled", true)


func physics_update(_delta: float):
	if allow_change_dir:
		enemy.setLookDirection()
	enemy.move_and_slide()


func addImpulseTowardsPlayer():
	
	#GameAudioManager.playSFX(enemy.global_position, tackle_sfx,2, true)
	
	if Afterimages_enabled:
		%AfterImageComponent.AiStart(%Skin)
		
	enemy.velocity = Vector3(dir_to_attack.normalized().x,dir_to_attack.normalized().y,dir_to_attack.normalized().z) * attack_motion_strength
	
	var tween = get_tree().create_tween()
	tween.tween_property(enemy, "velocity", Vector3.ZERO, 0.7).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	
	# Dust FX
	#match dust_fx_type:
		#0:
			#Fx.dustFx(enemy.global_position, -enemy.velocity.normalized(), 0)
		#1:
			#Fx.dustFx(enemy.global_position, Vector2.ZERO, 1)


func addImpulseToPlayer():
	
	if Afterimages_enabled:
		%AfterImageComponent.AiStart(%Skin)
	
	var time = 0.85
	var dist = (GameGlobals.returnPlayer().global_position - enemy.global_position).length()
	
	var speed = dist / time
	
	enemy.velocity = dir_to_attack.normalized() * speed * 4.0
	
	var tween = get_tree().create_tween()
	tween.tween_property(enemy, "velocity", Vector2.ZERO, 0.8).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	
	# Dust FX
	match dust_fx_type:
		0:
			Fx.dustFx(enemy.global_position, -enemy.velocity.normalized(), 0)
		1:
			Fx.dustFx(enemy.global_position, Vector2.ZERO, 1)
	
func setDirectionToAttack():
	var vel
	if predict_movement:
		vel = ((GameGlobals.returnPlayer().global_position - enemy.global_position) + GameGlobals.returnPlayer().velocity.normalized() * 10.0).normalized()
	else:
		vel = (GameGlobals.returnPlayer().global_position - enemy.global_position).normalized()
	dir_to_attack = vel

func returnToChase():
	Transitioned.emit(self, "EnemyIdle")

func ToRecover():
	
	if enemy.has_slash_hit == false:
		Transitioned.emit(self, "EnemySlashRecover")
	else:
		enemy.has_slash_hit = false
		Transitioned.emit(self, "EnemyJumpChase")
	
func disableChangeDir():
	allow_change_dir = false

func setSlasherSlash_dir():
	if dir_to_attack.x >= 0:
		%SlasherSlash.flip_h = true
	else:
		%SlasherSlash.flip_h = false

func enableSlasherHurtbox():
	if dir_to_attack.x >= 0:
		%right.disabled = false
	else:
		%left.disabled = false

func disableSlasherHurtbox():
	%left.disabled = true
	%right.disabled = true
