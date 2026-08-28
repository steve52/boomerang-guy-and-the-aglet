extends CanvasLayer

const FILE_PATH: String = "res://dialogue.json"

@onready var dialogue_box: Control = $DialogueBox
@onready var dialogue_text: Label = $DialogueBox/DialogueText

var dialogue_lines: Array = []
var current_line_index: int = 0
var is_dialogue_active: bool = false
var dialogue = {}


func _ready() -> void:
	
	dialogue = load_dialogue_file(FILE_PATH)
	
	if dialogue:
		dialogue_box.visible = false
	
func start_dialogue(dialogue_section: String):
	get_tree().paused = true
	
	dialogue_lines = dialogue[dialogue_section]
	
	current_line_index = 0
	is_dialogue_active = true
	dialogue_box.visible = true
	var obj = dialogue_lines[current_line_index]
	dialogue_text.text = obj["speaker"] + ": " + obj["text"]
	
func _input(event):
	if not is_dialogue_active:
		return
	
	if event.is_action_pressed("ui_accept"):
		advance_dialogue()
	
func advance_dialogue():
	if current_line_index < dialogue_lines.size() - 1:
		current_line_index += 1
		var obj = dialogue_lines[current_line_index]
		dialogue_text.text = obj["speaker"] + ": " + obj["text"]
	else:
		get_tree().paused = false
		is_dialogue_active = false
		dialogue_box.visible = false



func load_dialogue_file(path: String) -> Variant:
	# Verify that the file actually exists
	if not FileAccess.file_exists(path):
		print("Error: Dialogue file not found at " + path)
		return null
	
	# Open the file in read mode
	var file = FileAccess.open(path, FileAccess.READ)
	if not file:
		print("Error: Could not open file.")
		return null
		
	# Read the text contents
	var json_string = file.get_as_text()
	file.close() # Always close the file handle
	
	# Parse the JSON string into Godot arrays/dictionaries
	var data = JSON.parse_string(json_string)
	
	if data == null:
		print("Error: Failed to parse JSON. Check for formatting errors.")
		return null
		
	return data
