extends "res://Scripts/EnemyClass.gd"

const CHARGING_ENEMY_BULLETS = preload("uid://ctd6ht4ofjbmv")

func _ready():
	super()
	$ChargeTimer.start(3+randf_range(-1,1))

func SpriteDirectionCheck():
	$Icon.flip_h = true if Player.position.x > position.x else false

func BeforeCharge():
	var tween = get_tree().create_tween()
	var tilt = -15 if Player.position.x > position.x else 15
	tween.tween_property(self, "rotation_degrees", tilt, .5) 
	await get_tree().create_timer(.6).timeout
	for i in 8:
		var BulletDirection = Vector2.from_angle(deg_to_rad(i*45))
		ShootBullets(CHARGING_ENEMY_BULLETS, BulletDirection)
	Charge()

func  AfterCharge():
	for i in 8:
		var BulletDirection = Vector2.from_angle(deg_to_rad(i*45))
		ShootBullets(CHARGING_ENEMY_BULLETS, BulletDirection)
	$ChargeTimer.start(3+randf_range(-1,1))
	var tween = get_tree().create_tween()
	tween.tween_property(self, "rotation_degrees", 0, .2)
