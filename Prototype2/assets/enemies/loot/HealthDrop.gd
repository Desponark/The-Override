extends RigidBody2D


export var healAmount = 25
var player = null

func _process(delta):
	if player:
		# TODO: check if tween is bad here
		var tween = create_tween().set_trans(Tween.TRANS_LINEAR)
		tween.tween_property(self, "global_position", player.getHealthBarPosition(), 1)
		
#		linear_velocity = (player.getHealthBarPosition() - global_position)

func _on_Area2D_body_entered(body):
	player = body
	
func _on_Area2D_area_entered(area):
	if player and player.has_method("gainHealth"):
		player.gainHealth(healAmount)
		queue_free()
