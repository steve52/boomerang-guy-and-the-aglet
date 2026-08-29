extends Area2D

func isEnemy(body: Node2D) -> bool:
	return body is EnemySpawnPoint

func _on_body_entered(body: Node2D) -> void:
	if (body.is_in_group("player")):
		var enemy_spawn_points = get_overlapping_areas().filter(isEnemy)
		for spawn_point in enemy_spawn_points:
			spawn_point.spawn()
