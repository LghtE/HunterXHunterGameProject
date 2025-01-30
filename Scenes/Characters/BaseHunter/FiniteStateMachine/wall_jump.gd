extends State


func do(delta: float):
	%AnimationPlayer.play("Movement/WallJump")
	%Movement._rootNode.velocity = (%OnWall.wall_normal* 80 )
	%Movement._rootNode.velocity.y = %Movement.jump_impulse 
