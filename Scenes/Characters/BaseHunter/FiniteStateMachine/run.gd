extends State


func onExit():
	pass
	
func onEnter():
	pass
	
	

func do(delta : float):
	
	%Movement.move_speed = 45
	%AnimationPlayer.play("Run")
	
	

	if %StateMachine.mouse_moving == false:
		%Armature.rotation.z = lerp(%Armature.rotation.z, deg_to_rad(0), 0.1)
	else:
		if %StateMachine.mouse_position.x > 0:
			%Armature.rotation.z = lerp(%Armature.rotation.z, deg_to_rad(10), 0.1)
		elif %StateMachine.mouse_position.x < 0:
			%Armature.rotation.z = lerp(%Armature.rotation.z, deg_to_rad(-10), 0.1)
