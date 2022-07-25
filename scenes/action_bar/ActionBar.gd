extends Node2D

signal turn_ended

func _ready():
	pass # Replace with function body.

func _on_EndTurnButton_pressed():
	emit_signal("turn_ended")

func _on_AttackButton_pressed():
	var active_character = get_parent().active_character
	var current_target = get_parent().current_target
	
	if current_target == null:
		print("select a target!")
	else:
		if active_character.action_points > 0:
			active_character.attack(current_target)
			
		else:
			print("no points")
