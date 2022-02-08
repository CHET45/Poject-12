extends Control
var can_rearm_now


func _on_Player_rearm(gun_rearm_timer,rearm):
	can_rearm_now=rearm
	if can_rearm_now:
		if gun_rearm_timer==3:
			$Gun/Animation.play("Animation_for_green")
		elif gun_rearm_timer==6:
			$Gun/Animation.play("Animation_for_red")
		elif gun_rearm_timer==4.5:
			$Gun/Animation.play("Animation_for_black")
	


func _on_Player_change_gun():
	$Gun/Animation.play("Null_animation")
	can_rearm_now=false
