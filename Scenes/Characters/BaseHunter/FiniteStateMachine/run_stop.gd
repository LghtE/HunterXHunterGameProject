extends State

var run_stop_done = false
func do(delta: float):
	%Armature.rotation.z = 0
	%AnimationPlayer.play("Run_Stop")

func runStopDone():
	run_stop_done = true
