extends Node3D

var size_tw : Tween

func _ready() -> void:
	hide()

func idle():
	if $AnimationPlayer.is_playing():
		$AnimationPlayer.seek($AnimationPlayer.current_animation_length, true)
		$AnimationPlayer2.stop()
	$AnimationPlayer.play("Idle")

func interact():
	if $AnimationPlayer.is_playing():
		$AnimationPlayer.seek($AnimationPlayer.current_animation_length, true)
		$AnimationPlayer.stop()
	$AnimationPlayer.play("Interact")

func size():
	
	if size_tw:
		if size_tw.is_running():
			size_tw.stop()
	size_tw = get_tree().create_tween()
	size_tw.tween_property(self, "scale", Vector3(20, 20, 20), 0.06).set_ease(Tween.EASE_OUT)
	size_tw.tween_property(self, "scale", Vector3(10, 10, 10), 0.14).set_ease(Tween.EASE_IN)
	
