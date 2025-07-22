extends CollisionShape3D
class_name PlayerHurtboxCollider

@export_category("Collider Parameters")
@export var damage_amount = 10
@export var knockback_strength = 10
@export var isHitstop = false
@export var hitstopTime = 0.0
@export var knockback_direction = Vector3.FORWARD

func _ready() -> void:
	disabled = true
