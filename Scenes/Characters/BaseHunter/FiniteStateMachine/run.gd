extends State


func onExit():
	pass
	
func onEnter():
	pass
	
	

func do(delta : float):
	%Movement.move_speed = 45
	%AnimationPlayer.play("Run")
	
	var mouse_pos = get_viewport().get_mouse_position()
	
	if mouse_pos.x > 640:
		%Armature.rotation.z = deg_to_rad(3)
	elif mouse_pos.x < 640:
		%Armature.rotation.z = deg_to_rad(-3)

	
