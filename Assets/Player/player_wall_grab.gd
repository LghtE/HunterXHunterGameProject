extends FSMState
class_name PlayerWallGrab

@export var player : CharacterBody3D
@export var impulse_strength = 70.0

@export var wallgrabsfx : AudioStreamWAV
var can_stay_on_wall = true

var DOWNWARD_IMPULSE = 0.05

var collided_raycast : RayCast3D

var impulse_direction = Vector3.ZERO

func enter():
	#await get_tree().process_frame
	#await get_tree().process_frame
	#await get_tree().process_frame
	#await get_tree().process_frame
	
	player.velocity = Vector3.ZERO
	$OnWallTimer.start()
	GameAudioManager.playSFX(player.global_position, wallgrabsfx, 0, true)
	%WallDustParticle.global_transform = player.global_transform
	
	match collided_raycast.name:
		"right":
			%MovementAnims.play("movementAnims/wallgrab_right")
			%WallDustParticle.position = Vector3(1.905, 3.8, 0.919)
			player.facing = Vector2.LEFT
			impulse_direction = -Vector3.RIGHT
		"left":
			%MovementAnims.play("movementAnims/wallgrab_left")
			%WallDustParticle.position = Vector3(-1.905, 3.8, 0.919)
			player.facing = Vector2.RIGHT
			impulse_direction = -Vector3.LEFT
		"up":
			%MovementAnims.play("movementAnims/wallgrab_up")
			%WallDustParticle.position = Vector3(1.027, 3.822, -0.954)
			player.facing = Vector2.DOWN
			impulse_direction = -Vector3.FORWARD
		_:
			print("no collidede raycast")
	
	
	%WallDustParticle.emitting = true

func exit():
	%SkinSuit.scale = Vector3(10, 10, 10)
	
	for child in %WallRaycasts.get_children():
		child.enabled = true
	
	collided_raycast.enabled = false
	
	can_stay_on_wall = true
	%WallDustParticle.emitting = false

	

func physics_update(_delta : float):
	if can_stay_on_wall:
		player.velocity.y -= DOWNWARD_IMPULSE
		if Input.is_action_just_pressed("Jump"):
			$OnWallTimer.stop()
			player.velocity += impulse_direction * impulse_strength
			
			%SkinSuit.scale = Vector3(10, 10, 10)
			%PlayerJump.wall_jump = true
			Transitioned.emit(self, "PlayerJump")
	
	else:
		player.velocity = Vector3.ZERO
		%SkinSuit.scale = Vector3(10, 10, 10)
		Transitioned.emit(self, "PlayerFall")
	

	
	
	player.move_and_slide()


func _on_on_wall_timer_timeout() -> void:
	if %StateMachine.current_state.name == "PlayerWallGrab":
		can_stay_on_wall = false
