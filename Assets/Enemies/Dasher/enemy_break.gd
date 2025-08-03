extends FSMState
class_name EnemyBreak

@export var break_sfx : AudioStreamWAV
@export var enemy : BaseEnemy
@export var break_offset = Vector3(0,0,0)

func enter():
	
	#%Skin.set_instance_shader_parameter("active", false)
	%Skin.modulate = Color.WHITE
	
	if !enemy.in_break:
		SignalBus.emit_signal("onEnemyBreak", enemy)
		$Timer.start()
		GameAudioManager.playSFX(enemy.global_position, break_sfx, 0, true)
		Fx.breakFx(enemy.global_position + break_offset, enemy)
		
	enemy.in_break = true
	%AnimationPlayer.play("dasherAnims/break")
	

func exit():
	%Skin.modulate = Color.WHITE


func physics_update(_delta : float):
	pass

func _on_timer_timeout() -> void:
	
	if %StateMachine.current_state.name == "EnemyDead":
		return
	
	enemy.in_break = false
	Transitioned.emit(self, "EnemyIdle")
