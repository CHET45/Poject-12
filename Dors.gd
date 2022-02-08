extends Node2D
func _process(delta):
	$Dor_animation.play("Dors_animation")
func _on_Dors_area_body_entered():
	#if Input.is_action_just_pressed("use"):
	$Dor_animation.play("Dors_animation")
