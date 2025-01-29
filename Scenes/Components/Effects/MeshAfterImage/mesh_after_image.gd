extends Node

@export_group("Prerequisites")
## The MeshInstance3D used for the after-images.
@export var main_mesh : MeshInstance3D
## Where the MeshInstance3D and their Skeleton3D will be added to (also rotation).
@export var attach_node_path : NodePath
## Where the MeshInstance3D will get it's root position from.
@export var main_body_path : NodePath
@export var source_skeleton : Skeleton3D

var fade_and_delete_node : PackedScene = preload("res://Scenes/Components/Effects/MeshAfterImage/FadeOutAndDelete.tscn")

@export_group("Visual")
@export var no_of_afterimages : int = 4
@export var duration : float = 2
@export var afterimg_duration : float = 0.5
@export var afterimg_color : Color = Color.AQUA

var attach_node 
var main_body
var time_per_afterimg
var afteriimgidx = 0



func _ready() -> void:
	attach_node = get_node(attach_node_path)
	main_body = get_node(main_body_path)
	time_per_afterimg = duration / no_of_afterimages
	$Timer.wait_time = time_per_afterimg
func afterImage():
	if $Timer.is_stopped():
		$Timer.start()



func _on_timer_timeout() -> void:
	var duplicate_mesh = main_mesh.duplicate()
	var skeleton = Skeleton3D.new()
	
	duplicate_mesh.top_level = true
	duplicate_mesh.position = main_body.position
	duplicate_mesh.rotation = attach_node.rotation
	
	attach_node.add_child(skeleton)
	attach_node.move_child(skeleton, 0)
	
	duplicate_mesh.set_skeleton_path(attach_node.get_child(0).get_path())
	
	

	for bone_idx in range(0, source_skeleton.get_bone_count()):
		skeleton.add_bone(source_skeleton.get_bone_name(bone_idx))
		attach_node.get_child(0).set_bone_global_pose(bone_idx, source_skeleton.get_bone_global_pose(bone_idx))
		
	attach_node.add_child(duplicate_mesh)
	
	
	
	var del1 = fade_and_delete_node.instantiate()
	var del2 = fade_and_delete_node.instantiate()
	
	del1.duration = afterimg_duration
	del2.duration = afterimg_duration
	attach_node.get_node(skeleton.get_path()).add_child(del1)
	attach_node.get_node(duplicate_mesh.get_path()).add_child(del2)
	
	
	attach_node.get_node(duplicate_mesh.get_path()).set_surface_override_material(0, main_mesh.get_active_material(0).duplicate())

	attach_node.get_node(duplicate_mesh.get_path()).get_surface_override_material(0).set_next_pass(main_mesh.get_active_material(0).get_next_pass().get_next_pass().duplicate())
	
	attach_node.get_node(duplicate_mesh.get_path()).get_surface_override_material(0).get_next_pass().set_shader_parameter("distortion", 0.06)
	attach_node.get_node(duplicate_mesh.get_path()).get_surface_override_material(0).get_next_pass().set_shader_parameter("alpha", 0.89)
	attach_node.get_node(duplicate_mesh.get_path()).get_surface_override_material(0).get_next_pass().set_shader_parameter("speed", 0.01)
	attach_node.get_node(duplicate_mesh.get_path()).get_surface_override_material(0).emission_energy_multiplier = 2
	attach_node.get_node(duplicate_mesh.get_path()).get_surface_override_material(0).emission = afterimg_color


	
	
	afteriimgidx += 1
	if afteriimgidx >= no_of_afterimages:
		afteriimgidx = 0
		$Timer.stop()
