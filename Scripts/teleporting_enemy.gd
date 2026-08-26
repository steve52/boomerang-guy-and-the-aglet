extends "res://Scripts/EnemyClass.gd"

var ShotsToTeleport = 2
const TELEPORTING_ENEMY_HELIX_BULLETS = preload("uid://syjmblse5q32")




func _on_helix_shot_timer_timeout():
	var Target = position.direction_to(Player.position)
	for i in 3:
		await get_tree().create_timer(.2).timeout
		ShootBullets(TELEPORTING_ENEMY_HELIX_BULLETS, Target)
	$HelixShotTimer.start(1.5+randf_range(-.5,.5))
	ShotsToTeleport -= 1
	if ShotsToTeleport == 0:
		var GoodTeleport = false
		var TeleportTarget: Vector2
		while !GoodTeleport:
			TeleportTarget = Vector2(randf_range(-320,320),randf_range(-320,320))
			$TeleportCheck.target_position = TeleportTarget
			print("yay")
			$TeleportCheck.force_raycast_update()
			if $TeleportCheck.is_colliding() == false:
				Teleport(TeleportTarget + position)
				print("YAY")
				GoodTeleport = true
		
		ShotsToTeleport = 2
