extends FSMState
class_name PlayerHurt

@export var player : CharacterBody3D
@export var hurt_impact_sfx : AudioStreamWAV


func enter():
	
	#%BlackBars.close()
	#%SkillAnimations.hide()
	
	GameAudioManager.playSFX(player.global_position, hurt_impact_sfx, 6)

	player.invulnerable = true
	$InvulTimer.start()
	
	GameGlobals.hitStop(0.02)
	
	
	Input.start_joy_vibration(0, 0.6, 0.6, 0.2)

	
	%MovementAnims.play("movementAnims/hurt_down")
	%FXAnims.play("PlayerFxAnims/invul_flash")
	
	%Camera3D.onPlayerHurt()
	
func exit():
	%SkinSuit.modulate = Color.WHITE
	#player.invulnerable = false
	#%SkinSuit.material.set_shader_parameter("active", false)
	
func physics_update(_delta: float):
	
	player.move_and_slide()

func hurtFinish():
	Transitioned.emit(self, "PlayerIdle")


func invulEnd():
	player.invulnerable = false


func _on_invul_timer_timeout() -> void:
	invulEnd()
