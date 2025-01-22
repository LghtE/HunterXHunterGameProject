extends Node

func do(delta:float):
	%Armature.rotation.z = 0

	if %Movement._rootNode.velocity.y > 0:
		get_node("Jump").do(delta)
	elif %Movement._rootNode.velocity.y < 0:
		get_node("Jump").hit_peak = false
		get_node("Fall").do(delta)
