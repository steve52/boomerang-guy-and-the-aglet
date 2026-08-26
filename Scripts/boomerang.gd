extends Area2D


var Player
var Target
var Speed = 800
var Returning = false
var idkwhattocallititmakessureitdoesntinstantlygetdestroyed = false
var ThrowTween 

func _ready():
	await get_tree().create_timer(.02).timeout
	ThrowTween = get_tree().create_tween()
	var realtarget = position.direction_to(Target) * 700 + position
	var ETA = position.distance_to(realtarget) / Speed
	ThrowTween.tween_property(self,"position",realtarget, ETA).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	await ThrowTween.finished
	Returning = true
	$PathfindTimer.start()
	_on_pathfind_timer_timeout()



func _physics_process(delta):
	if Returning == true:
		var direction = to_local($NavigationAgent2D.get_next_path_position()).normalized()
		var NewVelocity = delta * Speed * direction
		position += NewVelocity
	$Icon.rotation_degrees += 15



func _on_pathfind_timer_timeout():
	$NavigationAgent2D.target_position = Player.position


func _on_body_entered(body):
	if body.name == "Player":
		if idkwhattocallititmakessureitdoesntinstantlygetdestroyed:
			body.BoomerangsOut -= 1
			queue_free()
		else:
			idkwhattocallititmakessureitdoesntinstantlygetdestroyed = true
	elif body.name == "Shield":
		print("a")
		if !Returning:
			print("b")
			ThrowTween.kill()
