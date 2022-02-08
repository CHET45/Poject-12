extends Area2D

signal used

export (PackedScene) var Bullet
export (float) var gun_cooldown
export (int) var gun_shot_max
export (float) var gun_rearm_timer
export var on_player=''
export var on_enemy=''
var body_in=false
onready var parent=$'../'

func _process(delta):
	if body_in:
		if Input.is_action_pressed("use"):
			body_in=true
			if on_player:
				if parent.has_method(on_player):
					parent.call(on_player)

func _on_Gun_area_body_entered(body):
	if body.name=='Player':
		body_in=true
		if Input.is_action_pressed("use") and body_in:
			if on_player:
				if parent.has_method(on_player):
					parent.call(on_player)
					body_in=false
	else:
		if parent.has_method(on_enemy):
			parent.call(on_enemy)
func _on_Gun_area_body_exited(body):
	body_in=false
