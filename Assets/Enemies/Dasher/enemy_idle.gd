extends FSMState
class_name EnemyIdle

@export var enemy : CharacterBody3D


func _ready() -> void:
	enemy.setChaseTarget(GameGlobals.returnPlayer())

func enter():
	%Skin.modulate = Color.WHITE

func exit():
	pass
	

func physics_update(_delta):
	
	enemy.velocity += Vector3(0, -98, 0) * _delta
	enemy.move_and_slide()
	
	enemy.velocity.x = move_toward(enemy.velocity.x, 0, 0.5)
	enemy.velocity.z = move_toward(enemy.velocity.z, 0, 0.5)
	
	
	if enemy.processing:
		match enemy.enemy_type:
			"EnemySlasher":
				Transitioned.emit(self, "EnemyHold")
			_:
				Transitioned.emit(self, "EnemyChase")
