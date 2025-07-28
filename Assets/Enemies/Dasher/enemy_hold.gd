extends FSMState

class_name EnemyHold

enum holdTypes {Circle, Maintain}
@export var enemy : CharacterBody3D
@export var CBS : ContextBasedSteering
@onready var attackTimer = $AttackTimer

@export var hold_speed : float = 10.0
@export var hold_type : holdTypes = holdTypes.Circle


var hold_speed_eased = 10.0
var circle_dir = 1

var other_en_ready : bool = false


@onready var tweenholdspeed
@onready var tweenvel : Tween


func _ready() -> void:
	SignalBus.connect("onEnemyReady", onEnReady)
func enter():
	
	%Skin.modulate = Color.WHITE
	
	if enemy.enemy_type == "EnemySlasher":
		%Skin.offset = Vector2.ZERO
		interpolateVelocity(Vector2.ZERO, 0.2)
	
	
	
	
	match hold_type:
		holdTypes.Circle:
			%AnimationPlayer.play("dasherAnims/Circle")
			
			if randf() > 0.5:
				circle_dir = 1
			else:
				circle_dir = -1
			interpolateHoldSpeed(hold_speed)
			
			
		holdTypes.Maintain:
			%AnimationPlayer.play("Idle")
			
	
	if attackTimer.is_stopped():
		attackTimer.wait_time = randf_range(1.2, 3)
		attackTimer.start()


func exit():
	CBS.stop()

func physics_update(_delta: float):
	
	enemy.setLookDirection()
	
	var dir_to_player = (enemy.chase_target.global_position - enemy.global_position).normalized()
	
	if (enemy.chase_target.global_position - enemy.global_position).length() > enemy.distance_to_maintain_outer:
		# If self is too far
		
		match enemy.enemy_type:
			"EnemySlasher":
				Transitioned.emit(self, "EnemyJumpChase")
			_:
				Transitioned.emit(self, "EnemyChase")
		
	elif (enemy.chase_target.global_position - enemy.global_position).length() < enemy.distance_to_maintain_inner:
		
		#If self is too close
		
		match enemy.enemy_type:
			"EnemySlasher":
				Transitioned.emit(self, "EnemyJumpChase")
			_:
				interpolateHoldSpeed(15.0)
				var dir_away = -Vector3(dir_to_player.x, 0 , dir_to_player.z)
				CBS.navigate(dir_away, hold_speed)
	else:
		
		#If in the positon that we have to hold
		if hold_type == holdTypes.Circle:
			interpolateHoldSpeed(10.0)
			var tangent_cw = Vector3(-dir_to_player.z, 0, dir_to_player.x) * circle_dir
			CBS.navigate(tangent_cw, hold_speed) 
			#%RayCast2D.target_position = tangent_cw * 20
	
	enemy.velocity += Vector3(0, -98, 0) * _delta
	enemy.move_and_slide()


func interpolateVelocity(val : Vector2, time):
	
	tweenvel = get_tree().create_tween()
	tweenvel.tween_property(enemy, "velocity", val, time).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)

func interpolateHoldSpeed(val : float):
	hold_speed = val
	
	tweenholdspeed = get_tree().create_tween()
	tweenholdspeed.tween_property(self, "hold_speed", 70, 1).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)


func _on_attack_timer_timeout() -> void:
	if %StateMachine.current_state.name == "EnemyDead":
		return
	
	
	if randf() > enemy.attack_frequency and %StateMachine.current_state.name == "EnemyHold":
		
		if enemy.has_token:
			if enemy.wait_for_others:
				if !other_en_ready:
					Transitioned.emit(self, "EnemyReady")
					enemy.has_token = false
			else:
					Transitioned.emit(self, "EnemyReady")
					enemy.has_token = false

func onEnReady(enem):
	pass
	#if enem != enemy:
		#$OtherEnReady.start()
		#other_en_ready = true


func _on_other_en_ready_timeout() -> void:
	other_en_ready = false
