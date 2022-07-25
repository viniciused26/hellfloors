extends Position2D

var ammount : int = 0
var velocity = Vector2(0, -1.7)

onready var initial_pos = position
onready var sprite_h = get_parent().sprite.texture.get_height()

func _ready():
	$Label.set_text(str(ammount))
	$Tween.interpolate_property(self, 'scale', scale, Vector2(1,1), 0.2, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	$Tween.interpolate_property(self, 'scale', Vector2(1,1), Vector2(0.4, 0.4), 0.2, Tween.TRANS_LINEAR, Tween.EASE_OUT, 1)
	$Tween.start()

func _on_Tween_tween_all_completed():
	self.queue_free()

func _process(delta):
	if position.y > (initial_pos.y - sprite_h/2 - 16):
		position += velocity
