extends FSMState
class_name EnemyChase

@export var enemy : CharacterBody3D
@export var CBS : ContextBasedSteering


var chase_target_pos



func _ready() -> void:
	enemy.setChaseTarget(GameGlobals.returnPlayer())
  
func enter():
	%AnimationPlayer.play("dasherAnims/Run")

func exit():
	CBS.stop()
	

func physics_update(_delta : float):
	enemy.setLookDirection()
	if enemy.chase_target:
		
		chase_target_pos = enemy.chase_target.global_position
		
		var path : Vector3 = navigatePath()
		CBS.navigate(path, enemy.run_speed)
		
		if (chase_target_pos - enemy.global_position).length() <= (enemy.distance_to_maintain_inner + enemy.distance_to_maintain_outer) / 2:
			
			Transitioned.emit(self, "EnemyHold")
	
	
	enemy.velocity += Vector3(0, -200, 0) * _delta
	
	enemy.move_and_slide()

func navigatePath() -> Vector3:
	
	# Find which direction to go to and set it as enemy_norm_dir
	var vector_to_chase_target = (chase_target_pos - enemy.global_position)
	var enemy_norm_dir = (vector_to_chase_target).normalized()
	
	return enemy_norm_dir
