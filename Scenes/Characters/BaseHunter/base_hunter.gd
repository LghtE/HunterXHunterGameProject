extends CharacterBody3D

enum {IDLE, RUN, WALK}
var curr_anim = IDLE


func _physics_process(delta: float) -> void:
	%Shadow.position.x = position.x - 0.15
	%Shadow.position.z = position.z
	%Shadow.position.y = position.y 
	
