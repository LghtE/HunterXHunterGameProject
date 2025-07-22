extends FSMState
class_name EnemyHurt

@export var enemy : CharacterBody3D



func enter():
	
	enemy.setLookDirection()
	%Skin.set_instance_shader_parameter("active", false)
	%Skin.modulate = Color.WHITE
	
	if %AnimationPlayer.is_playing() and %AnimationPlayer.current_animation == "dasherAnims/Hurt":
		%AnimationPlayer.stop()
	%AnimationPlayer.play("dasherAnims/Hurt")
	
	
	#if enemy.enemy_type == "EnemySlasher":
		#if %EnemyHold.tweenvel.is_running():
			#%EnemyHold.tweenvel.stop()
	

func exit():
	
	%Skin.set_instance_shader_parameter("active", false)
	%Skin.modulate = Color.WHITE
	

func physics_update(_delta: float):
	
	enemy.velocity += Vector3(0, -98, 0) * _delta
	enemy.move_and_slide()

func returnToChase():
	Transitioned.emit(self, "EnemyIdle")
