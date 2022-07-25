extends Node2D

signal turn_ended
signal text_alert

func _ready():
	pass

func _on_EndTurnButton_pressed():
	emit_signal("turn_ended")

func _on_AttackButton_pressed():
	var active_character = get_parent().active_character
	var current_target = get_parent().current_target
	
	if current_target == null or !weakref(current_target).get_ref():
		emit_signal("text_alert", "Select a target!")
	else:
		if active_character.action_points > 0:
			active_character.attack(current_target)
			
		else:
			emit_signal("text_alert", "No points left!")

func _on_BattleMap_set_text_alert(t):
	buttons_visibility(false)
	
	var text = ""
	for n in t.length():
		yield(get_tree().create_timer(0.02), "timeout")
		text += t[n]
		$TextPanel/TextAlert.text = text 
		
	
	yield(get_tree().create_timer(1.2), "timeout")
	$TextPanel/TextAlert.text = "" 
	buttons_visibility(true)
	
func buttons_visibility(b):
	for c in get_children():
		if "Button" in c.name:
			c.visible = b

func _on_BattleMap_new_turn(creature):
	$ActiveCharactPanel/TextAlert.text = creature.title
