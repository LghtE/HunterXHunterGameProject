extends State
var need_to_dash = false

func do(delta: float):
	%AnimationPlayer.play("Movement/Dash")
	%Movement._rootNode.velocity = %Movement.move_direction * %Movement.dash_impulse
	%Movement.player_movement_in_control = false
func dashFinished():
	need_to_dash = false
	%Movement.player_movement_in_control = true
