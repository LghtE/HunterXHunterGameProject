extends State

var on_ground = true

func do(delta):
	
	
	if Input.is_action_just_pressed("Jump"):
		%Movement._rootNode.velocity.y = %Movement.jump_impulse
	
	
	if %Movement._rootNode.is_on_floor():
		get_child(0).do(delta) #OnGround
	else:
		get_child(1).do(delta) #InAir
