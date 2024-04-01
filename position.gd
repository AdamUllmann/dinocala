extends Control


# Called when the node enters the scene tree for the first time.
@onready var player := get_tree().get_first_node_in_group("player")
@onready var water := get_parent().get_node("waterMesh").get_child(0)
#@onready var positionUI : Label = $position.get_first_node_in_group("currentPos")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#print(player.position.x)
	self.get_node("currentPos").text = "X: " + str(player.position.x) + ",Y: " + str(player.position.y) + ",Z: " + str(player.position.z) + "\nWater level: " + str(water.position.y)
	
	#print(get_child("currentPos").text)
