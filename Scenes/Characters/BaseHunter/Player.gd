extends Node

@export var current_state: State
var previous_state: State
var _velocity

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass
	
func _physics_process(delta: float) -> void:
	handleStates(delta)


func handleStates(delta : float):
	if previous_state && current_state:
		if current_state != previous_state:
			current_state.onEnter()
			previous_state.onExit()
			previous_state = current_state
	
	if current_state:
		current_state.do(delta)
	
