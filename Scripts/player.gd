extends CharacterBody2D

@export var Health = 3
@export var BaseSpeed = 20
var Speed = 20
const BOOMERANG = preload("uid://bgv7yok8kgxfo")
var BoomerangsOut = 0
var Walking = false
var Rotate = 0
var IFrames = false
var AttackCooldown = false

func _physics_process(delta):
	
	if Input.is_action_just_pressed("Lol"):
		Health = 1
		GameManager.PlaySound("Death")
		GameManager.PlayerDeath(1)
	
	if Input.is_action_pressed("Sprint"):
		Speed = BaseSpeed* 1.5
	else:
		Speed = BaseSpeed
	
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
	
	if Input.is_action_pressed("Attack"):
		if !AttackCooldown:
			Attack()
			AttackCooldown = true
			await get_tree().create_timer(.1).timeout
			AttackCooldown = false
	
	move_and_slide()

func Attack():
	if BoomerangsOut != 3:
		GameManager.PlaySound("Shoot")
		BoomerangsOut += 1
		var Boomerang = BOOMERANG.instantiate()
		get_parent().add_child(Boomerang)
		Boomerang.position = position
		Boomerang.Target = get_global_mouse_position()
		Boomerang.Player = self


func Hit(_HitBy):
	if !IFrames:
		GameManager.PlaySound("Hurt")
		Health -= 1
		IFrames = true
		if Health == 0:
			GameManager.PlaySound("Death")
			GameManager.PlayerDeath(0)
			self.visible = false
		else:
			await get_tree().create_timer(.5).timeout
			IFrames = false
