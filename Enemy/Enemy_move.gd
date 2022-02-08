extends Sprite
export(float)var speed
export (int) var detect_radius
var target_go=null
var target_stop=null
var path:=PoolVector2Array() setget set_path
var see_player=false

func _ready()->void:
	hide()
	var circle=CircleShape2D.new()
	$Detect_radius_main/CollisionShape2D.shape=circle
	$Detect_radius_main/CollisionShape2D.shape.radius=detect_radius
	set_process(false)

func _process(delta:float)->void:	
	if target_stop==null:
		if target_go and see_player:
			var move_distance=speed*delta
			move_along_path(move_distance)

func move_along_path(distance)->void:
	var start_point:=position
	for i in range(path.size()):
		var distance_to_next:=start_point.distance_to(path[0])
		if distance <= distance_to_next and distance>=0.0:
			position=start_point.linear_interpolate(path[0], distance/distance_to_next)		
			break
		elif distance<0.0:
			position=path[0]
			break
		distance-=distance_to_next
		start_point=path[0]
		path.remove(0)

func set_path(value:PoolVector2Array)->void:
	path =value
	if value.size()==0:
		return
	set_process(true)


func _on_Area2D_body_entered(body):
	if body.name=="Player":
		target_go=body


func _on_Area2D_body_exited(body):
	if body == target_go:
		target_go=null


func _on_Player_near_body_entered(body):
	if body.name=="Player":
		target_stop=body


func _on_Player_near_body_exited(body):
	if body == target_stop:
		target_stop=null


func _on_Game_Fight_start():
	see_player=true
