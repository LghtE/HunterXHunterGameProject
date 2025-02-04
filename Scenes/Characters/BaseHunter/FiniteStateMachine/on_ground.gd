extends State

var run_toggle = false


func do(delta : float):
	%Skeleton3D.position.y = 0
	%CameraTarget.position = lerp(%CameraTarget.position, %BaseCamPos.position, 0.1)
	
	
	if Input.is_action_just_pressed("Shift"):
		run_toggle = !run_toggle
	
	if Input.is_action_just_pressed("Dash") && get_node("Dash").need_to_dash == false && %Movement.move_direction != Vector3.ZERO:
		get_node("Dash").need_to_dash = true
	
	if %Movement.move_direction == Vector3.ZERO:
		if get_node("RunStop").run_stop_done == true:
			get_node("Idle").do(delta) # IDLE
		else:
			get_node("RunStop").do(delta) # RUN STOP
	else:
		if get_node("Dash").need_to_dash == false:
			if abs(%StateMachine.mouse_position.x) > 120 && get_node("Turn").need_to_turn == false:
				get_node("Turn").need_to_turn = true
			else:
				get_node("RunStop").run_stop_done = false
				
				if get_node("Turn").need_to_turn:
					get_node("Turn").do(delta) # TURNING
				else: get_node("Run").do(delta) # RUNNING
		else:
			get_node("Dash").do(delta)

	
	
