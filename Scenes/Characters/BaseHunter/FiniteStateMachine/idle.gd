extends State

func onExit():
	pass
	
func onEnter():
	pass
	
func do(delta : float):
	%Armature.rotation.z = 0
	%AnimationPlayer.play("Idle")
