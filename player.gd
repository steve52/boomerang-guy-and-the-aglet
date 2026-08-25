extends CharacterBody2D

@export var Speed = 20
const BOOMERANG = preload("uid://bgv7yok8kgxfo")
var Walking = false
var Rotate = 0

func _physics_process(delta):
	
	if Input.is_action_pressed("Down"):
		velocity.y = Speed * delta * 1000
		$AnimatedSprite2D.animation = "Front"
	elif Input.is_action_pressed("Up"):
		velocity.y = -Speed * delta * 1000
		$AnimatedSprite2D.animation = "Back"
	else:
		velocity.y = 0
	if Input.is_action_pressed("Left"):
		velocity.x = -Speed * delta * 1000
	elif Input.is_action_pressed("Right"):
		velocity.x = Speed * delta * 1000
	else:
		velocity.x = 0
	
	if velocity != Vector2(0,0):
		Walking = true
	else:
		Walking = false
	
	if Walking:
		if Rotate == 0:
			rotation_degrees += 2
			if rotation_degrees >= 15:
				Rotate = 1
		else:
			rotation_degrees -= 2
			if rotation_degrees <= -15:
				Rotate = 0
	
	if Input.is_action_just_pressed("Attack"):
		Attack()
	
	
	move_and_slide()

func Attack():
	var Boomerang = BOOMERANG.instantiate()
	get_parent().add_child(Boomerang)
	Boomerang.position = position
	Boomerang.Target = get_global_mouse_position()
	Boomerang.Player = self
