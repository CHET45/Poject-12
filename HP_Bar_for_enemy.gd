extends Control
func _on_Enemy_health_change(health):
	$HealthBar.value=health
