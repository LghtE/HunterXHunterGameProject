extends RigidBody3D

@export var health_amount = 10.0
@export var heal_sfx : AudioStreamWAV
var impulse = Vector3(0, 10, 0)

var picked_up = false


func _ready() -> void:
	self.hide()
	$SubViewport/HealthPickup/Sprite2D.material = $SubViewport/HealthPickup/Sprite2D.material.duplicate()
	$Area3D.set_deferred("monitoring", false)

func spawn():
	
	if GameGlobals.returnPlayer().current_health == GameGlobals.returnPlayer().max_health:
		return
	
	#if randf() > 0.5:
		#return
	
	$Shadow.global_position.y  = global_position.y - 4.5
	global_position += Vector3(0, 5, 0)
	
	
	apply_impulse(impulse)
	
	$Area3D.set_deferred("monitoring", true)
	
	
	
	
	show()
	$SubViewport/HealthPickup/pulse.play("squish")
	$SubViewport/HealthPickup/shake.play("shake")

func pulse():
	$SubViewport/HealthPickup/pulse.play("pulse")



func _on_timer_timeout() -> void:
	$SubViewport/HealthPickup/pulse.play("blink")

func _physics_process(delta: float) -> void:
	$Shadow.global_position.z  = global_position.z
	$Shadow.global_position.x  = global_position.x


func delete():
	if picked_up == false:
		queue_free()


func _on_area_3d_area_entered(area: Area3D) -> void:
	
	picked_up = true
	$Area3D.set_deferred("monitoring", false)
	area.owner.playerHeal(0.1)
	GameAudioManager.playSFX(Vector3.ZERO, heal_sfx)
	queue_free()
