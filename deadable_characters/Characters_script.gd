extends KinematicBody2D

signal shoot
signal health_change
signal dead
signal rearm
signal amount_change

var Gun=null
var Gun_is=false
var Gun_is_for_hand=false
var Gun_is_for_guns=false
var Bullet=null
var shot_notmiss
export (float) var speed
export (float) var rotation_speed
export (int) var max_health
export (float) var gun_position
var gun_cooldown=1
var gun_shot_max=1
var gun_rearm_timer=1
var rnd_rot_fir
var rnd_rot_sec
var gun_shot_counter=1
var max_rearm

var velocity = Vector2()
var alive=true
var can_shoot=true
var can_rearm=true
var health
var rearming=false

var rand=RandomNumberGenerator.new()
func _ready():
	health=max_health
	emit_signal('health_change',health*100/max_health)

func control(delta):
	pass
func shoot():
	if Gun_is_for_guns and !rearming and can_rearm:
		$Gun_rearm.wait_time=gun_rearm_timer
		emit_signal('amount_change',gun_shot_counter*100/gun_shot_max,gun_shot_counter, max_rearm)
		$GunTimer.wait_time=gun_cooldown
		Gun_is_for_guns=false		
	if can_shoot and !rearming and can_rearm:
		rand.randomize()
		var random_rotation=rand.randf_range(rnd_rot_fir,rnd_rot_sec)
		can_shoot=false
		$GunTimer.start()
		var dir
		shot_notmiss=rand.randf_range(-3,3)
		if shot_notmiss<0:
			dir=Vector2(1,0).rotated($Gun.global_rotation+random_rotation)
			shot_notmiss+=1
		else:
			dir=Vector2(1,0).rotated($Gun.global_rotation)
			shot_notmiss-=1
		emit_signal('shoot', Bullet, $Gun/Muzle.global_position, dir)
		gun_shot_counter-=1
		emit_signal('amount_change',gun_shot_counter*100/gun_shot_max,gun_shot_counter, max_rearm)
	elif gun_shot_counter<=0 and can_rearm:
		rearming=true
		if name=='Player':
			if max_rearm<=0:
				can_rearm=false
			else:			
				max_rearm-=gun_shot_max				
				emit_signal('rearm',gun_rearm_timer, rearming)
		$Gun_rearm.start()
		gun_shot_counter=gun_shot_max
	

func _process(delta):
	if not alive:
		return
	else:
		control(delta)

func take_damage(amount):
	health-=amount
	emit_signal('health_change',health*100/max_health)
	if health<=0:		
		alive=false
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		if name=='Player':
			get_tree().change_scene("res://GUI/gameOver.tscn")
		else:
			get_tree().change_scene("res://GUI/Win_scene.tscn")
		hide()
func explode():
	queue_free()

func _on_GunTimer_timeout():
	can_shoot=true
func _on_Gun_rearm_timeout():
	if name=='Player' and can_rearm:
		emit_signal('amount_change',gun_shot_counter*100/gun_shot_max,gun_shot_counter, max_rearm)
	rearming=false
	$Gun_rearm.stop()
