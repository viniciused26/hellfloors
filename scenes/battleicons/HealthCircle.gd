extends Node2D

var current_value

func _ready():
	$TextureProgress.value = 0

func on_health_changed(health, time):
	var initial_value = $TextureProgress.value
	var final_value = health
	$Tween.interpolate_property($TextureProgress, "value", initial_value, final_value, time)
	$Tween.start()
	yield($Tween, "tween_completed")

func _process(delta):
	pass

func _on_TextureProgress_value_changed(value):
	var r = range_lerp(value, 10, 100, 1, 0)
	var g = range_lerp(value, 10, 100, 0, 1)
	$TextureProgress.tint_progress = Color(r, g, 0)
