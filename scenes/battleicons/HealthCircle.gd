extends Node2D

var current_value

func _ready():
	$TextureProgress.value = get_parent().health

func on_health_changed(health):
	var initial_value = $TextureProgress.value
	var final_value = health
	$Tween.interpolate_property($TextureProgress, "value", initial_value, final_value, 0.5)
	$Tween.start()
	yield($Tween, "tween_completed")
