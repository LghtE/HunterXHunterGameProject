extends AudioStreamPlayer
class_name SoundEffect


func onSFXend():
	self.queue_free()
