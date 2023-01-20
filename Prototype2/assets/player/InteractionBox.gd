extends Area2D

var interactable = null

func _init():
	# set the interactionable box to always exist on the interaction layer (5)
	collision_layer = 0
	collision_mask = 5

func _unhandled_input(event):
	if event.is_action_pressed("interact") and interactable != null:
		if interactable.has_method("interact"):
			interactable.interact(self)

func _on_InteractionBox_area_entered(area):
	interactable = area
	# show ui prompt -> press e to interact

func _on_InteractionBox_area_exited(area):
	interactable = null
