extends Node2D

class_name Creature

const FLOATING_NUMBER: PackedScene = preload("res://scenes/floating_number/FloatingNumber.tscn")
const TARGET_SYMBOL: PackedScene = preload("res://scenes/battleicons/AttackSymbol.tscn")
const HEALTH_CIRCLE: PackedScene = preload("res://scenes/battleicons/HealthCircle.tscn")

onready var sprite = $Sprite
onready var anim_player = $AnimationPlayer

export var is_enemy: bool = true

export var speed : int = 5
export var health : int = 100
export var damage : int = 50
export var action_points : int = 2
export var title : String = ""


var is_active = false
var mouse_over = false

var hp_circle
var tgt_symb

signal action_taken
signal current_target
signal health_changed
signal died
signal text_alert

func _ready() -> void:
	sprite.flip_h = is_enemy
	anim_player.play("idle")
	
	hp_circle = HEALTH_CIRCLE.instance()
	add_child(hp_circle)
	hp_circle.position = Vector2(position.x, position.y + (sprite.texture.get_height()/2) + 14)

func play_turn():
	anim_player.play("active")
	yield(self, "action_taken")

func attack(target):
	if target == self:
		emit_signal("text_alert", "You cannot attack yourself!")
	else:
		if weakref(target).get_ref():
			anim_player.play("attack")
			is_active = false
			yield(anim_player, "animation_finished")
			anim_player.play("active")
			
			target.take_damage(damage)
			action_points -= 1

func take_damage(damage):
	var damageLabel = FLOATING_NUMBER.instance()
	damageLabel.ammount = damage
	add_child(damageLabel)
	anim_player.play("hit")
	yield(anim_player, "animation_finished")
	anim_player.play("idle")
	health -= damage
	
	yield(hp_circle.on_health_changed(health, 0.5), "completed")
	if health <= 0:
		emit_signal("died", self)
		call_deferred("free")

func _on_Area2D_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("ui_click"):
		emit_signal("current_target", self)

func add_tgt_symbol():
	tgt_symb = TARGET_SYMBOL.instance()
	add_child(tgt_symb)
	tgt_symb.position.y = tgt_symb.position.y - (sprite.texture.get_height()/2) - 8

func remove_tgt_symbol():
	remove_child(tgt_symb)

func add_healthbar():
	yield(hp_circle.on_health_changed(health, 1), "completed")

func round_end():
	action_points = 2
