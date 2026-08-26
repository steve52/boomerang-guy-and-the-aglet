extends "res://Scripts/EnemyClass.gd"

func _physics_process(delta):
	super(delta)
	MoveShield()

func MoveShield():
	$ShieldPivot.look_at(Player.position)
