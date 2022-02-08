extends "res://deadable_characters/Characters_script.gd"

signal in_flip
signal change_gun
signal rearm_for_amount
var mouse_is=false
var in_flip=false
var flip_is=true
var flipxm=false
var flipxp=false
var flipym=false
var flipyp=false
var x=1
func _ready():
	$Flip_timer.wait_time=0.5
	$Flip_cooldown.wait_time=1
func control(delta):
	$Mouse_is_in.look_at(get_global_mouse_position())
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	$Mouse.global_position=get_global_mouse_position()
	velocity=Vector2()
	if !in_flip:
		if Input.is_action_pressed("up"):
			velocity.y-=1
			if Input.is_action_just_pressed("flip"):
				flipym=true
				flip()		
		if Input.is_action_pressed("left"):
			velocity.x-=1
			if Input.is_action_just_pressed("flip"):
				flipxm=true
				flip()
		if Input.is_action_pressed("down"):
			velocity.y+=1
			if Input.is_action_just_pressed("flip"):
				flipyp=true
				flip()
		if Input.is_action_pressed("right"):
			velocity.x+=1
			if Input.is_action_just_pressed("flip"):
				flipxp=true
				flip()
		
	else:
		if flipxm:
			velocity.x-=1
		if flipxp:
			velocity.x+=1
		if flipym:
			velocity.y-=1
		if flipyp:
			velocity.y+=1
	velocity=velocity.normalized()*speed
	velocity=move_and_slide(velocity)
	if $Gun.rotation_degrees<=-360:
		$Gun.rotation_degrees=0
		$Mouse_is_in.rotation_degrees=0
	if $Gun.rotation_degrees>=360:
		$Gun.rotation_degrees=0
		$Mouse_is_in.rotation_degrees=0
		
	if mouse_is==false:
		$Mouse_is_in.hide()
		$Mouse.visible=true
		$Gun.look_at($Mouse.global_position)
		Gun_rotation()#Vse chto vise rabotaet NE MENJAT!!!!!!!!!!!!!!!!
	else:
		$Mouse.hide()
		$Mouse_is_in.visible=true
		Gun_rotation()#Vse chto vise rabotaet NE MENJAT!!!!!!!!!!!!!!!!
	if Input.is_action_pressed("click") and Gun_is and !in_flip:
			shoot()
	if Input.is_action_just_pressed("fast_gun_change"):		
		Gun=$Gun.get_child($Gun.get_child_count()-1)
		$Gun.move_child(Gun,1)
		$Gun.get_child(1).visible=false		
		Gun.gun_shot_counter=gun_shot_counter
		Gun.now_rearming=rearming		
		Gun.max_rearm=max_rearm
		Gun.can_rearm=can_rearm
		emit_signal('change_gun')		
		
		$Gun.get_child($Gun.get_child_count()-1).visible=true
		$Gun/Muzle.position=$Gun.get_child($Gun.get_child_count()-1).Muzle_position
		gun_cooldown=$Gun.get_child($Gun.get_child_count()-1).gun_cooldown
		gun_shot_max=$Gun.get_child($Gun.get_child_count()-1).gun_shot_max
		gun_rearm_timer=$Gun.get_child($Gun.get_child_count()-1).gun_rearm_timer
		Bullet=$Gun.get_child($Gun.get_child_count()-1).Bullet
		rnd_rot_fir=$Gun.get_child($Gun.get_child_count()-1).rnd_rot_fir
		rnd_rot_sec=$Gun.get_child($Gun.get_child_count()-1).rnd_rot_sec
		gun_shot_counter=$Gun.get_child($Gun.get_child_count()-1).gun_shot_counter
		Gun_is_for_guns=true
		rearming=$Gun.get_child($Gun.get_child_count()-1).now_rearming
		max_rearm=$Gun.get_child($Gun.get_child_count()-1).max_rearm
		can_rearm=$Gun.get_child($Gun.get_child_count()-1).can_rearm
		emit_signal('rearm_for_amount', rearming)
		if $Gun.get_child($Gun.get_child_count()-1).now_rearming and can_rearm:
			$Gun_rearm.wait_time=gun_rearm_timer
			$Gun_rearm.start()
			emit_signal('rearm',gun_rearm_timer, rearming)
		#elif can_rearm:
			#emit_signal('amount_change',gun_shot_counter*100/gun_shot_max,gun_shot_counter,max_rearm)
		elif !can_rearm:
			gun_shot_counter=0
		emit_signal('amount_change',gun_shot_counter*100/gun_shot_max,gun_shot_counter,max_rearm)
		
		
func _on_No_mouse_area_entered(area):
	if area.name=="Mouse":
		mouse_is=true
func _on_No_mouse_area_exited(area):
	if area.name=="Mouse":
		mouse_is=false

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



func _on_trident_get_gun(gun_path, Muzle_position,from_gun_cooldown,from_gun_shot_max,from_gun_rearm_timer,from_Bullet, from_rnd_rot_fir,from_rnd_rot_sec, from_gun_shot_counter,now_rearming,from_max_rearm,from_can_rearm):
	if Gun_is_for_hand:
		$Gun.get_child(x).hide()
		x+=1
		Gun.gun_shot_counter=gun_shot_counter
		Gun.now_rearming=rearming
		$Gun.get_child($Gun.get_child_count()-1).max_rearm=max_rearm
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
	rearming=now_rearming
	max_rearm=from_max_rearm
	can_rearm=from_can_rearm
	emit_signal('rearm_for_amount', rearming)
	if $Gun.get_child($Gun.get_child_count()-1).now_rearming and can_rearm:
		$Gun_rearm.wait_time=gun_rearm_timer
		$Gun_rearm.start()
		emit_signal('rearm',gun_rearm_timer, rearming)
	elif can_rearm:
		emit_signal('amount_change',gun_shot_counter*100/gun_shot_max,gun_shot_counter,max_rearm)
	emit_signal('change_gun')


func _on_Flip_timer_timeout():
	in_flip=false
	flipxm=false
	flipxp=false
	flipym=false
	flipyp=false
	$Gun.visible=true
	$Flip_timer.stop()
	emit_signal('in_flip',in_flip)


func _on_Flip_cooldown_timeout():
	flip_is=true
	$Flip_cooldown.stop()
	
func flip():
	if flip_is:
		#if flipxp:
		$Flip_animation.play("Flip_animation_x")
		#if flipxm:
		#	$Flip_animation.play_backwards("Flip_animation_x")
		#if flipyp:
		#	$Flip_animation.play_backwards("Flip_animation_y")
		#if flipym:
		#	$Flip_animation.play("Flip_animation_y")
		$Gun.visible=false
		in_flip=true
		$Flip_timer.start()
		$Flip_cooldown.start()
		flip_is=false
		emit_signal('in_flip', in_flip)

