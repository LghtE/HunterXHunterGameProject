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
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if event.is_action_pressed("Escape"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func handleStates(delta : float):
	if previous_state && current_state:
		if current_state != previous_state:
			current_state.onEnter()
			previous_state.onExit()
			previous_state = current_state
	
	if current_state:
		current_state.do(delta)
	

#func handleAnimations(delta):
	#match curr_anim:
		#IDLE:
			#run_value = lerp(run_value, 0.0, blend_speed * delta)
		#RUN:
			#run_value = lerp(run_value, 1.0, blend_speed * delta)
		#WALK:
			#run_value = lerp(run_value, 0.3, blend_speed * delta)
