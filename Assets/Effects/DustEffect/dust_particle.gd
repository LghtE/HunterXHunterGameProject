extends Node3D



func _on_finished() -> void:
	queue_free()


func play(id):
	match id:
		0:
			$DustParticle.show()
			$DustParticle.emitting = true
