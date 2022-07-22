extends Node2D

class_name Creature

const FLOATING_NUMBER: PackedScene = preload("res://scenes/floating_number/FloatingNumber.tscn")
const TARGET_SYMBOL: PackedScene = preload("res://scenes/battleicons/AttackSymbol.tscn")
const HEALTH_CIRCLE: PackedScene = preload("res://scenes/battleicons/HealthCircle.tscn")

export var is_enemy: bool = true

export var speed : int = 5
export var health : int = 100
export var damage : int = 50
export var action_points : int = 2


var is_active = false
var mouse_over = false

var hp_circle

signal action_taken
signal current_target
signal health_changed

func _ready() -> void:
	hp_circle = HEALTH_CIRCLE.instance()
	add_child(hp_circle)
	hp_circle.position = Vector2(position.x - 20, position.y + 12)
	hp_circle.visible = false
	
	$IdleSprite.flip_h = is_enemy
	$AttackSprite.flip_h = is_enemy
	$HitSprite.flip_h = is_enemy
	
	if is_enemy:
		$AttackSprite.position.x = $AttackSprite.position.x - 13
		$HitSprite.position.x = $HitSprite.position.x + 6
	
	$AnimationPlayer.play("idle")

func play_turn():
	yield(self, "action_taken")

func attack(target):
	$AnimationPlayer.play("attack")
	is_active = false
	yield($AnimationPlayer, "animation_finished")
	$AnimationPlayer.play("idle")
	
	target.take_damage(damage)

func take_damage(damage):
	var damageLabel = FLOATING_NUMBER.instance()
	damageLabel.ammount = damage
	add_child(damageLabel)
	$AnimationPlayer.play("hit")
	yield($AnimationPlayer, "animation_finished")
	$AnimationPlayer.play("idle")
	health -= damage
	emit_signal("health_changed", health)
	
	if health <= 0:
		self.queue_free()

func _on_Area2D_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("ui_click"):
		for creatures in get_parent().get_children():
				for c in creatures.get_children():
					if c.name == "AttackSymbol":
						c.queue_free()
					if c.name == "HealthCircle":
						c.visible = false
		
		for c in get_children():
			if c.name == "HealthCircle":
				c.visible = true
		
		var tgt_symb = TARGET_SYMBOL.instance()
		add_child(tgt_symb)
		tgt_symb.position.y = tgt_symb.position.y + 32
		emit_signal("current_target", self)
