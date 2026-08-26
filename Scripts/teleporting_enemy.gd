extends "res://Scripts/EnemyClass.gd"

var ShotsToTeleport = 3
const TELEPORTING_ENEMY_HELIX_BULLETS = preload("uid://syjmblse5q32")




func _on_helix_shot_timer_timeout():
	var Target = position.direction_to(Player.position)
	for i in 3:
		await get_tree().create_timer(.2).timeout
		ShootBullets(TELEPORTING_ENEMY_HELIX_BULLETS, Target)
	$HelixShotTimer.start(1.5+randf_range(-.5,.5))
