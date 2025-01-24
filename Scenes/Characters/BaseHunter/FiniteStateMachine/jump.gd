extends State

var hit_peak = false

func do(delta:float):
	if !hit_peak:
		%AnimationPlayer.play("Movement/Jump",-1,2.5)
	
func hitPeak():
	hit_peak = true
