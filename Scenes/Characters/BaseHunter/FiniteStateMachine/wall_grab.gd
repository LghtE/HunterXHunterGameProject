extends State


func do(delta: float):
	if %Movement.move_direction != Vector3.ZERO:
		get_node("MeshAfterImage").afterImage()
	
	%Skeleton3D.position.y = 0 # remove
	#%Movement._rootNode.velocity = %Movement.move_direction * 70
	%Movement._rootNode.velocity.y = -3
	
	
	if %mid_left_raycast.is_colliding():
		if %Movement.move_direction != Vector3.ZERO:
			%AnimationPlayer.play("Movement/WallRunLeft")
		else:
			%AnimationPlayer.play("Movement/WallGrabLeft")
	elif %mid_right_raycast.is_colliding():
		if %Movement.move_direction != Vector3.ZERO:
			%AnimationPlayer.play("Movement/WallRunRight")
		else:
			%AnimationPlayer.play("Movement/WallGrabRight")
