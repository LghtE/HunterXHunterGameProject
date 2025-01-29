extends State

var on_ground = true

func do(delta):
	%Camera3D.current = true
	
	if Input.is_action_just_pressed("Jump") :
		if %Movement._rootNode.is_on_floor() || (%mid_left_raycast.is_colliding() || %mid_right_raycast.is_colliding()):
			%Movement._rootNode.velocity.y = %Movement.jump_impulse


		
	if !(%mid_left_raycast.is_colliding() || %mid_right_raycast.is_colliding()) :
		%mid_left_raycast.enabled = true
		%mid_right_raycast.enabled = true
		
		
		if %Movement._rootNode.is_on_floor():
			get_node("OnGround").do(delta) #OnGround
		elif get_node("OnGround/Dash").need_to_dash == false:
			get_node("InAir").do(delta) #InAir
	else:
		get_node("OnWall").do(delta) #OnWall
