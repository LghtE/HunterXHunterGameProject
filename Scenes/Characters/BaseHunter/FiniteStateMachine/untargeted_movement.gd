extends State

var on_ground = true

func do(delta):
	if on_ground:
		get_child(0).do(delta)
	else:
		get_child(1).do(delta)
