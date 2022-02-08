extends Control

var Pause=false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	if Input.is_action_just_pressed("pause"):
		if !Pause:
			get_tree().paused=true
			Pause=true
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			visible=true
		else:
			get_tree().paused=false
			Pause=false			
			Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
			visible=false
	



func _on_StartButton_pressed():
	get_tree().paused=false
	Pause=false
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	visible=false
