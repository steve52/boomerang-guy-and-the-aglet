extends "res://Scripts/boomerang.gd"

var direction

func Shoot():
	pass

func _ready():
	Speed = 300
	for i in get_parent().get_children():
		if i.name == "BoomerangBoss":
			Player = i
	await get_tree().create_timer(.02).timeout
	ThrowTween = get_tree().create_tween()
	var realtarget = direction * 700 + position
	var ETA = position.distance_to(realtarget) / Speed
	ThrowTween.tween_property(self,"position",realtarget, ETA).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	await ThrowTween.finished
	Returning = true
	$PathfindTimer.start()
	_on_pathfind_timer_timeout()


func _on_body_entered(body):
	if body.name == "BoomerangBoss":
		if idkwhattocallititmakessureitdoesntinstantlygetdestroyed:
			queue_free()
		else:
			idkwhattocallititmakessureitdoesntinstantlygetdestroyed = true
	elif body.name == "Shield":
		if !Returning:
			Returning = true
			$PathfindTimer.start()
			_on_pathfind_timer_timeout()
			ThrowTween.kill()
