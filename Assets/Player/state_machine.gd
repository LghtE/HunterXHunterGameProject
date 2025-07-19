extends Node

@export var initial_state : FSMState
@export var main_node : CharacterBody3D

var current_state : FSMState
var states: Dictionary = {}

func _ready() -> void:
	
	for child in get_children():
		if child is FSMState:
			states[child.name.to_lower()] = child
			child.Transitioned.connect(on_child_transition)
			
	
	if initial_state:
		
		initial_state.enter()
		current_state = initial_state

	
func _process(delta: float) -> void:
	if current_state:
		current_state.update(delta)
	
func _physics_process(delta: float) -> void:
	
	if current_state:
		current_state.physics_update(delta)

func on_child_transition(_state, new_state_name):
	var new_state = states.get(new_state_name.to_lower())
	
	if !new_state:
		return
	
	
	if current_state:
		current_state.exit()
	
	
	new_state.enter()
	current_state = new_state
	
