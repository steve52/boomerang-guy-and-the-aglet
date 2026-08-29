extends CharacterBody2D

var Player
var Phase = 1
@export var Health : int
@export var Speed : float
@export var ChargeDistance : float
@export var Phases: int = 1
@export var HealthPerPhase: Array
var is_awake: bool = false

func _ready():
	Player = get_parent().Player

func _physics_process(_delta):
	SpriteDirectionCheck()

func SpriteDirectionCheck():
	pass

func TakeDamage(_Boomerang):
	Health -= 1
	GameManager.PlaySound("EnemyHurt")
	if Health == 0:
		if !CheckForPhaseChanges():
			GameManager.PlaySound("EnemyDeath")
			Die()

func CheckForPhaseChanges():
	if Phase == Phases:
		return false
	else:
		Phase += 1
		Health = HealthPerPhase.get(Phase-1)
		ChangePhase()
		return true

func ChangePhase():
	pass

func Spawn():
	pass

func Die():
	DeathAnimation()
	await DeathAnimation()
	GameManager.EnemyKilled.emit()
	queue_free()

func DeathAnimation():
	return 

func ShootBullets(Bullets,direction,StartPosition = position):
	var bullets = Bullets.instantiate()
	get_parent().add_child(bullets)
	bullets.position = StartPosition
	bullets.direction = direction
	bullets.Shoot()

func BeforeCharge():
	pass

func Charge():
	var tween = get_tree().create_tween()
	var tilt = -15 if Player.position.x < position.x else 15
	tween.tween_property(self, "rotation_degrees", tilt, .2) 
	var TargetPosition = (position.direction_to(Player.position) * ChargeDistance * 100) + position
	var Raycast = RayCast2D.new()
	add_child(Raycast)
	Raycast.target_position = to_local(TargetPosition) 
	Raycast.collision_mask = 8
	Raycast.force_raycast_update()
	if Raycast.is_colliding():
		var WallSpot = Raycast.get_collision_point()
		TargetPosition = WallSpot.direction_to(position) * 32 + WallSpot
	var ETA = position.distance_to(TargetPosition) / (Speed * 1.5)
	var tween2 = get_tree().create_tween()
	tween2.tween_property(self, "position", TargetPosition, ETA).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	DuringCharge(ETA)
	await  tween2.finished
	Raycast.queue_free()
	AfterCharge()

func DuringCharge(_ChargeTime):
	pass

func AfterCharge():
	pass

func BeforeTeleport(Target):
	Teleport(Target)

func Teleport(Target):
	position = Target
	AfterTeleport()

func AfterTeleport():
	pass

func BeforeDash(Target):
	Dash(Target)

func Dash(Target):
	var ETA = position.distance_to(Target) / (Speed)
	var Raycast = RayCast2D.new()
	add_child(Raycast)
	Raycast.target_position = to_local(Target) 
	Raycast.collision_mask = 8
	Raycast.force_raycast_update()
	if Raycast.is_colliding():
		var WallSpot = Raycast.get_collision_point()
		Target = WallSpot.direction_to(position) * 32 + WallSpot
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", Target, ETA).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	DuringDash(ETA)
	Raycast.queue_free()
	await  tween.finished
	AfterDash()

func DuringDash(_DashTime):
	pass

func AfterDash():
	pass
