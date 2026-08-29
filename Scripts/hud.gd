extends CanvasLayer

@export var player: Node


@onready var player_health: Label = $"Control/Player Health"



func _process(_delta: float) -> void:
	if player != null:
		player_health.text = "Player Health: " + str(player.Health)
	else:
		player_health.text = "Player Health: 0"
