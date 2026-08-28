extends "res://Scripts/EnemyClass.gd"

const EVIL_BOOMERANG = preload("uid://bdgrpn1c2tfya")
const SPIRAL_BULLETS = preload("uid://4uw0s7f2mr7u")

func _physics_process(_delta):
	if Input.is_action_just_pressed("ui_accept"):
		Phase1Spiral()

func Phase1Blast():
	for i in 5:
		for I in 5:
			var BulletDirection = Vector2.from_angle(position.angle_to_point(Player.position) + (I - 2) * deg_to_rad(15))
			ShootBullets(EVIL_BOOMERANG,BulletDirection)

func Phase1Spiral():
	var Direction = randi_range(-1, 1)
	while Direction == 0:
		Direction = randi_range(-1, 1)
	for i in randi_range(20,30):
		for I in 5:
			var BaseBulletDirection = deg_to_rad(72) * I
			for j in 18:
				var BulletDirection = Vector2.from_angle(BaseBulletDirection + deg_to_rad(j*1.5 + (i*8*Direction)))
				ShootBullets(SPIRAL_BULLETS,BulletDirection)
		await get_tree().create_timer(.15).timeout
