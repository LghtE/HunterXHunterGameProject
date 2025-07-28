extends Node3D

@export var color_shader : Shader

@export var ai_frequency : float = 2
@export var echo_frequency : float = 2

@export var sprite : Sprite3D
@export var main_node : Node

@export var afterimage_color : Color = Color.WHITE
@export var echo_color : Color = Color.WHITE
@export var mix_color = 0.35

var fade_time = 0.5




func echoStart(sp):
	$EchoTimer.wait_time = 1 / echo_frequency
	_on_echo_timer_timeout()
	$EchoTimer.start()

func echoEnd():
	$EchoTimer.stop()


func AiStart(sp):
	sprite = sp
	$AiTimer.wait_time = 1.0 / ai_frequency
	_on_timer_timeout()
	$AiTimer.start()

func AiStop(delay = 0):
	$AiTimer.stop()


func _on_timer_timeout() -> void:
	# For Afterimages
	var dupli = sprite.duplicate(true)
	
	
	dupli.scale = sprite.scale
	#dupli.global_transform = sprite.global_transform  # So that sprite appears behind player
	
	var new_transform = sprite.global_transform
	#SHIFTING BACK 1 UNIT IN Z AXIS
	new_transform.origin += Vector3(0, 0, -0.5)
	dupli.global_transform = new_transform
	
	dupli.transparency = 0.55
	
	var mat = ShaderMaterial.new()
	mat.shader = color_shader
	dupli.material_overlay = mat
	
	
	dupli.material_overlay.set_shader_parameter("albedo_texture", sprite.texture)
	
	dupli.material_overlay.set_shader_parameter("r", afterimage_color.r)
	dupli.material_overlay.set_shader_parameter("g", afterimage_color.g)
	dupli.material_overlay.set_shader_parameter("b", afterimage_color.b)
	
	
	dupli.material_overlay.set_shader_parameter("mix_color", mix_color)
	
	main_node.get_parent().add_child(dupli)
	var shader_tween = get_tree().create_tween()
	
	dupli.material_overlay.set_shader_parameter("opacity", 0.85)
	shader_tween.tween_property(dupli.material_overlay, "shader_parameter/opacity", 0.0, fade_time)
	
	shader_tween.connect("finished", Callable(dupli, "queue_free"))
	


func _on_echo_timer_timeout() -> void:
	
	var dupli = sprite.duplicate(true)
	
	#Offset for Fos
	#var offset = Vector2(-1, -6)
	#
	#dupli.offset = offset
	dupli.global_position = sprite.global_position  # So that sprite appears behind player
	
	var mat = ShaderMaterial.new()
	mat.shader = color_shader
	dupli.material_overlay = mat
	
	
	dupli.material_overlay.set_shader_parameter("r", echo_color.r)
	dupli.material_overlay.set_shader_parameter("g", echo_color.g)
	dupli.material_overlay.set_shader_parameter("b", echo_color.b)
	

	dupli.material_overlay.set_shader_parameter("mix_color", 1.0)
	
	main_node.get_parent().add_child(dupli)
	var shader_tween = get_tree().create_tween()
	var scale_tween = get_tree().create_tween()
	
	dupli.material.set_shader_parameter("opacity", 0.851)
	
	shader_tween.tween_property(dupli.material, "shader_parameter/opacity", 0.0, fade_time).set_ease(Tween.EASE_OUT)
	scale_tween.tween_property(dupli, "scale", Vector2(1.55, 1.35), 0.3)
	
	shader_tween.connect("finished", Callable(dupli, "queue_free"))



func singleEchoEffect(time, sp, offset, size):
	sprite = sp
	var dupli = sprite.duplicate(true)
	
	
	dupli.offset = offset
	dupli.global_position = sprite.global_position # So that sprite appears behind player
	dupli.y_sort_enabled = sprite.y_sort_enabled
	
	var mat = ShaderMaterial.new()
	mat.shader = color_shader
	dupli.material = mat
	
	
	dupli.material.set_shader_parameter("r", echo_color.r)
	dupli.material.set_shader_parameter("g", echo_color.g)
	dupli.material.set_shader_parameter("b", echo_color.b)
	

	dupli.material.set_shader_parameter("mix_color", 1.0)
	
	main_node.get_parent().add_child(dupli)
	var shader_tween = get_tree().create_tween()
	var scale_tween = get_tree().create_tween()
	
	dupli.material.set_shader_parameter("opacity", 1.0)
	
	
	shader_tween.tween_property(dupli.material, "shader_parameter/opacity", 0.0, time).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
	scale_tween.tween_property(dupli, "scale", size, time).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
	
	shader_tween.connect("finished", Callable(dupli, "queue_free"))


func _on_ai_timer_timeout() -> void:
	pass # Replace with function body.
