extends "res://Scripts/bulletbase.gd"



func _physics_process(delta):
	super(delta)
	for i in $Path2D.get_children():
		i.progress_ratio += .03 if i.name == "Helix1" else -.03
