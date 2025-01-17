extends Node

class_name State;

var child_states = get_children() if get_children() else null

func _ready() -> void:
	pass

func onEnter():
	print("state initiated")
	
func do(delta: float):
	pass
	
func onExit():
	pass
