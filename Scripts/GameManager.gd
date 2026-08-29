extends Node

signal EnemyKilled
var game
var Deaths = 0
var SaveSpot

func PlaySound(Sound):
	game.SoundEffect(Sound)

func PlayerDeath():
	
	Deaths += 1
	get_tree().change_scene_to_file("res://Scenes/game.tscn")
	var oldgame = game
	while game == oldgame:
		await get_tree().create_timer(0.05).timeout
	game.Spawn(SaveSpot)
