extends Node2D

signal Fight_start

onready var nav_2d:Navigation2D=$Navigation
onready var enemy_tra:Sprite=$Enemy_position
onready var player:KinematicBody2D=$Player
var where=RectangleShape2D.new()
var dor=RectangleShape2D.new()
var Player_starts_fight=false
func _ready():
	$HUD/Interface/Enemy_name.hide()
	$HUD/Interface/HP_Bar_for_enemy.hide()
	set_camera_limits()	
	$Enemy_position/Player_near/CollisionShape2D.shape=where
	$Enemy_position/Player_near/CollisionShape2D.shape.extents.x=$Navigation/Enemy/CollisionShape2D.shape.extents.x+1
	$Enemy_position/Player_near/CollisionShape2D.shape.extents.y=$Navigation/Enemy/CollisionShape2D.shape.extents.y+1
func _process(delta):
	if get_tree().paused==true:
		$Paus.current=true
	elif get_tree().paused==false:
		$Paus.current=false	
	if $Navigation/Enemy.alive==true:
		$Navigation/Enemy.global_position=$Enemy_position.global_position
	if $Player:
		var new_path:=nav_2d.get_simple_path(enemy_tra.global_position, player.global_position )
		enemy_tra.path=new_path
	if Player_starts_fight:
		emit_signal('Fight_start')
		$Dor/Collision.shape=dor
		$Dor/Collision.shape.extents.x=5
		$Dor/Collision.shape.extents.y=64
		$HUD/Interface/Enemy_name.visible=true
		$HUD/Interface/HP_Bar_for_enemy.visible=true
func set_camera_limits():
	var map_limits= $Navigation/Ground.get_used_rect()
	var map_cellsize=$Navigation/Ground.cell_size
	$Player/Camera2D.limit_left=map_limits.position.x*map_cellsize.x
	$Player/Camera2D.limit_right=map_limits.end.x*map_cellsize.x
	$Player/Camera2D.limit_top=map_limits.position.y*map_cellsize.y
	$Player/Camera2D.limit_bottom=map_limits.end.y*map_cellsize.y
	
func _on_shoot(bullet,_position,_direction):
	var b = bullet.instance()
	add_child(b)
	b.start(_position, _direction)
	


func _on_Player_in_flip(in_flop):
	if in_flop:
		$Player.set_collision_mask_bit(3, false)
		$Player.speed+=70
	else:
		$Player.set_collision_mask_bit(3, true)
		$Player.speed-=70


func _on_Area2D_body_entered(body):
	if body.name=="Player" and !Player_starts_fight:
		Player_starts_fight=true
