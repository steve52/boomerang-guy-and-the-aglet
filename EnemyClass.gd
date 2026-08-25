extends CharacterBody2D

var Player
@export var Health : int
@export var Speed : float
@export var ChargeDistance : float

func _ready():
	Player = get_parent().get_child(0)

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
	bullets.direction = direction
	bullets.Shoot()

func Charge():
	print(Player.position, Player.name)
	var TargetPosition = position.direction_to(Player.position) * ChargeDistance * 100 + position
	print(TargetPosition)
	var ETA = position.distance_to(TargetPosition) / (Speed * 1.5)
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", TargetPosition, ETA).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)

func Teleport(Target):
	position = Target

func Dash(Target):
	var ETA = position.distance_to(Target) / (Speed)
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", Target, ETA).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
