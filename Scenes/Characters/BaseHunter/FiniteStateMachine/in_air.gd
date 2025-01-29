extends Node

func do(delta:float):
	%CameraTarget.position = lerp(%CameraTarget.position, %BaseCamPos.position, 0.1)
	
	
	if %Movement._rootNode.velocity.y > 0 && %OnWall.wall_jumping == false:
		get_node("Jump").do(delta)
	elif %Movement._rootNode.velocity.y < 0:
		get_node("Jump").hit_peak = false
		get_node("Fall").do(delta)
