extends Area2D

@export var Speed: int
var direction
var Shot = false

func Shoot():
	Shot = true

func _physics_process(delta):
	if Shot:
		var velocity = direction * Speed * delta
		position += velocity
