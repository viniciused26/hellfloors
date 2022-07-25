extends Node2D

func _on_BattleMap_new_round(n_rounds):
	yield(get_tree().create_timer(0.5), "timeout") 
	$Label.text = "ROUND " + str(n_rounds)
	$Label.visible = true
	yield(get_tree().create_timer(2), "timeout") 
	$Label.visible = false

func _on_BattleMap_all_enemies_dead():
	yield(get_tree().create_timer(0.5), "timeout") 
	$Label.text = "VICTORY"
	$Label.visible = true
	yield(get_tree().create_timer(2), "timeout") 
	$Label.visible = false
