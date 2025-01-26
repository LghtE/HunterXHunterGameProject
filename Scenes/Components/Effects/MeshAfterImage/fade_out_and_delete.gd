extends Node

var duration: float = 1

func _ready() -> void:
	$Timer.wait_time = duration
	$Timer.start()


func _on_timer_timeout() -> void:
	get_parent().queue_free()
