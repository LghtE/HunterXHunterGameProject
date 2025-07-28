extends FSMState
class_name EnemyReady

@export var enemy: CharacterBody3D

@export var attackState : FSMState

@export var ready_anim_name = "AttackReady"
@export var indicator_offset = Vector3(0, 25, 0)

func _ready() -> void:
	%AnimationPlayer.connect("animation_finished", onAnimEnd)
func enter():
	SignalBus.emit_signal("onEnemyReady", enemy)
	Fx.enemyReadyIndicator(enemy.global_position + indicator_offset)
	enemy.velocity = Vector3.ZERO
	
	
	match enemy.enemy_type:
		"Dasher":
			if enemy.get_node("BreakIndicatorComp"):
				enemy.get_node("BreakIndicatorComp").tweenIn(Vector2(1, 1.129), 1.0)
	
	%AnimationPlayer.play(ready_anim_name)
	
func exit():
	%Skin.modulate = Color.WHITE
	for box in %HurtBox.get_children():
		box.set_deferred("disabled", true)
	

func physics_update(_delta : float):
	pass

func onAnimEnd(name):
	if %StateMachine.current_state.name == "EnemyReady":
		Transitioned.emit(self, attackState.name)
