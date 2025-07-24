extends Node3D

signal projHit(enemy)
@export var deflect_sound : AudioStreamWAV

@export var is_enemy_proj = false
var dir = Vector3.ZERO
var speed = 140.0
var rebound = false
@export var damage = 5


func _physics_process(delta: float) -> void:
	var old_pos = position
	position += dir * speed * delta
	
	if old_pos == position:
		queue_free()
	

func _on_timer_timeout() -> void:
	queue_free()

# This is for walls
func _on_hurtbox_body_entered(_body: Node2D) -> void:
	Fx.hitFx(global_position, 2)
	
	queue_free()


func onTarget():
	$TargetLockOn.onTarget(self)

func onUntarget():
	$TargetLockOn.onUntarget()


func projectileRebound(rebound_dir):
	GameAudioManager.playSFX(global_position, deflect_sound)
	rebound = true
	speed *= 5
	dir = rebound_dir
	$Hurtbox/CollisionShape2D.shape.radius = 16.0
	
	$Hurtbox.set_collision_layer_value(1, false)
	$Hurtbox.set_collision_layer_value(3, false)
	
	$Hurtbox.set_collision_layer_value(2, true)
	
	$Hurtbox.set_collision_mask_value(4, false)
	
	$Hurtbox.set_collision_mask_value(1, true)
	$Hurtbox.set_collision_mask_value(5, true)


func _on_hurt_box_area_entered(area: Area3D) -> void:
	if "invulnerable" in area.owner:
		if area.owner.invulnerable:
			return
	
	emit_signal("projHit", area.owner)
	
	if area.owner.has_node("DamageComponent"):
		
		if rebound and area.owner.get_node("StateMachine").current_state.name != "EnemyBreak":
			if area.owner.is_in_group("enemy"):
				match area.owner.enemy_type:
					"Shooter":
						area.owner.get_node("DamageComponent").damage(20, 150, dir)
						
						
						
						await get_tree().process_frame
						await get_tree().process_frame
						await get_tree().process_frame
						await get_tree().process_frame
						await get_tree().process_frame
						area.owner.call_deferred("spawnHealthPickupSafe", area.owner.global_position)
						area.owner.get_node("StateMachine").on_child_transition("", "EnemyBreak")
					_:
						area.owner.get_node("DamageComponent").damage(20, 150, dir)
		else:
			area.owner.get_node("DamageComponent").damage(damage, 150, dir)
	
	
	if area.owner.has_method("projectileRebound"):
		var rb_dir = (area.owner.global_position - GameGlobals.returnPlayer().global_position).normalized()
		area.owner.projectileRebound(rb_dir)
	
	Fx.hitFx(global_position, 0)
	
	queue_free()
