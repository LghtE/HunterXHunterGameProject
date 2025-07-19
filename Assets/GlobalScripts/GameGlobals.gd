extends Node2D
class_name Game


var player_can_move = true

var mouse_mode = true
var idx = 0
var f_idx = 0


func _ready() -> void:
	pass
	#Manually setting Fullscreen
	#SignalBus.emit_signal("fullscreenToggled", true)
	#DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)


func _input(event: InputEvent) -> void:
	
	
	if event.is_action_pressed("F"):
		if f_idx == 0:
			f_idx = 1
			SignalBus.emit_signal("fullscreenToggled", true)
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
		else:
			f_idx = 0
			SignalBus.emit_signal("fullscreenToggled", false)
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

	
	
	
	
	
	
	
	
	#
	#if event.is_action_pressed("M"):
		#mouse_mode = !mouse_mode
		#if idx == 0:
			#Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			#idx = 1
		#elif idx == 1:
			#Input.mouse_mode = Input.MOUSE_MODE_CONFINED
			#idx = 0

#

func hidePlayer():
	var p = GameGlobals.returnPlayer()
	p.get_node("SkinSuit").hide()
	p.get_node("Shadow").hide()
	
func showPlayer():
	var p = GameGlobals.returnPlayer()
	p.get_node("SkinSuit").show()
	p.get_node("Shadow").show()



func setProcessOff(exclude : Array):
	var entities = get_tree().get_nodes_in_group("process")
	
	
	
	for entity in entities:
		
		# For debug, some entities are kept as non processing from start so don't touch them
		if entity.is_in_group("enemy"):
			if !entity.processing:
				continue
		
		
		if entity in exclude:
			continue
		
		entity.call_deferred("set", "process_mode", Node.PROCESS_MODE_DISABLED)
		
		if entity.has_method("onProcessOff"):
			entity.onProcessOff()
			
		for node in entity.get_children():
			
			
			node.call_deferred("set", "process_mode", Node.PROCESS_MODE_DISABLED)
			
			
			# So that the hurtbox doesn't keep hurting the enemy 
			#if node is PlayerHurtboxCollider:
				#node.call_deferred("set", "disabled", true)
			#
			#
			#for n1 in node.get_children():
				#n1.call_deferred("set", "process_mode", Node.PROCESS_MODE_DISABLED)
				#
				#if n1 is PlayerHurtboxCollider:
					#n1.call_deferred("set", "disabled", true)

func resetProcess():
	var entities = get_tree().get_nodes_in_group("process")
	
	for entity in entities:
		
		# For debug, some entities are kept as non processing from start so don't touch them
		if entity.is_in_group("enemy"):
			if !entity.processing:
				continue
		
		
		
		entity.process_mode = Node.PROCESS_MODE_ALWAYS
		
		if entity.has_method("onProcessOn"):
			entity.onProcessOn()
		
		for node in entity.get_children():
			node.process_mode = Node.PROCESS_MODE_ALWAYS
			
			
			
			for n1 in node.get_children():
				n1.call_deferred("set", "process_mode", Node.PROCESS_MODE_ALWAYS)
				


func hitStop(duration):
	Engine.time_scale = 0.1
	var timer = get_tree().create_timer(duration)
	await timer.timeout
	Engine.time_scale = 1



func returnPlayer():
	var player = get_tree().get_first_node_in_group("player")
	return player

func returnMousePos():
	return get_global_mouse_position()

func findNodeById(parent: Node, target_id: String):
	for child in parent.get_children():
		if child.has_variable("id") and child.id == target_id:
			return child
		var found = findNodeById(child, target_id)
		if found:
			return found
		return null


#func spawnHealthPickup(pos, impulse):
	#var ins = health_pickup.instantiate()
	#
	#ins.global_position = pos
	#
	#var world = get_tree().get_first_node_in_group("world")
	#
	#world.add_child(ins)
	#world.move_child(ins, 0)
	#ins.impulse = impulse
	#ins.spawn()
