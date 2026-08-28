extends "res://Scripts/bulletbase.gd"

var WaveSpeed = 128
var Player

func _ready():
	Player = get_parent().Player
	look_at(Player.position)
	if randi_range(1,2) == 1:
		MoveBulletDown()
	else: 
		MoveBulletUp()
	

func MoveBulletDown():
	var tween = get_tree().create_tween()
	var MoveTime = (192-$Path2D/PathFollow2D.progress)/WaveSpeed
	tween.tween_property($Path2D/PathFollow2D,"progress_ratio",1,MoveTime).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	await tween.finished
	MoveBulletUp()

func MoveBulletUp():
	var tween = get_tree().create_tween()
	var MoveTime = $Path2D/PathFollow2D.progress/WaveSpeed
	tween.tween_property($Path2D/PathFollow2D,"progress_ratio",0,MoveTime).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	await tween.finished
	MoveBulletDown()
