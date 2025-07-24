extends Node
class_name ContextBasedSteering

@export var character : CharacterBody3D

var vector_map = [
	Vector3(0, 0, -1),   # Up
	Vector3(1, 0, -1),   # Up-Right
	Vector3(1, 0, 0),    # Right
	Vector3(1, 0, 1),    # Down-Right
	Vector3(0, 0, 1),    # Down
	Vector3(-1, 0, 1),   # Down-Left
	Vector3(-1, 0, 0),   # Left
	Vector3(-1, 0, -1)   # Up-Left
]

var context_map = [0,0,0,0,0,0,0,0]
var danger_map = [0,0,0,0,0,0,0,0]
var interest_map = []


var norm_dir # The direction we want to go to
var dir_to_go_to # The final direction entit

@export var raycasts : Node3D
@export var raycast_length : int = 40

var movement_speed : float = 100.0
var rays

func _ready() -> void:
	rays = raycasts.get_children()
	
	for i in range(rays.size()):
		rays[i].target_position = vector_map[i].normalized() * raycast_length

func _physics_process(_delta: float) -> void:
	if norm_dir:
		convertPathToInterest()
		convertPathToDanger()
		calculateConceptMap()
		convertConceptMapToDirection()
		steer()



func convertPathToInterest():
	
	interest_map.clear()
	var interest_vector: Vector3 = norm_dir

	for v in vector_map:
		var val = v.normalized().dot(interest_vector)

		interest_map.push_back(val)



func convertPathToDanger():
	danger_map = [0,0,0,0,0,0,0,0]
	
	for i in range(rays.size()):
		if rays[i].is_colliding() and rays[i].get_collider() != character:
			
			rays[i].get_collider()
			danger_map[i] = 5
			
			# Padding
			if i > 0:
				danger_map[i-1] = 2
			else:
				danger_map[7] = 2
				
			if i < 7:
				danger_map[i+1] = 2
			else:
				danger_map[0] = 2

func calculateConceptMap():
	for i in range(interest_map.size()):
		context_map[i] = interest_map[i] - danger_map[i]
	

func convertConceptMapToDirection():
	
	# Get the maximum value and it's coressponding direction in the vector map
	var num = context_map.max()
	var index = context_map.find(num)
	
	var non_normalized_new_velocity = vector_map[index]
	
	dir_to_go_to = non_normalized_new_velocity
	

func steer():
	var desired_velocity = dir_to_go_to * movement_speed
	var steer_force = desired_velocity - character.velocity
	var target_velocity = character.velocity + (character.steer * steer_force)
	
	character.velocity = target_velocity


func navigate(normalisedDir : Vector3, speed : float):
	
	norm_dir = normalisedDir
	movement_speed = speed
	if process_mode == Node.PROCESS_MODE_DISABLED:
		
		process_mode = Node.PROCESS_MODE_ALWAYS
	
func stop():
	norm_dir = null
	process_mode = Node.PROCESS_MODE_DISABLED
