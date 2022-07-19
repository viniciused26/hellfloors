extends Node2D

class_name Creature

export(int) var speed: int = 5
export(bool) var is_enemy: bool = true

var is_active = false

signal action_taken


func _ready() -> void:
	$IdleSprite.flip_h = is_enemy
	$AttackSprite.flip_h = is_enemy
	$HitSprite.flip_h = is_enemy
	
	if is_enemy:
		$AttackSprite.position.x = $AttackSprite.position.x - 13
		$HitSprite.position.x = $HitSprite.position.x + 6
	
	$AnimationPlayer.play("idle")

func _input(event):
	
	if Input.is_action_pressed("ui_select") and is_active == true:
		$AnimationPlayer.play("attack")
		is_active = false
	
	yield($AnimationPlayer, "animation_finished")
	$AnimationPlayer.play("idle")
	
	emit_signal("action_taken")

func play_turn():
	yield(self, "action_taken")
	
