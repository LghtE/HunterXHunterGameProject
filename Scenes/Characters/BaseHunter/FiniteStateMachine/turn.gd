extends Node
var need_to_turn = false

func do(delta: float):
	%Movement.player_movement_in_control = false
	%Movement._rootNode.velocity = Vector3.ZERO
	%AnimationPlayer.play("Turn")

func turnDone():
	%Movement.player_movement_in_control = true
	need_to_turn = false
