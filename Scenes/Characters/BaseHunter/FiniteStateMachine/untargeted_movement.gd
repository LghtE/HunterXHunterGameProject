extends State

var on_ground = true

func do(delta):
	
	
	if Input.is_action_just_pressed("Jump"):
		%Movement._rootNode.velocity.y = %Movement.jump_impulse
	
	
	if %Movement._rootNode.is_on_floor():
		get_node("OnGround").do(delta) #OnGround
	else:
		get_node("InAir").do(delta) #InAir
