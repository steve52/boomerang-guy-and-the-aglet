extends Node

signal EnemyKilled
var game
var Deaths = 0
var SaveSpot

func PlaySound(Sound):
	game.SoundEffect(Sound)

func Save(Room):
	if Room.name != "StartRoom":
		if Room.position != SaveSpot:
			for i in game.get_children():
				if i.name == "HUD":
					i.get_child(0).get_child(0).visible = true
					await get_tree().create_timer(3).timeout
					i.get_child(0).get_child(0).visible = false
			SaveSpot = Room.position
	else:
		if Room.position != SaveSpot:
			SaveSpot = Room.position

func PlayerDeath(Type):
	if Type == 0:
		Deaths += 1
	print(Deaths)
	get_tree().change_scene_to_file("res://Scenes/game.tscn")
	var oldgame = game
	while game == oldgame:
		await get_tree().create_timer(0.05).timeout
	game.Spawn(SaveSpot)
