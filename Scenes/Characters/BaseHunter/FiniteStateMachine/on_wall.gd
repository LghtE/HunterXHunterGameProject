extends State
var wall_jumping = false
var wall_normal

func do(delta: float):
	
	if %AnimationPlayer.current_animation == "Movement/WallRunRight":
		%CameraTarget.position = lerp(%CameraTarget.position, %WallCamPosLeft.position, 0.1)
	elif %AnimationPlayer.current_animation == "Movement/WallRunLeft":
		%CameraTarget.position = lerp(%CameraTarget.position, %WallCamPosRight.position, 0.1)

	
	if Input.is_action_just_pressed("Jump"):
		wall_jumping = true
	
	if %mid_left_raycast.is_colliding():
		wall_normal = %mid_left_raycast.get_collision_normal()
	elif %mid_right_raycast.is_colliding():
		wall_normal = %mid_right_raycast.get_collision_normal()
		
	if wall_jumping:
		%mid_left_raycast.enabled = false
		%mid_right_raycast.enabled = false
		get_node("WallJump").do(delta)
	else:
		get_node("WallGrab").do(delta)

func wallJumpFinish():
	wall_jumping = false
