extends CharacterBody2D

var Player
@export var Health : int
@export var Speed : float
@export var ChargeDistance : float

func _ready():
	Player = get_parent().Player

func TakeDamage(Boomerang):
	Health -= 1
	if Health == 0:
		Die()

func Die():
	DeathAnimation()
	await DeathAnimation()
	queue_free()

func DeathAnimation():
	return 

func ShootBullets(Bullets,direction):
	var bullets = Bullets.instantiate()
	get_parent().add_child(bullets)
	bullets.position = position
	bullets.direction = direction
	bullets.Shoot()

func BeforeCharge():
	Charge()

func Charge():
	var tween = get_tree().create_tween()
	var tilt = -15 if Player.position.x < position.x else 15
	tween.tween_property(self, "rotation_degrees", tilt, .2) 
	var TargetPosition = (position.direction_to(Player.position) * ChargeDistance * 100) + position
	var ETA = position.distance_to(TargetPosition) / (Speed * 1.5)
	var tween2 = get_tree().create_tween()
	tween2.tween_property(self, "position", TargetPosition, ETA).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	await  tween2.finished
	AfterCharge()

func AfterCharge():
	pass

func BeforeTeleport(Target):
	Teleport(Target)

func Teleport(Target):
	position = Target

func AfterTeleport():
	pass

func BeforeDash(Target):
	Dash(Target)

func Dash(Target):
	var ETA = position.distance_to(Target) / (Speed)
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", Target, ETA).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	await  tween.finished
	AfterDash()

func AfterDash():
	pass
