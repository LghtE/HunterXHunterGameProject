extends State

var hit_peak = false

func do(delta:float):
	if !hit_peak:
		%AnimationPlayer.play("Movement/Jump",-1,1)
	
	
	
	if %StateMachine.mouse_moving == false:
		%Armature.rotation.z = lerp(%Armature.rotation.z, deg_to_rad(0), 0.1)
	else:
		if %StateMachine.mouse_position.x > 0:
			%Armature.rotation.z = lerp(%Armature.rotation.z, deg_to_rad(15), 0.1)
		elif %StateMachine.mouse_position.x < 0:
			%Armature.rotation.z = lerp(%Armature.rotation.z, deg_to_rad(-15), 0.1)
			
func hitPeak():
	hit_peak = true
