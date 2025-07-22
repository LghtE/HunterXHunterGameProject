extends FSMState
class_name PlayerFall

@export var player : CharacterBody3D

@export var fall_move_speed = 10.0

func enter():
	playDirectionalAnim()

func exit():
	pass


func physics_update(_delta : float):
	
	
	player.velocity.x = move_toward(player.velocity.x, 0, 3)
	player.velocity.z = move_toward(player.velocity.z, 0, 3)
	
	var input_dir
	
	input_dir = Vector2(
	Input.get_action_strength("D") - Input.get_action_strength("A"),
	Input.get_action_strength("S") - Input.get_action_strength("W")).normalized()
	
	if input_dir != Vector2.ZERO and %StateMachine.current_state.name != "PlayerWallGrab":
		player.facing = (input_dir)
		playDirectionalAnim()
	
	var player_direction := (player.transform.basis * Vector3(input_dir.x, 0, input_dir.y))
	
	if player_direction != Vector3.ZERO:
		player.velocity.x = player_direction.normalized().x * fall_move_speed
		player.velocity.z = player_direction.normalized().z * fall_move_speed
	
	
	
	
	checkForWalls()
	# Add the gravity.
	
	player.velocity += Vector3(0, -98, 0) * _delta
	player.move_and_slide()
	
	if player.is_on_floor():
		Transitioned.emit(self, "PlayerLand")
		

func playDirectionalAnim():
	var anim_name = "movementAnims/fall_" + vecToDir(player.facing)
	
	if anim_name =="movementAnims/fall_downleft" or anim_name == "movementAnims/fall_downright":
		anim_name = "movementAnims/fall_down"
		
		
	if anim_name =="movementAnims/fall_upleft" or anim_name == "movementAnims/fall_upright":
		anim_name = "movementAnims/fall_up"
	
	
	
	if anim_name != "movementAnims/fall":
		%MovementAnims.play(anim_name)

func vecToDir(v : Vector2):
	if !v || v == Vector2.ZERO:
		return ""
	
	if v.x >= -0.5 and v.x <= 0.5:
		if v.y > 0:
			return "down"
		elif v.y < 0:
			return "up"
	if v.y >= -0.7 and v.y <= 0.7:
		if v.x > 0:
			return "right"
		elif v.x < 0:
			return "left"
	
	
	if v.x > 0.5 and v.y < -0.7:
		return "upright"
	elif v.x < -0.5 and v.y < 0:
		return "upleft"
	elif v.x > 0 and v.y > 0:
		return "downright"
	elif v.x < 0 and v.y > 0:
		return "downleft"



func checkForWalls():
	if %StateMachine.current_state.name == "PlayerWallGrab":
		return
	
	
	for child : RayCast3D in %WallRaycasts.get_children():
		if child.is_colliding():
			%PlayerWallGrab.collided_raycast = child
			Transitioned.emit(self, "PlayerWallGrab")
			
			return
