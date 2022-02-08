extends Control
func _on_Player_health_change(health):
	$HealthBar.value=health
