extends State


func do(delta: float):
	%AnimationPlayer.play("Movement/Jump")
	%Movement._rootNode.velocity = (%OnWall.wall_normal + %Movement.move_direction) * 80 
	%Movement._rootNode.velocity.y = %Movement.jump_impulse * 1.1
