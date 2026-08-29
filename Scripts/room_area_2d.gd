extends Area2D

@export var Door: TileMapLayer
var EnemyCount = 0
var ActiveRoom = false

func _ready():
	GameManager.EnemyKilled.connect(EnemyDeath)

func EnemyDeath():
	if ActiveRoom:
		EnemyCount-= 1
		if EnemyCount == 0:
			ActiveRoom = false
			Door.enabled = false

func isEnemy(body: Node2D) -> bool:
	return body is EnemySpawnPoint

func _on_body_entered(body: Node2D) -> void:
	if (body.is_in_group("player")):
		Door.enabled = true
		ActiveRoom = true
		var enemy_spawn_points = get_overlapping_areas().filter(isEnemy)
		for spawn_point in enemy_spawn_points:
			EnemyCount += 1
			spawn_point.spawn()
