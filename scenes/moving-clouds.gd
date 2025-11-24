extends Node2D

const cloudSpeed:=5

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for cloud in get_children():
		assert(cloud is Node2D)
		cloud.position.x=fmod(cloud.position.x+cloudSpeed*delta+500,2000)-500
