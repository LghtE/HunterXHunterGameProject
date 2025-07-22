extends Node

@onready var dust_particle = preload("res://Assets/Effects/DustEffect/dust_particle_system.tscn")


func dustParticleFx(pos, id, direction = Vector3.ZERO):
	var dustp_instance = dust_particle.instantiate()
	
	dustp_instance.set_deferred("global_position", pos)
	
	for world in get_tree().get_nodes_in_group("world"):
		world.add_child(dustp_instance)
		world.move_child(dustp_instance, 0)
	
	match id:
		0:
			dustp_instance.play(0)
		1:
			dustp_instance.play(1)



	
