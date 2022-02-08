extends ColorRect


func _ready():
	$AnimationPlayer.play("RESET")
func _process(delta):
	if $AnimationPlayer.current_animation_position==1:
		visible=false

