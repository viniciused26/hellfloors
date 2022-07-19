extends Node2D

class_name BattleMap

const SKELETON_SCENE: PackedScene = preload("res://scenes/characters/Skeleton.tscn")
const PLAYER_SCENE: PackedScene = preload("res://scenes/characters/Player.tscn")

var active_character

signal battle_start

static func sort_creatures_by_speed(a : Creature, b : Creature) -> bool:
	return a.speed > b.speed

func set_positions() -> void:
	var creatures = $Creatures.get_children()
	var n_allies = 0
	var n_enemies = 0
	
	creatures.sort_custom(self, 'sort_creatures_by_speed')
	
	for c in creatures:
		c.raise()
	
	for c in creatures:
		c.visible = false
		if c.is_enemy == true:
			c.position = $EnemiesPos.get_child(n_enemies).position
			n_enemies = n_enemies + 1
		else:
			c.position = $AlliesPos.get_child(n_allies).position
			n_allies = n_allies + 1

func spawn_creatures() -> void:
	for c in $Creatures.get_children():
		yield(get_tree().create_timer(0.3), "timeout")
		c.visible = true

func play_turn():
	active_character.is_active = true
	yield(active_character.play_turn(), "completed")
	var new_index : int = (active_character.get_index() + 1) % $Creatures.get_child_count()
	active_character = $Creatures.get_child(new_index)
	play_turn()

func _ready() -> void:
	
	var skel1 = SKELETON_SCENE.instance()
	var skel2 = SKELETON_SCENE.instance()
	var skel3 = SKELETON_SCENE.instance()
	var skel4 = SKELETON_SCENE.instance()
	var play = PLAYER_SCENE.instance()
	
	$Creatures.add_child(skel1)
	$Creatures.add_child(skel2)
	$Creatures.add_child(skel3)
	$Creatures.add_child(skel4)
	$Creatures.add_child(play)
	
	set_positions()
	spawn_creatures()
	active_character = $Creatures.get_child(0)
	emit_signal("battle_start")


func _on_BattleMap_battle_start():
	play_turn()
