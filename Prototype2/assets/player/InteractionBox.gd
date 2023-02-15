extends Area2D

var interactable = null

func _init():
	# set the interactionable box to always exist on the interaction layer 5 (value 16)
	collision_layer = 0
	collision_mask = 16

func _unhandled_input(event):
	if event.is_action_pressed("interact") and interactable != null:
		if interactable.has_method("interact"):
			interactable.interact(self)

func _on_InteractionBox_area_entered(area):	
	# make previous interactable prompt invisible on changing interact targets
	if interactable and interactable.has_method("changePromptVisibility"):
		interactable.changePromptVisibility(false)

	interactable = area
	if interactable.has_method("changePromptVisibility"):
		interactable.changePromptVisibility(true)

func _on_InteractionBox_area_exited(area):
	if area.has_method("changePromptVisibility"):
		area.changePromptVisibility(false)
	if area == interactable:
		interactable = null
