extends Node

@export var current_state: State
var previous_state: State
var _velocity
var mouse_position = Vector2.ZERO
var mouse_moving = false
var _old_mouse = Vector2.ZERO
var stick_vector : Vector2

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if get_viewport().get_mouse_position() != _old_mouse:
		mouse_moving = true
	else:
		mouse_moving = false
	_old_mouse = get_viewport().get_mouse_position()
	
func _physics_process(delta: float) -> void:
	
	stick_vector = Input.get_vector("joy_left", "joy_right", "joy_up", "joy_down")
	

	
	handleStates(delta)
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if event.is_action_pressed("Escape"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	if event.is_action_pressed("Fullscreen"):
		if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

	if event is InputEventMouseMotion:
		mouse_position = event.relative
	else:
		pass
		



func handleStates(delta : float):
	if previous_state && current_state:
		if current_state != previous_state:
			current_state.onEnter()
			previous_state.onExit()
			previous_state = current_state
	
	if current_state:
		current_state.do(delta)
	
