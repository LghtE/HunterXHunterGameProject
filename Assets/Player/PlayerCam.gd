extends Camera3D

class_name PlayerCam

var tween_zoom : Tween
var tween_move : Tween
var break_time = 0.4


var cam_tween_move : Tween
var cam_tween_zoom : Tween
@export var player : CharacterBody3D

func onEnemyBreak(enemy):
	%blurAnimPlayer.play("blurAnim/show")
	
	tween_zoom = get_tree().create_tween()
	tween_zoom.set_ease(Tween.EASE_OUT)
	tween_zoom.set_trans(Tween.TRANS_EXPO)
	
	var zoom_intensity = 3
	tween_zoom.tween_property(self, "position", position + Vector3(0, -zoom_intensity, -zoom_intensity), 0.1)
	
	tween_move = get_tree().create_tween()
	tween_move.set_ease(Tween.EASE_OUT)
	tween_move.set_trans(Tween.TRANS_EXPO)
	
	
	
	var pos = player.global_position * 0.1 + (enemy.global_position) * (1 - 0.1)
	
	tween_move.tween_property(%CamFollow, "position", to_local(pos), 0.1)
	
	
	await tween_move.finished
	%Camera3D.get_node("AnimationPlayer").play("shake_big")
	#GameGlobals.hitStop(0.02)
	
	GameGlobals.setProcessOff([player])
	var tw = get_tree().create_timer(0.1)
	await tw.timeout
	GameGlobals.resetProcess()
	
	tween_zoom = get_tree().create_tween()
	tween_zoom.set_ease(Tween.EASE_OUT)
	tween_zoom.set_trans(Tween.TRANS_EXPO)
	
	tween_zoom.tween_property(self, "position", position - Vector3(0, -zoom_intensity, -zoom_intensity), break_time)
	
	tween_move = get_tree().create_tween()
	tween_move.set_ease(Tween.EASE_OUT)
	tween_move.set_trans(Tween.TRANS_EXPO)
	
	tween_move.tween_property(%CamFollow, "position", player.cam_follow_orig_vec, break_time)



















func onPlayerHurt():
	
	%blurAnimPlayer.play("blurAnim/show")
	
	tween_zoom = get_tree().create_tween()
	tween_zoom.set_ease(Tween.EASE_OUT)
	tween_zoom.set_trans(Tween.TRANS_EXPO)
	
	var zoom_intensity = 1
	tween_zoom.tween_property(self, "position", position + Vector3(0, -zoom_intensity, -zoom_intensity), 0.1)
	
	

	
	
	await tween_zoom.finished
	%Camera3D.get_node("AnimationPlayer").play("shake_big")
	#GameGlobals.hitStop(0.02)
	
	GameGlobals.setProcessOff([])
	var tw = get_tree().create_timer(0.1)
	await tw.timeout
	GameGlobals.resetProcess()
	
	tween_zoom = get_tree().create_tween()
	tween_zoom.set_ease(Tween.EASE_OUT)
	tween_zoom.set_trans(Tween.TRANS_EXPO)
	
	tween_zoom.tween_property(self, "position", position - Vector3(0, -zoom_intensity, -zoom_intensity), break_time)
	

#func onSkillMenu():
	#%blurAnimPlayer.play("show")
	#
	#
	#tween_zoom = get_tree().create_tween()
	#tween_zoom.set_ease(Tween.EASE_OUT)
	#tween_zoom.set_trans(Tween.TRANS_EXPO)
	#
	#zoom = Vector2(1.1, 1.1)
	#tween_zoom.tween_property(self, "zoom", Vector2(1, 1), 0.3).set_ease(Tween.EASE_OUT)
	#
	#await tween_zoom.finished


func zoomTween(zm, dur, easetype):
	
	if cam_tween_zoom:
		if cam_tween_zoom.is_running():
			cam_tween_zoom.stop()
	
	cam_tween_zoom = get_tree().create_tween()
	
	match easetype:
		"EaseOut":
			cam_tween_zoom.set_ease(Tween.EASE_OUT)
		"EaseIn":
			cam_tween_zoom.set_ease(Tween.EASE_IN)
	
	cam_tween_zoom.set_trans(Tween.TRANS_EXPO)
	
	cam_tween_zoom.tween_property(self, "zoom", zm, dur)
	
	await cam_tween_zoom.finished

func moveTween(pos, dur, easetype):
	
	
	if cam_tween_move:
		if cam_tween_move.is_running():
			cam_tween_move.stop()
	
	
	cam_tween_move = get_tree().create_tween()
	cam_tween_move.set_ease(Tween.EASE_OUT)
	cam_tween_move.set_trans(Tween.TRANS_EXPO)
	
	cam_tween_move.tween_property(self, "global_position", pos, dur).set_ease(Tween.EASE_OUT)
	
	await cam_tween_move.finished
