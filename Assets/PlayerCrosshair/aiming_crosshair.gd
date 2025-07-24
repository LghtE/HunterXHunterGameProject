extends Node3D

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
	$AnimationPlayer2.play("size")
