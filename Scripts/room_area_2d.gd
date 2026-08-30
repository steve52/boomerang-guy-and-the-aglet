extends Area2D

@export var ExitDoor: TileMapLayer
@export var Door: TileMapLayer
@export var SaveRoom = false
@export var RoomType: String
var EnemyCount = 0
var ActiveRoom = false
var RoomUsed = false


func _ready():
	GameManager.EnemyKilled.connect(EnemyDeath)

func EnemyDeath():
	if ActiveRoom:
		EnemyCount-= 1
		if EnemyCount == 0:
			if ExitDoor != null:
				ExitDoor.enabled = false
			ActiveRoom = false
			RoomUsed = true
			Door.enabled = false

func isEnemy(body: Node2D) -> bool:
	return body is EnemySpawnPoint

func _on_body_entered(body: Node2D) -> void:
	if (body.is_in_group("player")) and !RoomUsed:
		GameManager.PlaySound(RoomType)
		if Door != null:
			Door.enabled = true
		if SaveRoom:
			await get_tree().create_timer(.05).timeout
			GameManager.Save(self)
		else:
			ActiveRoom = true
			var enemy_spawn_points = get_overlapping_areas().filter(isEnemy)
			for spawn_point in enemy_spawn_points:
				EnemyCount += 1
				spawn_point.spawn()
