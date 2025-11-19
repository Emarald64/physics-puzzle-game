extends Node2D

var currentLevelNumber:=0
var level:Node
const levels:Array[PackedScene]=[preload("res://scenes/levels/base_level.tscn")]

func _ready() -> void:
	loadLevel(0)

func fail() -> void:
	print('failed')
	call_deferred('loadLevel',currentLevelNumber)

func loadLevel(number:int)->void:
	if level!=null:
		# remove existing level
		level.queue_free()
		
	# add the new level
	level=levels[number].instantiate()
	add_child(level)

func startLevel()->void:
	# check that no blocks overlap
	print('starting level')
	var blocks:Array=level.get_node('Blocks').get_children()
	print(len(blocks))
	for block in blocks:
		if block.global_position.y>=500 or block.get_node('Overlapping Blocks Check').has_overlapping_areas():
			block.modulate=Color.RED
			get_tree().create_timer(1).timeout.connect(block.set_modulate.bind(Color.WHITE))
			return
	print('checks passed')
	for block in blocks:
		assert(block is RigidBody2D)
		block.modulate=Color.WHITE
		block.draggable=false
		block.freeze=false
		block.sleeping=false
	$Fail.monitoring=true
