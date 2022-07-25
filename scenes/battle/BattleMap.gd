extends Node2D

class_name BattleMap

const SKELETON_SCENE: PackedScene = preload("res://scenes/characters/Skeleton.tscn")
const PLAYER_SCENE: PackedScene = preload("res://scenes/characters/Player.tscn")

var active_character
var current_target
var n_rounds = 0

signal battle_start
signal new_round

static func sort_creatures_by_speed(a : Creature, b : Creature) -> bool:
	return a.speed > b.speed

func on_current_target(t):
	current_target = t

func set_positions():
	var creatures = $Creatures.get_children()
	var n_allies = 0
	var n_enemies = 0
	
	creatures.sort_custom(self, 'sort_creatures_by_speed')
	for c in creatures:
		c.connect("current_target", self, "on_current_target")
		
		c.raise()
		
		c.visible = false
		if c.is_enemy == true:
			c.position = $EnemiesPos.get_child(n_enemies).position
			n_enemies = n_enemies + 1
		else:
			c.position = $AlliesPos.get_child(n_allies).position
			n_allies = n_allies + 1

func spawn_creatures():
	yield(get_tree().create_timer(0.3), "timeout")
	for c in $Creatures.get_children():
		yield(get_tree().create_timer(0.2), "timeout")
		c.visible = true
	
	for c in $Creatures.get_children():
		c.add_healthbar()

func _ready() -> void:
	$ActionBar.connect("turn_ended", self, "on_turn_ended")
	
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
	
	n_rounds += 1
	emit_signal("new_round", n_rounds)

func _on_BattleMap_battle_start():
	play_turn()

func on_turn_ended():
	next_turn()

func play_turn():
	active_character.is_active = true
	yield(active_character.play_turn(), "completed")

func next_turn():
	var new_index : int = (active_character.get_index() + 1) % $Creatures.get_child_count()
	active_character = $Creatures.get_child(new_index)
	
	if new_index == 0:
		n_rounds += 1
		emit_signal("new_round", n_rounds)
	
	play_turn()
