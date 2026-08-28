extends "res://Scripts/evil_boomerang.gd"

signal TweenFinished


func _ready():
	Speed = 350
	for i in get_parent().get_children():
		if i.name == "BoomerangBoss":
			Player = i
	await get_tree().create_timer(.02).timeout
	ThrowTween = get_tree().create_tween()
	var realtarget = direction * 700 + position
	var ETA = position.distance_to(realtarget) / Speed
	ThrowTween.tween_property(self,"position",realtarget, ETA).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	await ThrowTween.finished
	TweenFinished.emit()
	$PathfindTimer.start()
	_on_pathfind_timer_timeout()
