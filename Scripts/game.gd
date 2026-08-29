extends Node2D

@export var Player: Node

func _ready():
	GameManager.game = self

func Spawn(Spot):
	$Player.position = Spot
	

func SoundEffect(Sound):
	if Sound == "Hurt":
		$Audio/HurtSound.play()
	if Sound == "Death":
		$Audio/DeathSound.play()
	if Sound == "Shoot":
		$Audio/ShootSound.play()
	if Sound == "Shield":
		$Audio/ShieldBlockSound.play()
	if Sound == "EnemyHurt":
		$Audio/EnemyHurtSound.play()
	if Sound == "EnemyDeath":
		$Audio/EnemyDeathSound.play()
