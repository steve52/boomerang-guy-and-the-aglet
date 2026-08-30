extends "res://Scripts/EnemyClass.gd"

const BOOMERANG_BARRAGE_BULLETS = preload("uid://cetwb6sf7xe2p")
const EVIL_BOOMERANG_BARRAGE = preload("uid://dnilkgsdfk1pi")
const PHASE_2_SHOTGUN_BULLETS = preload("uid://dp0tqbr4vdtpi")
const EVIL_BOOMERANG = preload("uid://bdgrpn1c2tfya")
const SPIRAL_BULLETS = preload("uid://4uw0s7f2mr7u")
const PHASE_1_WAVY_BULLETS = preload("uid://duoawnfml3wx1")
var Phase1Pattern = [0,randi_range(0,1), 1, randi_range(0,1) ,1, randi_range(0,1)]
var Phase2Pattern = [0, randi_range(1,2), 0, randi_range(1,2)]
var AttackNumber = 0

func _ready():
	super()
	if !GameManager.BoomerangBossAttempted:
		DialogueManager.start_dialogue("boomerang_boss_start")
	GameManager.BoomerangBossAttempted = true
	$AttackTimer.start(2 + randf_range(-.5,.5))

func DeathAnimation():
	DialogueManager.start_dialogue("boomerang_boss_end")
	return

func SpriteDirectionCheck():
	$Icon.animation = "Back" if position.y > Player.position.y else "Front"

func ChangePhase():
	$AttackTimer.paused = true
	if !GameManager.BoomerangBossPhase2Attempted:
		DialogueManager.start_dialogue("boomerang_boss_phase_2")
	else:
		DialogueManager.start_dialogue("boomerang_boss_phase_2_attempted")
	GameManager.BoomerangBossPhase2Attempted = true
	var tween = get_tree().create_tween()
	tween.tween_property(self,"global_scale", Vector2(1.5,1.5), .4).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_LINEAR)
	await tween.finished
	var tween2 = get_tree().create_tween()
	tween2.tween_property(self,"scale", Vector2(1,1), .4).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_LINEAR)
	$AttackTimer.paused = false
	AttackNumber = 0

func Attack():
	if Phase == 1:
		if Phase1Pattern.get(AttackNumber) == 0:
			Phase1Blast()
		elif Phase1Pattern.get(AttackNumber) == 1:
			Phase1Wavy()
		AttackNumber = 0 if AttackNumber == Phase1Pattern.size() - 1 else AttackNumber + 1 
		if AttackNumber == 0:
			Phase1Pattern = [0,randi_range(0,1), 1, randi_range(0,1) ,1, randi_range(0,1)]
	if Phase == 2:
		if Phase2Pattern.get(AttackNumber) == 0:
			Phase2Blast()
		elif Phase2Pattern.get(AttackNumber) == 1:
			Phase2BoomerangBarrage()
		else: 
			Phase2Spiral()
		AttackNumber = 0 if AttackNumber == Phase2Pattern.size() - 1 else AttackNumber + 1 
		if AttackNumber == 0:
			Phase2Pattern = [0, randi_range(1,2), 0, randi_range(0,2)]

func Phase1Blast():
	for i in 5:
		var BulletDirection = Vector2.from_angle(position.angle_to_point(Player.position) + (i - 2) * deg_to_rad(15))
		ShootBullets(EVIL_BOOMERANG,BulletDirection)
	$AttackTimer.start(2 + randf_range(-.3,.5))

func Phase2Blast():
	for i in 5:
		for I in 5:
			var BoomerangDirection = Vector2.from_angle(position.angle_to_point(Player.position) + (I - 2) * deg_to_rad(15))
			ShootBullets(EVIL_BOOMERANG,BoomerangDirection)
		await get_tree().create_timer(.7).timeout
	$AttackTimer.start(2 + randf_range(-.2,.5))

func Phase2Spiral():
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
	$AttackTimer.start(4 + randf_range(-.6,.6))

func Phase1Wavy():
	for i in randi_range(7,10):
		var BulletDirection = Vector2.from_angle(position.angle_to_point(Player.position) + deg_to_rad(randi_range(-12,12)))
		ShootBullets(PHASE_1_WAVY_BULLETS,BulletDirection)
		for I in 42:
			var BulletDirection2 = Vector2.from_angle(position.angle_to_point(Player.position) + deg_to_rad(I*-3 - 30))
			ShootBullets(SPIRAL_BULLETS,BulletDirection2)
		for I in 42:
			var BulletDirection2 = Vector2.from_angle(position.angle_to_point(Player.position) + deg_to_rad(I*3 + 30))
			ShootBullets(SPIRAL_BULLETS,BulletDirection2)
		await get_tree().create_timer(.2).timeout
	$AttackTimer.start(2.1 + randf_range(-.4,.4))

func Phase2BoomerangBarrage():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "rotation_degrees", 180, .5).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	await tween.finished
	var tween2 = get_tree().create_tween()
	tween2.tween_property(self, "rotation_degrees", 360, .5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	for i in 7:
		var Boomerang = EVIL_BOOMERANG_BARRAGE.instantiate()
		var direction = Vector2.from_angle(randf_range(-1*PI,PI))
		var StartPosition = position
		get_parent().add_child(Boomerang)
		Boomerang.position = StartPosition
		Boomerang.direction = direction
		Boomerang.Shoot()
		BoomerangRing(Boomerang)
		await get_tree().create_timer(.4).timeout
	await get_tree().create_timer(5).timeout
	$AttackTimer.start(3 + randf_range(-.3,.7))


func BoomerangRing(Boomerang):
	await Boomerang.TweenFinished
	var Rotation = randf_range(3, 18)
	for i in 2:
		for I in 12:
			var direction = Vector2.from_angle(deg_to_rad(I*36+Rotation*i))
			ShootBullets(BOOMERANG_BARRAGE_BULLETS,direction,Boomerang.position)
		await get_tree().create_timer(.5).timeout
	Boomerang.Returning = true
