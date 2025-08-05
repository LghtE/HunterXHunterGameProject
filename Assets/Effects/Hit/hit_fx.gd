extends Node3D

@export var hitSFX : AudioStreamWAV

var play_sfx : bool = true

func _ready() -> void:
	$BaseHit.hide()


func spawn(id, playSfx = true):
	
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	
	play_sfx = playSfx
	match id:
		0:
			$AnimationPlayer.play("hit_fx/0")
		#1:
			#position.y -= 20
			#$PurpleHitFx.rotation_degrees = randf_range(500, 250)
			#$AnimationPlayer.play("1")
		2:
			$AnimationPlayer.play("hit_fx/2")
func delete():
	queue_free()

func playSound():
	if play_sfx:
		GameAudioManager.playSFX(global_position, hitSFX, -10, true)
