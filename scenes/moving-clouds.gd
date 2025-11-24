extends Node2D

const cloudLoopSize=2000
const cloudLoopOffset=500
const cloudSpeed=5

func _ready() -> void:
	# Randomize initial cloud position
	var offset=randf()*cloudLoopSize
	for cloud in get_children():
		assert(cloud is Node2D)
		cloud.position.x=fmod(cloud.position.x+offset,2000)

func _process(delta: float) -> void:
	# Move every cloud every frame
	for cloud in get_children():
		assert(cloud is Node2D)
		cloud.position.x=fmod(cloud.position.x+cloudSpeed*delta+cloudLoopOffset,cloudLoopSize)-cloudLoopOffset
