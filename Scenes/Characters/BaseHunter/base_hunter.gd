extends CharacterBody3D


enum {IDLE, RUN, WALK}
var curr_anim = IDLE


func _physics_process(delta: float) -> void:
	pass
	
	#if move_direction != Vector3.ZERO:
		#if Input.is_action_pressed("Shift"):
			#move_speed = 35.0
			#curr_anim = RUN
		#else:
			#move_speed = 10.0
			#curr_anim = WALK
	#else:
		#curr_anim = IDLE
		
		
	#handleAnimations(delta)
	#updateTree()
	
	#if move_direction.length() > 0.2:
		#_last_movement_direction = move_direction
	#var target_angle := Vector3.BACK.signed_angle_to(_last_movement_direction, Vector3.UP)
	#_baseHunter.global_rotation.y = lerp_angle(_baseHunter.global_rotation.y, target_angle, rotation_speed * delta)

#func handleAnimations(delta):
	#match curr_anim:
		#IDLE:
			#run_value = lerp(run_value, 0.0, blend_speed * delta)
		#RUN:
			#run_value = lerp(run_value, 1.0, blend_speed * delta)
		#WALK:
			#run_value = lerp(run_value, 0.3, blend_speed * delta)
#func updateTree():
	#_animTree["parameters/Run/blend_amount"] = run_value
