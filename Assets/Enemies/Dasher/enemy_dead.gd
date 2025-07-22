extends FSMState
class_name EnemyDead

@export var enemy : BaseEnemy
@export var glow_dissolve_shader : Shader
@export var shimmer_offset : Vector3

@export var dissolve_time = 0.5
func enter():
	
	if enemy.enemy_type == "EnemySlasher":
		enemy.get_node("SlasherSlash").hide()
	
	
	enemy.velocity = Vector3.ZERO
	enemy.is_dead = true
	enemy.invulnerable = true
	
	SignalBus.emit_signal("onEnemyDied", enemy)
	
	enemy.get_node("Shadow").hide()
	%AnimationPlayer.play("dasherAnims/Died")
	
	await get_tree().create_timer(0.5).timeout
	
	
	
	
	## Attaching the glow dissolve shader 
	#var shader_mat = ShaderMaterial.new()
	#shader_mat.shader = glow_dissolve_shader
	#%Skin.material = shader_mat
	#
	#
	#var shader_tween = get_tree().create_tween()
	#%Skin.material.set_shader_parameter("progress", 0.0)
	#%Skin.material.set_shader_parameter("noise_desnity", 100.0)
	#%Skin.material.set_shader_parameter("beam_size", 0.093)
	#
	#%Skin.material.set_shader_parameter("color", Color(0.543, 2.6, 2.6, 1.0))
	#shader_tween.tween_property(%Skin.material, "shader_parameter/progress", 1.0 , dissolve_time)
	#
	#await shader_tween.finished
	
	
	enemy.queue_free()


func exit():
	pass


func physics_update(_delta : float):
	enemy.move_and_slide()

func shimmerFx():
	pass
	#Fx.shimmerFx(enemy.global_position + shimmer_offset)
