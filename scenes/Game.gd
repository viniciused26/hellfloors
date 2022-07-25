extends Node2D

func _on_BattleMap_new_round(n_rounds):
	yield(get_tree().create_timer(1), "timeout") 
	$Label.text = "RODADA " + str(n_rounds)
	$Label.visible = true
	yield(get_tree().create_timer(2), "timeout") 
	$Label.visible = false

