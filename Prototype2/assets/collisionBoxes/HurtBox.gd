class_name HurtBox
extends Area2D

func _ready():
	connect("area_entered", self, "_on_area_entered")
	
func _on_area_entered(hitBox: HitBox):
	# return if area is not a hitbox
	if hitBox == null:
		return
		
	if owner.has_method("takeDamage"):
		owner.takeDamage(hitBox.damage)
	if owner.has_method("knockBack"):
		owner.knockBack(hitBox.global_position)
