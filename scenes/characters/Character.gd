extends Node2D

class_name Creature

export(int) var speed: int = 5
export(bool) var is_enemy: bool = true

func _ready() -> void:
	$IdleSprite.flip_h = is_enemy
	$AttackSprite.flip_h = is_enemy
	$HitSprite.flip_h = is_enemy
	$AnimationPlayer.play("idle")

func play_turn() -> void:
	if Input.is_action_pressed("ui_select"):
		$AnimationPlayer.play("attack")
	
	yield($AnimationPlayer, "animation_finished")
	$AnimationPlayer.play("idle")
