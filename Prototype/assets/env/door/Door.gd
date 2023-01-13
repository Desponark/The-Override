extends StaticBody2D

export var proximityTriggerd = false
export(NodePath) var signalNode

func _ready():
	var node = get_node_or_null(signalNode)
	if node != null:
		node.connect("socketFullyCharged", self, "_on_SocketFullyCharged")
	pass

func _on_Area2D_area_entered(area):
	if proximityTriggerd:
		$AnimationPlayer.play("Open")
	pass


func _on_Area2D_area_exited(area):
	if proximityTriggerd:
		$AnimationPlayer.play_backwards("Open")
	pass # Replace with function body.


func _on_SocketFullyCharged():
	if !proximityTriggerd:
		print("signal received: open door")
		$AnimationPlayer.play("Open")
	pass # Replace with function body.
