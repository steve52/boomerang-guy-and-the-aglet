extends Control

func _ready():
	
	$VictorySound.play()
	$DeathLabel.text = "Deaths: " + str(GameManager.Deaths)

func _on_button_pressed():
	GameManager.Restart()
