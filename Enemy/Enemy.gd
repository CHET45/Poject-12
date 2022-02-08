extends "res://deadable_characters/Characters_script.gd"

onready var parent=get_parent()
export (int) var detect_radius
var see_player=false
func _ready():
	var circle=CircleShape2D.new()
	$DetectRadius/CollisionShape2D.shape=circle
	$DetectRadius/CollisionShape2D.shape.radius=detect_radius
var target=null
var alie=true

func control(delta):
	if parent is PathFollow2D:
		parent.set_offset(parent.get_offset()+speed*delta)
		position=Vector2()
	else:
		#other movement
		pass
	if target:
		var target_dir=(target.global_position-$Gun.global_position).normalized()
		var current_dir=Vector2(1,0).rotated($Gun.global_rotation)
		$Gun.global_rotation=current_dir.linear_interpolate(target_dir,rotation_speed*delta).angle()
		Gun_rotation()
		if target_dir.dot(current_dir)>0.9 and Gun_is and see_player:
			shoot()

func _on_DetectRadius_body_entered(body):
	if body.name=="Player":
		target=body


func _on_DetectRadius_body_exited(body):
	if body == target:
		target=null


func Gun_rotation():
	if $Gun.rotation_degrees>=120:
		if $Gun.rotation_degrees<250:
			if $body.flip_h==false:
				$body.flip_h=true
				$Gun.position.x=-gun_position
		if $Gun.rotation_degrees>295:
			if $body.flip_h==true:
				$body.flip_h=false
				$Gun.position.x=gun_position
	if $Gun.rotation_degrees<=69:
		if $Gun.rotation_degrees>-69:
			if $body.flip_h==true:
				$body.flip_h=false
				$Gun.position.x=gun_position
		if $Gun.rotation_degrees<-120:
			if $Gun.rotation_degrees>-250:
				if $body.flip_h==false:
					$body.flip_h=true
					$Gun.position.x=-gun_position
			if $Gun.rotation_degrees<-295:
				if $body.flip_h==true:
					$body.flip_h=false
					$Gun.position.x=gun_position


func _on_trident_get_enemy_gun(gun_path,Muzle_position,from_gun_cooldown,from_gun_shot_max,from_gun_rearm_timer,from_Bullet,from_rnd_rot_fir,from_rnd_rot_sec, from_gun_shot_counter):
	if Gun_is_for_hand:
		$Gun.get_child(1).queue_free()
	Gun=load(gun_path).instance()
	$Gun.add_child(Gun)
	$Gun/Muzle.position=Muzle_position
	Gun_is=true
	Gun_is_for_guns=true
	gun_cooldown=from_gun_cooldown
	gun_shot_max=from_gun_shot_max
	gun_rearm_timer=from_gun_rearm_timer
	Bullet=from_Bullet
	rnd_rot_fir=from_rnd_rot_fir
	rnd_rot_sec=from_rnd_rot_sec
	gun_shot_counter=from_gun_shot_counter
	Gun_is_for_hand=true
	




func _on_Game_Fight_start():
	see_player=true
