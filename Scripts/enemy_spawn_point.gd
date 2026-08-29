extends Node2D

class_name EnemySpawnPoint

@export_enum("teleporting", "charging", "shield_boss", "boomerang_boss") var enemy_type: String = "charging"


const BOOMERANG_BOSS_SCENE =preload("res://Scenes/Enemies/BoomerangBoss.tscn")
const CHARGING_ENEMY_SCENE =preload("res://Scenes/Enemies/ChargingEnemy.tscn")
const SHIELD_BOSS_SCENE =preload("res://Scenes/Enemies/ShieldBoss.tscn")
const TELEPORTINIG_ENEMY_SCENE =preload("res://Scenes/Enemies/TeleportingEnemy.tscn")
const ENEMY_WARNING = preload("res://Scenes/Enemies/enemy_warning.tscn")



func spawn():
	var enemy
	match enemy_type:
		"teleporting":
			var EnemyWarning = ENEMY_WARNING.instantiate()
			EnemyWarning.global_position = global_position
			get_tree().current_scene.add_child.call_deferred(EnemyWarning)
			await get_tree().create_timer(1).timeout
			EnemyWarning.queue_free()
			enemy = TELEPORTINIG_ENEMY_SCENE.instantiate()
		"charging":
			var EnemyWarning = ENEMY_WARNING.instantiate()
			EnemyWarning.global_position = global_position
			get_tree().current_scene.add_child.call_deferred(EnemyWarning)
			await get_tree().create_timer(1).timeout
			EnemyWarning.queue_free()
			enemy = CHARGING_ENEMY_SCENE.instantiate()
		"shield_boss":
			enemy = SHIELD_BOSS_SCENE.instantiate()
		"boomerang_boss":
			enemy = BOOMERANG_BOSS_SCENE.instantiate()
	enemy.global_position = global_position
	get_tree().current_scene.add_child.call_deferred(enemy)
