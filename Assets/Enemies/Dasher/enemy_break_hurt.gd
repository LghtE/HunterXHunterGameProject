extends FSMState
class_name EnemyBreakHurt

@export var enemy : BaseEnemy


func enter():
	#%Skin.material.set_shader_parameter("active", false)
	enemy.setLookDirection()
	
	if %AnimationPlayer.is_playing() and %AnimationPlayer.current_animation == "dasherAnims/BreakHurt":
		%AnimationPlayer.stop()
	%AnimationPlayer.play("dasherAnims/BreakHurt")
	
	
func exit():
	#%Skin.material.set_shader_parameter("active", false)
	%Skin.modulate = Color.WHITE


func physics_update(_delta : float):
	enemy.move_and_slide()

func returnToBreak():
	Transitioned.emit(self, "EnemyBreak")
