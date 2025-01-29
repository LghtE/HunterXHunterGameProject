extends State


func do(delta: float):
	get_node("MeshAfterImage").afterImage()
	
	%Skeleton3D.position.y = 0 # remove
	%Movement._rootNode.velocity = %Movement.move_direction * 70
	%Movement._rootNode.velocity.y = 0
	
	
	if %mid_left_raycast.is_colliding():
		%AnimationPlayer.play("Movement/WallRunLeft")
	elif %mid_right_raycast.is_colliding():
		%AnimationPlayer.play("Movement/WallRunRight")
