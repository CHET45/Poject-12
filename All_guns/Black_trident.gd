extends Node2D
signal get_gun
signal get_enemy_gun
var Muzle_position
var gun_shot_counter
var now_rearming=false
var can_rearm=true
export (float) var gun_cooldown
export (int) var gun_shot_max
export (float) var gun_rearm_timer
export (PackedScene) var Bullet
export (float) var rnd_rot_fir
export (float) var rnd_rot_sec
export (int) var max_rearm
func _ready():	
	gun_shot_counter=gun_shot_max
	Muzle_position=$Muzle.position
func get_gun():
	queue_free()
	emit_signal('get_gun',"res://All_guns/Black_trident.tscn",Muzle_position, gun_cooldown, gun_shot_max, gun_rearm_timer, Bullet,rnd_rot_fir,rnd_rot_sec,gun_shot_counter,now_rearming,max_rearm, can_rearm)
func get_enemy_gun():
	queue_free()
	emit_signal('get_enemy_gun',"res://All_guns/Black_trident.tscn", Muzle_position, gun_cooldown, gun_shot_max, gun_rearm_timer, Bullet,rnd_rot_fir,rnd_rot_sec,gun_shot_counter)
