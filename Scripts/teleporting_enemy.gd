extends "res://Scripts/EnemyClass.gd"

var ShotsToTeleport = 2
const TELEPORTING_ENEMY_HELIX_BULLETS = preload("uid://syjmblse5q32")
var Digging = false

func SpriteDirectionCheck():
	if Digging == false:
		$Icon.animation = "Front" if Player.position.y > position.y else "Back"

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
			$TeleportCheck.force_raycast_update()
			if $TeleportCheck.is_colliding() == false:
				BeforeTeleport(TeleportTarget + position)
				GoodTeleport = true
		
		ShotsToTeleport = 2

func BeforeTeleport(Target):
	Digging = true
	$Icon.animation = "Digging"
	$CollisionShape2D.disabled = true
	$Area2D/CollisionShape2D.disabled = true
	$HelixShotTimer.paused = true
	Teleport(Target)

func AfterTeleport():
	await get_tree().create_timer(1).timeout
	$HelixShotTimer.paused = false
	$CollisionShape2D.disabled = false
	$Area2D/CollisionShape2D.disabled = false
	Digging = false
