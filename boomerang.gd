extends Area2D



var Player
var Target
var Speed = 800
var Returning = false
var idkwhattocallititmakessureitdoesntinstantlygetdestroyed = false


func _ready():
	await get_tree().create_timer(.02).timeout
	var tween = get_tree().create_tween()
	var ETA = position.distance_to(Target) / Speed
	tween.tween_property(self,"position",Target, ETA).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	await tween.finished
	Returning = true
	$PathfindTimer.start()
	_on_pathfind_timer_timeout()



func _physics_process(delta):
	if Returning == true:
		var direction = to_local($NavigationAgent2D.get_next_path_position()).normalized()
		var NewVelocity = delta * Speed * direction
		position += NewVelocity



func _on_pathfind_timer_timeout():
	$NavigationAgent2D.target_position = Player.position


func _on_body_entered(body):
	if body.name == "Player":
		if idkwhattocallititmakessureitdoesntinstantlygetdestroyed:
			queue_free()
		else:
			idkwhattocallititmakessureitdoesntinstantlygetdestroyed = true
