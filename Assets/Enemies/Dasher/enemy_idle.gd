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
	
	
	if enemy.processing:
		match enemy.enemy_type:
			"EnemySlasher":
				Transitioned.emit(self, "EnemyHold")
			_:
				Transitioned.emit(self, "EnemyChase")
