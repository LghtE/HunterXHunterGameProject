extends Node

@onready var dust_particle = preload("res://Assets/Effects/DustEffect/dust_particle_system.tscn")
@onready var hitFX = preload("res://Assets/Effects/Hit/hit_fx.tscn")
@onready var enemyReadyInd = preload("res://Assets/Components/EnemyReadyIndicator/enemy_ready_indicator.tscn")


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

func hitFx(pos, id, play_sound = true):
	var hitfx_instance = hitFX.instantiate()
	
	hitfx_instance.set_deferred("global_position", pos)
	
	for world in get_tree().get_nodes_in_group("world"):
		world.add_child(hitfx_instance)
		world.move_child(hitfx_instance, 0)
	
	hitfx_instance.spawn(id, play_sound)

func enemyReadyIndicator(pos):
	
	var fx_instance = enemyReadyInd.instantiate()
	
	fx_instance.set_deferred("global_position" , pos)
	
	for world in get_tree().get_nodes_in_group("world"):
		world.add_child(fx_instance)
		world.move_child(fx_instance, 0)
