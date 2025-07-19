extends Node

var idx = 0

@export var animPlayers_to_exclude : Array[AnimationPlayer]

func stopAllAnims():
	for animplayer in get_children():
		if animplayer not in animPlayers_to_exclude:
			animplayer.stop()

func playAnim(anim, playerName):
	if anim != get_node(playerName).current_animation:
		stopAllAnims()
	get_node(playerName).play(anim)
	
