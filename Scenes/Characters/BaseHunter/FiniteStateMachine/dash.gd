extends State
var need_to_dash = false

func do(delta: float):
	%AnimationPlayer.play("Movement/Dash")
	%Movement._rootNode.velocity = %Movement.move_direction * %Movement.dash_impulse
	%Movement.player_movement_in_control = false
	
	
	if %StateMachine.mouse_moving == false:
		%Armature.rotation.z = lerp(%Armature.rotation.z, deg_to_rad(0), 0.1)
	else:
		if %StateMachine.mouse_position.x > 0:
			%Armature.rotation.z = lerp(%Armature.rotation.z, deg_to_rad(12), 0.1)
		elif %StateMachine.mouse_position.x < 0:
			%Armature.rotation.z = lerp(%Armature.rotation.z, deg_to_rad(-12), 0.1)
	
	
	var mesh = %Skeleton3D.get_node("HunterBody").duplicate()
	mesh.top_level = true
	mesh.position = %Armature.get_parent().position
	mesh.rotation = %Armature.rotation

	%Skeleton3D.add_child(mesh)
	
func dashFinished():
	need_to_dash = false
	%Movement.player_movement_in_control = true
