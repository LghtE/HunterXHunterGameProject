extends Node
enum States {Movement}
var current_state: State
var previous_state: State


func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass
	
func _physics_process(delta: float) -> void:
	
	if current_state:
		current_state.do(delta)
