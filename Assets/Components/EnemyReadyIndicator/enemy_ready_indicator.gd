extends Node3D

@export var readySFX : AudioStreamWAV


func delete():
	queue_free()

func playSound():
	GameAudioManager.playSFX(Vector3.ZERO, readySFX, 0, true)
