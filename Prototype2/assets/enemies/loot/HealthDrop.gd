extends RigidBody2D


export var healAmount = 25



func _on_Area2D_body_entered(body):
	if body.has_method("gainHealth"):
		body.gainHealth(healAmount)
		queue_free()
