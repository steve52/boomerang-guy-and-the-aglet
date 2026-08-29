extends "res://Scripts/EnemyClass.gd"

const SHIELD_BLAST_BULLETS = preload("uid://bd27vlnwpbjmr")
const DASH_BARRAGE_BULLETS = preload("uid://hodgh4fecxs")
const PHASE_1_CHARGE_RING_BULLETS = preload("uid://hgdiqcdafapu")
var Phase1Pattern = [1,0,randi_range(0,1)]
var Phase2Pattern = [1, randi_range(0,1), 0, 2, randi_range(0,1)]
var AttackNumber = 0
signal Phase2ChargeDone
signal DashFinish

func _ready():
	super()
	$AttackCooldown.start(3 + randf_range(-.5,.5))

func _physics_process(delta):
	super(delta)
	MoveShield()
	if Input.is_action_just_pressed("ui_accept"):
		ShieldBlast()

func MoveShield():
	if Phase == 1:
		$ShieldPivot.look_at(Player.position)

func ChangePhase():
	print("Phase: " + str(Phase))
	if (Phase == 2):
		DialogueManager.start_dialogue("shield_boss_phase_2")
	$ShieldPivot.queue_free()
	AttackNumber = 0

func Attack():
	if Phase == 1:
		if Phase1Pattern.get(AttackNumber) == 0:
			BeforeCharge()
		else:
			ShieldBlast()
		AttackNumber = 0 if AttackNumber == Phase1Pattern.size() - 1 else AttackNumber + 1 
		if AttackNumber == 0:
			Phase1Pattern = [1,0,randi_range(0,1)]
	if Phase == 2:
		if Phase2Pattern.get(AttackNumber) == 0:
			BeforeCharge()
		elif Phase2Pattern.get(AttackNumber) == 1:
			DashBarrage()
		else:
			RingsAttack()
		AttackNumber = 0 if AttackNumber == Phase2Pattern.size() - 1 else AttackNumber + 1 
		if AttackNumber == 0:
			Phase2Pattern = [1, randi_range(0,1), randi_range(1,2), 1, 2, randi_range(0,2)]

func BeforeCharge():
	var tween = get_tree().create_tween()
	var tilt = -15 if Player.position.x > position.x else 15
	tween.tween_property(self, "rotation_degrees", tilt, .5) 
	await get_tree().create_timer(.7).timeout
	if Phase == 1:
		BeforePhase1Charge()
	else:
		BeforePhase2Charge()

func BeforePhase1Charge():
	if Phase != 1:
		$AttackCooldown.start(3 + randf_range(-.5,.5))
		pass
	for i in 16:
		var BulletDirection = Vector2.from_angle(deg_to_rad(i*22.5))
		ShootBullets(PHASE_1_CHARGE_RING_BULLETS, BulletDirection, position)
	await get_tree().create_timer(.2).timeout
	if Phase != 1:
		$AttackCooldown.start(3 + randf_range(-.5,.5))
		pass
	for i in 16:
		var BulletDirection = Vector2.from_angle(deg_to_rad(i*22.5 + 11.25))
		ShootBullets(PHASE_1_CHARGE_RING_BULLETS, BulletDirection, position)
	if Phase == 1:
		Charge()
	else:
		$AttackCooldown.start(3 + randf_range(-.5,.5))

func BeforePhase2Charge():
	for i in 2:
		Charge()
		await Phase2ChargeDone
	$AttackCooldown.start(3.5 + randf_range(-.5,.5))

func DuringCharge(ChargeTime):
	if Phase == 1:
		DuringPhase1Charge(ChargeTime)
	else:
		$AttackCooldown.start(3 + randf_range(-.5,.5))

func DuringPhase1Charge(ChargeTime):
	var TimeToShoot = ChargeTime/2
	await get_tree().create_timer(TimeToShoot).timeout
	for I in 32:
		var BulletDirection = Vector2.from_angle(deg_to_rad(I*11.25))
		ShootBullets(PHASE_1_CHARGE_RING_BULLETS, BulletDirection, position)

func AfterCharge():
	if Phase == 1:
		AfterPhase1Charge()
	else:
		AfterPhase2Charge()

func AfterPhase1Charge():
	if Phase != 1:
		$AttackCooldown.start(3 + randf_range(-.5,.5))
		pass
	for i in 16:
		var BulletDirection = Vector2.from_angle(deg_to_rad(i*22.5))
		ShootBullets(PHASE_1_CHARGE_RING_BULLETS, BulletDirection, position)
	for i in 16:
		var BulletDirection = Vector2.from_angle(deg_to_rad(i*22.5 + 11.25))
		ShootBullets(PHASE_1_CHARGE_RING_BULLETS, BulletDirection, position)
	var tween = get_tree().create_tween()
	tween.tween_property(self, "rotation_degrees", 0, .2)
	$AttackCooldown.start(3 + randf_range(-.4,.4))

func AfterPhase2Charge():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "rotation_degrees", 0, .2)
	for i in 4:
		await get_tree().create_timer(.3).timeout
		for I in 36:
			var BulletDirection = Vector2.from_angle(deg_to_rad(I*10 + i*2))
			ShootBullets(PHASE_1_CHARGE_RING_BULLETS, BulletDirection, position)
	Phase2ChargeDone.emit()

func ShieldBlast():
	for i in 8:
		await get_tree().create_timer(.4).timeout
		for I in 17:
			if Phase == 1:
				
				var BulletDirection = Vector2.from_angle(position.angle_to_point(Player.position) + (I - 8) * deg_to_rad(3))
				ShootBullets(SHIELD_BLAST_BULLETS,BulletDirection,$ShieldPivot/Shield.global_position)
	$AttackCooldown.start(2 + randf_range(-.2,.2))

func RingsAttack():
	for i in 4:
		await get_tree().create_timer(.8).timeout
		var SafeSpot = randi_range(31,40)
		var SafeSpots = [SafeSpot,SafeSpot+1,SafeSpot-1]
		for I in 71:
			if !SafeSpots.has(I):
				var BulletDirection = Vector2.from_angle(position.angle_to_point(Player.position) + (I - 35) * deg_to_rad(3))
				ShootBullets(SHIELD_BLAST_BULLETS,BulletDirection,position)
	$AttackCooldown.start(3.3 + randf_range(-.53,.8))

func DashBarrage():
	var Direction = [Vector2.from_angle(position.direction_to(Player.position).angle() + PI/2), Vector2.from_angle(position.direction_to(Player.position).angle() - PI/2)] 
	var Position1 = Direction[0] * 160 + position
	var Position2 = Direction[1] * 160 + position
	Dash(Position2)
	await DashFinish
	await get_tree().create_timer(.2).timeout
	Dash(Position1)
	await DashFinish
	await get_tree().create_timer(.2).timeout
	Dash(Position2)
	await DashFinish
	await get_tree().create_timer(.2).timeout
	Dash(Position1)
	await DashFinish
	await get_tree().create_timer(.2).timeout
	Dash(Position2)
	await DashFinish
	$AttackCooldown.start(2 + randf_range(-.4,.4))

func DuringDash(DashTime):
	var TimeToShoot = DashTime/20
	for i in 20:
		await get_tree().create_timer(TimeToShoot).timeout
		if i != 20:
			var BulletDirection = position.direction_to(Player.position)
			ShootBullets(DASH_BARRAGE_BULLETS,BulletDirection, position)


func AfterDash():
	DashFinish.emit()
