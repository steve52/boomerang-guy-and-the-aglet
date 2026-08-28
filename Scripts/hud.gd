extends CanvasLayer

@export var player: Node
@export var enemy: Node

@onready var player_health: Label = $"Control/Player Health"
@onready var enemy_health: Label = $"Control/Enemy Health"


func _process(delta: float) -> void:
	player_health.text = "Player Health: " + str(player.Health)
	enemy_health.text = "Enemy Health: " + str(enemy.Health)
	
