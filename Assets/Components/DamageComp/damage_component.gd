extends Node3D
class_name DamageComponent

@export var entity : CharacterBody3D
@export var stun_lockable : bool = true
@export var StateMachine : Node
@export var hurt_State_name : String
@export var dead_State_name : String
var hurt_tween : Tween

var knockbackDir = Vector3.FORWARD

func damage(inc_damage, knockback_str = 0.0, knockback_direction = Vector3.ZERO):
	
	
	if "invulnerable" in entity:
		if entity.invulnerable == true:
			return
	
	
	
	knockbackDir = knockback_direction
	
	
	if StateMachine:
		
		if entity.current_health - inc_damage <= 0:
			StateMachine.on_child_transition(StateMachine.current_state, dead_State_name)
		else:
			if StateMachine.has_node("EnemyBreakHurt") and entity.in_break:
				StateMachine.on_child_transition(StateMachine.current_state, "EnemyBreakHurt")
			else:
				if entity.stun_lockable:
					StateMachine.on_child_transition(StateMachine.current_state, hurt_State_name)
				else:
					if entity.get_node("Fx").is_playing:
						entity.get_node("Fx").stop()
					entity.get_node("Fx").play("enemyFxAnims/HurtFx")
	
	
	
	
	
	
	if "current_health" in entity:
		
		entity.current_health -= inc_damage
		entity.current_health = clamp(entity.current_health, 0, entity.max_health)
		
		# Refactor
		#Fx.numPopup(inc_damage, entity.global_position + Vector2(0, -40))
		
		if entity.has_node("HealthBarComponent"):
			entity.get_node("HealthBarComponent").hpDrop(entity.current_health + inc_damage,
			entity.current_health, 0.3)
		elif entity.has_node("CanvasLayer/HealthBarComponent"):
			entity.get_node("CanvasLayer/HealthBarComponent").hpDrop(entity.current_health + inc_damage,
			entity.current_health, 0.3)
		

	else:
		print("No health variable in hit entity")
	
	
	
	if entity.stun_lockable or entity.in_break:
		entity.velocity = Vector3.ZERO
		
		# Applying Knockback
		
		
		
		if "is_dead" in entity:
			# For dead-ing enemies
			if entity.is_dead:
				entity.velocity = knockback_direction * knockback_str * 1.2
			else:
				entity.velocity = knockback_direction * knockback_str * 100.0
		
		if hurt_tween:
			if hurt_tween.is_running():
				hurt_tween.stop()
		
		hurt_tween = get_tree().create_tween()
		hurt_tween.set_ease(Tween.EASE_OUT)
		hurt_tween.tween_property(entity, "velocity", Vector3.ZERO, 0.3)
	else:
		#Enemy is NOT stunlockable but we like some knockback
		if !entity.is_dead:
			entity.velocity += knockback_direction * 15.0
		else:
			# For deading unstunlockable enemies
			entity.velocity += knockback_direction * 10.0
