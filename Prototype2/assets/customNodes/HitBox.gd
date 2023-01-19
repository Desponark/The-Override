class_name HitBox
extends Area2D

# possible change => get the damage var from the hitBox owner
export var damage = 10

func damageHitTarget(area):
	if area.owner.has_method("takeDamage"):
		area.owner.takeDamage(damage)
	if area.owner.has_method("knockBack"):
		area.owner.knockBack(global_position)
