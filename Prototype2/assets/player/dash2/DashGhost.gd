extends AnimatedSprite

func _ready():
	$Tween.interpolate_property(self, "modulate:a", 1.0, 0.0, 0.5, Tween.TRANS_QUART, Tween.EASE_OUT)
	$Tween.start()

func _on_Tween_tween_completed(_object, _key):
	queue_free()
