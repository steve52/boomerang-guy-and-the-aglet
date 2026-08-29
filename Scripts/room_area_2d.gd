extends Area2D

func isEnemy(body: Node2D) -> bool:
	return body.is_in_group("enemies")

func _on_body_entered(body: Node2D) -> void:
	if (body.is_in_group("player")):
		var enemies = get_overlapping_bodies().filter(isEnemy)
		print('~~~', enemies)
		for enemy in enemies:
			print('~~~', enemy)
			enemy.wakeUp()
