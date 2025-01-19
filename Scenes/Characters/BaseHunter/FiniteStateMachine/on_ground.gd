extends State

var run_toggle = false

func do(delta : float):
	
	if Input.is_action_just_pressed("Shift"):
		run_toggle = !run_toggle
	
	
	if %Movement.move_direction == Vector3.ZERO:
		get_child(1).do(delta) # IDLE
	else:
		get_child(0).do(delta) # RUNNING
