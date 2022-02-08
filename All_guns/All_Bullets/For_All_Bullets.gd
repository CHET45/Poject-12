extends Area2D

export(int) var bullet_speed
export(int) var damage

var velocity = Vector2()

func start(_position,_direction):
	position=_position
	rotation=_direction.angle()
	velocity=_direction*bullet_speed

func _process(delta):
	position+=velocity*delta

func explode():
	queue_free()

func _on_Bullet_body_entered(body):
	explode()
	if body.has_method('take_damage'):
		body.take_damage(damage)

