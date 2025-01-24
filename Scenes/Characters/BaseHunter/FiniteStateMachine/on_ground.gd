extends State

var run_toggle = false

func do(delta : float):
	
	if Input.is_action_just_pressed("Shift"):
		run_toggle = !run_toggle
	
	
	if %Movement.move_direction == Vector3.ZERO:
		if get_node("RunStop").run_stop_done == true:
			get_node("Idle").do(delta) # IDLE
		else:
			get_node("RunStop").do(delta)
	else:
		get_node("RunStop").run_stop_done = false
		get_node("Run").do(delta) # RUNNING
		
	if abs(%StateMachine.mouse_position.x) > 50:
		get_node("Turn").do(delta)
	
	
