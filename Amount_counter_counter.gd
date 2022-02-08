extends Control
var skoka=100
var skoka_net=50



func _ready():
	skoka=to_json(skoka)
	skoka_net=to_json(skoka_net)
	$Label.text=skoka_net+"/"+skoka
#	$Label.add_text=skoka_net
