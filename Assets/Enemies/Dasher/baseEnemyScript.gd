extends CharacterBody3D

class_name BaseEnemy

signal lockedOn(enemy)
signal lockedOff()



@export var enemy_type : String

var chase_target

var has_token : bool = true
# When Player hits the enemy, these values get set
var knockback_strength
var knockback_direction

var in_break : bool = false
var is_dead : bool = false
var invulnerable : bool = false

@export_group("Debug")
@export var processing = true
@export var delay_enable_time : float = 1

@export_group("Enemy Stats")
@export var current_health : float = 100.0
@export var max_health : float = 100.0

@export var base_damage : float = 25.0


@export_group("Enemy Parameters")

@export var stun_lockable : bool = true
@export var breakable : bool = true
@export var mini_boss : bool = false

@export_group("Enemy Behaviour")

@export var run_speed : float = 100.0

@export var run_speed_variation : float = 5.0  
@export var steer : float = 0.06
@export var distance_to_maintain_outer : float = 155
@export var distance_to_maintain_inner : float = 110
@export var attack_frequency : float = 0.05 # 40 %

@export var wait_for_others : bool = true


var has_slash_hit = false


@onready var player : CharacterBody3D = GameGlobals.returnPlayer()
 

func _physics_process(_delta: float) -> void:
	$DebugLabel.text = str("State : " + %StateMachine.current_state.name)
	#$Skin/DebugLabel.text = str("has_token : " + str(has_token))
	



func _ready() -> void:
	
	#if processing:
		#for node in get_children():
			#node.process_mode = Node.PROCESS_MODE_ALWAYS
	#else:
		#for node in get_children():
			#node.process_mode = Node.PROCESS_MODE_DISABLED
	
	if has_node("TargetLockOn"):
		connect("lockedOn", get_node("TargetLockOn").onTarget)
		connect("lockedOff", get_node("TargetLockOn").onUntarget)
	else:
		print("No target lock on node for ", self)
	
	randomize()
	run_speed += randf_range(-run_speed_variation, run_speed_variation)
	distance_to_maintain_outer += randf_range(-10, 10)
	distance_to_maintain_inner += randf_range(-10, 10)




func setLookDirection():
	if player:
		var vec_to_target = (chase_target.global_position - global_position).normalized()
		if vec_to_target.x >= 0:
			$Skin.flip_h = true
		else:
			$Skin.flip_h = false

func setChaseTarget(target):
	chase_target = target


func _on_hurt_box_area_entered(area: Area2D) -> void:
	
	match enemy_type:
		"EnemySlasher":
			has_slash_hit = true

	
	
	if area.owner.has_node("DamageComponent"):
		area.owner.get_node("DamageComponent").damage(base_damage, 250, velocity.normalized())
	else:
		print("Hit Entity has no Damage Component")


func onProjectileHit():
	if breakable:
		# Those enemies which get BREAK in specific state when hit by proj
		match enemy_type:
			"Dasher":
				if %StateMachine.current_state.name == "EnemyReady":
					if current_health != 0:
						
						call_deferred("spawnHealthPickupSafe", global_position)
						
						if get_node("BreakIndicatorComp"):
							get_node("BreakIndicatorComp").tweenOut()
						%StateMachine.on_child_transition(%StateMachine.current_state, "EnemyBreak")
			"EnemySlasher":
				if %StateMachine.current_state.name == "EnemySlashRecover":
					if current_health != 0:
						
						call_deferred("spawnHealthPickupSafe", global_position)
						
						if get_node("BreakIndicatorComp"):
							get_node("BreakIndicatorComp").tweenOut()
						%StateMachine.on_child_transition(%StateMachine.current_state, "EnemyBreak")
		

#Player locks on to enemy
func onTarget():
	emit_signal("lockedOn", self)

func onUntarget():
	emit_signal("lockedOff")

func spawnHealthPickupSafe(pos):
	var x_com 
	if randf() > 0.5:
		x_com = randf_range(-0.8, -0.2)
	else:
		x_com = randf_range(0.2, 0.8)

	var y_com = -1
	
	var x_mag = 250
	var y_mag = 350
	var impulse = Vector2(x_com * x_mag, y_com * y_mag)
	GameGlobals.spawnHealthPickup(pos, impulse)

func delayEnable():
	await get_tree().create_timer(delay_enable_time).timeout
	processing = true
