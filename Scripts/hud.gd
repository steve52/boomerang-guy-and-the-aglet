extends CanvasLayer

@export var player: Node
@export var enemy: Node

@onready var player_health: Label = $"Control/Player Health"
@onready var enemy_health: Label = $"Control/Enemy Health"


func _process(delta: float) -> void:
	if player != null:
		player_health.text = "Player Health: " + str(player.Health)
	else:
		player_health.text = "Player Health: 0"
	if enemy != null:
		enemy_health.text = "Enemy Health: " + str(enemy.Health)
	else:
		enemy_health.text = "Enemy Health: 0"
	
