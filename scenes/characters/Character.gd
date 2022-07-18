extends Node2D

class_name Creature

export(int) var speed: int = 5
export(bool) var is_enemy: bool = true

func _ready():
	$IdleSprite.flip_h = is_enemy
	$AnimationPlayer.play("idle")

