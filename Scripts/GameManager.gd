extends Node

signal EnemyKilled
var game
var Deaths = 0
func PlaySound(Sound):
	game.SoundEffect(Sound)

func PlayerDeath():
	Deaths += 1
	get_tree().change_scene_to_file("res://Scenes/game.tscn")
