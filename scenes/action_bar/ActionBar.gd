extends Node2D

signal turn_ended

func _ready():
	pass # Replace with function body.


func _on_EndTurnButton_pressed():
	emit_signal("turn_ended")

func _on_AttackButton_pressed():
	get_parent().active_character.attack(get_parent().current_target)
